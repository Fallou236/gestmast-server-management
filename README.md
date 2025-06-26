# Projet d’Administration Systèmes – `gestmast.sh`

## 📌 Contexte

Ce projet a été réalisé dans le cadre du cours *Administration Systèmes* (Licence 2 – Ingénierie Informatique) à l’Université Assane Seck de Ziguinchor (année universitaire 2022–2023).

Il consiste à développer un ensemble de scripts shell pour automatiser la **gestion des comptes étudiants** (Master & Doctorat) sur un serveur Linux pédagogique.


## 🎯 Objectif

Créer un outil appelé `gestmast` permettant :

- L'ajout de comptes pour les nouveaux étudiants de Master/Doctorat.
- La migration de comptes entre niveaux.
- La désactivation/réactivation et la suppression de comptes.
- La gestion de groupes d’utilisateurs et des espaces de partage.
- Le suivi des comptes créés dans un fichier de configuration.


## 🧱 Architecture du Serveur

### 1. Répertoires utilisateurs

| Classe   | Répertoire                                |
|----------|--------------------------------------------|
| m1rs     | `/home/master/master1/m1rs/`               |
| m1gl     | `/home/master/master1/m1gl/`               |
| m2rs     | `/home/master/master2/m2rs/`               |
| m2gl     | `/home/master/master2/m2gl/`               |
| d1, d2, d3 | `/home/doctorat/`                         |

Chaque étudiant possède un répertoire personnel (`chmod 770`) et appartient à plusieurs groupes selon sa classe.


### 2. Groupes d'utilisateurs

- **Commun à tous** : `etudiant`
- **Master** : `master`, `m1`, `m2`, `m1rs`, `m1gl`, `m2rs`, `m2gl`, `rs`, `gl`
- **Doctorat** : `doctorat`, `d1`, `d2`, `d3`


### 3. Espaces de partage

- Tous les groupes ont un répertoire de partage dans `/home/partages/` :  
  ex. `/home/partages/m1rs/`, `/home/partages/gl/`, etc.

- Ces répertoires sont créés avec `root` comme propriétaire, le groupe correspondant comme groupe, et les droits `775`.


## 📂 Structure du projet

```bash
.
├── install.sh       # Script d'installation initiale de l'architecture
├── uninstall.sh     # Script de désinstallation complète
├── gestmast.sh      # Script principal de gestion des comptes
└── /home/.gestmast/ # Répertoire caché contenant les fichiers de suivi
    ├── comptes.txt  # Informations sur tous les comptes créés
    ├── config.txt   # Configuration éventuelle
    └── aide.txt     # Aide affichée avec --help
````


## ⚙️ Utilisation de `gestmast`

```bash
./gestmast.sh [OPTION] [ARGUMENT]
```

### Options disponibles :

| Option            | Description                                                   |
| ----------------- | ------------------------------------------------------------- |
| `-a`, `--add`     | Ajouter un nouveau compte étudiant                            |
| `-m`, `--migrate` | Migrer un compte vers une autre classe                        |
| `-u`, `--update`  | Modifier nom/prénom d’un utilisateur                          |
| `-L`, `--lock`    | Verrouiller (désactiver) un compte                            |
| `-U`, `--unlock`  | Déverrouiller un compte                                       |
| `-d`, `--delete`  | Supprimer un compte de `gestmast` (archivage + désactivation) |
| `-c`, `--check`   | Vérifier la configuration du système `gestmast`               |
| `--help`          | Afficher ce guide d'utilisation                               |


## ✅ Installation

```bash
sudo bash install.sh
```

Ce script :

* Crée les répertoires nécessaires,
* Crée les groupes utilisateurs,
* Initialise `/home/.gestmast/`,
* Crée les espaces de partage dans `/home/partages/`.


## ❌ Désinstallation

```bash
sudo bash uninstall.sh
```

Ce script :

* Supprime tous les comptes créés avec `gestmast`,
* Supprime tous les fichiers de configuration et les groupes associés,
* Nécessite une confirmation manuelle avant suppression définitive.


## 🧪 Tests conseillés

1. Ajouter un compte M1RS avec :

   ```bash
   ./gestmast.sh -a nom_utilisateur
   ```
2. Migrer vers M2RS puis D1, tester les groupes et raccourcis.
3. Vérifier l’accès aux répertoires de partage.
4. Désactiver, réactiver, puis supprimer un compte.
5. Lancer :

   ```bash
   ./gestmast.sh --check
   ```

   pour vérifier que tout est bien en place.


## 👨‍💻 Auteurs

* Fallou Diouck


## 🏅 Note obtenue / Grade Received

> ✅ **17.25 / 20**  
> (Travail complet, bien structuré, respect des consignes)
  

## 📝 Licence

Ce projet est destiné à un usage académique dans le cadre de l’Université Assane Seck de Ziguinchor. Toute réutilisation dans un autre cadre nécessite une autorisation préalable.
