#include "raylib.h"
#include "text.h"

#include <libguile.h>
#include <math.h>
#include <stdio.h> 
#include <stdlib.h> 

static void* game (void* data)
{
  rl_text_define_methods();
  
  const int screen_width = 800;
  const int screen_height = 600;

  InitWindow(screen_width, screen_height, "SLGJ - 2024");
  SetTargetFPS(60);

  char filename[] = SCRIPTS_PATH"main.scm";

  scm_c_primitive_load(filename);

  SCM guile_draw = scm_variable_ref(scm_c_lookup("draw"));

  while (!WindowShouldClose())
    { 
      BeginDrawing();
      ClearBackground(RAYWHITE);
      DrawText("a", 200, 80, 20, RED); // <- this line works
      
      //scm_call_0(guile_draw); // <- this will crash the game

      EndDrawing();

    }
  
  CloseWindow();
  
  return NULL;
}


int main(int argc, char* argv[]) {
  scm_with_guile (&game, NULL);
  return 0;
}
