import tkinter as tk
import math
import numpy as np

class TransformApp:
    def __init__(self, root):
        self.root = root

        self.shapes = []  # Store drawn shapes (each shape is a list of points)
        self.current_shape = []  # Current shape being drawn

        self.selected_point_index = []  # Index of selected points
        
        self.cartesian_and_selected_point_index = []  # Cartesian coordinates of selected points related to x1, y1
        
        self.selection_start = None  # Starting point of selection rectangle
        self.selection_rectangle = None
        
        self.tx = 0
        self.ty = 0
        
        self.sx = 1
        self.sy = 1
        
        self.angle = 0
        
        self.init_ui()

    def init_ui(self):
        """Initialize the user interface with a canvas and buttons for transformations."""
        self.canvas = tk.Canvas(self.root, width=800, height=600, bg='white')
        self.canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

        control_frame = tk.Frame(self.root)
        control_frame.pack(side=tk.RIGHT, fill=tk.Y)

        # Button to clear canvas
        clear_btn = tk.Button(control_frame, text="Clear", command=self.clear_canvas)
        clear_btn.pack()

        # Transformation buttons
        rotate_btn = tk.Button(control_frame, text="Rotate", command=self.rotate_shape)
        rotate_btn.pack()

        scale_btn = tk.Button(control_frame, text="Scale", command=self.scale_shape)
        scale_btn.pack()

        translate_btn = tk.Button(control_frame, text="Translate", command=self.translate_shape)
        translate_btn.pack()

        drawing_btn = tk.Button(control_frame, text="Drawing", command=self.drawing)
        drawing_btn.pack()

        select_btn = tk.Button(control_frame, text="Select", command=self.initiate_select_mode)
        select_btn.pack()

        translation_label = tk.Label(control_frame, text="Translation")
        translation_label.pack()

        tx_label = tk.Label(control_frame, text="tx:")
        tx_label.pack()
        self.tx_entry = tk.Entry(control_frame)
        self.tx_entry.insert(0, str(self.tx))
        self.tx_entry.pack()

        ty_label = tk.Label(control_frame, text="ty:")
        ty_label.pack()
        self.ty_entry = tk.Entry(control_frame)
        self.ty_entry.insert(0, str(self.ty))
        self.ty_entry.pack()

        rotation_label = tk.Label(control_frame, text="Rotation")
        rotation_label.pack()

        angle_label = tk.Label(control_frame, text="Angle:")
        angle_label.pack()
        self.angle_entry = tk.Entry(control_frame)
        self.angle_entry.insert(0, str(self.angle))
        self.angle_entry.pack()

        scaling_label = tk.Label(control_frame, text="Scaling")
        scaling_label.pack()

        sx_label = tk.Label(control_frame, text="sx:")
        sx_label.pack()
        self.sx_entry = tk.Entry(control_frame)
        self.sx_entry.insert(0, str(self.sx))
        self.sx_entry.pack()

        sy_label = tk.Label(control_frame, text="sy:")
        sy_label.pack()
        self.sy_entry = tk.Entry(control_frame)
        self.sy_entry.insert(0, str(self.sy))
        self.sy_entry.pack()

    def update_all_entries(self):
        self.tx = int(self.tx_entry.get())
        self.ty = int(self.ty_entry.get())
        self.sx = int(self.sx_entry.get())
        self.sy = int(self.sy_entry.get())
        self.angle = int(self.angle_entry.get())

    def drawing(self):
        # Binding mouse events for drawing mode
        self.canvas.bind("<Button-1>", self.start_draw)
        self.canvas.bind("<B1-Motion>", self.drawing_process)
        self.canvas.bind("<ButtonRelease-1>", self.end_draw)

    def start_draw(self, event):
        print("start")
        self.current_shape = [(event.x, event.y)]
        
    def draw_pixel(self, x, y, color='black'):
        """Draw a pixel at (x, y)"""
        self.canvas.create_rectangle(x, y, x+1, y+1, fill=color, outline=color)

    def drawing_process(self, event):
        self.current_shape.append((event.x, event.y))
        self.draw_pixel(event.x, event.y, 'black')

    def end_draw(self, event):
        if len(self.current_shape) > 1:
            self.shapes.append(self.current_shape)
        self.current_shape = []

    def initiate_select_mode(self):
        # Binding mouse events for selection mode
        self.canvas.bind("<Button-1>", self.start_select)
        self.canvas.bind("<B1-Motion>", self.selection_process)  # Use a separate method for handling the dragging
        self.canvas.bind("<ButtonRelease-1>", self.end_select)

    def start_select(self, event):
        # back to black
        for shape in self.shapes:
            for i in range(len(shape) - 1):
                self.draw_pixel(shape[i][0], shape[i][1], 'black')
        self.selected_point_index = []
        self.selection_start = (event.x, event.y)
        self.selection_rectangle = self.canvas.create_rectangle(event.x, event.y, event.x, event.y, outline='blue')

    def selection_process(self, event):
    # Update the selection rectangle during mouse drag
        self.canvas.coords(self.selection_rectangle, self.selection_start[0], self.selection_start[1], event.x, event.y)

    def end_select(self, event):
    # Get the coordinates of the selection rectangle
        self.x1, self.y1, self.x2, self.y2 = self.canvas.coords(self.selection_rectangle)
        self.canvas.delete(self.selection_rectangle)  # Delete the selection rectangle

        # Select all shapes that are either completely or partially inside the selection rectangle
        self.selected_point_index = []
        for shape in (self.shapes):
            for point in shape:
                if self.x1 < point[0] < self.x2 and self.y1 < point[1] < self.y2:
                    self.selected_point_index.append(point)
        
        # color red the selected point index
        for i in range(len(self.selected_point_index) - 1):
            self.canvas.create_rectangle(self.selected_point_index[i], self.selected_point_index[i+1], fill='red')

    def selected_point_index_to_cartesian_related_to_x1_y1(self):
        if len(self.selected_point_index) == 0:
            return
        self.cartesian_and_selected_point_index = []
        for i in range(len(self.selected_point_index)):
            self.cartesian_and_selected_point_index.append((self.selected_point_index[i][0] - self.x1, self.selected_point_index[i][1] - self.y2))
        # negative the index 1
        self.cartesian_and_selected_point_index = [(x, -y) for x, y in self.cartesian_and_selected_point_index]

    def clear_canvas(self):
        """Clear the canvas and shape data."""
        self.shapes = []
        self.redraw_canvas()

    def redraw_canvas(self):
        """Redraw all shapes on the canvas."""
        self.canvas.delete("all")
        for shape in self.shapes:
            for i in range(len(shape) - 1):
                self.draw_pixel(shape[i][0], shape[i][1], 'black')

    def transformation(self, matrix):
        self.selected_point_index_to_cartesian_related_to_x1_y1()
        np_cartesian_and_selected_point_index = np.array(self.cartesian_and_selected_point_index).T
        # fill below with 1
        np_cartesian_and_selected_point_index = np.append(np_cartesian_and_selected_point_index, np.ones((1, np_cartesian_and_selected_point_index.shape[1])), axis=0)
        transformated_points = matrix @ np_cartesian_and_selected_point_index
        # negative y and add self.x1 and self.y1 to each point in index 0 and 1
        transformated_points[1] = -transformated_points[1]
        transformated_points[0] += self.x1
        transformated_points[1] += self.y2
        transformated_points = transformated_points.tolist()
        
        # back to self.selected_point_index
        new_selected_point_index = []
        for i in range(len(transformated_points[0])):
            new_selected_point_index.append((int(transformated_points[0][i]), int(transformated_points[1][i])))
        
        # update shapes with new_selected_point_index
        print(self.shapes)
        for i in range(len(self.selected_point_index)):
            for shape in self.shapes:
                for j in range(len(shape)):
                    if shape[j] == self.selected_point_index[i]:
                        self.shapes[0][j] = new_selected_point_index[i]
                        break
        print(self.shapes)
        self.redraw_canvas()

    def rotate_shape(self):
        """Rotate selected shape. Placeholder for rotation implementation."""
        print("Rotate shape")
        self.update_all_entries()
        transformation_matrix = self.rotation_matrix(self.angle)
        self.transformation(transformation_matrix)

    def scale_shape(self):
        """Scale selected shape. Placeholder for scaling implementation."""
        # Placeholder for actual scaling logic
        print("Scale shape")
        self.update_all_entries()
        transformation_matrix = self.scaling_matrix(self.sx, self.sy)
        self.transformation(transformation_matrix)

    def translate_shape(self):
        """Translate selected shape. Placeholder for translation implementation."""
        # Placeholder for actual translation logic
        print("Translate shape")
        self.update_all_entries()
        transformation_matrix = self.translation_matrix(self.tx, self.ty)
        self.transformation(transformation_matrix)

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

if __name__ == "__main__":
    root = tk.Tk()
    root.title("2D Geometric Transformations")
    app = TransformApp(root)
    root.mainloop()
