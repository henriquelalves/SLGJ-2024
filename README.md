This is a simple toy game engine I'm making for [Lisp Game Jam 2024](https://itch.io/jam/spring-lisp-game-jam-2024)! I'm posting the devlog here: https://henriquelalves.com/tags/devlog/.

To build the game, you need CMake.

1. Clone the repository and its submodule (Raylib)
2. Run `cmake -B build` to create the build folder, and `cmake --build build` to build the game.
3. The game will be copied with the necessary files to the `out/` folder.

The Scheme scripts on `scripts/` can be altered after building the game, the engine only read the files when starting up.
