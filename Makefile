test:
	bundle exec rspec

server:
	bin/dev

db-migrate:
	bin/rails db:migrate

db-create:
	bin/rails db:create

fmt:
	bundle exec rubocop -A
