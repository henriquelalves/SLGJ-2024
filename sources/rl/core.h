#include "raylib.h"
#include "s7/s7.h"
#include <stdio.h>
#include <stdlib.h>

static s7_pointer rl_get_mouse_position(s7_scheme *s7, s7_pointer args) {  
  Vector2 mouse_pos = GetMousePosition();
  s7_pointer vec = s7_make_float_vector(s7, 2, 1, NULL);
  s7_vector_set(s7, vec, 0, s7_make_real(s7, mouse_pos.x));
  s7_vector_set(s7, vec, 1, s7_make_real(s7, mouse_pos.y));
  return vec;
}

static s7_pointer rl_is_key_down(s7_scheme *s7, s7_pointer args) {
  int key = s7_integer(s7_car(args));
  bool isKey = IsKeyDown(key);
  return(s7_make_boolean(s7, isKey));
}

static s7_pointer rl_get_char_pressed(s7_scheme *s7, s7_pointer args) {
  int key = GetCharPressed();
  return(s7_make_integer(s7, key));
}

static s7_pointer rl_get_key_pressed(s7_scheme *s7, s7_pointer args) {
  int key = GetKeyPressed();
  return(s7_make_integer(s7, key));
}

static void rl_core_define_methods(s7_scheme *s7) {
  s7_define_function(s7, "rl-is-key-down", rl_is_key_down, 1, 0, false, "(rl-is-key-down KEY)");
  s7_define_function(s7, "rl-get-mouse-position", rl_get_mouse_position, 0, 0, false, "(rl-get-mouse-position)");
  s7_define_function(s7, "rl-get-char-pressed", rl_get_char_pressed, 0, 0, false, "(rl-get-char-pressed)");
  s7_define_function(s7, "rl-get-key-pressed", rl_get_key_pressed, 0, 0, false, "(rl-get-key-pressed)");
}
