-- Philips Evnia ultrawide. Fall back to preferred mode on other outputs.
hl.monitor({output = "DP-2", mode = "3440x1440@180", position = "0x0", scale = 1})
hl.monitor({output = "", mode = "preferred", position = "auto", scale = 1})
