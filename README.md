# Collection of Samples (CollOS)

--------------------------------

This Rails application is a light-weight LIMS that seeks to provide a solution for as low-friction as possible biomaterial tracking and annotation. The domain problem does not leave you much room to be completely frictionless, but we strive to minimize busy work and maximize utility.

The site itself has documentation on usage, refer to `Help` page. This document is mainly concerned about the underlying engineering of the site.

For the labeling, we modified and minimalised the SPS labeling system by Vitale et al.

### Compatibility

* Linux
* Mac OS
* Windows (not tested)

### Technologies

The site depends on two core technologies:

* [Rails 3](http://rubyonrails.org/)
* [PostgreSQL](http://www.postgresql.org/)
* [Redis server](http://redis.io/)
* [Zint for barcodes](https://zint.github.io/)

### Installation (TBU)

Instructions for CentOS setup:

```bash
yum install postgresql93-server
#install redis-server
rvm install ruby-1.9.3-p448
gem install rails
```

Like you would any other Rails application.

```
cd $RAILS_ROOT
bundle
```

Make sure Apache, Postgres, Redis-server and Rails-server are running.

```
service httpd start
service postgresql-9.3 start
service redis_6379 start
rails server --port 3001 -d
```

### Environment configuration

We use the [configulations gem](https://github.com/leongersing/configulations) as a simple method of passing environment variables to the application.

### Authentication

Authentication is handled using the Oauth 2 protocal, via [OmniAuth gem](https://github.com/intridea/omniauth/wiki) and the [omniauth-basecamp](https://github.com/Verano/omniauth-basecamp) strategy.

### Authorization

Authorization uses the [CanCan](https://github.com/ryanb/cancan) gem.

### Background Processing

Background processing is accomplished using [Sidekiq](http://sidekiq.org/)

You can see the processing queue and other Sidekiq information in the dashboard at `root_url()/sidekiq`. __Note:__ you need to be logged in first.

### PostgreSQL and Full Text Search

We are taking advantage of PostgreSQL's native full-text-search capabilities, by using the [pg_search gem](https://github.com/Casecommons/pg_search).

### Doorkeeper

We use [Doorkeeper](https://github.com/doorkeeper-gem/doorkeeper) as an oauth provider for the application.

### Ancestry

Ancestry is handled with [ancestry](https://github.com/stefankroes/ancestry) and [acts-as-dag](https://github.com/mleventi/acts-as-dag).

### Auditing

We use [paper_trail](https://github.com/airblade/paper_trail) to track the changes to the models' data.

### Contributors

- Dimitra Sarantopoulou
- Anand Srinivasan
- Angel Pizarro

### License

Under MIT License
