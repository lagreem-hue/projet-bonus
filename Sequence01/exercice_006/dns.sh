#!/bin/bash

# Exercice 006 : Introduction aux requêtes DNS avec nslookup
# Auteur : [Ton Nom]
# Objectif : Interroger des domaines et le hostname local

# Liste des domaines à tester
DOMAINS=("example.com" "google.com" "etna.io" "$(hostname)")

echo "===== EXERCICE 006 : Requêtes DNS ====="
echo ""

for domain in "${DOMAINS[@]}"; do
    echo "🔍 Requête DNS pour : $domain"
    echo "nslookup :"
    nslookup "$domain"
    echo ""
    echo "host :"
    host "$domain"
    echo "----------------------------------------"
    echo ""
done

echo "✅ Toutes les requêtes DNS ont été effectuées."

