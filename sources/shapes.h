#include "raylib.h"
#include "s7.h"
#include <stdio.h>
#include <stdlib.h>

static s7_pointer rl_draw_rectangle(s7_scheme *s7, s7_pointer args) {
  Color *c = (Color *)s7_c_object_value(s7_car(s7_cdr(s7_cdr(s7_cdr(s7_cdr(args))))));
  
  DrawRectangle(s7_integer(s7_car(args)),
		s7_integer(s7_car(s7_cdr(args))),
		s7_integer(s7_car(s7_cdr(s7_cdr(args)))),
		s7_integer(s7_car(s7_cdr(s7_cdr(s7_cdr(args))))),
		*c);

  return(NULL);
}

static void rl_shapes_define_methods(s7_scheme *s7) {
  s7_define_function(s7, "rl-draw-rectangle", rl_draw_rectangle, 5, 0, false, "test");
}
