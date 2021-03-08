# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

- Redis running on production server.
- Sidekiq service defined in `/lib/systemd/system/sidekiq-optologs.service`. Enabled and started on production server.
- Rake task `fix_unconfigured_logs` manually added to crontab on production server because it didn't seem to work using the Whenever gem.