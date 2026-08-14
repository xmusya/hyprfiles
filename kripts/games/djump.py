import pygame
import random
import sys

pygame.init()

width, height = 500, 700
screen = pygame.display.set_mode((width, height))
pygame.display.set_caption("arctic jump: pro edition")
clock = pygame.time.Clock()

# цвета
deep_blue = (5, 15, 40)
neon_cyan = (0, 255, 255)
ice_blue = (173, 216, 230)
glacier_blue = (30, 144, 255)
frost_white = (240, 255, 255)
gray = (80, 80, 90)
dark_red = (150, 0, 0)

font = pygame.font.SysFont("consolas", 20)

class Player:
    def __init__(self):
        self.rect = pygame.Rect(width // 2, height - 150, 30, 30)
        self.vel_y = 0
        self.score = 0
        self.jump_mult = 1.0
        self.jetpack_timer = 0
        self.boots_timer = 0
        self.brick_timer = 0

    def update(self):
        if self.jetpack_timer > 0:
            self.vel_y = -9
            self.jetpack_timer -= 1
        else:
            self.vel_y += 0.38

        if self.boots_timer > 0:
            self.jump_mult = 1.7
            self.boots_timer -= 1
        elif self.brick_timer > 0:
            self.jump_mult = 0.8
            self.brick_timer -= 1
        else:
            self.jump_mult = 1.0

        self.rect.y += self.vel_y
        keys = pygame.key.get_pressed()
        if keys[pygame.K_LEFT] or keys[pygame.K_a]: self.rect.x -= 7
        if keys[pygame.K_RIGHT] or keys[pygame.K_d]: self.rect.x += 7
        if self.rect.left > width: self.rect.right = 0
        if self.rect.right < 0: self.rect.left = width

class Item:
    def __init__(self, x, y):
        # шансы: 40% батут, 25% ботинки, 25% кирпич, 10% ранец
        self.type = random.choices(
            ['trampoline', 'boots', 'brick', 'jetpack'],
            weights=[40, 25, 25, 10]
        )[0]
        self.rect = pygame.Rect(x + 30, y - 25, 20, 20)

    def draw(self, surface):
        if self.type == 'trampoline':
            # рисуем пружинку/батут
            pygame.draw.rect(surface, glacier_blue, (self.rect.x, self.rect.y + 10, 20, 10))
            pygame.draw.ellipse(surface, neon_cyan, (self.rect.x - 2, self.rect.y + 5, 24, 8))
        elif self.type == 'jetpack':
            # ранец с огоньком
            pygame.draw.rect(surface, gray, self.rect)
            pygame.draw.rect(surface, (255, 100, 0), (self.rect.x + 5, self.rect.bottom - 5, 10, 8))
            pygame.draw.rect(surface, neon_cyan, (self.rect.x + 4, self.rect.y + 4, 12, 12), 2)
        elif self.type == 'boots':
            # ботинки (светлые сапожки)
            pygame.draw.rect(surface, frost_white, self.rect, border_radius=4)
            pygame.draw.line(surface, ice_blue, (self.rect.left, self.rect.centery), (self.rect.right, self.rect.centery), 2)
        elif self.type == 'brick':
            # тяжелый кирпич
            pygame.draw.rect(surface, (60, 40, 40), self.rect)
            pygame.draw.rect(surface, dark_red, self.rect, 2)

class Platform:
    def __init__(self, x, y):
        self.rect = pygame.Rect(x, y, 80, 15)
        self.item = None
        # общий шанс появления любого предмета на платформе - 15%
        if random.random() < 0.15:
            self.item = Item(x, y)

def main_jump():
    player = Player()
    platforms = [Platform(width // 2 - 40, height - 100)]
    for i in range(12):
        platforms.append(Platform(random.randint(0, width - 80), height - i * 75 - 200))

    game_over = False
    while True:
        screen.fill(deep_blue)
        for event in pygame.event.get():
            if event.type == pygame.QUIT: pygame.quit(); sys.exit()
            if event.type == pygame.KEYDOWN and event.key == pygame.K_r and game_over: main_jump()

        if not game_over:
            player.update()
            # скроллинг
            if player.rect.y < height // 3:
                diff = height // 3 - player.rect.y
                player.rect.y = height // 3
                player.score += int(diff // 5)
                for plat in platforms:
                    plat.rect.y += diff
                    if plat.item: plat.item.rect.y += diff

            # коллизии
            if player.vel_y > 0:
                for plat in platforms:
                    if player.rect.colliderect(plat.rect) and player.rect.bottom < plat.rect.bottom + 15:
                        player.vel_y = -12 * player.jump_mult
                        if plat.item and player.rect.colliderect(plat.item.rect):
                            if plat.item.type == 'trampoline': player.vel_y = -26
                            elif plat.item.type == 'jetpack': player.jetpack_timer = 240
                            elif plat.item.type == 'boots': player.boots_timer = 420; player.brick_timer = 0
                            elif plat.item.type == 'brick': player.brick_timer = 420; player.boots_timer = 0
                            plat.item = None

            # генерация новых платформ
            for plat in platforms:
                if plat.rect.y > height:
                    platforms.remove(plat)
                    new_x = random.randint(0, width - 80)
                    # плавная сложность: чем выше счет, тем выше новые платформы
                    new_y = min(p.rect.y for p in platforms) - random.randint(70, 90)
                    platforms.append(Platform(new_x, new_y))

            if player.rect.top > height: game_over = True

        # DRAW
        for plat in platforms:
            pygame.draw.rect(screen, glacier_blue, plat.rect, border_radius=5)
            pygame.draw.rect(screen, ice_blue, plat.rect, 1, border_radius=5) # блик
            if plat.item:
                plat.item.draw(screen)

        # игрок
        pygame.draw.rect(screen, neon_cyan, player.rect, border_radius=6)
        pygame.draw.rect(screen, frost_white, player.rect, 2, border_radius=6)

        # UI
        score_txt = font.render(f"SCORE: {player.score}", True, ice_blue)
        screen.blit(score_txt, (15, 15))

        # индикаторы баффов
        if player.jetpack_timer > 0: draw_indicator("JETPACK", neon_cyan, 1)
        if player.boots_timer > 0: draw_indicator("SUPER JUMP", frost_white, 2)
        if player.brick_timer > 0: draw_indicator("HEAVY", dark_red, 2)

        if game_over:
            draw_text_centered("GAME OVER", big_font if 'big_font' in locals() else font, height//2 - 20, neon_cyan)
            draw_text_centered("PRESS R TO RESTART", font, height//2 + 40, ice_blue)

        pygame.display.flip()
        clock.tick(60)

def draw_indicator(text, color, pos):
    txt = font.render(text, True, color)
    screen.blit(txt, (15, 15 + pos * 25))

def draw_text_centered(text, font_obj, y, color):
    img = font_obj.render(text, True, color)
    rect = img.get_rect(center=(width // 2, y))
    screen.blit(img, rect)

if __name__ == "__main__":
    main_jump()
