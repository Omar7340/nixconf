import time, random, colorsys
from openrgb import OpenRGBClient
from openrgb.utils import RGBColor

def get_random_rgb(brightness=0.4):
    """Génère une couleur aléatoire au format RGB tuple (0-255)."""
    r, g, b = colorsys.hsv_to_rgb(random.random(), 1.0, brightness)
    return (int(r * 255), int(g * 255), int(b * 255))

def effect_fill(speed=0.5, fps=40):
    try:
        client = OpenRGBClient()
        if not client.devices: return print("Aucun périphérique détecté.")

        start_time = time.time()
        current_color = get_random_rgb()
        last_cycle = -1

        print(f"Effet Fill démarré. (Ctrl+C pour arrêter)")

        while True:
            elapsed = (time.time() - start_time) * speed
            cycle = int(elapsed)
            progress = elapsed - cycle

            # Changement de couleur à chaque nouveau cycle
            if cycle != last_cycle:
                current_color = get_random_rgb()
                last_cycle = cycle

            is_fading = (cycle % 2 == 1)

            for device in client.devices:
                for zone in device.zones:
                    width = zone.matrix_map.width if zone.matrix_map else len(zone.leds)

                    new_colors = []
                    for i in range(len(zone.leds)):
                        pos = i % width if zone.matrix_map else i

                        if is_fading:
                            # Toute la zone s'efface uniformément
                            factor = 1.0 - progress
                        else:
                            # Remplissage progressif (clamp entre 0 et 1)
                            factor = max(0.0, min(1.0, progress * width - pos))

                        new_colors.append(RGBColor(
                            int(current_color[0] * factor),
                            int(current_color[1] * factor),
                            int(current_color[2] * factor)
                        ))

                    zone.set_colors(new_colors, fast=True)

            time.sleep(1/fps)

    except KeyboardInterrupt:
        print("\nEffet arrêté.")

if __name__ == "__main__":
    effect_fill(speed=0.6, fps=30)
