#include "raylib.h"
#include "text.h"
#include "texture.h"

#include <libguile.h>
#include <math.h>
#include <stdio.h> 
#include <stdlib.h> 
#include <pthread.h> 

static void* game (void* data)
{
  //rl_text_define_methods();
  rl_texture_define_methods();
  
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
      scm_call_with_blocked_asyncs(guile_update);
      //scm_call_0(guile_update);
      
      BeginDrawing();
      ClearBackground(RAYWHITE);
      scm_call_with_blocked_asyncs(guile_draw);
      //scm_call_0(guile_draw);
      EndDrawing();

      // This doesn't change anything
      //      SCM_TICK;
      
      // This line makes memory manageable - until it crashes again (takes more time to crash though)
      //      scm_run_finalizers();
      // This crashes after just a couple of frames
      //      scm_gc();
    }
  
  CloseWindow();
  
  return NULL;
}


int main(int argc, char* argv[]) {
  scm_with_guile (&game, NULL);
  return 0;
}
