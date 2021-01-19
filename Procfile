web: ./bin/server
worker: ./bin/worker
release: lucky db.rollback_to 20181214214853 && lucky db.migrate && lucky db.seed.required_data && find ./public
