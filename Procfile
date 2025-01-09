web: bundle exec puma -C config/puma.rb
release: bundle exec rails db:migrate
clock: bundle exec whenever --update-crontab --set environment=$RAILS_ENV