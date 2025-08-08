🚖 Projet DBT avec DuckDB — Analyse des trajets taxi NYC
📝 Description du projet
Ce projet utilise dbt (Data Build Tool) avec le moteur DuckDB pour transformer, nettoyer et analyser un dataset public des trajets de taxi jaunes à New York.
L’objectif est de produire un modèle de données fiable et testé, prêt pour des analyses approfondies.

📁 Structure du projet
plaintext
Copier
Modifier
Projet_DBT/
│
├── models/
│   ├── taxi_trips/
│   │   ├── sources.yml         # Définition des sources de données 
│   │   ├── transform.sql       # Requête SQL pour transformation des données
│   ├── schema.yml              # Définition des tests de qualité (tests dbt)
│
├── tests/
│   ├── Test_passenger_count.sql  # Tests SQL personnalisés 
│
├── output/                     # Répertoire où peut se trouver la base DuckDB 
│
├── packages.yml                # Dépendances dbt (vide ou avec packages externes)
├── dbt_project.yml             # Configuration principale du projet dbt
├── profiles.yml                # Configuration connexion DuckDB (hors dépôt en général)
├── README.md                   
🔍 Sources des données
Le dataset principal est un fichier Parquet public hébergé à l’URL suivante :
https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet

Il est défini dans models/taxi_trips/sources.yml pour être référencé dans dbt via la fonction source().

🛠️ Technologies utilisées
Technologie	Version utilisée / remarque
dbt-core	1.10.7
dbt-duckdb adapter	1.9.4
DuckDB	v1.9.x
Python	3.9+ (via environnement virtuel)
PowerShell / CLI	Windows PowerShell utilisé pour commandes Git

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
.\venv\Scripts\activate  # Windows PowerShell
# source venv/bin/activate  # macOS/Linux
3. Installer dbt et adapter DuckDB
bash
Copier
Modifier
pip install dbt-core dbt-duckdb
4. Configuration de la connexion DuckDB
Dans le fichier profiles.yml (hors dépôt recommandé pour la sécurité), configurer le profil DuckDB pointant vers la base de données .db ou fichier Parquet.

Exemple minimal pour DuckDB :

yaml
Copier
Modifier
projet_dbt:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: output/transformed_data.db  # ou ':memory:' pour en mémoire
5. Exécuter les modèles dbt
bash
Copier
Modifier
dbt run
6. Lancer les tests dbt pour valider la qualité des données
bash
Copier
Modifier
dbt test
🧩 Modèle de transformation SQL clé (transform.sql)
Nettoyage des données : suppression des trajets sans passagers, distances ou montants valides

Calcul de la durée du trajet en minutes

Transformation du type de paiement numérique en texte (Credit Card, Cash)

✅ Tests et qualité des données
Le projet inclut plusieurs tests dbt :

accepted_values : vérifier que certaines colonnes prennent uniquement des valeurs autorisées (ex. payment_method)

not_null : s’assurer que des colonnes clés ne contiennent pas de valeurs nulles

expression_is_true (tests personnalisés) : valider des règles métier (ex. trip_distance > 0)

🚩 Résolution des erreurs rencontrées
Erreurs liées à des colonnes non trouvées (payment_method absente dans certains tests) : corrigées en ajustant la sélection des colonnes dans les modèles

Macro test_expression_is_true non trouvée : nécessité d’ajouter ou d’importer certains packages ou macros dbt

Configuration des remotes git absente : ajout du remote origin avant de pousser le projet sur GitHub

Gestion des conversions de fin de ligne (LF/CRLF) signalée par Git, mais non bloquante

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
📚 Documentation & liens utiles
Documentation dbt

DuckDB

TLC Taxi Trip Data

dbt testing documentation

👤 Auteur
SMagui
GitHub | Projet DBT taxi NYC - Août 2025
