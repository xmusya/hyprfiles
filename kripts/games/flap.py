import pygame
import sys
import random

pygame.init()
width, height = 400, 600
screen = pygame.display.set_mode((width, height))
clock = pygame.time.Clock()

# ледяные цвета
deep_blue = (5, 15, 40)
neon_cyan = (0, 255, 255)
ice_blue = (173, 216, 230)

gravity = 0.25
flap_strength = -6.5
pipe_speed = 3
pipe_gap = 150

def draw_text(text, x, y):
    img = pygame.font.SysFont("consolas", 30).render(text, True, ice_blue)
    screen.blit(img, (x, y))

def main_flappy():
    bird = pygame.Rect(100, height // 2, 30, 30)
    bird_vel = 0
    pipes = []
    score = 0
    spawn_timer = 0

    running = True
    while running:
        screen.fill(deep_blue)
        for event in pygame.event.get():
            if event.type == pygame.QUIT: pygame.quit(); sys.exit()
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_SPACE or event.key == pygame.K_UP:
                    bird_vel = flap_strength
                if event.key == pygame.K_r: main_flappy()

        bird_vel += gravity
        bird.y += bird_vel

        if spawn_timer <= 0:
            h = random.randint(100, 400)
            pipes.append({'top': pygame.Rect(width, 0, 50, h), 'bot': pygame.Rect(width, h + pipe_gap, 50, height - h - pipe_gap), 'passed': False})
            spawn_timer = 90
        spawn_timer -= 1

        for pipe in pipes[:]:
            pipe['top'].x -= pipe_speed
            pipe['bot'].x -= pipe_speed
            if pipe['top'].right < 0: pipes.remove(pipe)
            if not pipe['passed'] and bird.left > pipe['top'].right:
                score += 1
                pipe['passed'] = True
            if bird.colliderect(pipe['top']) or bird.colliderect(pipe['bot']): running = False

        if bird.top < 0 or bird.bottom > height: running = False

        for pipe in pipes:
            pygame.draw.rect(screen, ice_blue, pipe['top'])
            pygame.draw.rect(screen, ice_blue, pipe['bot'])

        pygame.draw.rect(screen, neon_cyan, bird, border_radius=5)
        draw_text(f"SCORE: {score}", 10, 10)
        pygame.display.flip()
        clock.tick(60)

    # экран смерти
    screen.fill(deep_blue)
    draw_text("CRASHED! R to RESTART", 50, height // 2)
    pygame.display.flip()
    while True:
        for event in pygame.event.get():
            if event.type == pygame.KEYDOWN and event.key == pygame.K_r: main_flappy()
            if event.type == pygame.QUIT: pygame.quit(); sys.exit()

if __name__ == "__main__":
    main_flappy()
