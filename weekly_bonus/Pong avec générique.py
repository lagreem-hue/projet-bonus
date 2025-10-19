"""Pong."""


__author__ = "lagree_m"
import pygame
import sys

"""Initialisation."""
pygame.init()
pygame.mixer.init()

"""Fenêtre."""
screen = pygame.display.set_mode((0, 0), pygame.FULLSCREEN)
WIDTH, HEIGHT = screen.get_size()
pygame.display.set_caption("Pong")

"""Couleurs."""
BLANC = (255, 255, 255)
NOIR = (0, 0, 0)
ROUGE = (255, 0, 0)
GRIS = (128, 128, 128)
"""Police."""
font_titre = pygame.font.SysFont("Arial", 60)
font_texte = pygame.font.SysFont("Arial", 32)
font_texte1 = pygame.font.SysFont("Arial", 40)

"""Sons (facultatif)."""
pygame.mixer.music.load("/home/mathyss/music/wii.mp3")
sound_hit = pygame.mixer.Sound("/home/mathyss/music/raq.mp3")
sound_wall = pygame.mixer.Sound("/home/mathyss/music/mur.mp3")
pygame.mixer.music.play(-1)

"""Taille et variable."""
paddle_width, paddle_height = 10, 250
coory = HEIGHT//2 - paddle_height//2
mids = HEIGHT // 2


def afficher_generique_debut():
    """Fonction d'affichage de la generique."""
    screen.fill(GRIS)
    titre = font_titre.render(" PONG - Le Jeu ", True, BLANC)
    instructions = font_texte.render("ESPACE pour commencer", True, BLANC)
    screen.blit(titre, ((WIDTH - titre.get_width()) // 2, HEIGHT // 3))
    screen.blit(instructions, ((WIDTH - instructions.get_width()) // 2, mids))
    pygame.display.flip()

    attendre_lancement()


def afficher_generique_fin1(message="Merci d'avoir joué !"):
    """Fonction d'affichage de la generique."""
    screen.fill(NOIR)
    texte = font_titre.render(message, True, BLANC)
    texte1 = font_texte1.render("mettez text", True, ROUGE)
    continuer = font_texte.render("Appuie sur Échap pour quitter", True, BLANC)
    screen.blit(texte, ((WIDTH - texte.get_width()) // 2, HEIGHT // 3))
    screen.blit(texte1, ((WIDTH - texte.get_width()) // 2, HEIGHT // 2))
    screen.blit(continuer, ((WIDTH - continuer.get_width()) // 2, HEIGHT // 4))
    pygame.display.flip()

    attendre_quitter()


def afficher_generique_fin2(message="Merci d'avoir joué !"):
    """Fonction d'affichage de la generique."""
    screen.fill(NOIR)
    texte = font_titre.render(message, True, BLANC)
    texte2 = font_texte1.render("mettez text", True, ROUGE)
    continuer = font_texte.render("Appuie sur Échap pour quitter", True, BLANC)
    screen.blit(texte, ((WIDTH - texte.get_width()) // 2, HEIGHT // 3))
    screen.blit(texte2, ((WIDTH - texte.get_width()) // 2, HEIGHT // 2))
    screen.blit(continuer, ((WIDTH - continuer.get_width()) // 2, HEIGHT // 4))
    pygame.display.flip()

    attendre_quitter()


def attendre_lancement():
    """Fonction lancement."""
    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                quitter()
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_SPACE:
                    return


def attendre_quitter():
    """Attendre et quitter."""
    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                quitter()
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    quitter()


def quitter():
    """Quite pygame."""
    pygame.quit()
    sys.exit()


def jeu_pong():
    """Para du jeux."""
    ball_size = 25

    player1 = pygame.Rect(50, coory, paddle_width, paddle_height)
    player2 = pygame.Rect(WIDTH - 60, coory, paddle_width, paddle_height)
    ball = pygame.Rect(WIDTH//2, HEIGHT//2, ball_size, ball_size)

    ball_speed_x, ball_speed_y = 10, 10
    paddle_speed = 9

    score1, score2 = 0, 0
    score_max = 5
    font_score = pygame.font.SysFont("Arial", 36)

    clock = pygame.time.Clock()

    running = True
    while running:
        screen.fill(GRIS)

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                quitter()

        """Mouvements."""
        keys = pygame.key.get_pressed()
        if keys[pygame.K_z] and player1.top > 0:
            player1.y -= paddle_speed
        if keys[pygame.K_s] and player1.bottom < HEIGHT:
            player1.y += paddle_speed
        if keys[pygame.K_UP] and player2.top > 0:
            player2.y -= paddle_speed
        if keys[pygame.K_DOWN] and player2.bottom < HEIGHT:
            player2.y += paddle_speed

        """Balle."""
        ball.x += ball_speed_x
        ball.y += ball_speed_y

        if ball.top <= 0 or ball.bottom >= HEIGHT:
            ball_speed_y *= -1
            sound_wall.play()

        if ball.colliderect(player1) or ball.colliderect(player2):
            ball_speed_x *= -1
            sound_hit.play()

        if ball.left <= 0:
            score2 += 1
            ball.center = (WIDTH//2, HEIGHT//2)
            ball_speed_x *= -1

        if ball.right >= WIDTH:
            score1 += 1
            ball.center = (WIDTH//2, HEIGHT//2)
            ball_speed_x *= -1

        """Victoire ?."""
        if score1 >= score_max:
            afficher_generique_fin1(" Joueur 1 gagne ! ")
            return
        elif score2 >= score_max:
            afficher_generique_fin2(" Joueur 2 gagne ! ")
            return

        """Affichage."""
        pygame.draw.rect(screen, BLANC, player1)
        pygame.draw.rect(screen, BLANC, player2)
        pygame.draw.ellipse(screen, BLANC, ball)
        pygame.draw.aaline(screen, BLANC, (WIDTH//2, 0), (WIDTH//2, HEIGHT))

        """Score."""
        texte1 = font_score.render(str(score1), True, BLANC)
        texte2 = font_score.render(str(score2), True, BLANC)
        screen.blit(texte1, (WIDTH//4, 20))
        screen.blit(texte2, (WIDTH*3//4, 20))

        pygame.display.flip()
        clock.tick(60)


"""Lancement."""
afficher_generique_debut()
jeu_pong()
