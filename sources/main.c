#include "raylib.h"
#include "text.h"
#include "s7.h"

#include <math.h>
#include <stdio.h> 
#include <stdlib.h>


int main(int argc, char* argv[]) {
  s7_scheme *s7 = s7_init();
  
  rl_text_define_methods(s7);
  
  const int screen_width = 800;
  const int screen_height = 600;

  InitWindow(screen_width, screen_height, "SLGJ - 2024");
  SetTargetFPS(60);

  char filename[] = SCRIPTS_PATH"main.scm";
  s7_load(s7, filename);

  s7_pointer s7_update_fn = s7_name_to_value(s7, "update");
  s7_pointer s7_draw_fn = s7_name_to_value(s7, "draw");
  
  while (!WindowShouldClose())
    {
      s7_call(s7, s7_update_fn, s7_list(s7, 0));      
      
      BeginDrawing();
      ClearBackground(RAYWHITE);
      s7_call(s7, s7_draw_fn, s7_list(s7, 0));
      EndDrawing();

      s7_eval_c_string(s7, "(display 'noice')");
    }
  
  CloseWindow();
  
  return 0;
}
