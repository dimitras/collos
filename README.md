# Collection of Samples (CollOS)

--------------------------------

This site is a light-weight LIMS that seeks to provide a solution for as low-friction as possible biomaterial tracking and annotation. The domain problem does not leave you much room to be completely frictionless, but we strive to minimize busy work and maximize utility.

The site itself has documentation on usage, refer to the `About` and `Help` pages. This document is mainly concerned about the underlying engineering of the site.


## Technologies

The site depends on two core technologies:

* [Rails 3](http://rubyonrails.org/)
* [PostgreSQL](http://www.postgresql.org/)
* [redis](http://redis.io/)
* [GraphViz](http://www.graphviz.org/)
* zint


```bash
brew install postgresql 
# Follow the postgresql setup instructions
brew install graphviz
brew install zint
````


In particular we are taking advantage of PostgreSQL's native full-text-search capabilities. The Rails engines and plugins are itemized in the Gemfile. Both are discussed below.


## Major Application Functionality

There are several major subsystems in CollOS. They are described below.

### Environment configuration

We use the [configulations gem](https://github.com/leongersing/configulations) as a simple method of passing environment variables to the application.

### Authentication

Authentication is handled using the Oauth 2 protocal, via [OmniAuth gem](https://github.com/intridea/omniauth/wiki) and the [omniauth-basecamp](https://github.com/Verano/omniauth-basecamp) strategy.

### Authorization

Authorization uses the [CanCan](https://github.com/ryanb/cancan) gem.

### Background Processing

Background processing is accomplished using [Sidekiq](http://sidekiq.org/)

You can see the processing queue and other Sidekiq information in the dashboard at `root_url()/sidekiq`. __Note:__ you need to be logged in first.

You can find more information about the Sidekiq workers and how to deploy them at [the background processing page](doc/background_processing.md)

## PostgreSQL and Full Text Search

TODO: finish this section

## INSTALL

Like you would any other Rails application.

```
cd $RAILS_ROOT
bundle
```

Then make sure Postgres and redis are running, etc.


## Rails Plugins

We use a few rails plugins in this app

## Doorkeeper

## Ancestry

## License
Under MIT License
