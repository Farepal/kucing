import pygame
import numpy as np

# Initialize Pygame
pygame.init()
window_size = (600, 400)
screen = pygame.display.set_mode(window_size)
pygame.display.set_caption("2D Transformations")
clock = pygame.time.Clock()

# Colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)

# Variables for drawing
drawing = False
current_shape = []
shapes = []

# Current transformation
transformation_mode = None

# Define transformation matrices
def get_translation_matrix(dx, dy):
    return np.array([[1, 0, dx],
                     [0, 1, dy],
                     [0, 0, 1]])

def get_rotation_matrix(angle):
    rad = np.radians(angle)
    return np.array([[np.cos(rad), -np.sin(rad), 0],
                     [np.sin(rad),  np.cos(rad), 0],
                     [0,            0,           1]])

def get_scaling_matrix(sx, sy):
    return np.array([[sx, 0,  0],
                     [0,  sy, 0],
                     [0,  0,  1]])

# Apply matrix transformation
def apply_matrix(shape, matrix):
    return [tuple(matrix @ np.array(point + (1,)))[:2] for point in shape]

# Main loop
running = True
while running:
    screen.fill(WHITE)
    
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.MOUSEBUTTONDOWN:
            if event.button == 1:  # Left mouse button
                drawing = True
                current_shape.append(event.pos)
        elif event.type == pygame.MOUSEBUTTONUP:
            if event.button == 1:  # Left mouse button
                drawing = False
                shapes.append(current_shape)
                current_shape = []
        elif event.type == pygame.MOUSEMOTION:
            if drawing:
                current_shape.append(event.pos)
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_t:
                transformation_mode = 'translate'
            elif event.key == pygame.K_r:
                transformation_mode = 'rotate'
            elif event.key == pygame.K_s:
                transformation_mode = 'scale'
            elif event.key in (pygame.K_LEFT, pygame.K_RIGHT, pygame.K_UP, pygame.K_DOWN):
                if shapes and transformation_mode:
                    matrix = np.eye(3)
                    if transformation_mode == 'translate':
                        dx = -5 if event.key == pygame.K_LEFT else 5
                        dy = -5 if event.key == pygame.K_UP else 5
                        matrix = get_translation_matrix(dx, dy)
                    elif transformation_mode == 'rotate':
                        angle = -5 if event.key == pygame.K_LEFT else 5
                        matrix = get_rotation_matrix(angle)
                    elif transformation_mode == 'scale':
                        scale_factor = 0.9 if event.key == pygame.K_DOWN else 1.1
                        matrix = get_scaling_matrix(scale_factor, scale_factor)
                    shapes[-1] = apply_matrix(shapes[-1], matrix)

    # Draw shapes
    for shape in shapes + [current_shape]:
        if len(shape) > 1:
            pygame.draw.lines(screen, BLACK, False, shape, 2)
    
    pygame.display.flip()
    clock.tick(60)

pygame.quit()
