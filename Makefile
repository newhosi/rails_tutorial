test:
	bundle exec rspec

server:
	bin/dev

db-exec:
	mysql -u root -D sample_app_development

db-migrate:
	bin/rails db:migrate

db-create:
	bin/rails db:create

db-rollback:
	bin/rails db:rollback

fmt:
	bundle exec rubocop -A

