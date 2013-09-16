# forge-cli

Command line interface for creating Forge apps, which are Rails-based applications that come with a host of features
for content management, rapid application development, and improved scaffold generation.

Although the end result of this gem is the creation of a Rails 4 application that you can certainly use as the basis
for a new web application, this gem itself is still alpha quality and is undergoing heavy development.  You can, however,
create production-ready applications with it (and we do all the time).  Documentation is also greatly lacking at this
point.

## Requirements

Ruby 1.9.3 or higher.  Forge is best at creating Rails 4 applications using Ruby 2.0.

## Installation

    gem install forge-cli

## Usage

### Installation And Modules

To create a new Forge site:

    forge new APP_NAME LIST,OF,MODULES

For example:

    forge new app banners,dispatches,ecommerce,events,galleries,posts,subscribers,videos

The gem will display next steps once you've created the application.

Once the app is created, you can see a list of available modules by running:

    forge list

To install a module that is not yet installed, use:

    forge install MODULE_NAME

### Scaffold Generation

Forge comes with an advanced scaffold generation system that makes it extremely simple to create new,
content-managed entities in the administration panel.

To use the scaffold generator, run:

    rails generate forge:scaffold MODEL_NAME LIST_OF_ATTRIBUTES_IN_STANDARD_RAILS_FORMAT

For example:

    rails generate forge:scaffold vehicle title:string description:text image_file_name:string image_file_size:integer image_content_type:string list_order:integer publish_on:timestamp

As well as generating standard text fields as per Rails' normal behaviour, the scaffolder understands the following:

* `ATTRIBUTE_NAME:timestamp` (generates a calendar picker with a time field)
* `title:string` (generates a large text field at the top of the form for the title)
* `ATTRIBUTE_file_name:string, ATTRIBUTE_file_size:integer, ATTRIBUTE_content_type:string` (generates Paperclip-styled attachments that hook into the Asset Library)
* `list_order:integer` (makes the list of items in Forge reorderable using drag & drop)

You can also generate scaffolds for "small" entities, such as post categories, that have a streamlined interface as follows:



## Available Modules

* banners (e.g. for image carousels on a homepage)
* subscribers (subscribe management)
* dispatches (full-fledged newsletter sending system, installs subscribers as well)
* ecommerce (the lack of documentation for this module makes it rather hard to use right now)
* events (including a calendar if you wish)
* galleries (for photos)
* posts (i.e. blogging)
* videos

## Contributing

Contributions are welcome.  Right now the process of contributing is as follows:

1. Fork the gem
2. Use the local copy of the gem to create a new site, e.g: `bin/forge new testapp banners,dispatches`
3. Spin up the new app
4. Work on the new app as you would work on a normal Rails site
5. Copy the changed/new files from the new app into the gem's lib/forge folder.  For example, if you changed
   `app/controllers/application_controller.rb` in your new app, you would copy that into the gem's `lib/forge/app/controllers` folder.
6. Commit your changes and issue a pull request.
