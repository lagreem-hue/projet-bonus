#!/bin/bash
set -e


echo "Mise à jour du système et installation d’Apache..."
sudo apt update -y
sudo apt install apache2 -y
echo "Apache installé."

echo "⚙️ Activation du module userdir..."
sudo a2enmod userdir
sudo systemctl reload apache2


USERDIR_CONF="/etc/apache2/mods-available/userdir.conf"
echo "Configuration du module userdir..."
sudo cp "$USERDIR_CONF" "$USERDIR_CONF.bak"

sudo tee "$USERDIR_CONF" > /dev/null <<'EOF'
<IfModule mod_userdir.c>
    UserDir www
    UserDir disabled root

    <Directory /home/*/www>
        AllowOverride FileInfo AuthConfig Limit Indexes
        Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
        Require method GET POST OPTIONS
    </Directory>
</IfModule>
EOF

sudo systemctl reload apache2
echo "Module userdir configuré."


echo "Création des répertoires web pour tous les utilisateurs..."

for home_dir in /home/*; do
    user=$(basename "$home_dir")
    
    # Ignore si c'est root ou un dossier système (optionnel)
    if [ "$user" = "root" ]; then
        continue
    fi

    sudo mkdir -p "$home_dir/www"
    

    group=$(id -gn "$user" 2>/dev/null || echo "$user")
    
 
    sudo chown -R "$user:$group" "$home_dir/www"

    cat <<HTML | sudo tee "$home_dir/www/index.html" > /dev/null
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<title>Page personnelle de $user</title>
</head>
<body>
<h1>Bienvenue sur la page de $user</h1>
<p>Si vous voyez ceci, la configuration userdir fonctionne ! 🎉</p>
</body>
</html>
HTML


    sudo chmod 755 "$home_dir/www"
    sudo chmod 644 "$home_dir/www/index.html"

    echo "$user prêt pour l'hébergement personnel."
done

echo "Redémarrage d’Apache..."
sudo systemctl reload apache2

echo "Configuration terminée pour tous les utilisateurs !"
echo "Vous pouvez tester en accédant à http://localhost/~username pour chaque utilisateur."

