import pygame
import numpy as np
import sys

# Initialize Pygame
pygame.init()
window_size = (800, 600)
screen = pygame.display.set_mode(window_size)
pygame.display.set_caption("2D Transformations")
clock = pygame.time.Clock()

# Colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
GREEN = (0, 255, 0)

# Variables for drawing and transformation
drawing = False
current_shape = []
shapes = []
selected_shape_index = None
transformations = {"translate": np.eye(3), "rotate": np.eye(3), "scale": np.eye(3)}

# Transformation matrices functions
def get_translation_matrix(dx, dy):
    return np.array([[1, 0, dx], [0, 1, dy], [0, 0, 1]])

def get_rotation_matrix(angle):
    rad = np.radians(angle)
    return np.array([[np.cos(rad), -np.sin(rad), 0],
                     [np.sin(rad), np.cos(rad), 0],
                     [0, 0, 1]])

def get_scaling_matrix(sx, sy):
    return np.array([[sx, 0, 0], [0, sy, 0], [0, 0, 1]])

# Apply matrix transformation to shape
def apply_matrix(shape, matrix):
    return [tuple(matrix @ np.array(point + (1,)))[:2] for point in shape]

# Apply transformation
def apply_transformation(shape_index, transformation):
    global shapes
    shapes[shape_index] = apply_matrix(shapes[shape_index], transformations[transformation])

# Get input for transformation
def get_transformation_input(transformation):
    if transformation == "translate":
        dx = float(input("Enter x translation: "))
        dy = float(input("Enter y translation: "))
        return get_translation_matrix(dx, dy)
    elif transformation == "rotate":
        angle = float(input("Enter rotation angle: "))
        return get_rotation_matrix(angle)
    elif transformation == "scale":
        sx = float(input("Enter x scale factor: "))
        sy = float(input("Enter y scale factor: "))
        return get_scaling_matrix(sx, sy)

# Main loop
running = True
while running:
    screen.fill(WHITE)

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
        elif event.type == pygame.MOUSEBUTTONDOWN:
            if event.button == 1:  # Left mouse button
                drawing = True
                current_shape.append(event.pos)
            elif event.button == 3:  # Right mouse button
                # Select shape
                mouse_pos = pygame.mouse.get_pos()
                for i, shape in enumerate(shapes):
                    if mouse_pos in shape:
                        selected_shape_index = i
                        break
        elif event.type == pygame.MOUSEBUTTONUP:
            if event.button == 1:  # Left mouse button
                drawing = False
                shapes.append(current_shape)
                current_shape = []
        elif event.type == pygame.MOUSEMOTION:
            if drawing:
                current_shape.append(event.pos)
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_c and selected_shape_index is not None:
                # Cancel selection
                selected_shape_index = None

    if selected_shape_index is not None:
        # Get input for transformations from the console
        for transformation in ["translate", "rotate", "scale"]:
            transformations[transformation] = get_transformation_input(transformation)
            apply_transformation(selected_shape_index, transformation)
            selected_shape_index = None  # Deselect shape after applying transformations

    # Draw shapes
    for i, shape in enumerate(shapes):
        color = GREEN if i == selected_shape_index else BLACK
        if len(shape) > 1:
            pygame.draw.lines(screen, color, False, shape, 2)

    pygame.display.flip()
    clock.tick(60)
