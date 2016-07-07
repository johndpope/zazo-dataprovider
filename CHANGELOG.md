# Changelog

### next release
- :bulb: Extended `Users::Queries::Attributes` query to accept `users` array

### v0.3.1
- :bulb: Added `ActiveFriends` users query
- :hammer: Refactored `Friends` users query

### v0.3.0
- :bulb: Migrated ZazoFriendFinder API from ZazoStatistics to ZazoDataProvider

### v0.2.1
- :arrow_up: Updated shared subtree (staging settings for database config)
- :bulb: Added staging env config
- :bulb: Added newrelic config

### v0.2.0
- :bulb: Added pagination and recent option for filter queries

### v0.1.5
- :hammer: Fixed after build slack notifier
- :hammer: Changed box owner for wercker deployment

### v0.1.4
- :bulb: Added slack notifier to wercker after-deploy steps

### v0.1.3
- :hammer: Fixed wercker deploy config

### v0.1.2
- :bulb: Added version route
- :bulb: Updated Dockerfile to use cached rubygems

### v0.1.1
- :hammer: Fixed Dockerfile

### v0.1.0
- :bulb: Created ZazoDataProvider service based on ZazoStatistics and ZazoSqsWorker
