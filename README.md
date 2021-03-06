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

To install a module into an existing application use:

    forge install MODULE_NAME

You can see a list of available modules by running:

    forge list

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
* `published:boolean` (creates a 'Published' selector that is only accessible by users with the Admin or Super Admin role)

You can also generate scaffolds for "small" entities, such as post categories, that have a streamlined interface as follows:

    rails generate forge:scaffold_small MODEL_NAME LIST_OF_ATTRIBUTES_IN_STANDARD_RAILS_FORMAT


For either generator it is highly recommended that you include an attribute called "title" as it is relied on in the list views.  If you don't wish to use "title" you can edit the generated views.  This will likely be more customizable in the future.

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


## LICENSE

(The MIT License)

Copyright (c) 2013 factor[e] design initiative

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the 'Software'), to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of
the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
