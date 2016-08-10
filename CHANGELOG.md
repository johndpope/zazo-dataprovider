# Changelog

### 0.3.2-wip.1
- :bulb: Added new users query `FindByMobile`
- :arrow_up: Fixed docker configuration

### 0.3.2
- :bulb: Refactored `Users::Queries::Attributes` query to get attributes on collection
- :arrow_up: Extended `Users::Queries::Attributes` query to accept `users` array
- :arrow_up: Updated wercker config
- :arrow_up: Bumped `nokogirl` gem

### 0.3.1
- :bulb: Added `ActiveFriends` users query
- :hammer: Refactored `Friends` users query

### 0.3.0
- :bulb: Migrated ZazoFriendFinder API from ZazoStatistics to ZazoDataProvider

### 0.2.1
- :arrow_up: Updated shared subtree (staging settings for database config)
- :bulb: Added staging env config
- :bulb: Added newrelic config

### 0.2.0
- :bulb: Added pagination and recent option for filter queries

### 0.1.5
- :hammer: Fixed after build slack notifier
- :hammer: Changed box owner for wercker deployment

### 0.1.4
- :bulb: Added slack notifier to wercker after-deploy steps

### 0.1.3
- :hammer: Fixed wercker deploy config

### 0.1.2
- :bulb: Added version route
- :bulb: Updated Dockerfile to use cached rubygems

### 0.1.1
- :hammer: Fixed Dockerfile

### 0.1.0
- :bulb: Created ZazoDataProvider service based on ZazoStatistics and ZazoSqsWorker
