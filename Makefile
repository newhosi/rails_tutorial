test:
	bundle exec rspec

server:
	bin/dev

db-exec:
	mysql -u root

db-migrate:
	bin/rails db:migrate

db-create:
	bin/rails db:create

db-rollback:
	bin/rails db:rollback

fmt:
	bundle exec rubocop -A

