# Task list
-----

# General

-- Update documentation on used gem plugins--


# Regular app


* Export/Import CSV documentation
* Possible integration with Roo gem for import
    * likely this will be in `lib/import_worksheet.rb` or something similar
* -- change user reg for default active. Have forms for deactivating users. --

## barcodes

* better template export and API
* add referenced object type to views

## taxon

* Nothing

## container types

* --remove autocomplete--
* --switch to selection of proper ontology terms--
* --Make sure that we really can't delete these, only retire!--


## containers

* --remove autocomplete conatiner_type in favor of selection--
* hierachy navigation
* visualizations
    * basically I need to make a table grid and show sample contents.
* tags

## Samples

* --remove taxon autocomplete in favor of selection--
* --tags instead of robust characteristics--
* --container placement-- Needs a bit more from container view
* -- hiearchy visualizations - same as Containers? - needs multiple parents, ancestry gem seems to not have this. -- Changed to using acts-as-dag gem --



## Shipments

* Start it :)
* mailers for sending and receiving

# API

* Integrate oauth provider - doorkeeper
* API using RABL - half-ass implementation at the moment.

