#include "raylib.h"
#include "s7.h"
#include <stdio.h>
#include <stdlib.h>

static s7_pointer rl_is_key_down(s7_scheme *s7, s7_pointer args) {
  int key = s7_integer(s7_car(args));
  bool isKey = IsKeyDown(key);
  return(s7_make_boolean(s7, isKey));
}

static void rl_core_define_methods(s7_scheme *s7) {
  s7_define_function(s7, "rl-is-key-down", rl_is_key_down, 1, 0, false, "test");
}
