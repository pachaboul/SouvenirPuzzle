# Souvenir Puzzle — Game Design Document

Version : 0.1
Projet : Koyra Games
Produit : Souvenir Puzzle
Genre : Puzzle photo / casual game
Plateforme MVP : Android
Plateforme future : iOS
Mode de jeu : Solo, local-first, offline
Public cible : familles, enfants, parents, couples, diaspora, seniors, joueurs casual

---

# 1. Concept du jeu

**Souvenir Puzzle** est un jeu mobile où le joueur transforme ses propres photos en puzzles.

Le joueur choisit une photo depuis son téléphone, sélectionne une difficulté, puis reconstruit l’image pièce par pièce.

Le jeu est simple, calme, familial et émotionnel.
Chaque puzzle représente un souvenir personnel.

---

# 2. Promesse du jeu

> Transformez vos photos en puzzles et revivez vos souvenirs pièce par pièce.

Souvenir Puzzle ne cherche pas à créer une compétition agressive.
Il cherche à créer une expérience douce, personnelle et accessible.

---

# 3. Objectif du joueur

L’objectif principal du joueur est de reconstruire une photo mélangée.

Le joueur gagne quand toutes les pièces sont replacées dans leur position correcte.

---

# 4. Piliers du game design

## 4.1 Simplicité

Le joueur doit comprendre le jeu immédiatement.

Actions principales :

* choisir une photo ;
* choisir une difficulté ;
* déplacer les pièces ;
* compléter le puzzle.

## 4.2 Émotion

Le jeu utilise les propres photos du joueur.
La valeur émotionnelle vient du souvenir, pas seulement du gameplay.

## 4.3 Calme

L’expérience doit être relaxante.
Pas de pression forte, pas d’échec agressif, pas de punition dure.

## 4.4 Accessibilité

Le jeu doit être jouable par :

* enfants ;
* parents ;
* seniors ;
* personnes qui ne jouent pas souvent aux jeux vidéo.

## 4.5 Respect de la vie privée

Les photos doivent rester sur le téléphone.
Le jeu doit rassurer l’utilisateur.

---

# 5. Boucle principale de jeu

La boucle principale est très simple :

```text
Choisir une photo
↓
Choisir une difficulté
↓
Jouer au puzzle
↓
Terminer le puzzle
↓
Voir le résultat
↓
Rejouer ou créer un nouveau souvenir
```

Cette boucle doit être rapide, fluide et agréable.

---

# 6. Mécanique principale

## 6.1 Sélection de photo

Le joueur choisit une photo depuis la galerie de son téléphone.

Types de photos possibles :

* famille ;
* enfants ;
* mariage ;
* voyage ;
* village ;
* amis ;
* événement important ;
* souvenir personnel.

La photo devient la base du puzzle.

---

## 6.2 Découpage de l’image

L’image est découpée en grille.

Pour le MVP, les pièces sont carrées ou rectangulaires.

Exemple :

* 3 x 3 = 9 pièces ;
* 4 x 4 = 16 pièces ;
* 5 x 5 = 25 pièces.

Les formes réalistes de puzzle peuvent être ajoutées dans une version future.

---

## 6.3 Mélange des pièces

Après le découpage, les pièces sont mélangées automatiquement.

Règle importante :

Le mélange doit toujours produire un puzzle jouable.

Pour le MVP, la méthode recommandée est simple :

* créer la liste des pièces ;
* mélanger leurs positions ;
* éviter que l’image reste déjà complète après mélange.

---

## 6.4 Déplacement des pièces

Mécanique MVP recommandée :

Le joueur glisse une pièce vers une autre position.

Quand la pièce est déposée sur une autre case :

* les deux pièces échangent leur position ;
* le compteur de mouvements augmente ;
* le jeu vérifie si le puzzle est terminé.

Cette mécanique est simple et adaptée au mobile.

---

# 7. Difficultés

## 7.1 Facile

```text
Grille : 3 x 3
Nombre de pièces : 9
Public : enfants, seniors, débutants
```

Objectif :

* découverte du jeu ;
* expérience rapide ;
* faible frustration.

---

## 7.2 Moyen

```text
Grille : 4 x 4
Nombre de pièces : 16
Public : joueurs casual
```

Objectif :

* difficulté équilibrée ;
* expérience principale du jeu ;
* durée raisonnable.

---

## 7.3 Difficile

```text
Grille : 5 x 5
Nombre de pièces : 25
Public : joueurs patients
```

Objectif :

* plus de défi ;
* plus de satisfaction à la fin ;
* adapté aux joueurs qui veulent rejouer.

---

# 8. Durée de jeu estimée

## 8.1 Facile

Durée moyenne :

```text
30 secondes à 2 minutes
```

## 8.2 Moyen

Durée moyenne :

```text
2 à 5 minutes
```

## 8.3 Difficile

Durée moyenne :

```text
5 à 10 minutes
```

Ces durées ne doivent pas être affichées comme une pression.
Elles servent seulement à guider le design.

---

# 9. Conditions de victoire

Le joueur gagne quand chaque pièce est à sa position correcte.

Chaque pièce possède deux positions :

```text
positionCorrecte
positionActuelle
```

Le puzzle est terminé si :

```text
positionActuelle == positionCorrecte
```

pour toutes les pièces.

Quand le puzzle est terminé :

1. le timer s’arrête ;
2. les mouvements sont enregistrés ;
3. l’écran de victoire s’affiche ;
4. le joueur peut rejouer ou créer un nouveau souvenir.

---

# 10. Échec et punition

Souvenir Puzzle ne doit pas avoir d’échec dur.

Il n’y a pas de :

* game over ;
* perte de vie ;
* limite de temps obligatoire ;
* score négatif ;
* punition agressive.

Le joueur peut prendre son temps.

Le jeu doit rester calme et encourageant.

---

# 11. Aides au joueur

## 11.1 Aperçu de l’image complète

Le joueur peut appuyer sur un bouton pour voir l’image originale.

Objectif :

* aider à résoudre le puzzle ;
* réduire la frustration ;
* rendre le jeu accessible.

## 11.2 Grille visible

La grille peut rester visible pour aider le joueur à comprendre les positions.

## 11.3 Feedback de bonne position

Quand une pièce est bien placée, le jeu peut afficher :

* un contour vert doux ;
* une petite animation ;
* une vibration légère ;
* un son discret.

Pour le MVP, ce feedback peut être simple.

---

# 12. Scores et statistiques

Le jeu peut enregistrer des statistiques simples.

## 12.1 Temps

Le temps commence au lancement du puzzle.

Il s’arrête :

* pendant la pause ;
* à la victoire.

Format :

```text
00:45
02:31
10:08
```

## 12.2 Mouvements

Un mouvement est compté lorsqu’un échange de pièces est validé.

Exemple :

* le joueur glisse une pièce ;
* elle échange sa position avec une autre ;
* compteur +1.

## 12.3 Meilleur temps

Pour chaque souvenir, l’application peut garder le meilleur temps.

## 12.4 Meilleur nombre de mouvements

Pour chaque souvenir, l’application peut garder le meilleur nombre de mouvements.

---

# 13. Récompenses

Les récompenses doivent rester douces et émotionnelles.

## 13.1 Récompense principale

La récompense principale est la photo reconstruite.

Le joueur voit le souvenir complet.

## 13.2 Message positif

Exemples :

```text
Souvenir complété.
Bravo, tu as reconstruit ce moment.
Un beau souvenir retrouvé.
Puzzle terminé avec succès.
```

## 13.3 Animation de victoire

Animation recommandée :

* lumière douce ;
* pièce finale qui se place ;
* petites étoiles ;
* vibration légère.

Éviter les effets trop agressifs.

---

# 14. Progression

## 14.1 MVP

Pour le MVP, la progression est simple :

* créer plusieurs puzzles ;
* rejouer ses souvenirs ;
* améliorer son temps ;
* améliorer ses mouvements.

## 14.2 Version future

Progressions possibles :

* collection de souvenirs ;
* badges doux ;
* albums de puzzles ;
* série de puzzles terminés ;
* défis personnels sans pression ;
* calendrier de souvenirs.

---

# 15. Badges futurs

Les badges ne sont pas obligatoires pour le MVP.

Idées futures :

```text
Premier souvenir
10 puzzles terminés
Souvenir de famille
Souvenir de voyage
Puzzle sans aide
Puzzle rapide
Patience d’or
```

Le ton doit rester positif et non compétitif.

---

# 16. Modes de jeu

## 16.1 Mode principal — Photo Puzzle

Inclus dans le MVP.

Le joueur choisit une photo et la transforme en puzzle.

## 16.2 Mode Souvenirs

Le joueur rejoue les puzzles déjà créés.

Peut être inclus dans le MVP complet ou juste après.

## 16.3 Mode Enfant

Version future.

Caractéristiques possibles :

* pièces plus grandes ;
* difficulté limitée ;
* interface encore plus simple ;
* sons plus ludiques ;
* pas de suppression accidentelle.

## 16.4 Mode Senior

Version future.

Caractéristiques possibles :

* boutons plus grands ;
* contraste renforcé ;
* textes plus lisibles ;
* difficulté facile par défaut ;
* gestes simplifiés.

## 16.5 Mode Défi quotidien

Version future.

L’application propose à l’utilisateur de rejouer un souvenir par jour.

Exemple :

```text
Souvenir du jour
Rejouez un moment important aujourd’hui.
```

---

# 17. Économie du jeu

## 17.1 MVP

Le MVP peut être gratuit.

Objectif :

* tester l’intérêt ;
* obtenir des retours utilisateurs ;
* publier rapidement ;
* construire la marque Koyra Games.

## 17.2 Monétisation future

Options possibles :

### Achat premium unique

Débloque :

* plus de difficultés ;
* plus de thèmes ;
* albums illimités ;
* export de souvenirs ;
* mode sombre ;
* pas de publicité.

### Abonnement

À éviter au début.
Ce jeu est mieux adapté à un achat simple ou freemium léger.

### Publicité

Possible, mais pas recommandée au départ.

Si publicité plus tard :

* non intrusive ;
* adaptée aux familles ;
* jamais au milieu d’un puzzle ;
* jamais agressive.

---

# 18. Contenu du jeu

Souvenir Puzzle ne dépend pas d’un grand contenu créé par le studio.

Le contenu principal vient de l’utilisateur :

* ses photos ;
* ses souvenirs ;
* ses moments de vie.

Cela réduit le coût de production de contenu.

Le studio doit surtout produire :

* une belle interface ;
* des thèmes ;
* des sons ;
* des animations ;
* des messages émotionnels.

---

# 19. Thèmes visuels futurs

Le MVP peut commencer avec un seul thème.

Thèmes futurs possibles :

## 19.1 Thème Famille

Ambiance chaude, douce, familiale.

## 19.2 Thème Voyage

Ambiance carte postale, aventure calme.

## 19.3 Thème Mariage

Ambiance élégante, romantique.

## 19.4 Thème Village

Ambiance terre, racines, mémoire.

## 19.5 Thème Enfant

Ambiance colorée, douce et ludique.

## 19.6 Thème Premium

Ambiance minimaliste, élégante, moderne.

---

# 20. Design émotionnel du gameplay

Le jeu doit utiliser des mots liés aux souvenirs.

Préférer :

```text
Nouveau souvenir
Mes souvenirs
Souvenir complété
Un beau souvenir retrouvé
```

Éviter :

```text
Nouveau niveau
Historique
Victoire
Score final
```

Cette différence donne au jeu une identité plus forte.

---

# 21. Son et ambiance

## 21.1 Ambiance sonore

Le jeu doit être calme.

Sons recommandés :

* clic doux ;
* placement de pièce discret ;
* son de réussite chaleureux ;
* ambiance légère optionnelle.

## 21.2 Musique

Pour le MVP, la musique n’est pas obligatoire.

Si ajoutée plus tard :

* très douce ;
* désactivable ;
* pas répétitive ;
* pas stressante.

---

# 22. Contrôles

## 22.1 Contrôle principal

Glisser-déposer avec le doigt.

## 22.2 Actions secondaires

* appuyer pour sélectionner une pièce ;
* appuyer sur aperçu ;
* appuyer sur pause ;
* appuyer sur recommencer.

## 22.3 Alternative possible

Pour améliorer l’accessibilité, une version future peut permettre :

1. appuyer sur une pièce ;
2. appuyer sur une autre pièce ;
3. les deux pièces échangent leur place.

Cette méthode peut être plus facile pour certains seniors.

---

# 23. Règles de pause

Quand le joueur met en pause :

* le timer s’arrête ;
* les pièces ne bougent plus ;
* le joueur peut reprendre ;
* le joueur peut voir l’image ;
* le joueur peut recommencer ;
* le joueur peut quitter.

Si le joueur quitte :

* la progression peut être perdue dans le prototype ;
* dans une version future, la progression peut être sauvegardée.

---

# 24. Sauvegarde de progression

## 24.1 MVP simple

Sauvegarder seulement les puzzles terminés.

## 24.2 Version future

Sauvegarder aussi les puzzles non terminés.

Données possibles :

```text
photoReference
difficulty
currentPiecePositions
elapsedTime
moves
lastPlayedAt
```

---

# 25. États du jeu

Le jeu peut avoir les états suivants :

```text
idle
photoSelected
difficultySelected
generatingPuzzle
playing
paused
completed
error
```

## 25.1 idle

Aucune photo sélectionnée.

## 25.2 photoSelected

Une photo est choisie.

## 25.3 difficultySelected

La difficulté est choisie.

## 25.4 generatingPuzzle

Le puzzle est en cours de création.

## 25.5 playing

Le joueur joue.

## 25.6 paused

Le jeu est en pause.

## 25.7 completed

Le puzzle est terminé.

## 25.8 error

Une erreur est survenue.

---

# 26. Données de partie

Chaque partie doit contenir :

```text
sessionId
imageReference
difficulty
rows
columns
pieces
startTime
elapsedTime
moves
isCompleted
createdAt
completedAt
```

Chaque pièce doit contenir :

```text
pieceId
correctIndex
currentIndex
row
column
imageCropData
isCorrectlyPlaced
```

---

# 27. Logique de génération du puzzle

Étapes recommandées :

```text
1. Charger l’image sélectionnée.
2. Redimensionner l’image pour éviter les problèmes de mémoire.
3. Définir rows et columns selon la difficulté.
4. Découper l’image en pièces.
5. Assigner à chaque pièce une position correcte.
6. Mélanger les positions actuelles.
7. Vérifier que le puzzle n’est pas déjà terminé.
8. Afficher la grille.
```

---

# 28. Logique de victoire

Pseudo-logique :

```text
for each piece in pieces:
    if piece.currentIndex != piece.correctIndex:
        return false

return true
```

Quand la fonction retourne `true` :

```text
stopTimer()
saveResult()
showVictoryScreen()
```

---

# 29. Expérience débutant

Le premier puzzle doit être facile à créer.

Pour la première utilisation :

* afficher un message court ;
* ne pas afficher trop d’explications ;
* guider par les boutons ;
* choisir “Moyen” ou “Facile” comme recommandation.

Message possible :

```text
Choisissez une photo importante pour créer votre premier souvenir puzzle.
```

---

# 30. Expérience enfant

Pour les enfants :

* privilégier le niveau facile ;
* pièces assez grandes ;
* pas de texte compliqué ;
* feedback positif ;
* pas de pression.

Message possible :

```text
Bravo, tu as retrouvé l’image !
```

---

# 31. Expérience senior

Pour les seniors :

* interface lisible ;
* boutons larges ;
* niveau facile clair ;
* aperçu facile d’accès ;
* pas de timer stressant.

Le timer peut être visible, mais il ne doit pas donner une sensation de pression.

---

# 32. Expérience diaspora

Pour la diaspora, le jeu peut avoir une forte dimension émotionnelle.

Exemples de souvenirs :

* village ;
* famille au pays ;
* mariage ;
* enfance ;
* voyage ;
* anciennes photos ;
* lieux importants.

Le vocabulaire “souvenir”, “famille”, “village”, “moment” est important.

---

# 33. Risques de game design

## 33.1 Jeu trop simple

Solution :

* ajouter plusieurs difficultés ;
* ajouter meilleur temps ;
* ajouter historique ;
* ajouter badges doux ;
* ajouter thèmes.

## 33.2 Frustration avec les photos complexes

Certaines photos peuvent être difficiles à résoudre.

Solution :

* bouton aperçu ;
* grille visible ;
* niveau facile ;
* possibilité de recommencer.

## 33.3 Mauvaise expérience sur petites photos

Les photos de mauvaise qualité peuvent rendre le puzzle moins agréable.

Solution :

* afficher un avertissement doux ;
* optimiser l’image ;
* permettre de choisir une autre photo.

## 33.4 Inquiétude confidentialité

Solution :

* message clair ;
* aucun compte obligatoire ;
* stockage local ;
* suppression de l’historique.

---

# 34. Priorité des mécaniques

## Must-have

* choisir une photo ;
* découper en puzzle ;
* mélanger les pièces ;
* déplacer les pièces ;
* compter les mouvements ;
* compter le temps ;
* détecter la victoire ;
* afficher écran de victoire.

## Should-have

* aperçu image ;
* pause ;
* historique ;
* meilleur temps ;
* meilleur nombre de mouvements ;
* son doux ;
* vibration légère.

## Could-have

* badges ;
* thèmes ;
* mode enfant ;
* mode senior ;
* sauvegarde des puzzles non terminés ;
* partage ;
* export souvenir.

## Won’t-have pour MVP

* multijoueur ;
* cloud ;
* classement en ligne ;
* compétition mondiale ;
* boutique ;
* formes complexes de puzzle ;
* IA avancée.

---

# 35. Version MVP recommandée

Le MVP recommandé doit contenir :

```text
1. Accueil
2. Sélection photo
3. Choix difficulté
4. Puzzle 3x3, 4x4, 5x5
5. Drag-and-drop avec échange de pièces
6. Timer
7. Compteur de mouvements
8. Aperçu image
9. Détection victoire
10. Écran de victoire
11. Historique simple si possible
```

---

# 36. Vision future du jeu

Souvenir Puzzle peut évoluer vers une plateforme de jeux de mémoire personnelle.

Extensions possibles :

* albums de souvenirs ;
* puzzles familiaux partagés ;
* puzzle du jour ;
* thèmes culturels ;
* mode enfant ;
* mode senior ;
* export souvenir ;
* impression photo/puzzle ;
* version tablette ;
* puzzles éducatifs ;
* puzzles culturels africains ;
* packs Koyra Games.

---

# 37. Résumé final

Souvenir Puzzle est un jeu casual très simple, mais avec un fort potentiel émotionnel.

Son gameplay repose sur une mécanique connue : reconstruire une image.
Sa différence vient du fait que l’image appartient au joueur.

Le cœur du jeu est donc :

> Ma photo. Mon souvenir. Mon puzzle.

Pour réussir, le MVP doit rester concentré sur trois choses :

1. créer un puzzle rapidement ;
2. jouer facilement ;
3. ressentir une émotion à la fin.
