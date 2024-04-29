int texture_2d_tag;

static s7_pointer free_texture_2d(s7_scheme *s7, s7_pointer obj) {
  Texture2D *texture = (Texture2D *) s7_c_object_value(obj);
  UnloadTexture(*texture);
  free(texture);
  return(NULL);
}

static s7_pointer rl_draw_texture(s7_scheme *s7, s7_pointer args) {
  Texture2D *texture = (Texture2D *) s7_c_object_value(s7_car(args));
  DrawTexture(*texture, 100, 100, WHITE);
  return(NULL);
}

static s7_pointer rl_load_texture(s7_scheme *s7, s7_pointer args) {
  Texture2D texture = LoadTexture("./assets/test.png");
  Texture2D *texture_ptr = (Texture2D *) malloc(sizeof(Texture2D));
  *texture_ptr = texture;
  return (s7_make_c_object(s7, texture_2d_tag, (void *) texture_ptr));
}

static void rl_texture_define_methods(s7_scheme *s7) {
  s7_define_function(s7, "rl-load-texture", rl_load_texture, 0, 0, false, "test");
  s7_define_function(s7, "rl-draw-texture", rl_draw_texture, 1, 0, false, "test");
  
  texture_2d_tag = s7_make_c_type(s7, "texture-2d");
  s7_c_type_set_gc_free(s7, texture_2d_tag, free_texture_2d);
}
