# Blockchain.BigEarth

Blockchain.BigEarth is an open source Bitcoin Block explorer w/ bookmark manager and a BTC/USD exchange rate caclulator built on the [Ruby on Rails](https://github.com/rails/rails) web framework.

It is powered by 3rd party webservice calls and doesn't currently require an full bitcoin node though this could change in the future as the platform grows.

The idea was to make a quality block explorer that could be set up and deployed w/ very minimal work leaving developers cycles to spend on design and extension. 

## Running an instance

1. First clone the repo
  * `git clone https://github.com/cgcardona/blockchain.bigearth.io.git`
2. Change into the new directory
  * `cd blockchain.bigearth.io`
3. Fire up a rails server
  * `rails s`
4. Check out `localhost:3000` to see your very own fully operation instance of Blockchain.BigEarth.

### Bonus points

* Use a prettier URL during development than `localhost:3000` by adding the following to `/etc/hosts` on OS X or Linux
  * `127.0.0.1 local.blockchain.bigearth.io`
  
#### Launch your app on heroku

For this you'll need the [Heroku Toolbelt](https://toolbelt.heroku.com/)

1. Create a new heroku app
  * `heroku create`
2. `git push heroku master`

## Tech Stack 

* [Bootstrap](https://getbootstrap.com/)
* [erb](https://en.wikipedia.org/wiki/ERuby)
* [scss](http://sass-lang.com/)
* [Coffeescript](http://coffeescript.org/)
* [jQuery](https://jquery.com/)
* [lodash](https://lodash.com/)

## Bugs && Issues

Please file any bugs in the [issues tracker](https://github.com/cgcardona/blockchain.bigearth.io/issues). And of course [pull requests](https://github.com/cgcardona/blockchain.bigearth.io/pulls) are always encouraged and welcomed.

### Security

Any and all security issues should be reported immediately to cgcardona [at] gmail [dot] com or [@cgcardona](https://twitter.com/cgcardona).

#### Environment Variables

I'm using [figaro](https://github.com/laserlemon/figaro) to handle all app sensitive information. This includes:

* API tokens
* IP Addresses
* User/Passwords
* Secret Keys 
* Rails secret tokens 

## Miscellaneous
 
* Available under the [MIT Open Source License](LICENSE.md)
* Check out the [wiki](https://github.com/cgcardona/blockchain.bigearth.io/wiki) for the latest docs.
* Latest version can be found in [config/initializers/version.rb](config/initializers/version.rb) and follows [Semantic Versioning](http://semver.org/).
