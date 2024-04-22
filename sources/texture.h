#include "raylib.h"
#include <libguile.h>
#include <stdio.h>

struct texture_2d {
  Texture2D texture;
};

static SCM texture_2d_type;

static void finalize_texture_2d(SCM texture_2d_scm) {
  struct texture_2d *texture_2d;
  texture_2d = scm_foreign_object_ref(texture_2d_scm, 0);
  UnloadTexture(texture_2d->texture);
}

static void init_texture_2d_type (void) {
  SCM name, slots;
  scm_t_struct_finalize finalizer;
  
  name = scm_from_utf8_symbol("texture_2d");
  slots = scm_list_1(scm_from_utf8_symbol("data"));
  finalizer = finalize_texture_2d;

  texture_2d_type = scm_make_foreign_object_type(name, slots, finalizer);
}

static SCM rl_load_texture(SCM file_name_scm) {
  scm_t_string_failed_conversion_handler handler;
  char* file_name = scm_to_stringn(file_name_scm, NULL, NULL, handler);

  struct texture_2d *new_texture_2d;

  // Tested different mallocs, didn't work
  /* new_texture_2d = (struct texture_2d *) scm_malloc(sizeof (struct texture_2d)); */
  new_texture_2d = (struct texture_2d *) scm_gc_malloc(sizeof (struct texture_2d), "texture_2d");

  new_texture_2d->texture = LoadTexture(file_name);
   
  return scm_make_foreign_object_1(texture_2d_type, new_texture_2d);
}

static void rl_texture_define_methods() {
  init_texture_2d_type();
  
  scm_c_define_gsubr ("rl-load-texture", 1, 0, 0, rl_load_texture);
}

