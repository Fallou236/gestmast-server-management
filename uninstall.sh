#!/bin/bash

# Fonction pour supprimer les comptes créés avec Gestmast
supprimer_comptes_gestmast() {
    # Vérifier si le fichier des comptes existe
    if [ -f "/home/.gestmast/comptes.txt" ]; then
        # Lire chaque ligne du fichier des comptes
        while IFS= read -r compte; do
            # Vérifier si le compte a été créé avec Gestmast
            if id "$compte" &>/dev/null; then
                sudo deluser --remove-home "$compte"
            fi
        done < "/home/.gestmast/comptes.txt"
    fi
}

# Fonction pour supprimer les répertoires de partage
supprimer_repertoires_partage() {
    # Supprimer les répertoires de partage pour chaque groupe
    for groupe in etudiant doctorat master m1 m2 m1rs m1gl m2rs m2gl rs gl; do
        sudo rm -rf "/home/partages/$groupe"
    done
    sudo rm -rf /home/partages
}

# Fonction pour supprimer les groupes créés par le script d'installation
supprimer_groupes() {
    # Supprimer les groupes créés par le script d'installation
    sudo groupdel etudiant
    sudo groupdel doctorat
    sudo groupdel master
    sudo groupdel m1
    sudo groupdel m2
    sudo groupdel m1rs
    sudo groupdel m1gl
    sudo groupdel m2rs
    sudo groupdel m2gl
    sudo groupdel rs
    sudo groupdel gl
}

# Fonction pour supprimer les répertoires de l'architecture proposée
supprimer_repertoires() {
    # Supprimer les répertoires de l'architecture proposée
    sudo rm -rf /home/master
    sudo rm -rf /home/doctorat
}

# Fonction pour supprimer les fichiers de configuration
supprimer_fichiers_configuration() {
     #Supprimer les fichiers de configuration
     sudo rm -rf /home/.gestmast
}

# Fonction principale de désinstallation
desinstaller() {
    # Confirmation de la désinstallation
    read -p "Êtes-vous sûr de vouloir désinstaller gestmast ? [o/N]: " choix
    case "$choix" in 
      o|O ) 
        supprimer_comptes_gestmast
        supprimer_repertoires_partage
        supprimer_groupes
        supprimer_repertoires
        supprimer_fichiers_configuration
        echo "gestmast a été désinstallé avec succès."
        ;;
      * )
        echo "Désinstallation annulée."
        ;;
    esac
}

# Appel de la fonction de désinstallation
desinstaller

