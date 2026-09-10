#!/bin/bash

sudo mkdir -p /Goinfre
sudo chmod 777 /Goinfre

for group in $(cut -d: -f1 /etc/group); do
    sudo mkdir -p /Goinfre/"$group"
    
    sudo chown root:"$group" /Goinfre/"$group"  
    
    sudo chmod 770 /Goinfre/"$group"
done

echo "Structure de répertoires /Goinfre créée avec permissions pour chaque groupe."

