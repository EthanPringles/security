# 📋 Template Vérification Transaction

## Message type pour le canal Treasury-Verification

```
🔍 TRANSACTION VERIFICATION

📄 Description: [Envoi 0.5 ETH vers 0x123...abc]
💰 Montant: [0.5 ETH]  
🎯 Destinataire: [0x123...abc]
⛽ Gas: [~25 gwei]

🔑 HASHES:
• Domain Hash: 0x1234567890abcdef...
• Message Hash: 0xabcdef1234567890...

🛠️ Calculé avec: [OpenZeppelin Safe Utils / CLI]
📅 Date: [2026-02-04 15:30 UTC]

⚠️ À VÉRIFIER sur votre wallet avant signature
✅ Confirmez ci-dessous une fois vérifié
```

## Réponses attendues

```
✅ [Pseudo]: Hash vérifié, correspond
❌ [Pseudo]: Hash différent - STOP
🤔 [Pseudo]: Problème technique, aide needed
```

## 🚨 Si hash ne correspond pas

```
🛑 ALERTE SÉCURITÉ

❌ Hash ne correspond pas sur mon wallet:
• Attendu: 0x1234...
• Affiché: 0x5678...

🔍 Device: [Ledger X / Android / etc.]
⏰ Heure: [timestamp]

🚨 RECOMMANDATION: Personne ne signe tant qu'on n'a pas élucidé
```

---

*Template à adapter selon les transactions*