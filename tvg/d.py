import tkinter as tk
from tkinter import messagebox
import numpy as np

class TransformationApp:
    def __init__(self, root):
        self.root = root
        self.canvas = tk.Canvas(root, width=800, height=600, bg='white')
        self.canvas.pack()

        self.shapes = []  # List to store shapes (list of points)
        self.current_shape = []  # Points of the currently drawing shape
        self.selected_shape_index = None  # Index of the selected shape

        # Bind mouse events
        self.canvas.bind('<Button-1>', self.start_draw)
        self.canvas.bind('<B1-Motion>', self.drawing)
        self.canvas.bind('<ButtonRelease-1>', self.end_draw)
        self.canvas.bind('<Button-3>', self.select_shape)  # Right click to select a shape

    def start_draw(self, event):
        self.current_shape = [(event.x, event.y)]

    def drawing(self, event):
        # Draw line from the last point to the current point
        self.current_shape.append((event.x, event.y))
        self.canvas.create_line(self.current_shape[-2], self.current_shape[-1], fill='black')

    def end_draw(self, event):
        if len(self.current_shape) > 1:
            self.shapes.append(self.current_shape)
        self.current_shape = []

    def select_shape(self, event):
        # Deselect any previously selected shape
        if self.selected_shape_index is not None:
            self.redraw_shape(self.selected_shape_index, 'black')
        
        # Find the shape closest to the click (simple approach)
        self.selected_shape_index = self.find_closest_shape(event.x, event.y)
        if self.selected_shape_index is not None:
            self.redraw_shape(self.selected_shape_index, 'red')

    def find_closest_shape(self, x, y):
        closest_index = None
        min_dist = float('inf')
        for index, shape in enumerate(self.shapes):
            for point in shape:
                dist = np.sqrt((point[0] - x) ** 2 + (point[1] - y) ** 2)
                if dist < min_dist:
                    min_dist = dist
                    closest_index = index
        return closest_index

    def redraw_shape(self, shape_index, color):
        shape = self.shapes[shape_index]
        for i in range(len(shape) - 1):
            self.canvas.create_line(shape[i], shape[i+1], fill=color)
            
class TransformationAppExtended(TransformationApp):
    def __init__(self, root):
        super().__init__(root)
        self.setup_ui()

    def setup_ui(self):
        self.translation_button = tk.Button(self.root, text="Translate", command=self.apply_translation)
        self.translation_button.pack(side=tk.LEFT)
        
        self.rotation_button = tk.Button(self.root, text="Rotate", command=self.apply_rotation)
        self.rotation_button.pack(side=tk.LEFT)

        self.scaling_button = tk.Button(self.root, text="Scale", command=self.apply_scaling)
        self.scaling_button.pack(side=tk.LEFT)
        
        self.clear_button = tk.Button(self.root, text="Clear", command=self.clear_canvas)
        self.clear_button.pack(side=tk.LEFT)

    def clear_canvas(self):
        self.shapes = []
        self.selected_shape_index = None
        self.redraw_all_shapes()

    def apply_translation(self):
        if self.selected_shape_index is not None:
            dx, dy = 10, 10  # Example translation values
            matrix = self.translation_matrix(dx, dy)
            self.transform_shape(matrix)

    def apply_rotation(self):
        if self.selected_shape_index is not None:
            angle = 45  # Example rotation angle
            matrix = self.rotation_matrix(angle)
            self.transform_shape(matrix)

    def apply_scaling(self):
        if self.selected_shape_index is not None:
            sx, sy = 1.1, 1.1  # Example scaling factors
            matrix = self.scaling_matrix(sx, sy)
            self.transform_shape(matrix)

    def transform_shape(self, matrix):
        shape = self.shapes[self.selected_shape_index]
        transformed_shape = []
        for point in shape:
            transformed_point = np.dot(matrix, np.array([[point[0]], [point[1]], [1]]))
            transformed_shape.append((transformed_point[0, 0], transformed_point[1, 0]))
        self.shapes[self.selected_shape_index] = transformed_shape
        self.redraw_all_shapes()

    def redraw_all_shapes(self):
        self.canvas.delete("all")
        for index, shape in enumerate(self.shapes):
            color = 'red' if index == self.selected_shape_index else 'black'
            self.redraw_shape(index, color)

    @staticmethod
    def translation_matrix(dx, dy):
        return np.array([[1, 0, dx],
                         [0, 1, dy],
                         [0, 0, 1]])

    @staticmethod
    def rotation_matrix(angle):
        radians = np.radians(angle)
        return np.array([[np.cos(radians), -np.sin(radians), 0],
                         [np.sin(radians), np.cos(radians), 0],
                         [0, 0, 1]])

    @staticmethod
    def scaling_matrix(sx, sy):
        return np.array([[sx, 0, 0],
                         [0, sy, 0],
                         [0, 0, 1]])

def main_extended():
    root = tk.Tk()
    root.title("2D Transformation App with Transformations")
    app = TransformationAppExtended(root)
    root.mainloop()


# Uncomment the line below to run the program
main_extended()
