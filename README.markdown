# Data Engineering Challenge
This is an attempt at cracking the data challenge presented by [LivingSocial](http://corporate.livingsocial.com/careersoverview). The original readme, including a good description of the challenge can be found [here](https://github.com/lschallenges/data-engineering/blob/master/README.markdown).

[![Build Status](https://secure.travis-ci.org/arnab/data-engineering.png?branch=master)](http://travis-ci.org/arnab/data-engineering)

[![Dependency Status](https://gemnasium.com/arnab/data-engineering.png)](https://gemnasium.com/arnab/data-engineering)

# Description
My attempt uses Rails and a RESTfult style for the various interactions. See the thoughts section below for an idea of how (and why) the code is organized.

# Links
1. Live demo, using [heroku](http://www.heroku.com), at [http://arnab-ls-data-challenge.herokuapp.com/](http://arnab-ls-data-challenge.herokuapp.com/)
1. Note that importing files requires a sign in/up.
1. Backlog and stories, using [Pivotal Tracker](https://www.pivotaltracker.com), at [https://www.pivotaltracker.com/projects/507765](https://www.pivotaltracker.com/projects/507765)
1. Continuous integration, using [travis.ci](http://travis-ci.org), at [http://travis-ci.org/arnab/data-engineering](http://travis-ci.org/arnab/data-engineering)

# Getting started
1. Get [rvm](http://beginrescueend.com/) if you don't already have it.
1. Install Ruby 1.9 inside rvm: `rvm install 1.9.2`. This package works with Ruby 1.9.2+ (or rubinius in 1.9 mode).
1. Create a gemset under Ruby 1.9: `rvm gemset create <name> && rvm use 1.9.2@<name>`
1. `bundle install`
1. Typical rails (rake will run tests, rails s will run the server etc. etc.).

# Thoughts
This is a Rails app built using a RESTful model when it comes to interacting with the app. If you know Rails the following will be a breeze. Otherwise, a little brushing up on REST and Rails will be awesome!

## Entities

### Resources
Most of the interaction the user does is with the DataFile resource. That's what they see as the GET as the new form (in which to upload a data file) and POST it back to the server. The DataFile model is not persisted but it does follow a ActiveModel interface. This resource manages the persisted data indirectly (through the persisted, ActiveRecord backed models).

### Data modeling and normalization
Looking at the [example input](https://raw.github.com/lschallenges/data-engineering/master/example_input.tab) and the main requirement (normalize, persist and show the gross revenue represented by the uploaded file) the most natural normalized data models that come to mind are:

#### Option A) Deals and Purchases
  * Deals: merchant name, merchant address, deal description, price
  * Purchase: purchaser name, quantity purchased
  * Relations: A Deal has many Purchases and a Purchase belongs to a Deal

#### Option B) Merchants, Deals, Purchasers and Purchases
  * Merchant
  * Deal
  * Purchaser
  * Purchase
  * Relations: A Merchant has many Deals; A Deal has many Purchases; A Purchase belongs to a Purchaser; A Purchaser has many Purchases.

#### Comparison & Conclusion
Option A is simpler while B is naturally more normalized (no duplication of merchants and purchasers). Both can answer with ease, apart from the main requirement (calculating the gross), questions such as:

  * What is LivingSocial's total revenue from this merchant? Option A can be used to find the merchant by name in the Deal table, find all of it's purchases and multiply the quantity by the price. Option B will yield: merchant.deals.map(price) * merchant.deals.purchases.map(quantity)

  * How many times has this customer bought from LivingSocial? Similar to above, in option A you start by querying the purchases model.

The normalization of option B) can easily fall apart with scale though (and obviously Option A scales even less): think about merchants having different locations and now we need to normalize the merchant table further into merchants and merchant_locations. I am not going to attempt to trivialize the data model LivingSocial probably by trying to come up with the most normalized form here, and am instead going to concentrate on simplicity, retaining just enough complexity to be able to easily solve the given requirements (and a few others that I dreamed up above). Hence, my choice at this point is Option A.

## File format validations
Although it's mentioned that I can assume the file's columns to always remain in the same order and that all the fields will be present, for the sake of completeness I added validations to my models. In doing so, I saw that it was easy enough to make the fields order-independent and thus much more flexible for end-users. Technically, it goes beyond the requirements, but I hope that's ok. Take a look at the cucumber features for examples of such validations.

# TODOs
Like any project, this is work in progress. As can be seen in the [Pivotal Tracker backlog](https://www.pivotaltracker.com/projects/507765) here are a few things that can be done:

## Redirect-After-Post
Right now the POST of the file renders the view. This can confuse users if they try to refresh (as it's a form POST the browser shows a warning). We can do a redirect, but to where is an interesting question. We'd probably need either a index page for our deals.

## Huge files
Right now, everything is done in the HTTP request. Meaning the experience will be bad if the file is huge. The first step will be using something like pjax/ajax. Eventually the file should be processed asynchronously: using something like background-job or resque (or perhaps SQS messages that talk to the processing apps that are running separately). But then again, we don't want to prematurely optimize.

## Code refractor
Eventually the DataFile model has become kind of big. Perhaps we should create a separate DataFileLine class and have that hold one Deal and one Purchase and the DataFile model holing a collection of DataFileLines. Just an idea.