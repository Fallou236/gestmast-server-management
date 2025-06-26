#!/bin/bash

# Chemins vers les scripts d'installation et de désinstallation
install_script="~/documents/install.sh"
uninstall_script="~/documents/uninstall.sh"


nom_du_compte=$2
#Fonction pour ajouter un compte
ajouter_compte() {
    # Demander le nom d'utilisateur
    #read -p "Nom d'utilisateur : " nom_utilisateur
    # Vérification si le compte existe déjà
    if id "$nom_du_compte" &>/dev/null; then
        echo "Ce nom d'utilisateur existe déjà."
        exit 1
    fi
    
    # Demander les informations sur l'étudiant
    read -p "Nom de l'étudiant : " nom_etudiant
    read -p "Prénom de l'étudiant : " prenom_etudiant
    read -p "Classe de l'étudiant (m1rs, m1gl, m2rs, m2gl, d1, d2, d3) : " classe
    
    # Création du chemin du répertoire personnel en fonction de la classe
    case "$classe" in
   	m1rs) 
   		sudo mkdir -p "/home/master/master1/$classe/$nom_du_compte"
   	 	;;
   	
   	m1gl)  
   		sudo mkdir -p "/home/master/master1/$classe/$nom_du_compte"
   		;;
   	m2gl)  
   		sudo mkdir -p "/home/master/master2/$classe/$nom_du_compte"
   		;;
   	m2rs)  
   		sudo mkdir -p "/home/master/master2/$classe/$nom_du_compte"
   	 	;;
   	d1|d2|d3)  
   		sudo mkdir -p "/home/doctorat/$nom_du_compte"
   	 	;;
    esac
    
    
    # Création du compte
    case "$classe" in
   	m1rs) 
   		sudo useradd -d  /home/master/master1/$classe/$nom_du_compte -e "$(date -d '+18 month' +%Y-%m-%d)" $nom_du_compte
   		sudo chmod 770 /home/master/master1/$classe/$nom_du_compte
   		;;
   	m1gl)  
   		sudo useradd -d  /home/master/master1/$classe/$nom_du_compte -e "$(date -d '+18 month' +%Y-%m-%d)" $nom_du_compte
   	 	sudo chmod 770 /home/master/master1/$classe/$nom_compte
   	 	;;
   	m2gl)  
   		sudo useradd -d  /home/master/master2/$classe/$nom_du_compte -e "$(date -d '+18 month' +%Y-%m-%d)" $nom_du_compte
   	 	sudo chmod 770 /home/master/master2/$classe/$nom_du_compte
   	 	;;
   	m2rs)  
   		sudo useradd -d  /home/master/master2/$classe/$nom_du_compte -e "$(date -d '+18 month' +%Y-%m-%d)" $nom_du_compte
   	 	sudo chmod 770 /home/master/master2/$classe/$nom_du_compte
   	 	;;
   	d1|d2|d3)  
   		sudo useradd -d  /home/doctorat/$nom_du_compte -e "$(date -d '+3 years' +%Y-%m-%d)" $nom_du_compte
   	 	sudo chmod 770 /home/doctorat/$nom_du_compte
   	 	;;
     esac
     
    
    if [[ $classe == "d1" || $classe == "d2" || $classe == "d3" ]]; then
        sudo usermod -aG etudiant,doctorat "$nom_du_compte"
    else
    	case $classe in
		m1rs)
		    sudo usermod -aG $classe,m1,master,rs $nom_du_compte
		    ;;
		m1gl)
		    sudo usermod -aG $classe,m1,master,gl $nom_du_compte
		    ;;
		m2rs)
		    sudo usermod -aG $classe,m2,master,rs $nom_du_compte
		    ;;
		m2gl)
		    sudo usermod -aG $classe,m2,master,gl $nom_du_compte
		    ;;
    	esac
    fi
    
    
    # Enregistrement des informations dans le fichier du répertoire caché
    echo "$nom_du_compte:$nom_etudiant:$prenom_etudiant:$classe:$(date +%Y-%m-%d)" | sudo tee -a /home/.gestmast/comptes.txt
    
    #Creation des raccourcis
    case $classe in
		m1rs)
		    for groupe in etudiant master m1 m1rs rs ; do
		    	sudo ln -s "/home/partages/$groupe" "/home/master/master1/$classe/$nom_du_compte"
    		    done
    		    ;;
		m1gl)
		    for groupe in etudiant  master m1 m1gl gl; do
		    	sudo ln -s "/home/partages/$groupe" "/home/master/master1/$classe/$nom_du_compte"
    		    done
    		    ;;
		m2rs)
		    for groupe in etudiant master  m2 m2rs rs; do
		    	sudo ln -s "/home/partages/$groupe" "/home/master/master2/$classe/$nom_du_compte"
    		    done
    		    ;;
		m2gl)
		    for groupe in etudiant master m2 m2gl gl; do
		    	sudo ln -s "/home/partages/$groupe" "/home/master/master2/$classe/$nom_du_compte"
    		    done
    		    ;;
    		d1|d2|d3)
    		    for groupe in etudiant doctorat; do
		    	sudo ln -s "/home/partages/$groupe" "/home/doctorat/$nom_du_compte"
    		    done
    		    ;;
    	esac
    
    echo "Le compte $nom_du_compte a été créé avec succès."
}

#-------------------------------------------------------------------------------------------------------------------------------------------

#Fonction pour migrer un etudiant d'une classe a une autre
migrer_etudiant() {
    # Demander le nom d'utilisateur
    read -p "Nom d'utilisateur à migrer: " nom_utilisateur
    
    # Vérification si le compte existe
    if ! id "$nom_utilisateur" &>/dev/null; then
        echo "Le compte $nom_utilisateur n'existe pas."
        exit 1
    fi
    
    actuelle=$(grep -i "$nom_utilisateur" "/home/.gestmast/comptes.txt" | cut -d':' -f4)
    echo "Classe actuelle :  $actuelle"
    
    #echo "Preciser la classe actuelle et celle de migration"
    #read -p "Classe actuelle : " actuelle
    
    # Demander la classe de migration
    read -p "Classe de migration (m1rs, m1gl, m2rs, m2gl, d1, d2, d3): " nouvelle_classe
    
    # Vérifier si la classe de migration est différente de la classe actuelle
    if [[ "$nouvelle_classe" == "$classe_actuelle" ]]; then
        echo "Le compte est déjà dans la classe $nouvelle_classe."
        exit 1
    fi
    
    
    # Définir la destination en fonction de la nouvelle classe
    case "$nouvelle_classe" in
        m1rs)
            destination="/home/master/master1/$nouvelle_classe"
            ;;
        m1gl)
            destination="/home/master/master1/$nouvelle_classe"
            ;;
        m2rs)
            destination="/home/master/master2/$nouvelle_classe"
            ;;
        m2gl)
            destination="/home/master/master2/$nouvelle_classe"
            ;;
        d1|d2|d3)
            destination="/home/doctorat/"
            ;;
    esac
    
    #Definir le repertoire source de l'utilisateur
    if [[ "$actuelle" == "m1rs" ]]; then
        source="/home/master/master1/m1rs"
    fi
    if [[ "$actuelle" == "m1gl" ]]; then
        source="/home/master/master1/m1gl"
    fi
    if [[ "$actuelle" == "m2rs" ]]; then
        source="/home/master/master2/m2rs"
    fi
    if [[ "$actuelle" == "m2gl" ]]; then
        source="/home/master/master2/m2gl"
    fi
    if [[ "$actuelle" == "d1" ]]; then
        source="/home/doctorat"
    fi
    if [[ "$actuelle" == "d2" ]]; then
        source="/home/doctorat"
    fi
    if [[ "$actuelle" == "d3" ]]; then
        source="/home/doctorat"
    fi
    
    #Changement des groupes d'appartenance
    if [[ $nouvelle_classe == "d1" || $nouvelle_classe == "d2" || $nouvelle_classe == "d3" ]]; then
        sudo usermod -G etudiant,doctorat "$nom_utilisateur"
    else
    	case $nouvelle_classe in
		m1rs)
		    sudo usermod -G $classe,m1,master,rs,etudiant $nom_utilisateur
		    ;;
		m1gl)
		    sudo usermod -G $classe,m1,master,gl,etudiant $nom_utilisateur
		    ;;
		m2rs)
		    sudo usermod -G $classe,m2,master,rs,etudiant $nom_utilisateur
		    ;;
		m2gl)
		    sudo usermod -G $classe,m2,master,gl,etudiant $nom_utilisateur
		    ;;
    	esac
    fi
    
    
    
    #Suppression des raccourcis et augmentation du duree de validite
    case $actuelle in
		m1rs)
			if [[ $nouvelle_classe == "m2rs" ]]; then
        			for lien in  m1 m1rs; do
		    			sudo rm -r "/home/master/master1/m1rs/$nom_utilisateur/$lien"
		    		done
    			fi
		    	;;
		m1gl)
			if [[ $nouvelle_classe == "m2gl" ]]; then
        			for lien in  m1 m1gl; do
		    			sudo rm -r "/home/master/master1/m1gl/$nom_utilisateur/$lien"
		    		done
    			fi
		    	;;
		m2rs)
			if [[ $nouvelle_classe == "d1" ]]; then
        			for lien in  master m2 m2rs rs ; do
		    			sudo rm -r "/home/master/master2/m2rs/$nom_utilisateur/$lien"
		    		done
    			fi
    			sudo chage -E $(date -d '+3 years' +%Y-%m-%d) $nom_utilisateur
    			;;
		m2gl)
		    	if [[ $nouvelle_classe == "d1" ]]; then
        			for lien in  m2 master m2gl gl; do
		    			sudo rm -r "/home/master/master1/m1rs/$nom_utilisateur/$lien"
		    		done
		    		sudo chage -E $(date -d '+3 years' +%Y-%m-%d) $nom_utilisateur

    			fi
		    	;;
		d3)	
			#Derogation
		    		sudo chage -E $(date -d '+1 year' +%Y-%m-%d) $nom_utilisateur

		    	;;
			
    esac
    
    # Effectuer la migration
    echo "Migration de $nom_utilisateur de $actuelle vers $nouvelle_classe..."
    sudo mv "$source/$nom_utilisateur" "$destination/"
    
    # Récupérer la ligne utilisateur
    ligne=$(grep "^$nom_utilisateur:" "/home/.gestmast/comptes.txt")
    prenom=$(echo "$ligne" | cut -d ":" -f3)
    nom=$(echo "$ligne" | cut -d ":" -f2)
    classe=$(echo "$ligne" | cut -d ":" -f4)
    
    # Remplacer la ligne utilisateur avec les nouvelles informations
    sudo sed -i "s#^$nom_utilisateur:$nom:$prenom:$classe#$nom_utilisateur:$nom:$prenom:$nouvelle_classe:#" "/home/.gestmast/comptes.txt"

    
    #Creation des nouveaux raccourcis 
    case $nouvelle_classe in
		m2rs)
		    for groupe in m2 m2rs; do
		    	sudo ln -s "/home/partages/$groupe" "/home/master/master2/$nouvelle_classe/$nom_utilisateur"
    		    done
    		    ;;
		m2gl)
		    for groupe in m2 m2gl; do
		    	sudo ln -s "/home/partages/$groupe" "/home/master/master2/$nouvelle_classe/$nom_utilisateur"
    		    done
    		    ;;
    		d1)
    		    for groupe in doctorat; do
		    	sudo ln -s "/home/partages/$groupe" "/home/doctorat/$nom_utilisateur"
    		    done
    		    ;;
    esac
    echo "Migration terminée."
    
}
#-----------------------------------------------------------------------------------------------------------
#Fonction pour mettre a jour les informations
update() {
    # Vérification de l'existence du fichier
    if [ ! -f "/home/.gestmast/comptes.txt" ]; then 
        echo "Le fichier compte.txt n'existe pas"
        return
    fi
   
    # Demander le login
    read -p "Entrer le login de l'utilisateur à modifier : " nom_utilisateur
    
    # Vérifier si l'utilisateur existe
    if ! grep -q "^$nom_utilisateur:" "/home/.gestmast/comptes.txt"; then
        echo "L'utilisateur $nom_utilisateur n'existe pas"
        return
    fi
    
    # Récupérer la ligne utilisateur
    ligne=$(grep "^$nom_utilisateur:" "/home/.gestmast/comptes.txt")
    prenom=$(echo "$ligne" | cut -d ":" -f3)
    nom=$(echo "$ligne" | cut -d ":" -f2)
    
    # Demander les nouvelles informations
    read -p "Entrer le nouveau prénom: " new_prenom
    read -p "Entrer le nouveau nom: " new_nom
    
    # Remplacer la ligne utilisateur avec les nouvelles informations
    sudo sed -i "s#^$nom_utilisateur:$nom:$prenom#$nom_utilisateur:$new_nom:$new_prenom#" "/home/.gestmast/comptes.txt"

    # Afficher les nouvelles informations
    echo "$nom_utilisateur a été mise à jour"
    echo "Nouvelles infos :"
    echo "Nom utilisateur : $nom_utilisateur"
    echo "Prénom : $new_prenom"
    echo "Nom : $new_nom"
}
#---------------------------------------------------------------------------------------------------------------------------------

# Fonction pour désactiver un compte
desactiver_compte() {
    # Demander le nom d'utilisateur à désactiver
    read -p "Nom d'utilisateur à désactiver : " nom_utilisateur
    
    # Vérification si le compte existe
    if ! id "$nom_utilisateur" &>/dev/null; then
        echo "Le compte $nom_utilisateur n'existe pas."
        exit 1
    fi
    
    # Désactiver le compte
    sudo usermod -L "$nom_utilisateur"
    
    echo "Le compte $nom_utilisateur a été désactivé avec succès."
}
#-------------------------------------------------------------------------------------------------------------

# Fonction pour réactiver un compte
reactiver_compte() {
    # Demander le nom d'utilisateur à réactiver
    read -p "Nom d'utilisateur à réactiver : " nom_utilisateur
    
    # Vérification si le compte existe
    if ! id "$nom_utilisateur" &>/dev/null; then
        echo "Le compte $nom_utilisateur n'existe pas."
        exit 1
    fi
    
    # Réactiver le compte
    sudo usermod -U "$nom_utilisateur"
    
    echo "Le compte $nom_utilisateur a été réactivé avec succès."
}
#----------------------------------------------------------------------------------------------------------

# Fonction pour supprimer un compte gestmast
supprimer_compte() {
    # Demander le nom d'utilisateur à supprimer
    read -p "Nom d'utilisateur à supprimer de gestmast : " nom_utilisateur
    classe=$(grep -i "$nom_utilisateur" "/home/.gestmast/comptes.txt" | cut -d':' -f4)
    
    # Vérification si le compte existe
    if ! id "$nom_utilisateur" &>/dev/null; then
        echo "Le compte $nom_utilisateur n'existe pas."
        exit 1
    fi
    
    # Exclure l'étudiant des groupes
    for groupe in $(groups "$nom_utilisateur" | cut -d' ' -f3-); do
        sudo deluser "$nom_utilisateur" "$groupe"
    done
    
    # Déplacer le home dans /home/archives
    case "$classe" in
        m1rs)
            sudo mv "/home/master/master1/$classe/$nom_utilisateur" /home/archives/
            ;;
        m1gl)
            sudo mv "/home/master/master1/$classe/$nom_utilisateur" /home/archives/
            ;;
        m2rs)
            sudo mv "/home/master/master2/$classe/$nom_utilisateur" /home/archives/
            ;;
        m2gl)
            sudo mv "/home/master/master2/$classe/$nom_utilisateur" /home/archives/
            ;;
        d1|d2|d3)
            sudo mv "/home/doctorat/$nom_utilisateur" /home/archives/
            ;;
    esac
    
    # Désactiver le compte
    sudo usermod -L "$nom_utilisateur"
    
    echo "Le compte $nom_utilisateur a été supprimé de gestmast avec succès."
}
#---------------------------------------------------------------------------------------------------------------

# Fonction pour vérifier la configuration de gestmast
verifier_configuration() {
    # Vérifier l'existence des répertoires principaux
    declare -a repertoires=("m1rs" "m1gl" )
    echo "Vérification des répertoires principaux :"
    for rep in "${repertoires[@]}"; do
        if [ -d "/home/master/master1/$rep" ]; then
            echo "Répertoire /home/master/master1/$rep : OK"
        else
            echo "Répertoire /home/master/master1/$rep : NON TROUVÉ"
        fi
    done
    
    declare -a repertoires=("m2rs" "m2gl" )
    for rep in "${repertoires[@]}"; do
        if [ -d "/home/master/master2/$rep" ]; then
            echo "Répertoire /home/master/master2/$rep : OK"
        else
            echo "Répertoire /home/master/master2/$rep : NON TROUVÉ"
        fi
    done
    
    if [ -d "/home/doctorat" ]; then
        echo "Répertoire /home/doctorant : OK"
    else
        echo "Répertoire /home/doctorat : NON TROUVÉ"
    fi
           
    # Vérifier l'existence des groupes
    declare -a groupes=("etudiant" "doctorat" "master" "m1" "m2" "m1rs" "m1gl" "m2rs" "m2gl" "rs" "gl")
    echo -e "\nVérification des groupes :"
    for grp in "${groupes[@]}"; do
        if grep -q "^$grp:" /etc/group; then
            echo "Groupe $grp : OK"
        else
            echo "Groupe $grp : NON TROUVÉ"
        fi
    done
    
    
    # Vérifier l'existence des répertoires de partage
    echo -e "\nVérification des répertoires de partage :"
    if [ -d "/home/partages" ]; then
        echo "Répertoire /home/partages : OK"
        # Vérifier les sous-répertoires pour chaque groupe
        for grp in "${groupes[@]}"; do
            if [ -d "/home/partages/$grp" ]; then
                echo "Répertoire /home/partages/$grp : OK"
            else
                echo "Répertoire /home/partages/$grp : NON TROUVÉ"
            fi
        done
    else
        echo "Répertoire /home/partages : NON TROUVÉ"
    fi
    
    # Vérifier l'existence du fichier de configuration
    echo -e "\nVérification du fichier de configuration :"
    if [ -f "/home/.gestmast/config.txt" ]; then
        echo "Fichier de configuration /home/.gestmast/config.txt : OK"
    else
        echo "Fichier de configuration /home/.gestmast/config.txt : NON TROUVÉ"
    fi
    
    # Vérifier l'existence du répertoire caché
    echo -e "\nVérification du répertoire caché :"
    if [ -d "/home/.gestmast" ]; then
        echo "Répertoire caché /home/.gestmast : OK"
        # Vérifier les fichiers essentiels
        declare -a fichiers=("comptes.txt" "aide.txt")
        for fichier in "${fichiers[@]}"; do
            if [ -f "/home/.gestmast/$fichier" ]; then
                echo "Fichier /home/.gestmast/$fichier : OK"
            else
                echo "Fichier /home/.gestmast/$fichier : NON TROUVÉ"
            fi
        done
    else
        echo "Répertoire caché /home/.gestmast : NON TROUVÉ"
    fi
}
#----------------------------------------------------------------------------------------------------
# Fonction pour afficher l'aide
afficher_aide() {
    echo "Usage: gestmast [OPTIONS] [PARAMETRES]"
    echo "Options:"
    echo "  -a, --add             Ajouter un compte utilisateur"
    echo "  -u, --update          Mettre à jour les caractéristiques d'un compte utilisateur"
    echo "  -m, --migrate         Migrer un compte utilisateur vers une classe supérieure"
    echo "  -L, --lock            Verrouiller un compte utilisateur"
    echo "  -U, --unlock          Déverrouiller un compte utilisateur"
    echo "  -d, --delete          Supprimer un compte de gestmast"
    echo "  -c, --check           Vérifier la configuration de gestmast"
    echo "  --help                Afficher cette aide"
}

# Appel des fonctions (les fonctionalités de Gestmast)
case "$1" in
    -a | --add)
        if [ $# -eq 2 ]; then
            ajouter_compte
        else
            echo "Nombre d'arguments invalide pour l'option -a/--add"
        fi
        ;;
    -u | --update)
        if [ $# -eq 1 ]; then
            update
        else
            echo "Nombre d'arguments invalide pour l'option -u | --update"
        fi
        ;;
    -m | --migrate)
        if [ $# -eq 1 ]; then
            migrer_etudiant
        else
            echo "Nombre d'arguments invalide"
        fi
        
        ;;
    -L | --lock)
        if [ $# -eq 1 ]; then
            desactiver_compte
        else
            echo "Nombre d'arguments invalide"
        fi
        ;;
    -U | --unlock)
        if [ $# -eq 1 ]; then
            reactiver_compte
        else
            echo "Nombre d'arguments invalide"
        fi
        ;;
    -d | --delete)
        if [ $# -eq 1 ]; then
            supprimer_compte
        else
            echo "Nombre d'arguments invalide"
        fi
        ;;
    -c | --check)
        verifier_configuration
        ;;
    --help)
        afficher_aide
        ;;
    *)
        echo "Option invalide. Utilisez --help pour afficher l'aide."
        ;;
esac

