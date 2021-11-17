<h1 align="center">Belvo Ruby Gem</h1>
<p align="center">
    <a href="https://rubygems.org/gems/belvo"><img alt="Rubygems.org" src="https://img.shields.io/gem/v/belvo?style=for-the-badge"></a>
    <a href="https://app.circleci.com/pipelines/github/belvo-finance/belvo-ruby"><img alt="CircleCI (.com)" src="https://img.shields.io/travis/com/belvo-finance/belvo-ruby/master?style=for-the-badge"></a>
    <a href="https://coveralls.io/github/belvo-finance/belvo-ruby"><img alt="Coveralls github" src="https://img.shields.io/coveralls/github/belvo-finance/belvo-ruby?style=for-the-badge"></a>
    <a href="https://codeclimate.com/github/belvo-finance/belvo-ruby"><img alt="CodeClimate maintainability" src="https://img.shields.io/codeclimate/maintainability/belvo-finance/belvo-ruby?style=for-the-badge"></a>
</p>

## 📕 Documentation
How to use `belvo-ruby`: https://belvo-finance.github.io/belvo-ruby/

If you want to check the full documentation about Belvo API: https://docs.belvo.com

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

## Usage (create link via widget)

When your user successfully links their account using the [Connect Widget](https://developers.belvo.com/docs/connect-widget), your implemented callback funciton will return the `link_id` required to make further API to retrieve information.


```ruby
require 'belvo'

belvo = Belvo::Client.new(
  'your-secret-id',
  'your-secret-password',
  'sandbox'
)

begin
    # Get the link_id from the result of your widget callback function
    link_id = result_from_callback_function.id 
    
    belvo.accounts.retrieve(link: link_id)

    puts belvo.accounts.list
rescue Belvo::RequestError => e
    puts e.status_code
    puts e.detail
end
```

## Usage (create link via SDK)

You can also manually create the link using the SDK. However, for security purposes, we highly recommend, that you use the [Connect Widget](https://developers.belvo.com/docs/connect-widget) to create the link and follow the **Usage (create link via widget)** example.

```ruby
require 'belvo'

belvo = Belvo::Client.new(
  'your-secret-id',
  'your-secret-password',
  'sandbox'
)

begin
    new_link = belvo.links.register( # Creating the link
        institution: 'erebor_mx_retail', 
        username: 'janedoe', 
        password: 'super-secret',
        options: { access_mode: Belvo::Link::AccessMode::SINGLE }
        )
    
    belvo.accounts.retrieve(link: new_link['id'])

    puts belvo.accounts.list
rescue Belvo::RequestError => e
    puts e.status_code
    puts e.detail
end
```

**Note:** If you create a `Link` without specifying [access_mode](https://docs.belvo.com/#operation/RegisterLink), the SDK will respect the default value from the API.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 

To release a new version:
- Create a new branch from master.
- Update the version number in `version.rb`
- Run `bundle exec rake install` to update `Gemfile.lock` version
- Create a new pull request for the new version.
- Once the new version is merged in `master`, create a `tag` matching the new version.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/belvo-finance/belvo-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/belvo-finance/belvo-ruby/blob/master/CODE_OF_CONDUCT.md).

If you wish to submit a pull request, please be sure check the items on this list:
- [ ] Tests related to the changed code were executed
- [ ] The source code has been coded following the OWASP security best practices (https://owasp.org/www-pdf-archive/OWASP_SCP_Quick_Reference_Guide_v2.pdf).
- [ ] Commit message properly labeled
- [ ] There is a ticket associated to each PR. 


## Code of Conduct

Everyone interacting in the Belvo project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/belvo-finance/belvo-ruby/blob/master/CODE_OF_CONDUCT.md).
