#include "raylib.h"
#include <libguile.h>
#include <math.h>
#include <stdio.h> 
#include <stdlib.h> 
#include <pthread.h> 


static SCM rl_draw_text(SCM text)
{
  scm_t_string_failed_conversion_handler handler;
  char* str = scm_to_stringn(text, NULL, NULL, handler);
  DrawText(str, 200, 80, 20, RED);
}

static void* game (void* data)
{
  scm_c_define_gsubr ("rl-draw-text", 1, 0, 0, &rl_draw_text);
  
  const int screen_width = 800;
  const int screen_height = 600;

  InitWindow(screen_width, screen_height, "SLGJ - 2024");
  SetTargetFPS(60);

  char filename[] = SCRIPTS_PATH"main.scm";

  scm_c_primitive_load(filename);

  SCM guile_update = scm_variable_ref(scm_c_lookup("update"));
  SCM guile_draw = scm_variable_ref(scm_c_lookup("draw"));

  while (!WindowShouldClose())
    {
      scm_call_0(guile_update);
      
      BeginDrawing();
      ClearBackground(RAYWHITE);
      scm_call_0(guile_draw);
      EndDrawing();
    }
  
  CloseWindow();
  
  return NULL;
}


int main(int argc, char* argv[]) {
  scm_with_guile (&game, NULL);
  return 0;
}
