import pygame
import pygame_gui
from pygame.locals import *

pygame.init()

# Window setup
window_size = (800, 600)
window = pygame.display.set_mode(window_size)
pygame.display.set_caption("2D Geometric Transformations with Pygame and Pygame_GUI")

# GUI manager
manager = pygame_gui.UIManager(window_size)

# Create GUI elements
clear_button = pygame_gui.elements.UIButton(relative_rect=pygame.Rect((650, 50), (100, 50)),
                                            text='Clear',
                                            manager=manager)

# Clock and background color
clock = pygame.time.Clock()
background_color = pygame.Color('#FFFFFF')

# Main loop
is_running = True
while is_running:
    time_delta = clock.tick(60)/1000.0
    
    for event in pygame.event.get():
        if event.type == QUIT:
            is_running = False
        
        # Pass the event to the GUI manager
        manager.process_events(event)
        
        # Handle clear button
        if event.type == pygame.USEREVENT:
            if event.user_type == pygame_gui.UI_BUTTON_PRESSED:
                if event.ui_element == clear_button:
                    print("Clear the canvas")

    # Update GUI
    manager.update(time_delta)
    
    # Render everything
    window.fill(background_color)
    manager.draw_ui(window)
    
    pygame.display.update()

pygame.quit()
