# 🔐 Audit Sécurité Multisig - Safe "Treasury"

**Date :** 4 février 2026  
**Évaluateur :** Mat (Mathieu Gorichon)  
**Safe :** Treasury (configuration 3/5)  
**Score global :** 19/55 (34.5%) - **RISQUE ÉLEVÉ** ⚠️

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
- **Score global :** >35/55 (63%)
- **Zéro critère à 0/5**
- **Processus vérification :** 100% des transactions
- **Temps moyen validation :** <30 minutes

### KPIs mensuels
- Transactions avec vérification hors-bande : _%
- Temps de détection d'anomalie simulée : _min
- Participation aux formations : _%

### Audit de suivi
**Date :** Septembre 2026  
**Objectif :** Score >40/55 (Risque Moyen)

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
- [OpenZeppelin Safe Utils](https://safeutils.openzeppelin.com/)
- [safe-tx-hashes-util](https://github.com/pcaversaccio/safe-tx-hashes-util)
- [Zodiac Delay Modifier](https://github.com/gnosispm/zodiac-modifier-delay)
- [Safe Transaction Builder](https://help.safe.global/en/articles/234052-transaction-builder)

### Documentation
- [1kx Network Audit Guide](https://1kx.network/writing/self-assessment-multisig-opsec-defending-against-malware-and-ui-exploits)
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

*🦡 Document généré le 4 février 2026 par Bold Badger*  
*Basé sur l'audit 1kx Network Self-Assessment*