set(BUILD_SHARED_LIBS OFF)  # link third party libraries statically

# raylib
if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/raylib")
  message(FATAL_ERROR "Could not find raylib folder. Did you clone the Git submodules?")
endif()

add_subdirectory(raylib)
target_compile_options(raylib PRIVATE "-w")  # disable warnings
