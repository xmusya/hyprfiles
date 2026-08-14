import pygame
import random

# инициализация
pygame.init()

# настройки экрана
s_width = 800
s_height = 700
play_width = 300
play_height = 600
block_size = 30

top_left_x = (s_width - play_width) // 2
top_left_y = s_height - play_height - 50

# форматы фигур
s = [['.....', '.....', '..00.', '.00..', '.....'], ['.....', '..0..', '..00.', '...0.', '.....']]
z = [['.....', '.....', '.00..', '..00.', '.....'], ['.....', '..0..', '.00..', '.0..', '.....']]
i = [['..0..', '..0..', '..0..', '..0..', '.....'], ['.....', '0000.', '.....', '.....', '.....']]
o = [['.....', '.....', '.00..', '.00..', '.....']]
j = [['.....', '.0...', '.000.', '.....', '.....'], ['.....', '..00.', '..0..', '..0..', '.....'], ['.....', '.....', '.000.', '...0.', '.....'], ['.....', '..0..', '..0..', '.00..', '.....']]
l = [['.....', '...0.', '.000.', '.....', '.....'], ['.....', '..0..', '..0..', '..00.', '.....'], ['.....', '.....', '.000.', '.0...', '.....'], ['.....', '.00..', '..0..', '..0..', '.....']]
t = [['.....', '..0..', '.000.', '.....', '.....'], ['.....', '..0..', '..00.', '..0..', '.....'], ['.....', '.....', '.000.', '..0..', '.....'], ['.....', '..0..', '.00..', '..0..', '.....']]

shapes = [s, z, i, o, j, l, t]
shape_colors = [(0, 255, 0), (255, 0, 0), (0, 255, 255), (255, 255, 0), (255, 165, 0), (0, 0, 255), (128, 0, 128)]

class piece(object):
    def __init__(self, x, y, shape):
        self.x = x
        self.y = y
        self.shape = shape
        self.color = shape_colors[shapes.index(shape)]
        self.rotation = 0

def create_grid(locked_pos={}):
    grid = [[(0,0,0) for _ in range(10)] for _ in range(20)]
    for i in range(len(grid)):
        for j in range(len(grid[i])):
            if (j, i) in locked_pos:
                grid[i][j] = locked_pos[(j,i)]
    return grid

def convert_shape_format(shape):
    positions = []
    format = shape.shape[shape.rotation % len(shape.shape)]
    for i, line in enumerate(format):
        row = list(line)
        for j, column in enumerate(row):
            if column == '0':
                positions.append((shape.x + j, shape.y + i))
    for i, pos in enumerate(positions):
        positions[i] = (pos[0] - 2, pos[1] - 4)
    return positions

def valid_space(shape, grid):
    accepted_pos = [[(j, i) for j in range(10) if grid[i][j] == (0,0,0)] for i in range(20)]
    accepted_pos = [j for sub in accepted_pos for j in sub]
    formatted = convert_shape_format(shape)
    for pos in formatted:
        if pos not in accepted_pos:
            if pos[1] > -1:
                return False
    return True

def get_ghost_pos(shape, grid):
    temp_shape = piece(shape.x, shape.y, shape.shape)
    temp_shape.rotation = shape.rotation
    while valid_space(temp_shape, grid):
        temp_shape.y += 1
    temp_shape.y -= 1
    return convert_shape_format(temp_shape)

def check_lost(positions):
    for pos in positions:
        x, y = pos
        if y < 1:
            return True
    return False

def get_shape():
    return piece(5, 0, random.choice(shapes))

def draw_text_middle(surface, text, size, color):
    font = pygame.font.SysFont("comicsans", size, bold=True)
    label = font.render(text, 1, color)
    surface.blit(label, (top_left_x + play_width/2 - (label.get_width()/2), top_left_y + play_height/2 - label.get_height()/2))

def draw_grid(surface, grid):
    sx, sy = top_left_x, top_left_y
    for i in range(len(grid)):
        pygame.draw.line(surface, (128,128,128), (sx, sy + i*block_size), (sx+play_width, sy + i*block_size))
        for j in range(len(grid[i])):
            pygame.draw.line(surface, (128,128,128), (sx + j*block_size, sy), (sx + j*block_size, sy + play_height))

def clear_rows(grid, locked):
    inc = 0
    for i in range(len(grid)-1, -1, -1):
        if (0,0,0) not in grid[i]:
            inc += 1
            ind = i
            for j in range(len(grid[i])):
                try: del locked[(j,i)]
                except: continue
    if inc > 0:
        for key in sorted(list(locked.keys()), key=lambda x: x[1])[::-1]:
            x, y = key
            if y < ind:
                newKey = (x, y + inc)
                locked[newKey] = locked.pop(key)
    return inc

def draw_next_shape(shape, surface):
    font = pygame.font.SysFont('comicsans', 30)
    label = font.render('следующая:', 1, (255,255,255))
    sx, sy = top_left_x + play_width + 50, top_left_y + 100
    format = shape.shape[shape.rotation % len(shape.shape)]
    for i, line in enumerate(format):
        for j, column in enumerate(list(line)):
            if column == '0':
                pygame.draw.rect(surface, shape.color, (sx + j*block_size, sy + i*block_size, block_size, block_size), 0)
    surface.blit(label, (sx, sy - 40))

def draw_window(surface, grid, score=0):
    surface.fill((0, 0, 0))
    font = pygame.font.SysFont('comicsans', 60)
    label = font.render('tetris', 1, (255, 255, 255))
    surface.blit(label, (top_left_x + play_width / 2 - (label.get_width() / 2), 30))

    font = pygame.font.SysFont('comicsans', 30)
    label = font.render('счет: ' + str(score), 1, (255,255,255))
    surface.blit(label, (top_left_x - 200, top_left_y + 50))

    controls = [
        "управление:",
        "wasd / ijkl / стрелки",
        "поворот: w, i, up, r, o, end",
        "ускорение: s, k, down",
        "выход: ctrl + q"
    ]
    for i, line in enumerate(controls):
        c_label = font.render(line, 1, (180, 180, 180))
        surface.blit(c_label, (20, s_height - 180 + (i * 30)))

    for i in range(len(grid)):
        for j in range(len(grid[i])):
            pygame.draw.rect(surface, grid[i][j], (top_left_x + j*block_size, top_left_y + i*block_size, block_size, block_size), 0)

    pygame.draw.rect(surface, (255, 0, 0), (top_left_x, top_left_y, play_width, play_height), 4)
    draw_grid(surface, grid)

def main():
    locked_positions = {}
    run = True
    current_piece = get_shape()
    next_piece = get_shape()
    clock = pygame.time.Clock()
    fall_time = 0
    normal_speed = 0.27
    score = 0

    while run:
        grid = create_grid(locked_positions)
        fall_time += clock.get_rawtime()
        clock.tick()

        change_piece = False # сбрасываем флаг в начале каждой итерации

        keys = pygame.key.get_pressed()
        current_speed = normal_speed / 4 if (keys[pygame.K_DOWN] or keys[pygame.K_s] or keys[pygame.K_k]) else normal_speed

        if fall_time/1000 > current_speed:
            fall_time = 0
            current_piece.y += 1
            if not(valid_space(current_piece, grid)) and current_piece.y > 0:
                current_piece.y -= 1
                change_piece = True

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                run = False

            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_q and (pygame.key.get_mods() & pygame.KMOD_CTRL):
                    run = False

                if event.key in [pygame.K_LEFT, pygame.K_a, pygame.K_j]:
                    current_piece.x -= 1
                    if not(valid_space(current_piece, grid)): current_piece.x += 1

                if event.key in [pygame.K_RIGHT, pygame.K_d, pygame.K_l]:
                    current_piece.x += 1
                    if not(valid_space(current_piece, grid)): current_piece.x -= 1

                if event.key in [pygame.K_UP, pygame.K_w, pygame.K_i, pygame.K_r, pygame.K_o, pygame.K_END]:
                    current_piece.rotation += 1
                    if not(valid_space(current_piece, grid)): current_piece.rotation -= 1

        draw_window(win, grid, score)

        ghost_pos = get_ghost_pos(current_piece, grid)
        for pos in ghost_pos:
            x, y = pos
            if y > -1:
                ghost_surf = pygame.Surface((block_size, block_size))
                ghost_surf.set_alpha(50)
                ghost_surf.fill(current_piece.color)
                win.blit(ghost_surf, (top_left_x + x*block_size, top_left_y + y*block_size))

        shape_pos = convert_shape_format(current_piece)
        for i in range(len(shape_pos)):
            x, y = shape_pos[i]
            if y > -1:
                pygame.draw.rect(win, current_piece.color, (top_left_x + x*block_size, top_left_y + y*block_size, block_size, block_size), 0)

        if change_piece:
            for pos in shape_pos:
                locked_positions[(pos[0], pos[1])] = current_piece.color
            current_piece = next_piece
            next_piece = get_shape()
            score += clear_rows(grid, locked_positions) * 10

        draw_next_shape(next_piece, win)
        pygame.display.update()

        if check_lost(locked_positions):
            draw_text_middle(win, "ты проиграл!", 80, (255,255,255))
            pygame.display.update()
            pygame.time.delay(1500)
            run = False

    pygame.display.quit()

win = pygame.display.set_mode((s_width, s_height))
pygame.display.set_caption('tetris')
main()
