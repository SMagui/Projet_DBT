🚖 1 # Projet DBT avec DuckDB — Analyse des trajets taxi NYC
   2
   3 ## Description du projet
   4
   5 Ce projet utilise dbt (Data Build Tool) avec le moteur DuckDB pour transformer, nettoyer et
     analyser un ensemble de données public des trajets de taxi jaunes à New York. L'objectif est de
     construire un modèle de données fiable et testé, prêt pour des analyses approfondies et la
     création de tableaux de bord.
   6
   7 Nous appliquons des transformations complexes, des filtres rigoureux et des tests de qualité des
     données pour garantir l'intégrité et la pertinence des informations.
   8
   9 ## Structure du projet
  Projet_DBT/
  ├── models/
  │   ├── taxi_trips/
  │   │   ├── sources.yml       # Définition des sources de données brutes
  │   │   └── transform.sql     # Logique de transformation et de nettoyage des données
  │   └── schema.yml            # Définition des tests de qualité des données (dbt tests génériques)
  ├── tests/
  │   ├── Test_passenger_count.sql # Test SQL personnalisé pour la colonne passenger_count
  │   └── Test_disctint_months.sql # Test SQL personnalisé pour vérifier les mois distincts
  ├── output/                   # Répertoire pour la base de données DuckDB transformée
  ├── dbt_packages/             # Dépendances dbt installées (généré par dbt deps)
  ├── packages.yml              # Définition des paquets dbt externes
  ├── dbt_project.yml           # Configuration principale du projet dbt
  ├── profiles.yml              # Configuration de connexion DuckDB (à adapter localement)
  └── README.md                 # Ce fichier de documentation

    1
    2 ## Sources des données
    3
    4 Le dataset principal utilisé est un fichier Parquet des données de trajets de taxi jaunes de New
      York pour janvier 2024 :
    5
    6 *   **Dataset :** `yellow_tripdata_2024-01.parquet`
    7 *   **Lien :** `https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet`
    8
    9 Ce dataset est défini dans `models/taxi_trips/sources.yml` et référencé dans les modèles dbt via
      la fonction `{{ source('taxi_trips', 'row_yellow_tripdata') }}`.
   10
   11 ## ️ Technologies utilisées
   12
   13 | Technologie             | Version / Remarque                     |
   14 | :----------------------- | :------------------------------------- |
   15 | `dbt-core`               | 1.10.7                                 |
   16 | `dbt-duckdb` adapter     | 1.9.4                                  |
   17 | `DuckDB`                 | v1.9.x                                 |
   18 | `Python`                 | 3.9+ (environnement virtuel conseillé) |
   19 | `dbt-labs/dbt_utils`     | 1.1.1 (pour les macros utilitaires)    |
   20 | `metaplane/dbt_expectations` | 0.10.8 (pour les tests de données avancés) |
   21 | `godatadriven/dbt_date`  | 0.16.1 (pour les fonctions de date)    |
   22
   23 ## ⚙️ Installation et utilisation
   24
   25 1.  **Cloner le dépôt**
      git clone https://github.com/SMagui/Projet_DBT.git
      cd Projet_DBT/Projet_DBT
   1
   2 2.  **Créer et activer l'environnement virtuel Python**
      python -m venv venv
      .\venv\Scripts\activate # Pour Windows PowerShell
  source venv/bin/activate # Pour macOS / Linux / Git Bash
   1
   2 3.  **Installer dbt et les adaptateurs nécessaires**
      pip install dbt-core dbt-duckdb

   1
   2 4.  **Configurer la connexion DuckDB**
   3
   4     Assurez-vous que votre fichier `profiles.yml` (situé à la racine du projet) est configuré
     comme suit pour la connexion DuckDB. Ce fichier définit comment dbt se connecte à votre base de
     données.
      DBT_Projet:
        target: dev
        outputs:
          dev:
            type: duckdb
            path: output/transformed_data.db # La base de données sera stockée ici
  ou utilisez ':memory:' pour une base en mémoire (non persistante)

   1
   2 5.  **Installer les dépendances dbt**
   3
   4     Les paquets externes sont définis dans `packages.yml`. Installez-les avec :
      dbt deps

   1
   2 6.  **Lancer la transformation des données**
   3
   4     Cette commande exécute le modèle `transform.sql` et crée la vue dans votre base de données
     DuckDB.
      dbt run
   1
   2 7.  **Lancer les tests de qualité des données**
   3
   4     Cette commande exécute tous les tests définis dans `schema.yml` et les tests SQL
     personnalisés.
      dbt test

    1
    2 ## Modèle de transformation clé (`transform.sql`)
    3
    4 Le modèle `transform.sql` effectue les opérations suivantes :
    5
    6 *   **Sélection initiale :** Sélectionne toutes les colonnes de la source
      `taxi_trips.row_yellow_tripdata`, en excluant `VendorID` et `RatecodeID`.
    7 *   **Filtrage des données (`filtered_data` CTE) :**
    8     *   Exclut les trajets avec `passenger_count` <= 0, `trip_distance` <= 0, `total_amount` <=
      0.
    9     *   Corrige les trajets où l'heure de dépose est antérieure à l'heure de prise en charge (
      `tpep_dropoff_datetime > tpep_pickup_datetime`).
   10     *   Filtre les trajets avec `store_and_fwd_flag = 'N'` (pas de stockage et transfert).
   11     *   Exclut les `tip_amount` négatifs.
   12     *   Limite les `payment_type` aux valeurs 1 (Credit Card) et 2 (Cash).
   13 *   **Transformations (`transformed_data` CTE) :**
   14     *   Convertit `passenger_count` en `BIGINT`.
   15     *   Mappe `payment_type` numérique à `payment_method` textuel (`Credit Card`, `Cash`).
   16     *   Calcule `trip_duration_minutes` en utilisant `DATE_DIFF` entre les heures de prise en
      charge et de dépose.
   17     *   Exclut les colonnes originales `passenger_count` et `payment_type` après transformation.
   18 *   **Filtrage final par date (`final_data` CTE) :**
   19     *   Convertit les horodatages de prise en charge et de dépose en dates (`pickup_date`,
      `dropoff_date`).
   20     *   Filtre les trajets pour l'année 2024 (`pickup_date` et `dropoff_date` entre '2024-01-01'
      et '2025-01-01').
   21 *   **Sélection finale :** Exclut les colonnes `pickup_date` et `dropoff_date` temporaires et ne
      conserve que les trajets avec `trip_duration_minutes` > 0.
   22
   23 ## ✅ Tests et qualité des données
   24
   25 Le projet inclut une suite de tests pour assurer la qualité et la cohérence des données
      transformées :
   26
   27 *   **Tests génériques (définis dans `schema.yml`) :**
   28     *   `not_null` : Vérifie l'absence de valeurs nulles sur des colonnes critiques (
      `tpep_pickup_datetime`, `tpep_dropoff_datetime`, `passenger_count`, `trip_distance`,
      `total_amount`, `payment_method`, `trip_duration_minutes`, `store_and_fwd_flag`, `tip_amount`).
   29     *   `accepted_values` : Vérifie que `passenger_count` est entre 1 et 6, et que
      `payment_method` est 'Credit Card' ou 'Cash'.
   30     *   `dbt_utils.expression_is_true` : S'assure que `tpep_dropoff_datetime` est toujours
      postérieur à `tpep_pickup_datetime`.
   31     *   `dbt_expectations.expression_is_true` : Valide des contraintes métier comme
      `trip_distance >= 0`, `total_amount >= 0`, et `trip_duration_minutes >= 0`.
   32
   33 *   **Tests SQL personnalisés (définis dans le dossier `tests/`) :**
   34     *   `Test_passenger_count.sql` : Vérifie les cas où `passenger_count` est invalide (<= 0 ou
      non entier).
   35     *   `Test_disctint_months.sql` : S'assure que les données couvrent les 12 mois de l'année
      (peut échouer si le dataset source est limité à un seul mois).
   36
   37 ## Commandes Git pour mise en ligne
   38
   39 Pour pousser ce projet sur un nouveau dépôt GitHub :
  Assurez-vous d'être dans le répertoire racine du projet (Projet_DBT)
  cd C:\Users\smagu\Projet_DBT\Projet_DBT

  git init                                    # Initialise un nouveau dépôt Git local
  git add .                                   # Ajoute tous les fichiers au staging area
  git commit -m "Initial commit: Projet DBT taxi NYC" # Crée le premier commit
  git branch -M main                          # Renomme la branche principale en 'main'
  git remote add origin https://github.com/VOTRE_NOM_UTILISATEUR/NOM_DU_DEPOT.git # Remplacez par votre URL
  de dépôt
  git push -u origin main                     # Pousse le projet vers GitHub

    1
    2 ## Documentation et liens utiles
    3
    4 *   [Documentation dbt](https://docs.getdbt.com/docs/introduction)
    5 *   [Documentation DuckDB](https://duckdb.org/docs/)
    6 *   [Données TLC Taxi NYC](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)
    7 *   [Documentation des tests dbt](https://docs.getdbt.com/docs/build/data-tests)
    8 *   [dbt_utils package](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/)
    9 *   [dbt_expectations package](https://hub.getdbt.com/metaplane/dbt_expectations/latest/)
   10
   11 ---
   12
   13 **Auteur :** SMagui
   14 **Projet :** DBT taxi NYC - Août 2025

