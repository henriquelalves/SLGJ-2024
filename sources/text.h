#include "raylib.h"
#include <libguile.h>

static void rl_draw_text(SCM text) {
  scm_t_string_failed_conversion_handler handler;
  char* str = scm_to_stringn(text, NULL, NULL, handler);
  DrawText(str, 200, 80, 20, RED);
}

static void rl_text_define_methods() {
  scm_c_define_gsubr ("rl-draw-text", 1, 0, 0, rl_draw_text);
}
