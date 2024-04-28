#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#include <emscripten/html5.h>
#endif

#include "raylib.h"
#include "s7.h"
#include "types.h"
#include "text.h"
#include "texture.h"
#include "core.h"
#include "shapes.h"

#include <math.h>
#include <stdio.h> 
#include <stdlib.h>

s7_scheme *s7;
s7_pointer s7_update_fn;
s7_pointer s7_draw_fn;

#ifdef __EMSCRIPTEN__
EM_BOOL main_loop_web(double time, void* userData) {
  s7_call(s7, s7_update_fn, s7_list(s7, 0));
      
  BeginDrawing();
  ClearBackground(BLUE);
  s7_call(s7, s7_draw_fn, s7_list(s7, 0));
  EndDrawing();
  return EM_TRUE;
}
#else
void main_loop(){
  s7_call(s7, s7_update_fn, s7_list(s7, 0));
      
  BeginDrawing();
  ClearBackground(RAYWHITE);
  s7_call(s7, s7_draw_fn, s7_list(s7, 0));
  EndDrawing();
}
#endif


int main(int argc, char* argv[]) {
  s7 = s7_init();

  rl_register_types(s7);
  rl_text_define_methods(s7);
  rl_texture_define_methods(s7);
  rl_core_define_methods(s7);
  rl_shapes_define_methods(s7);
  
  const int screen_width = 800;
  const int screen_height = 600;

  InitWindow(screen_width, screen_height, "SLGJ - 2024");
  SetTargetFPS(60);

  char filename[] = SCRIPTS_PATH"main.scm";

  s7_load(s7, filename);

  s7_update_fn = s7_name_to_value(s7, "update");
  s7_draw_fn = s7_name_to_value(s7, "draw");

#ifdef __EMSCRIPTEN__
  emscripten_request_animation_frame_loop(main_loop_web, 0);
#else
  while (!WindowShouldClose()) {
    main_loop();
  }
  
  CloseWindow();
#endif
  
  return 0;
}
