import fcntl
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time
from contextlib import contextmanager

ROOT = Path(os.environ.get("XDG_RUNTIME_DIR", f"/tmp/brightness-{os.getuid()}")) / "monitor-brightness"
ROOT.mkdir(mode=0o700, parents=True, exist_ok=True)
STATE = ROOT / "state.json"
MODEL_FILE = Path("/etc/monitor-brightness-model")
MODEL = os.environ.get("NIRI_BRIGHTNESS_MONITOR") or (MODEL_FILE.read_text().strip() if MODEL_FILE.exists() else "")


@contextmanager
def locked(name):
    with (ROOT / name).open("w") as file:
        fcntl.flock(file, fcntl.LOCK_EX)
        yield file


def run(*args):
    result = subprocess.run(args, text=True, capture_output=True, timeout=10)
    if result.returncode:
        raise RuntimeError(result.stderr.strip() or result.stdout.strip() or "Monitor communication failed")
    return result.stdout


def save(state):
    temporary = STATE.with_suffix(".new")
    temporary.write_text(json.dumps(state))
    temporary.replace(STATE)


def read():
    return json.loads(STATE.read_text()) if STATE.exists() else None


def initialize():
    model = MODEL
    output = run("ddcutil", "detect", "--brief")
    displays = re.split(r"(?=Display \d+)", output)
    display = next((d for d in displays if "I2C bus:" in d and (not model or model in d)), None)
    if not display:
        raise RuntimeError("Configured monitor not detected")
    bus = int(re.search(r"/dev/i2c-(\d+)", display).group(1))
    state = {"bus": bus, "model": model}
    synchronize(state)
    return state


def synchronize(state):
    output = run("ddcutil", "--bus", str(state["bus"]), "getvcp", "10", "--brief")
    match = re.search(r"VCP\s+10\s+C\s+(\d+)\s+(\d+)", output)
    if not match or int(match[2]) <= 0:
        raise RuntimeError("Monitor does not expose a continuous brightness control")
    current, maximum = map(int, match.groups())
    state.update(maximum=maximum, target=round(current * 100 / maximum), applied=round(current * 100 / maximum), refreshed=time.time())
    save(state)


def worker():
    # One writer drains the latest target, rather than queuing every key repeat.
    with (ROOT / "writer.lock").open("w") as writer:
        try:
            fcntl.flock(writer, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            return
        while True:
            with locked("state.lock"):
                state = read()
                target = state["target"]
                if target == state["applied"]:
                    # Release writer ownership before another request can arrive.
                    fcntl.flock(writer, fcntl.LOCK_UN)
                    return
            try:
                run("ddcutil", "--bus", str(state["bus"]), "--noverify", "setvcp", "10", str(round(target * state["maximum"] / 100)))
            except (RuntimeError, subprocess.TimeoutExpired):
                with locked("state.lock"):
                    STATE.unlink(missing_ok=True)
                subprocess.run(["notify-send", "Brightness adjustment failed", "Check the monitor connection and DDC/CI setting."], check=False)
                return
            with locked("state.lock"):
                latest = read()
                latest["applied"] = target
                latest["refreshed"] = time.time()
                save(latest)


def main():
    action = sys.argv[1] if len(sys.argv) > 1 else "menu"
    if action == "worker":
        worker()
        return
    with locked("state.lock"):
        state = read()
        if state is None or state["model"] != MODEL:
            state = initialize()
        # Only idle status reads resynchronize with changes made using the OSD.
        if action == "sync" or (action == "status" and state["target"] == state["applied"] and time.time() - state["refreshed"] > 60):
            synchronize(state)
        percent = state["target"]
    if action in ("status", "sync"):
        print(json.dumps({"text": f"󰃠 {percent}%", "tooltip": "Monitor brightness · scroll to adjust; click to choose"}))
        return
    if action == "menu":
        choice = subprocess.run(["niri-launcher", "--dmenu", "--prompt", f"Brightness ({percent}%): "], input="\n".join(f"{n}%" for n in range(10, 101, 10)), text=True, capture_output=True)
        if choice.returncode or not choice.stdout.strip():
            return
        action = choice.stdout.strip().rstrip("%")
    with locked("state.lock"):
        state = read() or initialize()
        target = state["target"] + (5 if action == "up" else -5) if action in ("up", "down") else int(action.rstrip("%"))
        if action not in ("up", "down") and not 0 <= target <= 100:
            raise ValueError("Brightness must be between 0 and 100 percent")
        state["target"] = max(0, min(100, target))
        save(state)
    subprocess.Popen([sys.executable, __file__, "worker"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, start_new_session=True)


try:
    main()
except (RuntimeError, ValueError, subprocess.TimeoutExpired) as error:
    if len(sys.argv) > 1 and sys.argv[1] in ("status", "sync"):
        print(json.dumps({"text": "󰃠 ?", "tooltip": f"DDC brightness unavailable: {error}"}))
    else:
        print(f"Brightness: {error}", file=sys.stderr)
        subprocess.run(["notify-send", "Monitor brightness unavailable", "Check that DDC/CI is enabled in the monitor menu."], check=False)
        sys.exit(1)
