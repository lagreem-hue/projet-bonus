#!/bin/bash

sudo apt update
sudo apt install passwd -y
sudo apt install pwgen -y


if [ "$(id -u)" -ne 0 ]; then
  echo "Ce script doit être exécuté en tant que root."
  exit 1
fi

CSV_FILE="$1"
if [ -z "$CSV_FILE" ] || [ ! -f "$CSV_FILE" ]; then
  echo "Fichier CSV manquant ou introuvable."
  echo "Usage : $0 group.csv"
  exit 1
fi

tail -n +2 "$CSV_FILE" | while IFS=',' read -r group users; do
  group=$(echo "$group" | tr -d ' ')
  users=$(echo "$users" | tr -d ' ')

  if getent group "$group" > /dev/null 2>&1; then
    echo "Groupe '$group' existe déjà."
  else
    groupadd "$group"
    echo "Groupe '$group' créé."
  fi

  IFS=';' read -ra user_list <<< "$users"
  for user in "${user_list[@]}"; do
    if id "$user" &>/dev/null; then
      usermod -aG "$group" "$user"
      echo " Utilisateur '$user' ajouté au groupe '$group'."
    else
      echo "Utilisateur '$user' inexistant — ignoré."
    fi
  done

done

echo "Gestion des groupes terminée."

