# Souvenir Puzzle — UI/UX Design Document

Version : 0.1
Projet : Koyra Games
Produit : Souvenir Puzzle
Type : Jeu mobile photo-puzzle familial
Plateforme MVP : Android
Style : simple, familial, émotionnel, calme, propre

---

# 1. Direction UX globale

## 1.1 Objectif de l’expérience

Souvenir Puzzle doit donner à l’utilisateur une sensation de calme, de simplicité et d’émotion.

L’utilisateur ne doit jamais se sentir perdu.
Il doit comprendre immédiatement :

1. comment choisir une photo ;
2. comment transformer cette photo en puzzle ;
3. comment jouer ;
4. comment rejouer ou créer un nouveau souvenir.

L’expérience doit être accessible aux enfants, parents, seniors et joueurs casual.

---

# 2. Principe central de design

Le souvenir doit être au centre.

L’interface ne doit pas être trop chargée.
La photo de l’utilisateur est l’élément le plus important du jeu.

Le design doit soutenir l’émotion, pas la remplacer.

---

# 3. Style visuel

## 3.1 Ambiance

Souvenir Puzzle doit avoir une ambiance :

* douce ;
* familiale ;
* chaleureuse ;
* calme ;
* propre ;
* émotionnelle ;
* moderne ;
* accessible.

L’application ne doit pas ressembler à un jeu agressif ou trop compétitif.
Elle doit plutôt ressembler à un espace personnel de souvenirs.

---

# 4. Palette de couleurs

## 4.1 Couleurs principales

### Bleu Souvenir

Utilisation : fond principal, header, boutons importants.

```text
#1E3A5F
```

Sensation : confiance, calme, stabilité.

### Crème Doux

Utilisation : arrière-plan clair.

```text
#FFF8EE
```

Sensation : chaleur, famille, douceur.

### Or Mémoire

Utilisation : victoire, succès, éléments émotionnels.

```text
#E8B04A
```

Sensation : souvenir précieux, réussite, chaleur.

### Vert Réussite

Utilisation : validation, pièce bien placée, succès.

```text
#4CAF7D
```

Sensation : positif, doux, rassurant.

### Gris Texte

Utilisation : texte principal.

```text
#2E2E2E
```

### Gris Secondaire

Utilisation : texte secondaire, bordures légères.

```text
#8A8A8A
```

### Blanc

Utilisation : cartes, boutons secondaires, surfaces.

```text
#FFFFFF
```

---

# 5. Typographie

## 5.1 Style recommandé

La typographie doit être :

* ronde ;
* lisible ;
* moderne ;
* accessible ;
* douce.

## 5.2 Polices possibles

Pour Flutter :

* `Nunito`
* `Poppins`
* `Inter`
* `Quicksand`

Recommandation MVP : **Nunito**.

Pourquoi :

* très lisible ;
* ronde ;
* familiale ;
* adaptée aux enfants et seniors ;
* moderne sans être froide.

---

# 6. Logo et identité

## 6.1 Idée du logo

Le logo peut mélanger trois idées :

1. une pièce de puzzle ;
2. une photo ;
3. un souvenir ou un cœur discret.

Concept possible :

Une petite photo carrée avec un coin en forme de pièce de puzzle, accompagnée d’un petit cœur ou d’un éclat doux.

## 6.2 Style du logo

Le logo doit être :

* simple ;
* lisible en petite taille ;
* utilisable comme icône d’application ;
* pas trop enfantin ;
* pas trop sérieux ;
* familial et premium.

## 6.3 Icône d’application

L’icône Android peut être :

* fond Bleu Souvenir ;
* pièce de puzzle crème ;
* petit cœur Or Mémoire ;
* coins arrondis.

---

# 7. Navigation générale

## 7.1 Navigation MVP

La navigation doit rester très simple.

```text
Splash Screen
   ↓
Home Screen
   ↓
Photo Picker Screen
   ↓
Difficulty Screen
   ↓
Puzzle Game Screen
   ↓
Victory Screen
```

Écrans secondaires :

```text
Home Screen
   ↓
Memories Screen

Home Screen
   ↓
Settings Screen
```

---

# 8. Structure des écrans

---

## 8.1 Splash Screen

### Objectif

Afficher rapidement l’identité du jeu.

### Contenu

* logo Souvenir Puzzle ;
* nom du jeu ;
* mention discrète : “by Koyra Games”.

### Design

Fond : Bleu Souvenir ou Crème Doux.
Logo au centre.
Animation légère possible : une pièce qui se place doucement.

### Texte

```text
Souvenir Puzzle
by Koyra Games
```

### Durée

1 à 2 secondes maximum.

---

## 8.2 Home Screen

### Objectif

Permettre de commencer un puzzle immédiatement.

### Hiérarchie visuelle

1. Logo
2. Slogan
3. Bouton principal
4. Accès aux souvenirs
5. Paramètres

### Contenu

Titre :

```text
Souvenir Puzzle
```

Slogan :

```text
Revivez vos souvenirs pièce par pièce.
```

Bouton principal :

```text
Créer un puzzle
```

Bouton secondaire :

```text
Mes souvenirs
```

Lien ou icône :

```text
Paramètres
```

### Layout recommandé

```text
[Logo]

Souvenir Puzzle
Revivez vos souvenirs pièce par pièce.

[Créer un puzzle]

[Mes souvenirs]

[Paramètres]
```

### UX importante

Le bouton “Créer un puzzle” doit être très visible.
C’est l’action principale.

---

## 8.3 Photo Picker Screen

### Objectif

Choisir une photo depuis le téléphone.

### Contenu avant sélection

Titre :

```text
Choisissez une photo
```

Description :

```text
Transformez une photo de famille, de voyage ou d’un moment important en puzzle.
```

Bouton :

```text
Choisir une photo
```

Message confidentialité :

```text
Vos photos restent sur votre téléphone.
```

### Contenu après sélection

* aperçu de la photo ;
* bouton “Changer la photo” ;
* bouton “Continuer”.

### Layout recommandé

```text
Choisissez une photo

[Zone aperçu photo]

[Choisir une photo]
ou
[Changer la photo]

Vos photos restent sur votre téléphone.

[Continuer]
```

### UX importante

Le message de confidentialité doit être visible mais discret.
Il doit rassurer l’utilisateur sans créer de peur.

---

## 8.4 Difficulty Screen

### Objectif

Choisir le niveau du puzzle.

### Contenu

Titre :

```text
Choisissez la difficulté
```

Sous-titre :

```text
Commencez simple ou ajoutez un peu de défi.
```

Cartes de difficulté :

```text
Facile
3 x 3 — 9 pièces
Idéal pour enfants et débutants
```

```text
Moyen
4 x 4 — 16 pièces
Un bon équilibre
```

```text
Difficile
5 x 5 — 25 pièces
Pour plus de patience
```

Bouton :

```text
Commencer le puzzle
```

### UX importante

Chaque difficulté doit être claire.
L’utilisateur doit comprendre le nombre de pièces sans réfléchir.

---

## 8.5 Puzzle Game Screen

### Objectif

Jouer au puzzle.

### Éléments visibles

En haut :

* bouton retour ou pause ;
* temps ;
* mouvements.

Au centre :

* grille du puzzle.

En bas :

* bouton aperçu ;
* bouton recommencer ;
* bouton pause si non présent en haut.

### Layout recommandé

```text
[Pause]        01:24        18 mouvements

[Zone puzzle]

[Aperçu]   [Recommencer]
```

### Règles UI

* La zone de puzzle doit être grande.
* Les pièces doivent être faciles à toucher.
* Les bordures doivent être visibles mais légères.
* Les animations doivent être douces.
* Le jeu ne doit pas être bruyant visuellement.

### Feedback visuel

Quand une pièce est bien placée :

* petite animation ;
* légère vibration si activée ;
* contour vert doux ;
* effet sonore léger si activé.

---

## 8.6 Image Preview Modal

### Objectif

Permettre au joueur de revoir l’image complète.

### Contenu

* image complète ;
* bouton fermer.

Texte :

```text
Image originale
```

Bouton :

```text
Retour au puzzle
```

### UX importante

L’aperçu doit aider sans casser le rythme.
L’image doit être affichée proprement, sans recadrage excessif.

---

## 8.7 Pause Screen

### Objectif

Mettre le puzzle en pause.

### Contenu

Titre :

```text
Puzzle en pause
```

Options :

```text
Continuer
Voir l’image
Recommencer
Quitter
```

### UX importante

Le timer doit s’arrêter pendant la pause.
Le joueur doit pouvoir reprendre sans perdre sa progression.

---

## 8.8 Victory Screen

### Objectif

Célébrer la réussite.

### Contenu

* photo complète ;
* message positif ;
* temps final ;
* nombre de mouvements ;
* boutons d’action.

Titre possible :

```text
Souvenir complété
```

Messages possibles :

```text
Bravo, tu as reconstruit ce moment.
```

```text
Un beau souvenir retrouvé.
```

```text
Puzzle terminé avec succès.
```

Statistiques :

```text
Temps : 02:45
Mouvements : 34
```

Boutons :

```text
Rejouer
Nouveau souvenir
Sauvegarder
```

### UX importante

L’écran de victoire doit être émotionnel, pas seulement technique.
La photo doit être bien visible.

---

## 8.9 Memories Screen

### Objectif

Afficher les puzzles déjà créés ou joués.

### Contenu

Titre :

```text
Mes souvenirs
```

État vide :

```text
Aucun souvenir pour le moment.
Créez votre premier puzzle avec une photo importante.
```

Bouton :

```text
Créer un puzzle
```

Carte souvenir :

```text
[Miniature]
Facile — 9 pièces
Meilleur temps : 01:34
Joué le : 16 juin 2026
[Rejouer]
```

Actions secondaires :

```text
Supprimer
```

### UX importante

Les miniatures doivent être assez grandes pour reconnaître le souvenir.
La suppression doit demander confirmation.

Message confirmation :

```text
Supprimer ce souvenir ?
Cette action supprimera l’historique de ce puzzle sur cet appareil.
```

Boutons :

```text
Annuler
Supprimer
```

---

## 8.10 Settings Screen

### Objectif

Gérer les préférences.

### Contenu

Titre :

```text
Paramètres
```

Sections :

```text
Expérience
- Son
- Vibration
- Thème
```

```text
Confidentialité
- Vos photos restent sur votre téléphone
- Supprimer l’historique local
```

```text
À propos
- Souvenir Puzzle
- Koyra Games
- Version de l’application
```

### Textes importants

```text
Souvenir Puzzle ne téléverse pas vos photos. Les puzzles sont créés directement sur votre téléphone.
```

Bouton :

```text
Supprimer tout l’historique
```

Confirmation :

```text
Voulez-vous supprimer tout l’historique local ?
Vos photos originales ne seront pas supprimées de votre téléphone.
```

---

# 9. Composants UI

## 9.1 Bouton principal

Utilisation :

* créer un puzzle ;
* continuer ;
* commencer ;
* nouveau souvenir.

Style :

* fond Bleu Souvenir ;
* texte blanc ;
* coins arrondis ;
* hauteur confortable ;
* grande zone tactile.

Exemple :

```text
Créer un puzzle
```

---

## 9.2 Bouton secondaire

Utilisation :

* mes souvenirs ;
* changer photo ;
* aperçu ;
* rejouer.

Style :

* fond blanc ;
* bordure Bleu Souvenir ;
* texte Bleu Souvenir ;
* coins arrondis.

---

## 9.3 Carte

Utilisation :

* difficulté ;
* souvenir ;
* paramètre.

Style :

* fond blanc ;
* coins arrondis ;
* ombre légère ;
* padding confortable.

---

## 9.4 Modal

Utilisation :

* aperçu image ;
* pause ;
* confirmation suppression.

Style :

* fond blanc ;
* coins arrondis ;
* texte clair ;
* boutons visibles.

---

## 9.5 Grille puzzle

Style :

* fond neutre ;
* bordures fines ;
* coins légèrement arrondis ;
* ombre très légère ;
* espace minimal entre pièces.

---

# 10. Microcopy

La microcopy doit être douce, claire et humaine.

## 10.1 Textes de boutons

```text
Créer un puzzle
Choisir une photo
Changer la photo
Continuer
Commencer le puzzle
Aperçu
Recommencer
Rejouer
Nouveau souvenir
Sauvegarder
Mes souvenirs
Paramètres
Supprimer
Annuler
```

## 10.2 Messages de réussite

```text
Souvenir complété.
Bravo, tu as reconstruit ce moment.
Un beau souvenir retrouvé.
Puzzle terminé avec succès.
```

## 10.3 Messages d’erreur

Permission refusée :

```text
Impossible d’accéder aux photos.
Vous pouvez autoriser l’accès depuis les paramètres de votre téléphone.
```

Image non compatible :

```text
Cette image ne peut pas être utilisée.
Essayez avec une autre photo.
```

Erreur de chargement :

```text
La photo n’a pas pu être chargée.
Veuillez réessayer.
```

Historique vide :

```text
Aucun souvenir pour le moment.
Créez votre premier puzzle avec une photo importante.
```

---

# 11. Accessibilité

Souvenir Puzzle doit être utilisable par des publics variés.

## 11.1 Taille des boutons

Les boutons doivent être grands, avec une zone tactile confortable.

## 11.2 Contraste

Le texte doit être lisible sur tous les fonds.

## 11.3 Texte

Les phrases doivent être courtes.
Le vocabulaire doit être simple.

## 11.4 Enfants et seniors

Éviter :

* textes trop petits ;
* gestes compliqués ;
* menus cachés ;
* trop de choix ;
* animations agressives.

---

# 12. Animations

Les animations doivent être légères.

## 12.1 Animations recommandées

* apparition douce des écrans ;
* léger zoom sur une pièce sélectionnée ;
* animation quand deux pièces échangent leur place ;
* petite célébration sur l’écran de victoire ;
* pièce qui se place doucement au splash screen.

## 12.2 Animations à éviter

* explosions agressives ;
* effets trop rapides ;
* animations longues ;
* trop de confettis ;
* mouvements qui fatiguent les yeux.

---

# 13. Sons et vibrations

## 13.1 Sons recommandés

* son doux quand une pièce est déplacée ;
* son léger quand une pièce est bien placée ;
* son calme à la victoire.

## 13.2 Vibration

* vibration très légère quand une pièce est bien placée ;
* aucune vibration agressive.

## 13.3 Contrôle utilisateur

L’utilisateur doit pouvoir désactiver :

* les sons ;
* les vibrations.

---

# 14. Responsive design mobile

## 14.1 Petits écrans

Sur petits écrans :

* réduire les marges ;
* garder la grille visible ;
* éviter trop de textes ;
* placer les actions importantes en bas.

## 14.2 Grands écrans

Sur grands écrans :

* augmenter la taille de la grille ;
* garder les boutons lisibles ;
* ne pas trop étirer la photo.

---

# 15. Mode clair et mode sombre

## 15.1 MVP recommandé

Commencer avec le mode clair uniquement.

## 15.2 Version suivante

Ajouter un mode sombre.

Mode sombre possible :

* fond Bleu Souvenir foncé ;
* cartes bleu-gris ;
* texte blanc ;
* accent Or Mémoire.

---

# 16. Règles de confidentialité dans l’interface

La confidentialité doit être visible à trois endroits :

## 16.1 Sur l’écran Photo Picker

```text
Vos photos restent sur votre téléphone.
```

## 16.2 Dans les paramètres

```text
Souvenir Puzzle ne téléverse pas vos photos. Les puzzles sont créés directement sur votre téléphone.
```

## 16.3 Lors de la suppression

```text
Vos photos originales ne seront pas supprimées de votre téléphone.
```

---

# 17. État vide

## 17.1 Mes souvenirs vide

Texte :

```text
Aucun souvenir pour le moment.
Créez votre premier puzzle avec une photo importante.
```

Bouton :

```text
Créer un puzzle
```

## 17.2 Aucune photo sélectionnée

Texte :

```text
Choisissez une photo pour commencer.
```

Bouton :

```text
Choisir une photo
```

---

# 18. États d’erreur

## 18.1 Permission refusée

Titre :

```text
Accès aux photos refusé
```

Message :

```text
Souvenir Puzzle a besoin d’accéder à vos photos pour créer un puzzle.
Vous pouvez modifier cette autorisation dans les paramètres de votre téléphone.
```

Boutons :

```text
Ouvrir les paramètres
Annuler
```

## 18.2 Image trop grande

Titre :

```text
Photo trop lourde
```

Message :

```text
Cette photo est trop grande pour être utilisée directement.
L’application va essayer de l’optimiser.
```

## 18.3 Erreur inconnue

Titre :

```text
Une erreur est survenue
```

Message :

```text
Veuillez réessayer avec une autre photo.
```

---

# 19. Ton de communication

Le ton doit être :

* simple ;
* humain ;
* rassurant ;
* familial ;
* positif.

Éviter :

* langage technique ;
* vocabulaire froid ;
* messages trop longs ;
* compétition agressive.

Exemples :

Bon :

```text
Un beau souvenir retrouvé.
```

Moins bon :

```text
Puzzle solved successfully.
```

Bon :

```text
Vos photos restent sur votre téléphone.
```

Moins bon :

```text
Local data processing enabled.
```

---

# 20. Design des cartes de difficulté

## 20.1 Carte facile

```text
Facile
3 x 3 — 9 pièces
Idéal pour commencer
```

Style :

* icône simple ;
* couleur douce ;
* conseillé aux enfants/seniors.

## 20.2 Carte moyen

```text
Moyen
4 x 4 — 16 pièces
Un bon équilibre
```

Style :

* carte mise en avant par défaut ;
* recommandé pour la plupart des utilisateurs.

## 20.3 Carte difficile

```text
Difficile
5 x 5 — 25 pièces
Pour plus de patience
```

Style :

* pas agressif ;
* montrer que c’est un défi calme.

---

# 21. Design de l’écran de victoire

L’écran de victoire est très important.

Il doit donner une sensation de :

* réussite ;
* émotion ;
* souvenir retrouvé ;
* calme ;
* satisfaction.

Structure :

```text
[Photo complète]

Souvenir complété

Bravo, tu as reconstruit ce moment.

Temps : 02:45
Mouvements : 34

[Rejouer]
[Nouveau souvenir]
```

Animation possible :

* lumière douce ;
* petites étoiles ;
* pièce finale qui se place ;
* vibration légère.

---

# 22. Design émotionnel

Souvenir Puzzle doit créer une relation avec l’utilisateur.

Exemples de petits détails émotionnels :

* “Nouveau souvenir” au lieu de “Nouveau puzzle”.
* “Mes souvenirs” au lieu de “Historique”.
* “Souvenir complété” au lieu de “Victoire”.
* “Un beau souvenir retrouvé” au lieu de “Gagné”.

Ces choix rendent le jeu plus humain et plus unique.

---

# 23. Écrans MVP obligatoires

Pour la première version jouable, les écrans obligatoires sont :

1. Splash Screen
2. Home Screen
3. Photo Picker Screen
4. Difficulty Screen
5. Puzzle Game Screen
6. Victory Screen

Écrans fortement recommandés :

7. Memories Screen
8. Settings Screen
9. Pause Screen

---

# 24. Résumé UI/UX

Souvenir Puzzle doit être conçu comme un jeu mobile calme et émotionnel, centré sur les photos personnelles de l’utilisateur.

Le design doit être simple, clair et chaleureux.
Les mots utilisés doivent renforcer l’idée de souvenir, famille, émotion et réussite douce.

La priorité UX est que l’utilisateur puisse créer son premier puzzle très rapidement, sans compte, sans complication et sans peur pour ses photos personnelles.
