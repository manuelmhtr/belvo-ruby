<h1 align="center">Belvo Ruby Gem</h1>
<p align="center">
    <a href="https://rubygems.org/gems/belvo"><img alt="Rubygems.org" src="https://img.shields.io/gem/v/belvo?style=for-the-badge"></a>
    <a href="https://travis-ci.com/belvo-finance/belvo-ruby"><img alt="Travis (.com)" src="https://img.shields.io/travis/com/belvo-finance/belvo-ruby/master?style=for-the-badge"></a>
    <a href="https://coveralls.io/github/belvo-finance/belvo-ruby"><img alt="Coveralls github" src="https://img.shields.io/coveralls/github/belvo-finance/belvo-ruby?style=for-the-badge"></a>
    <a href="https://codeclimate.com/github/belvo-finance/belvo-ruby"><img alt="CodeClimate maintainability" src="https://img.shields.io/codeclimate/maintainability/belvo-finance/belvo-ruby?style=for-the-badge"></a>
</p>

## 📕 Documentation
How to use `belvo-ruby`: https://belvo-finance.github.io/belvo-ruby/

If you want to check the full documentation about Belvo API: https://docs.belvo.co

Or if you want to more information about:
* [Getting Belvo API keys](https://developers.belvo.com/docs/get-your-belvo-api-keys)
* [Using Connect Widget](https://developers.belvo.com/docs/connect-widget)
* [Testing in sandbox](https://developers.belvo.com/docs/test-in-sandbox)
* [Using webhooks and recurrent links](https://developers.belvo.com/docs/webhooks)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'belvo'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install belvo

## Usage

```ruby
require 'belvo'

belvo = Belvo::Client.new(
  'af6e69ff-43fa-4e10-8d90-3d217309a1e5',
  'gdi64m68Lc6xUjIKN3aJF2fZd51wD36lTjGVyJO5xQBfL7PRsgFef-ADXBxIhUnd',
  'https://sandbox.belvo.co'
)

begin
  new_link = belvo.links.register(
    institution: 'banamex_mx_retail', 
    username: 'janedoe', 
    password: 'super-secret'
  )

  belvo.accounts.retrieve(link: new_link['id'])

  puts belvo.accounts.list
rescue Belvo::RequestError => e
  puts e.status_code
  puts e.detail
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/belvo-finance/belvo-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/belvo-finance/belvo-ruby/blob/master/CODE_OF_CONDUCT.md).


## Code of Conduct

Everyone interacting in the Belvo project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/belvo-finance/belvo-ruby/blob/master/CODE_OF_CONDUCT.md).
