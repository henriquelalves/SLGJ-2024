cmake_minimum_required(VERSION 3.0)
project(slgj C)
set(CMAKE_C_STANDARD 99)

# the `pkg_check_modules` function is created with this call
find_package(PkgConfig REQUIRED)

# Adding Raylib
include(FetchContent)
set(FETCHCONTENT_QUIET FALSE)
set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE) # don't build the supplied examples
set(BUILD_GAMES    OFF CACHE BOOL "" FORCE) # don't build the supplied example games

FetchContent_Declare(
  raylib
  GIT_REPOSITORY "https://github.com/raysan5/raylib.git"
  GIT_TAG "master"
  GIT_PROGRESS TRUE
)

FetchContent_MakeAvailable(raylib)

# Adding our source files
file(GLOB_RECURSE PROJECT_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_LIST_DIR}/sources/*.c") # Define PROJECT_SOURCES as a list of all source files
set(PROJECT_INCLUDE "${CMAKE_CURRENT_LIST_DIR}/sources/") # Define PROJECT_INCLUDE to be the path to the include directory of the project

# Declaring our executable
add_executable(${PROJECT_NAME})
target_sources(${PROJECT_NAME} PRIVATE ${PROJECT_SOURCES})
target_include_directories(${PROJECT_NAME} PRIVATE ${PROJECT_INCLUDE})
target_link_libraries(${PROJECT_NAME} PRIVATE raylib)

# Checks if OSX and links appropriate frameworks (Only required on MacOS)
if (APPLE)
  target_link_libraries(${PROJECT_NAME} PRIVATE "-framework IOKit")
  target_link_libraries(${PROJECT_NAME} PRIVATE "-framework Cocoa")
  target_link_libraries(${PROJECT_NAME} PRIVATE "-framework OpenGL")
endif()

# Web Configurations
if (${PLATFORM} STREQUAL "Web")
  # Tell Emscripten to build an example.html file.
  set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".html")
endif()

if (EMSCRIPTEN)
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -s USE_GLFW=3 -s ASSERTIONS=1 -s WASM=1 -s GL_ENABLE_GET_PROC_ADDRESS=1 --embed-file assets --embed-file scripts")
  set(CMAKE_EXECUTABLE_SUFFIX ".html") # This line is used to set your executable to build with the emscripten html template so that you can directly open it.
  add_custom_command(
    TARGET ${CMAKE_PROJECT_NAME} PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/assets $<TARGET_FILE_DIR:${CMAKE_PROJECT_NAME}>/assets
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/scripts $<TARGET_FILE_DIR:${CMAKE_PROJECT_NAME}>/scripts
  )
  add_custom_command(
    TARGET ${CMAKE_PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE_DIR:${CMAKE_PROJECT_NAME}>/${CMAKE_PROJECT_NAME}.html ${CMAKE_SOURCE_DIR}/out/${CMAKE_PROJECT_NAME}.html
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE_DIR:${CMAKE_PROJECT_NAME}>/${CMAKE_PROJECT_NAME}.js ${CMAKE_SOURCE_DIR}/out/${CMAKE_PROJECT_NAME}.js
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE_DIR:${CMAKE_PROJECT_NAME}>/${CMAKE_PROJECT_NAME}.wasm ${CMAKE_SOURCE_DIR}/out/${CMAKE_PROJECT_NAME}.wasm
  )
else ()
  add_custom_command(
    TARGET ${CMAKE_PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/scripts ${CMAKE_SOURCE_DIR}/out/scripts
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/assets ${CMAKE_SOURCE_DIR}/out/assets
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE_DIR:${CMAKE_PROJECT_NAME}>/${CMAKE_PROJECT_NAME} ${CMAKE_SOURCE_DIR}/out/${CMAKE_PROJECT_NAME}
  )  
endif ()

# Setting ASSETS_PATH
target_compile_definitions(${PROJECT_NAME} PUBLIC ASSETS_PATH="./assets/")
target_compile_definitions(${PROJECT_NAME} PUBLIC SCRIPTS_PATH="./scripts/")
