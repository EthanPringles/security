#!/bin/bash

# 🔍 Script de vérification rapide des hashs Safe
# Usage: ./hash-check.sh <safe-address> <transaction-data>

echo "🔐 Safe Hash Verification Tool"
echo "=============================="

if [ $# -lt 2 ]; then
    echo "Usage: $0 <safe-address> <transaction-data>"
    echo "Example: $0 0x123...abc '{\"to\":\"0x456...\",\"value\":\"1000000000000000000\"}'"
    exit 1
fi

SAFE_ADDRESS=$1
TX_DATA=$2

echo "🏠 Safe Address: $SAFE_ADDRESS"
echo "📄 Transaction Data: $TX_DATA"
echo ""

echo "🛠️  Outils recommandés pour vérification:"
echo "1. OpenZeppelin Safe Utils: https://safeutils.openzeppelin.com/"
echo "2. safe-tx-hashes-util CLI: https://github.com/pcaversaccio/safe-tx-hashes-util"
echo ""

echo "✅ Étapes de vérification:"
echo "1. Copier les données ci-dessus dans l'outil"
echo "2. Calculer Domain Hash + Message Hash"
echo "3. Comparer avec l'affichage de votre hardware wallet"
echo "4. Poster le résultat dans le canal Treasury-Verification"
echo ""

echo "⚠️  Si les hashs ne correspondent pas: NE PAS SIGNER !"
echo ""

# Note: Ce script pourrait être étendu pour calculer les hashs directement
# mais pour l'instant on reste sur les outils vérifiés