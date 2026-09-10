#!/bin/bash

sudo apt update
sudo apt install passwd -y
sudo apt install pwgen -y

if [[ $EUID -ne 0 ]]; then
  echo "Ce script doit être exécuté en tant que root."
  exit 1
fi

CSV_FILE="users.csv"
PASSWORD_FILE="generated_passwords.txt"

if [[ ! -f "$CSV_FILE" ]]; then
  echo "Fichier $CSV_FILE introuvable."
  exit 1
fi

echo "# Liste des utilisateurs et mots de passe générés" > "$PASSWORD_FILE"
echo "# Généré le : $(date)" >> "$PASSWORD_FILE"
echo "---------------------------------------------" >> "$PASSWORD_FILE"


tail -n +2 "$CSV_FILE" | while IFS=',' read -r id first_name last_name email gender group last_login
do
  username="${first_name,,}.${last_name,,}"   # ex: thorndike.butchers
  shell="/bin/bash"                           # shell par défaut
  home_dir="/home/$username"


  if ! getent group "$group" >/dev/null; then
    groupadd "$group"
    echo " Groupe $group créé."
  fi

  if id "$username" &>/dev/null; then
    echo " L’utilisateur $username existe déjà, passage..."
    continue
  fi

  useradd -m -d "$home_dir" -s "$shell" -g "$group" "$username"

  password=$(pwgen -s 12 1)

  echo "$username:$password" | chpasswd

  chage -d 0 "$username"

  echo "$username : $password ($group)" >> "$PASSWORD_FILE"

  echo " Utilisateur $username (groupe $group) créé avec succès."
done

echo "---------------------------------------------"
echo " Création des utilisateurs terminée."
echo " Mots de passe enregistrés dans : $PASSWORD_FILE"

