import pygame
import sys
import math

# Inisialisasi pygame
pygame.init()

# Ukuran layar
WIDTH, HEIGHT = 800, 600
SCREEN_SIZE = (WIDTH, HEIGHT)
CENTER = (WIDTH // 2, HEIGHT // 2)

# Warna
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
RED = (255, 0, 0)

# Fungsi untuk menggambar objek
def draw_object(surface, color, points):
    pygame.draw.polygon(surface, color, points)

# Fungsi untuk melakukan transformasi translasi
def translate(points, tx, ty):
    return [(x + tx, y + ty) for x, y in points]

# Fungsi untuk melakukan transformasi rotasi
def rotate(points, angle, center):
    angle_rad = math.radians(angle)
    cos_theta = math.cos(angle_rad)
    sin_theta = math.sin(angle_rad)
    cx, cy = center
    return [((x - cx) * cos_theta - (y - cy) * sin_theta + cx,
             (x - cx) * sin_theta + (y - cy) * cos_theta + cy) for x, y in points]

# Fungsi untuk menampilkan teks di layar
def draw_text(surface, text, font, color, pos):
    text_surface = font.render(text, True, color)
    text_rect = text_surface.get_rect(center=pos)
    surface.blit(text_surface, text_rect)

def main():
    # Inisialisasi layar
    screen = pygame.display.set_mode(SCREEN_SIZE)
    pygame.display.set_caption('2D Transformation')

    # Clock
    clock = pygame.time.Clock()

    # Objek dinamis
    dynamic_object = []

    # Variabel untuk menyimpan hasil transformasi
    transformed_object = []

    # Sudut rotasi awal
    rotation_angle = 0

    drawing = False
    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.MOUSEBUTTONDOWN:
                if event.button == 1:  # Klik kiri mouse
                    drawing = True
                    dynamic_object = [event.pos]
            elif event.type == pygame.MOUSEBUTTONUP:
                if event.button == 1:  # Lepas klik kiri mouse
                    drawing = False
                    transformed_object = dynamic_object.copy()
            elif event.type == pygame.MOUSEMOTION:
                if drawing:
                    dynamic_object.append(event.pos)
            elif event.type == pygame.KEYDOWN:
                # Melakukan transformasi
                if event.key == pygame.K_t:
                    transformed_object = translate(transformed_object, 20, 20)
                elif event.key == pygame.K_r:
                    rotation_angle += 45
                    transformed_object = rotate(transformed_object, rotation_angle, CENTER)

        # Bersihkan layar
        screen.fill(WHITE)

        # Gambar objek dinamis
        if len(dynamic_object) > 1:
            pygame.draw.lines(screen, BLACK, False, dynamic_object)
        
        # Gambar objek hasil transformasi
        if transformed_object:
            draw_object(screen, RED, transformed_object)

        # Teks instruksi
        font = pygame.font.Font(None, 24)
        draw_text(screen, "Drag mouse to draw, T to translate, R to rotate", font, BLACK, (WIDTH // 2, HEIGHT - 30))

        # Update layar
        pygame.display.flip()

        # Batasi kecepatan frame
        clock.tick(30)

    pygame.quit()
    sys.exit()

if __name__ == '_main_':
    main()