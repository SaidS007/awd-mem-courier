
Créer `config.json`(à partir de `config.json.default`) et `OpenGSTScript.log` dans :
`/custom/<custom_id>/bin/external/opengst/`

Explications `config.json`
```
{
    "MEM" : {
        "url": "", // URL de l'instance MEM courrier : e.g http://localhost/edissyum/rest/ --> le / après rest est obligatoire
        "username": "", // Nom d'utilisateur de l'utilisateur Web Service
        "password": "", // Mot de passe de l'utilisateur Web Service
        "externalId": "opengst", // Identifiant externe de l'application
        "senderEmail": "contact@edissyum.com" // Adresse email utilisée pour faire partir les emails dans MEM après création d'un report OpenGST
    },
    "OpenGST" : {
        "url": "",  // URL de l'instance OpenGST
        "username": "", // Nom d'utilisateur de l'utilisateur Web Service
        "password": "", // Mot de passe de l'utilisateur Web Service
        "database": "" // Base de données de l'instance OpenGST
    },
    "synchronizeFields": {
        // Le chemin du fichier CSV permet de remplir la BDD contenant les correspondances entre les types de documents MEM et OpenGST
        // Il est composé de plusieurs lignes, où les données sont séparées par des #
        // Exemple : "Type de document MEM # Entité Open GST # Modèle OpenGST"
        "file_path": "/var/share/opengst/services.csv"
    },
    "sendToOpenGSTRequest": { // Construction de la requête pour récupérer les demandes MEM à envoyer à OpenGST 
        "select": "res_id, subject, creation_date at time zone 'cest' at time zone 'utc' as creation_date, custom_fields, external_id, typist, alt_identifier",
        "clause": [
            {
                "where": "status IN (?)",
                "data": "NEW"
            },
            {
                "where": "custom_fields #>> '{110}' <> ''",
                "data": ""
            },
            {
                "where": "custom_fields #>> '{110}' NOT ILIKE '%(nosync)%'",
                "data": ""
            },
            {
                "where": "custom_fields #>> '{100}' <> ''",
                "data": ""
            },
            {
                "where": "external_id ->> 'opengst' IS NULL",
                "data": ""
            }
        ]
    },
    "customFields": { // Identifiant des champs personnalisés MEM liés à OpenGST
        "type": ,
        "channel": ,
        "priority": ,
        "quartier": ,
        "domaine": ,
        "adresse": ,
        "infos": ,
        "status_demande": ,
        "status_intervention": 5,
        "motif_refus": ,
        "objet": 
    },
    "mapping" : {
        "status" : [
            {
                "MEM" : "0_DRAFT",
                "OpenGST" : "draft"
            }
        ],
        "channels" : [
            {
                "MEM": "TELEPHONE",
                "OpenGST": "5",
                "sendEmail": true
            }
        ]
    }
}
```


Les demandes OpenGST sont mappé sur les entités présentes dans leur nom.  
Par exemple "ST - Voirie-Proprete" => Assigné à entité ST (Service Technique).