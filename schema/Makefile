DB_NAME = soong

schema:
	mysql $(DB_NAME) < schema.sql
	mysql $(DB_NAME) < default_data.sql

er:
	mysqldump --no-data $(DB_NAME) > /tmp/$(DB_NAME)
	sqlt-graph --color -f MySQL -o schema.png /tmp/$(DB_NAME)
	rm /tmp/$(DB_NAME)
