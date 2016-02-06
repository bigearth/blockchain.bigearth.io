# Blockchain 

Blockchain by Big Earth is a Bitcoin Block explorer built on the [Ruby on Rails](https://github.com/rails/rails) web framework.

## Tech Stack 

* [Bootstrap](https://getbootstrap.com/)
* [erb](https://en.wikipedia.org/wiki/ERuby)
* [scss](http://sass-lang.com/)
* [Coffeescript](http://coffeescript.org/)
* [jQuery](https://jquery.com/)
* [lodash](https://lodash.com/)

It is powered by 3rd party webservice calls and doesn't currently require an full bitcoin node though this could change in the future as the platform grows.

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
