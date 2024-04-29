#include "raylib.h"
#include "s7/s7.h"
#include <stdio.h>
#include <stdlib.h>

static s7_pointer rl_draw_text(s7_scheme *s7, s7_pointer args) {
  Color *c = (Color *)s7_c_object_value(s7_car(s7_cddddr(args)));
  
  DrawText(s7_string(s7_car(args)),
	   s7_integer(s7_cadr(args)),
	   s7_integer(s7_caddr(args)),
	   s7_integer(s7_cadddr(args)),
	   *c);
  
  return(NULL);
}

static void rl_text_define_methods(s7_scheme *s7) {
  s7_define_function(s7, "rl-draw-text", rl_draw_text, 5, 0, false, "test");
}
