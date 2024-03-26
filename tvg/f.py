import pygame
import sys
import numpy as np
from pygame.locals import *

# Define some colors
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
RED = (255, 0, 0)
BLUE = (0, 0, 255)

class PygameTransformApp:
    def __init__(self):
        pygame.init()
        self.screen = pygame.display.set_mode((800, 600))
        pygame.display.set_caption("2D Geometric Transformations with GUI in Pygame")
        
        self.font = pygame.font.Font(None, 36)
        
        self.shapes = []
        self.current_shape = []
        self.selected_shape_index = None
        self.dragging = False

        # Transformation parameters
        self.tx, self.ty = 0, 0
        self.sx, self.sy = 1, 1
        self.angle = 0

        # UI state
        self.input_active = False
        self.input_text = ''

    def draw_ui(self):
        # Display the current transformation parameters
        tx_text = self.font.render(f'Translation X: {self.tx}', True, BLACK)
        self.screen.blit(tx_text, (10, 10))
        
        ty_text = self.font.render(f'Translation Y: {self.ty}', True, BLACK)
        self.screen.blit(ty_text, (10, 50))
        
        angle_text = self.font.render(f'Rotation Angle: {self.angle}', True, BLACK)
        self.screen.blit(angle_text, (10, 90))
        
        sx_text = self.font.render(f'Scale X: {self.sx}', True, BLACK)
        self.screen.blit(sx_text, (10, 130))
        
        sy_text = self.font.render(f'Scale Y: {self.sy}', True, BLACK)
        self.screen.blit(sy_text, (10, 170))

    def handle_events(self):
        for event in pygame.event.get():
            if event.type == QUIT:
                pygame.quit()
                sys.exit()
            elif event.type == KEYDOWN:
                # Implement key bindings for adjusting transformations
                if event.key == K_UP:
                    self.ty -= 10
                elif event.key == K_DOWN:
                    self.ty += 10
                elif event.key == K_LEFT:
                    self.tx -= 10
                elif event.key == K_RIGHT:
                    self.tx += 10
                elif event.key == K_r:
                    self.angle = (self.angle + 5) % 360
                elif event.key == K_s:
                    self.sx += 0.1
                    self.sy += 0.1
                elif event.key == K_n:
                    self.sx -= 0.1 if self.sx > 0.1 else 0
                    self.sy -= 0.1 if self.sy > 0.1 else 0

    def run(self):
        clock = pygame.time.Clock()
        while True:
            self.screen.fill(WHITE)
            self.handle_events()
            # Draw all the things
            self.draw_ui()
            pygame.display.flip()
            clock.tick(60)

if __name__ == "__main__":
    app = PygameTransformApp()
    app.run()
