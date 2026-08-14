import pygame
import sys
import random

# инициализация
pygame.init()

# константы
width, height = 800, 600
grid_size = 20
grid_width = width // grid_size
grid_height = height // grid_size

# ледяная палитра
deep_blue = (5, 15, 40)      # фон (очень темный синий)
ice_blue = (173, 216, 230)    # текст / акценты
neon_cyan = (0, 255, 255)    # голова змейки
frost_white = (240, 255, 255) # еда (кристаллик)
glacier_blue = (30, 144, 255) # стены
grid_color = (15, 30, 60)    # сетка

screen = pygame.display.set_mode((width, height))
pygame.display.set_caption("snake: arctic edition")
clock = pygame.time.Clock()

# шрифты
try:
    font = pygame.font.SysFont("consolas", 28)
    big_font = pygame.font.SysFont("consolas", 70, bold=True)
except:
    font = pygame.font.SysFont("monospace", 28)
    big_font = pygame.font.SysFont("monospace", 70, bold=True)

levels = [
    set(),
    set([(x, 0) for x in range(grid_width)] + [(x, grid_height-1) for x in range(grid_width)] +
        [(0, y) for y in range(grid_height)] + [(grid_width-1, y) for y in range(grid_height)]),
    set([(x, grid_height//3) for x in range(10, grid_width-10)] +
        [(x, 2*grid_height//3) for x in range(10, grid_width-10)])
]

def draw_text(text, x, y, color=ice_blue, center=False, font_obj=font):
    img = font_obj.render(text, True, color)
    if center:
        rect = img.get_rect(center=(x, y))
        screen.blit(img, rect)
    else:
        screen.blit(img, (x, y))

def main():
    state = "menu"
    menu_options = ["начать", "редактор", "настройки", "выйти"]
    selected_option = 0

    speed_multiplier = 1.0
    walls = set()
    editing = False

    snake = [(grid_width // 2, grid_height // 2)]
    direction = (1, 0)
    food = None
    score = 0
    game_running = False

    def spawn_food(curr_snake, curr_walls):
        while True:
            f = (random.randint(0, grid_width - 1), random.randint(0, grid_height - 1))
            if f not in curr_snake and f not in curr_walls:
                return f

    while True:
        screen.fill(deep_blue)

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()

            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_q and (pygame.key.get_mods() & pygame.KMOD_CTRL):
                    pygame.quit()
                    sys.exit()

                if event.key == pygame.K_r:
                    main()

                if state == "menu":
                    if event.key == pygame.K_UP:
                        selected_option = (selected_option - 1) % len(menu_options)
                    elif event.key == pygame.K_DOWN:
                        selected_option = (selected_option + 1) % len(menu_options)
                    elif event.key == pygame.K_RETURN:
                        choice = menu_options[selected_option]
                        if choice == "начать":
                            walls = random.choice(levels).copy()
                            state = "playing"
                            editing = False
                            game_running = True
                            food = spawn_food(snake, walls)
                        elif choice == "редактор":
                            walls = set()
                            state = "playing"
                            editing = True
                            game_running = False
                        elif choice == "настройки":
                            state = "settings"
                        elif choice == "выйти":
                            pygame.quit()
                            sys.exit()

                elif state == "settings":
                    if event.key in [pygame.K_RIGHT, pygame.K_d]:
                        speed_multiplier += 0.5
                    elif event.key in [pygame.K_LEFT, pygame.K_a]:
                        speed_multiplier = max(0.5, speed_multiplier - 0.5)
                    elif event.key == pygame.K_RETURN:
                        state = "menu"

                elif state == "playing":
                    if editing:
                        if event.key == pygame.K_RIGHTBRACKET:
                            m_pos = pygame.mouse.get_pos()
                            cell = (m_pos[0] // grid_size, m_pos[1] // grid_size)
                            if cell != snake[0]:
                                if cell in walls: walls.remove(cell)
                                else: walls.add(cell)
                        if event.key == pygame.K_LEFTBRACKET:
                            walls.clear()
                        if event.key == pygame.K_RETURN:
                            editing = False
                            game_running = True
                            food = spawn_food(snake, walls)
                    else:
                        if event.key in [pygame.K_UP, pygame.K_w, pygame.K_i] and direction != (0, 1):
                            direction = (0, -1)
                        elif event.key in [pygame.K_DOWN, pygame.K_s, pygame.K_k] and direction != (0, -1):
                            direction = (0, 1)
                        elif event.key in [pygame.K_LEFT, pygame.K_a, pygame.K_j] and direction != (1, 0):
                            direction = (-1, 0)
                        elif event.key in [pygame.K_RIGHT, pygame.K_d, pygame.K_l] and direction != (-1, 0):
                            direction = (1, 0)

        if state == "menu":
            draw_text("FROST SNAKE", width//2, 120, neon_cyan, True, big_font)
            for i, opt in enumerate(menu_options):
                color = neon_cyan if i == selected_option else ice_blue
                prefix = "> " if i == selected_option else "  "
                draw_text(prefix + opt, width//2, 280 + i*50, color, True)

        elif state == "settings":
            draw_text("CONFIG", width//2, 150, ice_blue, True, big_font)
            draw_text(f"Speed Factor: {speed_multiplier}", width//2, height//2, neon_cyan, True)
            draw_text(f"({int(2 * speed_multiplier)} cells/sec)", width//2, height//2 + 40, glacier_blue, True)
            draw_text("Press Enter to save", width//2, height - 100, ice_blue, True)

        elif state == "playing":
            if game_running and not editing:
                new_head = (snake[0][0] + direction[0], snake[0][1] + direction[1])
                if (new_head[0] < 0 or new_head[0] >= grid_width or
                    new_head[1] < 0 or new_head[1] >= grid_height or
                    new_head in walls or new_head in snake):
                    state = "menu"
                    snake = [(grid_width // 2, grid_height // 2)]
                    direction = (1, 0)
                    score = 0
                else:
                    snake.insert(0, new_head)
                    if new_head == food:
                        score += 1
                        food = spawn_food(snake, walls)
                    else:
                        snake.pop()

            # отрисовка сетки
            for x in range(0, width, grid_size):
                pygame.draw.line(screen, grid_color, (x, 0), (x, height))
            for y in range(0, height, grid_size):
                pygame.draw.line(screen, grid_color, (0, y), (width, y))

            # отрисовка стен (как ледяные глыбы)
            for wall in walls:
                pygame.draw.rect(screen, glacier_blue, (wall[0]*grid_size, wall[1]*grid_size, grid_size-1, grid_size-1))
                pygame.draw.rect(screen, ice_blue, (wall[0]*grid_size, wall[1]*grid_size, grid_size-1, grid_size-1), 1)

            # отрисовка еды (мерцающий кристалл)
            if food:
                pygame.draw.rect(screen, frost_white, (food[0]*grid_size + 4, food[1]*grid_size + 4, grid_size-9, grid_size-9))
                pygame.draw.rect(screen, neon_cyan, (food[0]*grid_size + 2, food[1]*grid_size + 2, grid_size-5, grid_size-5), 1)

            # отрисовка змейки с градиентом
            for i, part in enumerate(snake):
                if i == 0:
                    color = neon_cyan
                else:
                    # чем дальше хвост, тем темнее синий
                    alpha = max(50, 200 - (i * 10))
                    color = (0, alpha, alpha + 55)

                pygame.draw.rect(screen, color, (part[0]*grid_size, part[1]*grid_size, grid_size-1, grid_size-1))

            if editing:
                m_pos = pygame.mouse.get_pos()
                c_cell = (m_pos[0] // grid_size, m_pos[1] // grid_size)
                pygame.draw.rect(screen, (30, 50, 100), (c_cell[0]*grid_size, c_cell[1]*grid_size, grid_size, grid_size), 2)
                draw_text("EDITOR: ] ADD/DEL, [ CLEAR, ENTER START", 10, 10, neon_cyan)
            else:
                draw_text(f"SCORE: {score}", 10, 10, ice_blue)

        pygame.display.flip()
        current_fps = 2 * speed_multiplier if state == "playing" and not editing else 30
        clock.tick(current_fps)

if __name__ == "__main__":
    main()
