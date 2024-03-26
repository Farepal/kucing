import pygame
import tkinter as tk
import numpy as np
from tkinter import ttk

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

# Transformation functions using matrices
def matrix_transform(shape, matrix):
    # Append 1 for homogeneous coordinates
    points = np.array([np.append(point, 1) for point in shape])
    transformed_points = points @ matrix.T
    # Discard the homogeneous coordinate
    return transformed_points[:, :2].tolist()

# Tkinter GUI for transformation controls
def apply_transformation():
    global shapes
    selected_shape = int(shape_combo.get())
    transformation_type = trans_combo.get()
    dx = float(dx_entry.get())
    dy = float(dy_entry.get())
    angle = float(angle_entry.get())
    sx = float(sx_entry.get())
    sy = float(sy_entry.get())

    if transformation_type == 'Translate':
        matrix = np.array([[1, 0, 0],
                           [0, 1, 0],
                           [dx, dy, 1]])
    elif transformation_type == 'Rotate':
        rad = np.radians(angle)
        matrix = np.array([[np.cos(rad), -np.sin(rad), 0],
                           [np.sin(rad), np.cos(rad), 0],
                           [0, 0, 1]])
    elif transformation_type == 'Scale':
        matrix = np.array([[sx, 0, 0],
                           [0, sy, 0],
                           [0, 0, 1]])

    shapes[selected_shape] = matrix_transform(shapes[selected_shape], matrix)

# Setting up the Tkinter window
root = tk.Tk()
root.title("Transformation Controls")

# Transformation type
ttk.Label(root, text="Transformation:").grid(column=0, row=0, padx=5, pady=5)
trans_combo = ttk.Combobox(root, values=['Translate', 'Rotate', 'Scale'])
trans_combo.grid(column=1, row=0, padx=5, pady=5)
trans_combo.current(0)

# Shape selector
ttk.Label(root, text="Shape:").grid(column=2, row=0, padx=5, pady=5)
shape_combo = ttk.Combobox(root, values=[str(i) for i in range(len(shapes))])
shape_combo.grid(column=3, row=0, padx=5, pady=5)

# Translation entries
dx_entry = tk.Entry(root, width=5)
dx_entry.grid(column=1, row=1, padx=5, pady=5)
dx_entry.insert(0, '0')

dy_entry = tk.Entry(root, width=5)
dy_entry.grid(column=1, row=2, padx=5, pady=5)
dy_entry.insert(0, '0')

# Rotation entry
angle_entry = tk.Entry(root, width=5)
angle_entry.grid(column=1, row=3, padx=5, pady=5)
angle_entry.insert(0, '0')

# Scale entries
sx_entry = tk.Entry(root, width=5)
sx_entry.grid(column=1, row=4, padx=5, pady=5)
sx_entry.insert(0, '1')

sy_entry = tk.Entry(root, width=5)
sy_entry.grid(column=1, row=5, padx=5, pady=5)
sy_entry.insert(0, '1')

# Apply button
apply_button = tk.Button(root, text="Apply Transformation", command=apply_transformation)
apply_button.grid(column=1, row=6, padx=5, pady=5)

# Running the Tkinter event loop in a separate thread
import threading
def run_tkinter():
    root.mainloop()

t = threading.Thread(target=run_tkinter)
t.daemon = True
t.start()

# Pygame event loop
running = True
while running:
    screen.fill(WHITE)
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    # Update the shapes combo box with latest shapes
    shape_combo['values'] = [str(i) for i in range(len(shapes))]

    # Draw shapes
    for shape in shapes:
        if len(shape) > 1:
            pygame.draw.lines(screen, BLACK, True, shape, 2)

    pygame.display.flip()
    clock.tick(60)

pygame.quit()
