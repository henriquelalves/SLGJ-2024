#include "raylib.h"
#include "s7/s7.h"
#include <stdio.h>
#include <stdlib.h>

// ======================================
// Color

static int color_type_tag = 0;

static s7_pointer free_color(s7_scheme *sc, s7_pointer obj)
{
  free(s7_c_object_value(obj));
  return(NULL);
}

static s7_pointer make_color(s7_scheme *sc, s7_pointer args)
{
  Color *c = (Color *)malloc(sizeof(Color));

  c->r = s7_integer(s7_car(args));
  c->g = s7_integer(s7_cadr(args));
  c->b = s7_integer(s7_caddr(args));
  c->a = s7_integer(s7_cadddr(args));
  
  return(s7_make_c_object(sc, color_type_tag, (void *)c));
}

static s7_pointer color_to_string(s7_scheme *sc, s7_pointer args)
{
  s7_pointer result;
  Color *c = (Color *)s7_c_object_value(s7_car(args));
  char *str = (char *)calloc(32, sizeof(char));
  snprintf(str, 32, "<color %d %d %d>", c->r, c->g, c->b);
  result = s7_make_string(sc, str);
  free(str);
  return(result);
}

static s7_pointer is_color(s7_scheme *sc, s7_pointer args)
{
  return(s7_make_boolean(sc, 
			 s7_is_c_object(s7_car(args)) &&
			 s7_c_object_type(s7_car(args)) == color_type_tag));
}

static s7_pointer color_r(s7_scheme *sc, s7_pointer args)
{
  Color *c = (Color *)s7_c_object_value(s7_car(args));
  return(s7_make_integer(sc, c->r));
}

static s7_pointer set_color_r(s7_scheme *sc, s7_pointer args)
{
  Color *c = (Color *)s7_c_object_value(s7_car(args));
  c->r = s7_integer(s7_cadr(args));
  return(s7_cadr(args));
}

static s7_pointer color_g(s7_scheme *sc, s7_pointer args)
{
  Color *c = (Color *)s7_c_object_value(s7_car(args));
  return(s7_make_integer(sc, c->g));
}

static s7_pointer set_color_g(s7_scheme *sc, s7_pointer args)
{
  Color *c = (Color *)s7_c_object_value(s7_car(args));
  c->g = s7_integer(s7_cadr(args));
  return(s7_cadr(args));
}

static s7_pointer color_b(s7_scheme *sc, s7_pointer args)
{
  Color *c = (Color *)s7_c_object_value(s7_car(args));
  return(s7_make_integer(sc, c->b));
}

static s7_pointer set_color_b(s7_scheme *sc, s7_pointer args)
{
  Color *c = (Color *)s7_c_object_value(s7_car(args));
  c->b = s7_integer(s7_cadr(args));
  return(s7_cadr(args));
}



// ======================================

static void rl_register_types(s7_scheme *s7) {
  color_type_tag = s7_make_c_type(s7, "color");
  s7_c_type_set_gc_free(s7, color_type_tag, free_color);
  s7_c_type_set_to_string(s7, color_type_tag, color_to_string);
  
  s7_define_function(s7, "make-color", make_color, 4, 0, false, "(make-color r g b a) makes a new color");
  
  s7_define_function(s7, "color?", is_color, 1, 0, false, "(color? anything) returns #t if its argument is a color object");

  s7_define_variable(s7, "color-r", s7_dilambda(s7, "color-r", color_r, 1, 0, set_color_r, 2, 0, "color r field"));
  s7_define_variable(s7, "color-g", s7_dilambda(s7, "color-g", color_g, 1, 0, set_color_g, 2, 0, "color g field"));
  s7_define_variable(s7, "color-b", s7_dilambda(s7, "color-b", color_b, 1, 0, set_color_b, 2, 0, "color b field"));
}

