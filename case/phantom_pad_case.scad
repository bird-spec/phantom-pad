// -------------------------------------------------------------
//  Phantom Pad - printable case (parametric, OpenSCAD)
//
//  Sandwich case: the PCB (no mounting holes) is captured between a
//  BASE tray and a top PLATE, held by 4 corner screws through standoffs.
//
//  All key/encoder cutouts are placed at the EXACT footprint positions
//  pulled from mk1.kicad_pcb (board origin = board min corner
//  94.492612, 33.242612 mm), so the plate lines up with the real board.
//
//  Board outline: 86.10 x 94.33 mm, XIAO USB faces the top edge (y=0).
//  Units: mm.
//
//  Render one part at a time with -D PART="base" | "plate" | "keycap" | "knob"
// -------------------------------------------------------------

PART = "base";           // base | plate | keycap | knob   (overridden by -D)
$fn  = 48;

// -- board --
BOARD_W = 86.10;
BOARD_H = 94.33;
PCB_T   = 1.6;           // 2-layer board thickness

// -- fit / walls --
SLACK   = 0.4;           // per-side clearance around the PCB in the tray
WALL    = 2.5;
FLOOR   = 2.0;
PLATE_T = 3.0;
STANDOFF_H = PCB_T + 0.6;   // lifts plate just above the board

// -- switches / encoders --
KEY_CUT = 14.0;          // Cherry MX plate cutout (14.0 mm square)
ENC_D   = 7.2;           // EC11 bushing hole
CAP     = 18.0;          // keycap footprint
CAP_H   = 7.0;

// USB-C slot on the top wall (XIAO connector faces y=0)
USB_W = 9.5; USB_H = 3.6;
XIAO_X = 42.91;          // U1 x, relative to board origin

// -- screw standoffs (M3 self-tap into plastic) --
SCREW_R   = 1.35;        // pilot for M3 self-tapping
BOSS_R    = 3.4;
BOSS_INSET = 6.0;
boss_xy = [
  [BOSS_INSET,            BOSS_INSET],
  [BOARD_W - BOSS_INSET,  BOSS_INSET],
  [BOSS_INSET,            BOARD_H - BOSS_INSET],
  [BOARD_W - BOSS_INSET,  BOARD_H - BOSS_INSET],
];

// -- EXACT switch positions (relative to board origin), from mk1.kicad_pcb --
keys = [
  [17.36,37.88],[36.32,37.88],[55.37,37.88],[74.42,37.88],  // row 1
  [17.27,56.93],[36.32,56.93],[55.37,56.93],[74.42,56.93],  // row 2
  [17.27,75.98],[36.32,75.98],[55.37,75.98],[74.42,75.98],  // row 3
];
encoders = [ [6.80,19.73], [64.14,20.21] ];   // SW14 (left), SW13 (right)

// tray inner cavity size (PCB + slack)
inner_w = BOARD_W + 2*SLACK;
inner_h = BOARD_H + 2*SLACK;
outer_w = inner_w + 2*WALL;
outer_h = inner_h + 2*WALL;

// ------------------------- BASE -------------------------
module base() {
  difference() {
    union() {
      // outer shell
      translate([-WALL-SLACK, -WALL-SLACK, 0])
        cube([outer_w, outer_h, FLOOR + STANDOFF_H + PCB_T]);
    }
    // hollow the cavity that holds the PCB (walls remain)
    translate([-SLACK, -SLACK, FLOOR])
      cube([inner_w, inner_h, STANDOFF_H + PCB_T + 1]);
    // USB-C slot in the top wall
    translate([XIAO_X - USB_W/2, -WALL-SLACK-0.1, FLOOR + STANDOFF_H])
      cube([USB_W, WALL + SLACK + 0.2, USB_H]);
  }
  // 4 corner standoffs the PCB rests against; screws self-tap here
  for (p = boss_xy)
    translate([p[0], p[1], FLOOR])
      difference() {
        cylinder(r = BOSS_R, h = STANDOFF_H);
        translate([0,0,-0.1]) cylinder(r = SCREW_R, h = STANDOFF_H + 0.2);
      }
}

// ------------------------- PLATE -------------------------
module plate() {
  difference() {
    // plate matches the outer footprint so it caps the tray
    translate([-WALL-SLACK, -WALL-SLACK, 0])
      cube([outer_w, outer_h, PLATE_T]);
    // 12 switch cutouts
    for (k = keys)
      translate([k[0]-KEY_CUT/2, k[1]-KEY_CUT/2, -0.1])
        cube([KEY_CUT, KEY_CUT, PLATE_T+0.2]);
    // 2 encoder bushing holes
    for (e = encoders)
      translate([e[0], e[1], -0.1])
        cylinder(d = ENC_D, h = PLATE_T+0.2);
    // 4 screw clearance holes (through)
    for (p = boss_xy)
      translate([p[0], p[1], -0.1])
        cylinder(r = SCREW_R + 0.35, h = PLATE_T+0.2);
  }
}

// ------------------- KEYCAP (simple, printable) -------------------
module keycap() {
  difference() {
    hull() {
      translate([-CAP/2,-CAP/2,0]) cube([CAP,CAP,0.1]);
      translate([-(CAP-3)/2,-(CAP-3)/2,CAP_H-0.1]) cube([CAP-3,CAP-3,0.1]);
    }
    // MX stem socket (+ cross)
    translate([0,0,-0.1]) {
      cylinder(d=5.6,h=4);
      translate([-2.05,-0.55,0]) cube([4.1,1.1,4]);
      translate([-0.55,-2.05,0]) cube([1.1,4.1,4]);
    }
  }
}

// ------------------- ENCODER KNOB -------------------
module knob() {
  KN_D=18; KN_H=14;
  difference() {
    union() {
      cylinder(d=KN_D,h=KN_H);
      for (i=[0:11]) rotate([0,0,i*30]) translate([KN_D/2-0.4,0,0]) cylinder(d=1.6,h=KN_H);
    }
    // D-shaft 6mm with flat
    translate([0,0,-0.1]) difference() {
      cylinder(d=6.1,h=KN_H-3);
      translate([1.5,-4,-0.2]) cube([4,8,KN_H]);   // flat
    }
  }
}

if      (PART == "base")   base();
else if (PART == "plate")  plate();
else if (PART == "keycap") keycap();
else if (PART == "knob")   knob();
else                       base();
