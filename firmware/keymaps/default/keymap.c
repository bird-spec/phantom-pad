#include QMK_KEYBOARD_H

// PHANTOM pad — two layers.
//
//   DRONE : sends F13-F23, plus Ctrl+F13..F16 for the encoders. Nothing on a
//           PC uses those, so the host script can listen for them without
//           stealing keys you actually need. It turns each into a UDP packet
//           the drone already understands on port 5006.
//
//   PAD   : ordinary keys. Slide the rocker plate off, it is a macropad.
//
// The pad never talks to the drone directly - it is a USB device and the
// drone is on WiFi. The host script is the bridge.
//
// Why the modifiers: 8 directions + stop + 2 encoder buttons + 4 encoder
// turns is 15 distinct events, and F13-F24 only gives 12. Ctrl+F13..F16
// carries the four turns without colliding with anything.

enum layers { DRONE, PAD };

#define DR_LU  KC_F13   // left cluster  up
#define DR_LD  KC_F14   //               down
#define DR_LL  KC_F15   //               left
#define DR_LR  KC_F16   //               right
#define DR_RU  KC_F17   // right cluster up
#define DR_RD  KC_F18   //               down
#define DR_RL  KC_F19   //               left
#define DR_RR  KC_F20   //               right
#define DR_E1  KC_F21   // encoder 1 button
#define DR_E2  KC_F22   // encoder 2 button
#define DR_STOP KC_F23  // stabilise and land

#define DR_THRD LCTL(KC_F13)   // throttle down
#define DR_THRU LCTL(KC_F14)   // throttle up
#define DR_YAWL LCTL(KC_F15)   // yaw left
#define DR_YAWR LCTL(KC_F16)   // yaw right

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

  [DRONE] = LAYOUT(
      DR_LU,   DR_LD,   DR_LL,   DR_LR,
      DR_RU,   DR_RD,   DR_RL,   DR_RR,
      DR_STOP, DR_E1,   DR_E2
  ),

  // Emergency stays on the same key and keeps sending the same code on both
  // layers. A stop button you have to be on the right layer to press is not
  // a stop button.
  [PAD] = LAYOUT(
      KC_W,    KC_S,    KC_A,    KC_D,
      KC_UP,   KC_DOWN, KC_LEFT, KC_RGHT,
      DR_STOP, KC_MPLY, KC_MUTE
  ),
};

// Hold stop and tap encoder 1's button to swap layers. Deliberately awkward -
// you do not want to land on the other layer mid-flight.
bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  static bool stop_held = false;

  if (keycode == DR_STOP) { stop_held = record->event.pressed; return true; }

  if (stop_held && keycode == DR_E1 && record->event.pressed) {
    layer_invert(PAD);
    return false;                       // swallow it, do not send F21
  }
  return true;
}

#if defined(ENCODER_MAP_ENABLE)
const uint16_t PROGMEM encoder_map[][NUM_ENCODERS][2] = {
  //          encoder 1 - throttle          encoder 2 - yaw trim
  [DRONE] = { ENCODER_CCW_CW(DR_THRD, DR_THRU), ENCODER_CCW_CW(DR_YAWL, DR_YAWR) },
  [PAD]   = { ENCODER_CCW_CW(KC_VOLD, KC_VOLU), ENCODER_CCW_CW(KC_PGDN, KC_PGUP) },
};
#endif
