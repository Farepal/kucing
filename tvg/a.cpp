#include <SDL2/SDL.h>
#include <iostream>
#include <vector>
#include <cmath>

// Window dimensions
const int WIDTH = 800, HEIGHT = 600;

// Function to draw a pixel on the renderer
void drawPixel(SDL_Renderer *renderer, int x, int y, SDL_Color color) {
    SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);
    SDL_RenderDrawPoint(renderer, x, y);
}

// Main application class
class TransformApp {
public:
    TransformApp() {
        // Initialize SDL
        if (SDL_Init(SDL_INIT_VIDEO) < 0) {
            std::cerr << "SDL could not initialize! SDL_Error: " << SDL_GetError() << std::endl;
        } else {
            // Create window
            window = SDL_CreateWindow("2D Geometric Transformations in C++", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, WIDTH, HEIGHT, SDL_WINDOW_SHOWN);
            if (!window) {
                std::cerr << "Window could not be created! SDL_Error: " << SDL_GetError() << std::endl;
            } else {
                // Create renderer for window
                renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
                if (!renderer) {
                    std::cerr << "Renderer could not be created! SDL_Error: " << SDL_GetError() << std::endl;
                }
            }
        }
    }

    // Main loop of the application
    void run() {
        bool quit = false;
        SDL_Event e;

        while (!quit) {
            // Handle events on queue
            while (SDL_PollEvent(&e) != 0) {
                // User requests quit
                if (e.type == SDL_QUIT) {
                    quit = true;
                }
            }

            // Clear screen
            SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255); // White background
            SDL_RenderClear(renderer);

            // TODO: Implement drawing and transformations here

            // Update screen
            SDL_RenderPresent(renderer);
        }
    }

    ~TransformApp() {
        // Destroy window and renderer
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        window = nullptr;
        renderer = nullptr;

        // Quit SDL subsystems
        SDL_Quit();
    }

private:
    SDL_Window* window = nullptr;
    SDL_Renderer* renderer = nullptr;
};

int main() {
    TransformApp app;
    app.run();
    return 0;
}
