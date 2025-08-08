🚖 Projet DBT avec DuckDB — Analyse des trajets taxi NYC
📝 Description du projet
Ce projet utilise dbt (Data Build Tool) avec le moteur DuckDB pour transformer, nettoyer et analyser un dataset public des trajets de taxi jaunes à New York.
L'objectif est de produire un modèle de données fiable et testé, prêt pour des analyses approfondies.

📁 Structure du projet
graphql
Copier
Modifier
Projet_DBT/
│
├── models/
│   ├── taxi_trips/
│   │   ├── sources.yml           # Définition des sources de données
│   │   ├── transform.sql         # Requête SQL pour transformation des données
│   ├── schema.yml                # Définition des tests de qualité (dbt tests)
│
├── tests/
│   ├── Test_passenger_count.sql  # Tests SQL personnalisés (optionnel)
│
├── output/                      # Répertoire pour base DuckDB ou résultats
│
├── packages.yml                 # Dépendances dbt (peut être vide)
├── dbt_project.yml              # Configuration principale du projet dbt
├── profiles.yml                 # Configuration de connexion DuckDB (généralement ignoré par git)
├── README.md                   # Ce fichier
🔍 Sources des données
Dataset principal :
https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet

Défini dans models/taxi_trips/sources.yml et référencé via la fonction source() dans dbt.

🛠️ Technologies utilisées
Technologie	Version / Remarque
dbt-core	1.10.7
dbt-duckdb adapter	1.9.4
DuckDB	v1.9.x
Python	3.9+ (environnement virtuel conseillé)
PowerShell / CLI	Windows PowerShell utilisé pour Git

⚙️ Installation & utilisation
1. Cloner le dépôt
bash
Copier
Modifier
git clone https://github.com/SMagui/Projet_DBT.git
cd Projet_DBT/Projet_DBT
2. Créer et activer l’environnement virtuel Python
bash
Copier
Modifier
python -m venv venv
.\venv\Scripts\activate    # Windows PowerShell
# source venv/bin/activate  # macOS / Linux
3. Installer dbt et l’adaptateur DuckDB
bash
Copier
Modifier
pip install dbt-core dbt-duckdb
4. Configurer la connexion DuckDB
Dans le fichier profiles.yml (hors dépôt git recommandé pour la sécurité), configurez le profil dbt :

yaml
Copier
Modifier
projet_dbt:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: output/transformed_data.db  # ou ':memory:' pour base en mémoire
5. Lancer la transformation
bash
Copier
Modifier
dbt run
6. Lancer les tests de qualité
bash
Copier
Modifier
dbt test
🧩 Modèle de transformation clé (transform.sql)
Nettoyage des données (exclusion des trajets avec passagers, distance ou montant invalides)

Calcul de la durée du trajet en minutes

Conversion des codes numériques de paiement en labels (ex. Credit Card, Cash)

✅ Tests et qualité des données
Les tests inclus :

accepted_values : vérifie que certaines colonnes ont uniquement des valeurs autorisées (payment_method, passenger_count)

not_null : vérifie l’absence de valeurs nulles sur des colonnes critiques

expression_is_true (tests personnalisés) : valide des contraintes métier (trip_distance > 0)

🚩 Résolution des erreurs rencontrées
Erreurs dues à l’absence de colonnes (payment_method) dans certains tests : corrigées en ajustant les modèles

Macro test_expression_is_true non trouvée : nécessité d’ajouter les macros ou packages manquants

Configuration du remote Git absente initialement : ajout de origin avant de pousser sur GitHub

Avertissements LF/CRLF signalés par Git, non bloquants

💻 Commandes Git pour mise en ligne
bash
Copier
Modifier
git init
git add .
git commit -m "Initial commit projet DBT taxi NYC"
git remote add origin https://github.com/SMagui/Projet_DBT.git
git branch -M main
git push -u origin main
📚 Documentation et liens utiles
Documentation dbt

Documentation DuckDB

Données TLC Taxi NYC

Documentation des tests dbt

👤 Auteur
SMagui
GitHub | Projet DBT taxi NYC - Août 2025
