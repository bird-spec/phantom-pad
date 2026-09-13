# Phantom Pad - Bill of Materials

12-key macropad + 2 rotary encoders on a Seeed XIAO, 2-layer board (86.1 x 94.3 mm).

| # | Ref | Qty | Component | Footprint / Spec | Notes |
|---|-----|-----|-----------|------------------|-------|
| 1 | U1 | 1 | Seeed Studio XIAO RP2040 | XIAO 14-pin hybrid, 2.54 mm | QMK (rp2040 bootloader); USB-C faces top edge |
| 2 | SW1-SW12 | 12 | Cherry MX (or MX-compatible) switch | Cherry MX PCB-mount | 3x4 matrix, 19.05 mm pitch |
| 3 | SW13, SW14 | 2 | Alps EC11 rotary encoder w/ switch | EC11, 6 mm D-shaft | throttle / yaw + push |
| 4 | D1-D12 | 12 | 1N4148 diode | DO-35, through-hole, vertical | one per switch (matrix anti-ghosting) |
| 5 | - | 1 | PCB | 2-layer, 86.1 x 94.3 mm | this repo (mk1.kicad_pcb) |
| 6 | - | 4 | M3 self-tapping screw, ~8 mm | - | base -> plate sandwich |
| 7 | - | 12 | Keycap (MX stem) | printed or DSA/OEM | printable |
| 8 | - | 2 | Encoder knob (6 mm D-shaft) | printed | printable |
| 9 | - | 1 | USB-C cable | - | power + flashing |

**Matrix:** 12 keys use 7 MCU pins (3 rows + 4 cols) instead of 12; the freed pins
drive the 2 encoders. Every switch has a diode so N-key rollover does not ghost.

_Component references (U1, SW1-SW14, D1-D12) verified against mk1.kicad_pcb
