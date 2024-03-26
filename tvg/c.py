import pygame
import numpy as np
import sys

# Initialize pygame
pygame.init()

# Screen dimensions
screen_width, screen_height = 800, 600
screen = pygame.display.set_mode((screen_width, screen_height))

# Colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
GREEN = (0, 255, 0)
RED = (255, 0, 0)
BLUE = (0, 0, 255)

# State variables
drawing = False
selected_shape = None
shapes = []
current_shape = []

# Transformation matrices
def translation_matrix(dx, dy):
    return np.array([[1, 0, dx],
                     [0, 1, dy],
                     [0, 0, 1]])

def rotation_matrix(angle):
    radians = np.radians(angle)
    return np.array([[np.cos(radians), -np.sin(radians), 0],
                     [np.sin(radians), np.cos(radians), 0],
                     [0, 0, 1]])

def scaling_matrix(sx, sy):
    return np.array([[sx, 0, 0],
                     [0, sy, 0],
                     [0, 0, 1]])

def apply_transformation(shape, matrix):
    transformed_shape = []
    for point in shape:
        # Adding a third dimension for matrix multiplication
        point_3d = np.append(point, 1)
        transformed_point = np.dot(matrix, point_3d)[:2]
        transformed_shape.append(transformed_point)
    return transformed_shape

def draw_shapes(shapes):
    for shape in shapes:
        if len(shape) > 1:
            pygame.draw.lines(screen, WHITE, False, shape, 3)

def draw_selected_shape(shape):
    if shape:
        pygame.draw.lines(screen, RED, False, shape, 3)

def main():
    global drawing, current_shape, selected_shape, shapes
    
    clock = pygame.time.Clock()
    
    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            
            if event.type == pygame.MOUSEBUTTONDOWN:
                if not drawing:
                    drawing = True
                    current_shape = [event.pos]
                else:
                    drawing = False
                    shapes.append(current_shape)
                    current_shape = []
            
            if event.type == pygame.MOUSEMOTION and drawing:
                current_shape.append(event.pos)
        
        screen.fill(BLACK)
        
        draw_shapes(shapes)
        draw_selected_shape(selected_shape)
        
        pygame.display.flip()
        clock.tick(60)

# Uncomment the line below to run the program
main()
