package main

import "vendor:raylib"

main :: proc() {
    raylib.SetConfigFlags({raylib.ConfigFlag.WINDOW_RESIZABLE})
    raylib.InitWindow(800, 600, "test window");
    raylib.SetTargetFPS(60);

    for !raylib.WindowShouldClose() {
        raylib.BeginDrawing()

        raylib.ClearBackground(raylib.Color{200, 150, 100, 255})
        raylib.DrawText("Test stuff", 100, 100, 20, raylib.LIGHTGRAY)

        raylib.EndDrawing()
    }

    return
}