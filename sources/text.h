#include "raylib.h"
#include <libguile.h>
#include <stdio.h>

static void rl_draw_text() {
  DrawText("a", 200, 80, 20, RED); //< this line segfaults
}

static void rl_text_define_methods() {
  SCM handler = scm_c_define_gsubr ("rl-draw-text", 0, 0, 0, rl_draw_text);
}
