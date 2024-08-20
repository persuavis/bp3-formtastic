# Bp3::Formtastic

bp3-formtastic adapts formtastic for BP3, the persuavis/black_phoebe_3
multi-site multi-tenant rails application.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'bp3-formtastic'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install bp3-formtastic

## Usage
In your application's `config/initializers/bp3-formtastic` initializer, specify the name of the class 
that controls whether to show a formtastic input control or not:
```ruby
Bp3::Formtastic.input_control_class_name = 'Vizfact::Input'
```

In your application's formtastic configuration file (typically `config/initializers/formtastic`), 
specify which form builder to use:
```ruby
Rails.application.config.after_initialize do
  Formtastic::Helpers::FormHelper.builder = Bp3::Formtastic::VizFormBuilder
end
```
Specify `Bp3::Formtastice::VizFormBuilderWithCreate` if you want new `Bp3::Formtastic.input_control_class_name` 
records to be added for each form input encountered on a form.

## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run 
`rake spec` to run the tests. You can also run `bin/console` for an interactive 
prompt that will allow you to experiment.

To install this gem onto your local machine, run `rake install`. To release a 
new version, update the version number in `version.rb`, and then run 
`rake release`, which will create a git tag for the version, push git 
commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Testing
Run `rake` to run rspec tests and rubocop linting.

## Documentation
A `.yardopts` file is provided to support yard documentation.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
