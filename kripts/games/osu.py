import pygame
import sys
import random
import math

pygame.init()

width, height = 800, 600
screen = pygame.display.set_mode((width, height))
pygame.display.set_caption("arctic rhythm: 1.3s hold edition")
clock = pygame.time.Clock()

# цвета
deep_blue = (5, 15, 40)
neon_cyan = (0, 255, 255)
ice_blue = (173, 216, 230)
frost_white = (240, 255, 255)
yellow = (255, 230, 0)

font = pygame.font.SysFont("consolas", 28)

class Note:
    def __init__(self):
        self.x = random.randint(100, width - 100)
        self.y = random.randint(100, height - 100)
        self.radius = 40
        # нота исчезает через 2 секунды, если ничего не делать
        self.lifetime = 1000
        self.start_time = pygame.time.get_ticks()

        self.type = random.choices(['normal', 'hold'], weights=[60, 40])[0]
        self.hold_progress = 0
        self.is_being_held = False

    def update(self, current_time, m_pos, is_pressing):
        elapsed = current_time - self.start_time

        if elapsed > self.lifetime:
            return "miss"

        dist = math.hypot(m_pos[0] - self.x, m_pos[1] - self.y)
        currently_pressing = dist < self.radius and is_pressing

        if self.type == 'normal':
            if currently_pressing:
                return "hit"
        else: # hold
            if currently_pressing:
                self.is_being_held = True
                self.hold_progress += (100 / (0.2 * 60))
                if self.hold_progress >= 100:
                    return "hit"
            else:
                self.is_being_held = False
                # убывает в 2 раза быстрее, чем растет (жесткий штраф)
                self.hold_progress = max(0, self.hold_progress - (200 / (1.3 * 60)))

        return "alive"

    def draw(self, surface, current_time):
        elapsed = current_time - self.start_time
        # кольцо тайминга
        approach_radius = 120 - (elapsed / self.lifetime) * 80

        color = frost_white if (self.type == 'hold' and self.is_being_held) else (yellow if self.type == 'hold' else neon_cyan)

        # кольцо
        pygame.draw.circle(surface, ice_blue, (self.x, self.y), int(max(40, approach_radius)), 2)
        # нота
        pygame.draw.circle(surface, color, (self.x, self.y), self.radius, 4)

        if self.type == 'hold':
            # фон шкалы
            pygame.draw.circle(surface, (20, 20, 40), (self.x, self.y), self.radius - 8, 2)
            if self.hold_progress > 0:
                rect = (self.x - 32, self.y - 32, 64, 64)
                # рисуем дугу прогресса
                angle = (self.hold_progress / 100) * (2 * math.pi)
                pygame.draw.arc(surface, neon_cyan, rect, 0, angle, 8)

def main():
    notes = []
    score = 0
    combo = 0
    lives = 5
    last_spawn = 0
    spawn_rate = 900

    while True:
        screen.fill(deep_blue)
        now = pygame.time.get_ticks()
        m_pos = pygame.mouse.get_pos()

        keys = pygame.key.get_pressed()
        m_keys = pygame.mouse.get_pressed()
        is_pressing = keys[pygame.K_z] or keys[pygame.K_x] or m_keys[0]

        for event in pygame.event.get():
            if event.type == pygame.QUIT: pygame.quit(); sys.exit()

        if now - last_spawn > spawn_rate and len(notes) < 5:
            notes.append(Note())
            last_spawn = now
            spawn_rate = max(500, spawn_rate - 8)

        for note in notes[:]:
            res = note.update(now, m_pos, is_pressing)
            if res == "hit":
                score += (300 if note.type == 'hold' else 100) * (combo + 1)
                combo += 1
                notes.remove(note)
            elif res == "miss":
                lives -= 1
                combo = 0
                notes.remove(note)
                if lives <= 0: return

        for note in notes:
            note.draw(screen, now)

        # UI
        screen.blit(font.render(f"SCORE: {score}", True, ice_blue), (20, 20))
        screen.blit(font.render(f"COMBO: {combo}", True, neon_cyan), (20, 60))

        # жизни в виде полосок
        for i in range(5):
            c = (255, 50, 50) if i < lives else (30, 30, 30)
            pygame.draw.rect(screen, c, (width - 190 + i*35, 25, 25, 10))

        pygame.display.flip()
        clock.tick(60)

if __name__ == "__main__":
    while True:
        main()
        pygame.time.wait(800)
