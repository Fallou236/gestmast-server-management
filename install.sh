#!/bin/bash

# Fonction pour créer les fichiers de configuration
creer_fichiers_configuration() {
    sudo mkdir -p /home/.gestmast
    # Créer les fichiers nécessaires dans le répertoire ~/.gestmast
    sudo touch /home/.gestmast/comptes.txt
    sudo touch /home/.gestmast/aide.txt
}

# Fonction pour créer les répertoires de l'architecture proposée
creer_repertoires() {
    # Créer les répertoires selon l'architecture proposée
    sudo mkdir -p /home/master
    sudo mkdir -p /home/master/master1
    sudo mkdir -p /home/master/master2
    sudo mkdir -p /home/master/master1/m1rs
    sudo mkdir -p /home/master/master1/m1gl
    sudo mkdir -p /home/master/master2/m2rs
    sudo mkdir -p /home/master/master2/m2gl
    sudo mkdir -p /home/doctorat
}

# Fonction pour créer les groupes de l'architecture proposée
creer_groupes() {
    # Créer les groupes selon l'architecture proposée
    sudo groupadd etudiant
    sudo groupadd doctorat
    sudo groupadd master
    sudo groupadd m1
    sudo groupadd m2
    sudo groupadd m1rs
    sudo groupadd m1gl
    sudo groupadd m2rs
    sudo groupadd m2gl
    sudo groupadd rs
    sudo groupadd gl
}

# Fonction pour créer et configurer les répertoires de partage avec les bons droits
creer_repertoires_partage() {
    sudo mkdir -p /home/partages
    # Créer les répertoires de partage pour chaque groupe
    for groupe in etudiant doctorat master m1 m2 m1rs m1gl m2rs m2gl rs gl; do
        sudo mkdir -p "/home/partages/$groupe"
        sudo chown root:$groupe "/home/partages/$groupe"
        sudo chmod 775 "/home/partages/$groupe"
    done
}

# Fonction principale d'installation
installer() {
    creer_fichiers_configuration
    creer_repertoires
    creer_groupes
    creer_repertoires_partage
}

# Appel de la fonction d'installation
installer



