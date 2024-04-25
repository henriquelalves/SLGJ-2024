#include "raylib.h"
#include "s7.h"
#include <stdio.h>
#include <stdlib.h>

static s7_pointer rl_draw_text(s7_scheme *s7, s7_pointer args) {
  printf("%s\n", s7_string(s7_car(args)));
  DrawText(s7_string(s7_car(args)), 200, 80, 20, RED);
  return(NULL);
}

static void rl_text_define_methods(s7_scheme *s7) {
  s7_define_function(s7, "rl-draw-text", rl_draw_text, 1, 0, false, "test");
}
