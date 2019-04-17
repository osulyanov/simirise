# README

##  Local development

*   Start the server `docker-compose up`

*   Prepare DB `docker-compose exec app rails db:create db:migrate db:seed`

## Testing

*   Prepare DB `docker-compose exec app rails db:create db:migrate RAILS_ENV=test`

*   Run tests `docker-compose exec app bundle exec rspec spec/`

## Production 

* Create network `docker network create local`

* Run DB `docker run -d --rm --name postgres --network=local -v $(pwd)/postgresql/data:/var/lib/postgresql/data -e POSTGRES_PASSWORD=pgpasswd postgres:10.3-alpine`

* Build App `docker build -t simirise -f prod.Dockerfile .`

* Run App `docker run -d --rm --name simirise --network=local -p 3000:3000 -v $(pwd)/simirise/log:/app/log -v $(pwd)/simirise/rails:/app/rails -e POSTGRES_PASSWORD=pgpasswd simirise/backend`
