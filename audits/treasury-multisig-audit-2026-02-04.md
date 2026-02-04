# 🔐 Audit Sécurité Multisig - Safe "Treasury"

**Date :** 4 février 2026  
**Évaluateur :** Mat (Mathieu Gorichon)  
**Safe :** Treasury (configuration 3/5)  
**Score global :** 19/55 (34.5%) - **RISQUE ÉLEVÉ** ⚠️

**🛠️ Outil d'audit :** [1kx Network Self-Assessment: Multisig OpSec](https://1kx.network/writing/self-assessment-multisig-opsec-defending-against-malware-and-ui-exploits)  
*Guide officiel de défense contre malware et exploits UI*

---

## 🎯 Méthodologie

Cet audit utilise le framework **1kx Network Self-Assessment** - référence industrie pour l'évaluation de sécurité multisig. Le guide couvre 11 critères essentiels de défense contre :
- **Attaques malware** sur les appareils de signature
- **Exploits UI** (manipulation d'interface utilisateur)

Chaque critère est noté de 0 à 5 selon des barèmes précis définis par 1kx Network.

📖 **Source :** https://1kx.network/writing/self-assessment-multisig-opsec-defending-against-malware-and-ui-exploits

---

## 📊 Résultats détaillés

| Critère | Score | Risque | Commentaire |
|---------|-------|--------|-------------|
| 1. Seuil de signature (n/m) | 3/5 | Moyen | Config 3/5 équilibrée, mais Mat détient 2 clés (effectivement 2/4) |
| 2. Homogénéité hardware wallets | 3/5 | Moyen | 2x Ledger + 1 mobile, dominance Ledger mais diversité partielle |
| 3. Homogénéité appareils signature | 5/5 | Faible | Excellent mix : Linux + Windows + Android |
| 4. Appareils dédiés signature | 0/5 | **Élevé** | Aucun appareil dédié, signature sur machines du quotidien |
| 5. Vérification hors-bande | 1/5 | **Élevé** | Vérification minimaliste, pas de validation croisée |
| 6. Ségrégation processus | 0/5 | **Élevé** | Même personne prépare et signe |
| 7. Vérification indépendante | 0/5 | **Élevé** | Aucun outil alternatif pour valider les hashs |
| 8. Guards programmatiques | 0/5 | **Élevé** | Safe basique sans protection avancée |
| 9. Anti-malware | 2/5 | Élevé | Linux/Android OK, Windows non protégé |
| 10. Sécurité physique | 3/5 | Moyen | Coffres à clés, pas de coffres-forts fixes |
| 11. Formation signataires | 2/5 | Élevé | Connaissance des risques mais maîtrise limitée |

### 📋 Critères complémentaires (howtomultisig.com)

| Critère | Score | Risque | Commentaire |
|---------|-------|--------|-------------|
| 12. Anonymat des signataires | 0/5 | **Élevé** | Identités publiquement connues |
| 13. Adresses dédiées multisig | 0/5 | **Élevé** | Adresses utilisées pour DeFi/NFTs |
| 14. Diversité géographique | 1/5 | **Élevé** | Signataires concentrés géographiquement |
| 15. Safe word offline | 0/5 | **Élevé** | Aucun mécanisme d'authentification d'urgence |
| 16. Simulation transactions | 0/5 | **Élevé** | Pas de preview des effets avant signature |
| 17. Décodage calldata | 0/5 | **Élevé** | Paramètres contrats non vérifiés |
| 18. Vérification Call/DelegateCall | 1/5 | **Élevé** | Connaissance basique mais pas de vérification systématique |
| 19. Paramètres gas refund | 0/5 | **Élevé** | Jamais vérifiés (doivent être à zéro) |
| 20. Plan d'urgence + monitoring | 0/5 | **Élevé** | Aucune procédure de compromission ni monitoring |

**Score final : 20/100 = 20% - RISQUE TRÈS ÉLEVÉ** ⚠️⚠️  
*Combinaison 1kx Network (11 critères) + howtomultisig.com (9 critères) = 20 critères × 5 points*

---

## 🎯 Plan d'action détaillé

### 🔴 URGENCES (Implémentation immédiate - 0-30 jours)

#### 1. Vérification hors-bande systématique
**Objectif :** Empêcher les attaques par manipulation d'interface (UI spoofing)

**🚀 Mise en œuvre immédiate :**

1. **Créer un canal Signal/Telegram dédié** "Treasury-Verification"
   - Ajouter tous les signataires
   - Canal uniquement pour validation de transactions

2. **Processus obligatoire pour TOUTE transaction :**
   ```
   ÉTAPE 1: Celui qui prépare la transaction
   → Va sur https://safeutils.openzeppelin.com/
   → Colle les détails de la transaction
   → Calcule Domain Hash + Message Hash
   → Poste dans le canal : 
     "Transaction X: Domain Hash: 0x123..., Message Hash: 0x456..."
   
   ÉTAPE 2: Chaque signataire AVANT de signer
   → Vérifie que le hash affiché sur son wallet = hash posté
   → Si différent = STOP, ne pas signer
   → Confirme dans le canal : "Hash vérifié ✅"
   
   ÉTAPE 3: Signature uniquement après validation collective
   ```

3. **Outils de vérification indépendante à installer :**
   - [OpenZeppelin Safe Utils](https://safeutils.openzeppelin.com/) (web)
   - [safe-tx-hashes-util](https://github.com/pcaversaccio/safe-tx-hashes-util) (CLI)

**Impact :** Protection contre 90% des attaques UI

---

#### 2. Transaction Guards de base
**Objectif :** Ajouter du temps de réaction en cas de transaction malicieuse

**🚀 Mise en œuvre immédiate :**

1. **Installer un Guard avec timelock :**
   ```solidity
   // Règles recommandées :
   - Timelock 6h pour transactions < 1 ETH
   - Timelock 24h pour transactions 1-10 ETH  
   - Timelock 72h pour transactions > 10 ETH
   ```

2. **Procédure d'installation :**
   - Utiliser [Zodiac Delay Modifier](https://github.com/gnosispm/zodiac-modifier-delay)
   - Transaction multisig pour l'installer sur Treasury
   - Tester avec une petite transaction

3. **Avantage :** 
   - Même si 3 signataires sont compromis simultanément
   - 6-72h pour détecter et réagir avant exécution

**Impact :** Filet de sécurité critique

---

#### 3. Simulation et vérification avancée des transactions
**Objectif :** Comprendre les effets réels avant signature

**🚀 Mise en œuvre immédiate :**

1. **Simulation obligatoire :**
   ```
   AVANT signature de TOUTE transaction contractuelle :
   → Utiliser https://tenderly.co/simulator ou Hardhat/Foundry
   → Prévisualiser les changements d'état 
   → Vérifier les transferts, approvals, etc.
   → Poster capture dans le canal avec les hashs
   ```

2. **Décodage calldata systématique :**
   ```
   Pour transactions vers contrats :
   → Utiliser https://www.4byte.directory/ pour les function selectors
   → Décoder TOUS les paramètres avec https://abi.ninja/
   → Vérifier que les paramètres correspondent à l'intention
   → Documenter dans le canal : "Function: transfer(address,uint256)"
   ```

3. **Vérification Operation Type :**
   ```
   RÈGLE CRITIQUE :
   ✅ Operation: 0 (Call) = OK pour la plupart des transactions
   🚨 Operation: 1 (DelegateCall) = DANGER EXTRÊME
   
   Si DelegateCall détecté :
   → Vérifier que le target est un proxy connu et approuvé
   → Double validation par 2 signataires minimum
   → Documentation détaillée du pourquoi
   ```

4. **Paramètres gas refund à zéro :**
   ```
   VÉRIFIER systématiquement :
   - safeTxGas: 0 ✓
   - baseGas: 0 ✓  
   - gasPrice: 0 ✓
   - gasToken: 0x0000000000000000000000000000000000000000 ✓
   - refundReceiver: 0x0000000000000000000000000000000000000000 ✓
   
   Si différent → investigation approfondie avant signature
   ```

**Impact :** Protection contre exploits contractuels sophistiqués

---

#### 4. Plan d'urgence et authentification
**Objectif :** Réaction rapide en cas de compromission

**🚀 Mise en œuvre immédiate :**

1. **Safe word offline établi :**
   ```
   - Choisir une phrase/mot que seuls les vrais signataires connaissent
   - Partagé UNIQUEMENT en personne physique, jamais par digital
   - Utilisé pour authentification en cas de doute
   - Renouvelé tous les 6 mois
   ```

2. **Procédure de compromission :**
   ```
   SI clé potentiellement compromise :
   1. IMMÉDIATEMENT alerter dans canal Signal "COMPROMISSION SUSPECTÉE"
   2. Poster le safe word pour authentification
   3. Bloquer toute signature pendant enquête
   4. Révoquer la clé si compromission confirmée
   5. Rotation d'urgence des autres clés par précaution
   ```

3. **Contacts d'urgence ("Break-the-glass") :**
   ```
   Liste sécurisée contenant :
   - Nom + téléphone + Signal de chaque signataire  
   - Procédure révocation d'urgence
   - Stockée chiffrée, accessible par au moins 2 personnes
   ```

**Impact :** Réduction drastique des dégâts en cas d'attaque

---

### 🟡 IMPORTANTES (3-6 mois)

#### 3. Ségrégation stricte préparation/signature
**Objectif :** Éliminer le single point of failure

**🔧 Plan détaillé :**

1. **Répartition des rôles :**
   ```
   PRÉPARATEUR (1 personne) :
   - Rédige la transaction sur Safe interface
   - Calcule et publie les hashs
   - NE SIGNE PAS sa propre transaction
   
   VALIDATEURS (2+ personnes) :
   - Vérifient indépendamment les hashs  
   - Signent uniquement après validation
   - Utilisent des machines différentes
   ```

2. **Rotation des rôles :**
   - Préparateur change chaque mois
   - Empêche l'habituation et la négligence

3. **Machine dédiée à la préparation :**
   - VM Linux isolée uniquement pour Safe interface
   - Pas d'emails, pas de navigation web

**Impact :** Réduction drastique du risque de compromission totale

---

#### 4. Formation avancée des signataires
**Objectif :** Créer un "human firewall" efficace

**🎓 Programme de formation (4h par signataire) :**

**Module 1 : Reconnaissance des attaques**
- Exemples réels d'interfaces compromises
- Différence entre vrai/faux hash
- Red flags à surveiller

**Module 2 : Outils pratiques**
- Hands-on avec OpenZeppelin Safe Utils
- Calcul manuel des hashs
- Vérification sur hardware wallet

**Module 3 : Simulation d'attaque**
- Exercice : détecter une fausse transaction
- Test sous pression
- Procédure d'escalation

**Module 4 : Processus d'urgence**
- Que faire si hash ne correspond pas
- Comment alerter les autres signataires
- Procédure de révocation d'urgence

**Planning :** 1 session par mois, 1h par session

---

#### 5. OpSec avancé des signataires
**Objectif :** Réduire les vecteurs d'attaque personnels

**🔧 Plan détaillé :**

1. **Anonymat des signataires :**
   ```
   RÈGLES STRICTES :
   - Jamais révéler publiquement qui sont les signataires
   - Pas de mention sur réseaux sociaux, Discord, Twitter
   - Communications uniquement dans canaux privés chiffrés
   - En cas de leak accidentel → rotation immédiate des clés
   ```

2. **Adresses dédiées exclusivement au multisig :**
   ```
   CHAQUE signataire doit :
   - Générer 1 adresse UNIQUEMENT pour Treasury
   - Jamais utiliser cette adresse pour :
     * DeFi (Uniswap, Aave, etc.)
     * NFTs  
     * Autre multisig
     * Transactions personnelles
   - Historique on-chain propre = réduction fingerprinting
   ```

3. **Diversité géographique :**
   ```
   OBJECTIF : Éviter concentration géographique
   - Idéalement : signataires sur 3+ continents
   - Éviter events/conférences groupés
   - Rotation si trop de concentration détectée
   - Considérer timezone spread pour disponibilité
   ```

4. **Mise en place monitoring basique :**
   ```
   ALERTES ESSENTIELLES à implémenter :
   - Changement configuration Safe (seuil, signataires)  
   - Nouvelle transaction proposée
   - Transaction exécutée (succès/échec)
   - Activité suspecte sur adresses signataires
   
   Outils : Tenderly alerts, OZ Defender, custom webhooks
   ```

**Impact :** Réduction significative surface d'attaque personnelle

---

### 🟢 LONG TERME (6-12 mois)

#### 5. Appareils dédiés signature critique
**Objectif :** Isolation malware pour transactions importantes

**💰 Solution économique par étapes :**

1. **Phase 1 - Smartphone dédié** (200€)
   - iPhone ou Android neuf
   - UNIQUEMENT apps crypto : MetaMask, Safe, Ledger Live
   - Jamais d'email, réseaux sociaux, navigation

2. **Phase 2 - Laptop dédié** (500€)
   - Machine uniquement pour crypto
   - Linux minimal (Ubuntu Server + GUI légère)
   - Connexion réseau contrôlée

3. **Phase 3 - Air-gap setup** (pour >100 ETH)
   - Machine complètement offline
   - Transfert par QR codes
   - Cold storage ultime

**Règle :** Appareils dédiés obligatoires pour transactions >50 ETH

---

#### 6. Diversification hardware wallets
**Objectif :** Protection contre exploits vendor-specific

**🔄 Plan de migration :**

1. **Ajouter 1x Trezor Model T** → Mix 2 Ledger + 1 Trezor + 1 Mobile
2. **Évaluer Coldcard** pour signature ultra-froide
3. **Objectif final :** 5 vendors différents pour 5 clés

**Budget :** ~300€ étalés sur 12 mois

---

## 🔍 Métriques et suivi

### Objectifs 6 mois
- **Score cible :** >60/100 (passage en Risque Moyen)
- **Zéro critère à 0/5** dans les 20 critères
- **Processus vérification :** 100% des transactions avec simulation
- **Temps moyen validation :** <30 minutes
- **Safe word :** établi et testé
- **Plan d'urgence :** documenté et connu de tous

### KPIs mensuels
- Transactions avec vérification hors-bande : _%
- Temps de détection d'anomalie simulée : _min
- Participation aux formations : _%

### Audit de suivi
**Date :** Septembre 2026  
**Objectif :** Score >60/100 (Risque Moyen)

---

## 💡 Contexte et justification

### Pourquoi ces recommandations ?

**Exemples d'attaques récentes :**
- **Radiant Capital** : ~50M$ perdus via UI compromise
- **Bybit** : ~1.4B$ via exploitation similaire  

**Notre profil de risque :**
- Treasury probablement >10 ETH
- Signataires techniques mais non experts sécurité
- Utilisation occasionnelle = vigilance réduite

### ROI sécurité
**Coût implémentation :** ~1000€ + 20h de travail  
**Valeur protégée :** XXX ETH  
**ROI :** Quasi-infini si ça évite 1 seule attaque

---

## 🛠️ Ressources techniques

### Outils recommandés

**Vérification de base :**
- [OpenZeppelin Safe Utils](https://safeutils.openzeppelin.com/)
- [safe-tx-hashes-util](https://github.com/pcaversaccio/safe-tx-hashes-util)
- [Safe Transaction Builder](https://help.safe.global/en/articles/234052-transaction-builder)

**Simulation et analyse :**
- [Tenderly Simulator](https://tenderly.co/simulator) - preview effets transactions
- [4byte Directory](https://www.4byte.directory/) - décodage function selectors  
- [ABI Ninja](https://abi.ninja/) - décodage paramètres contrats
- [Etherscan/Polygonscan](https://etherscan.io) - vérification historique

**Guards et sécurité :**
- [Zodiac Delay Modifier](https://github.com/gnosispm/zodiac-modifier-delay)
- [OpenZeppelin Defender](https://defender.openzeppelin.com/) - monitoring alerts

**Communication sécurisée :**
- [Signal](https://signal.org/) avec PIN et messages éphémères

### Documentation
- 🔥 **[1kx Network Self-Assessment Guide](https://1kx.network/writing/self-assessment-multisig-opsec-defending-against-malware-and-ui-exploits)** - Framework d'audit utilisé
- [Safe Guards Documentation](https://docs.safe.global/advanced/smart-account-guards)
- [Rekt.news](https://rekt.news/) pour les post-mortems d'attaques

### Configuration technique actuelle
```yaml
Safe: Treasury
Type: 3/5 multisig
Clés Mat: 2 (concentration de risque)
Clés froides backup: 2
Hardware: 2x Ledger (X + Nano) + 1 mobile
OS: Linux + Windows + Android
Guards: aucun
Processus: basique
```

---

## ⚠️ Avertissements

1. **Aucune sécurité n'est parfaite** - L'objectif est de réduire drastiquement les risques
2. **Vigilance constante requise** - Les processus ne valent que par leur application
3. **Évolution des menaces** - Re-audit tous les 6 mois minimum
4. **Formation continue** - La technologie évolue, les compétences aussi

---

## 📈 Évolution de l'audit

**Version 1** - Audit de base 1kx Network (11 critères)
- Score : 19/55 (34.5%) - Risque Élevé
- Focus : Malware et UI exploits

**Version 2** - Audit complet 1kx + howtomultisig (20 critères)  
- **Score final : 20/100 (20%) - Risque Très Élevé** ⚠️⚠️
- Ajout : Emergency, OpSec signataires, vérification avancée

Cette approche combinée offre la **couverture la plus complète** disponible pour l'audit de sécurité multisig.

---

*🦡 Document généré le 4 février 2026 par Bold Badger*  
*Basé sur l'audit 1kx Network Self-Assessment + howtomultisig.com best practices*