from tkinter import Tk, Canvas, PhotoImage, mainloop


class Color:
    BLACK = '#000000'
    WHITE = '#ffffff'


class CustomCanvas(Canvas):
    """Class for drawing on canvas by pixels (simple as much as possible)
    >>> canvas = CustomCanvas()
    >>> canvas.draw(50, 42)
    >>> canvas.display()
    """

    def __init__(self, width=800, height=800):
        # Define a window for displaying drawing results
        self.window = Tk()

        # You cannot access to a pixel on a canvas that is why
        # we define an image for drawing by pixels
        self.image = PhotoImage(width=width, height=height)

        # We initialize the canvas and create the image into it
        super().__init__(
            self.window, width=width, height=height, bg=Color.BLACK
        )
        self.create_image((width//2, height//2), image=self.image)
        self.pack()

    def draw(self, x, y, color=Color.WHITE):
        self.image.put(color, (x, y))

    @staticmethod
    def display():
        mainloop()


class Line:
    def __init__(self, canvas):
        self.canvas = canvas

    def draw(self, x0, y0, x1, y1, color=Color.WHITE):
        reverse = False

        if abs(x0 - x1) < abs(y0 - y1):
            reverse = True
            x0, y0 = y0, x0
            x1, y1, = y1, x1

        if x0 > x1:
            x0, y0 = y0, x0
            x1, y1, = y1, x1

        y = y0
        error = 0
        dx = x1 - x0
        dy = y1 - y0
        derror = abs(dy / dx)

        for x in range(x0, x1):
            if reverse:
                self.canvas.draw(y, x, color)
            else:
                self.canvas.draw(x, y, color)

            error += derror

            if error > 0.5:
                y += 1 if y1 > y0 else -1
                error -= 1


if __name__ == '__main__':
    canvas = CustomCanvas()

    Line(canvas).draw(180, 200, 390, 400)

    canvas.display()