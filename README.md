# Collection of Samples (CollOS)

--------------------------------

This site is a light-weight LIMS that seeks to provide a solution for as low-friction as possible biomaterial tracking and annotation. The domain problem does not leave you much room to be completely frictionless, but we strive to minimize busy work and maximize utility.

The site itself has documentation on usage, refer to the `About` and `Help` pages. This document is mainly concerned about the underlying engineering of the site.


## Technologies

The site depends on two core technologies:

* Rails 3
* PostgreSQL

In particular we are taking advantage of PostgreSQL's native full-text-search capabilities. The Rails engines and plugins are itemized in the Gemfile. Both are discussed below.


## PostgreSQL and Full Text Search

TODO: finish this section

## Major Rails Functionality

There are several major subsystems in CollOS. They are described below.

### Environment configuration

### Authentication

### Authorization

### Background Processing

