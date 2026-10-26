# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

bp3-formtastic adapts `formtastic` for BP3 (persuavis/black_phoebe_3), a multi-site multi-tenant Rails
application. It lets each site hide individual form inputs, controlled by records of an "input control"
class (`Vizfact::Input` in the application), keyed by controller, action and field.

## Commands

The gems run on Ruby 3.4.6 (`.ruby-version`). Prefix commands with `~/.rvm/bin/rvm 3.4.6 do` when the
shell is not already on it; a missing `rspec` means the wrong Ruby, not a missing bundle.

- `bundle exec rake` - specs and RuboCop (the default task)
- `bundle exec rspec spec/path/to/file_spec.rb[:LINE]` - one file or example
- `bundle exec rubocop` / `bundle exec rubocop -a`
- `bin/setup`, `bin/console`, `rake install`

## Architecture

**VizFormBuilder** (`lib/bp3/formtastic/viz_form_builder.rb`), a `Formtastic::FormBuilder`
- on initialize, loads the input control records for the controller's `current_site`, controller class and
  action into `vizfacts`
- `viz(element_name, element_ident)` finds the record matching the field name (`object[attribute]`) or
  DOM id

**VizFormBuilderWithCreate** (`viz_form_builder_with_create.rb`)
- creates a missing record (`show_element: true`) for every input it meets, so operators can then hide it.
  It names `Vizfact::Input` directly. The application uses it outside the test environment

**Railtie** (`railtie.rb`), in an `after_initialize` block, only when `Rails.env` is defined
- prepends `PrependInputs` to `Formtastic::Inputs::Base`. `input_wrapping` renders nothing for the `rqid`
  and `sqnr` columns, and nothing when the matching record has `show_element` false
- it falls through to formtastic when there is no column, no input control class, or a builder without
  `viz`, so plain formtastic builders are unaffected

**Configuration** (`lib/bp3/formtastic.rb`): `Bp3::Formtastic.input_control_class_name`; `.input_control_class`
constantizes and caches it, and returns nil when unset. The application sets it in
`config/initializers/bp3-formtastic.rb` and also redefines `input_control_class` in a `to_prepare` block so
code reloading in development does not leave a stale class. It picks the builder in
`config/initializers/formtastic.rb`.

`lib/bp3/formtastic.rb` requires `action_dispatch` first to avoid an
`uninitialized constant Rails::Engine::Configuration::ActionDispatch` error when loading formtastic.

## Testing

The spec only checks the version; the builders and the Railtie need a Rails view context to exercise. Try
a change against the application (black_phoebe_3) by putting this repo's `lib` ahead of the bundled gem.

## Code Style

- RuboCop (`.rubocop.yml`): target Ruby 3.2.2, NewCops, rubocop-rake and rubocop-rspec; AbcSize 26,
  MethodLength 15, BlockLength 66, ModuleLength 150; `Lint/ConstantDefinitionInBlock` and `Lint/Void`
  are off for `lib/bp3/**/railtie.rb`, where classes are reopened inside a block
- Constants holding a regex end in `_REGEX`
- Every file starts with `# frozen_string_literal: true`
- American English; no trailing whitespace on any added or modified line

## Release

Bump `lib/bp3/formtastic/version.rb` and add a `CHANGELOG.md` entry. `rake release` tags, pushes and
publishes to rubygems.org; leave releasing and committing to the user.
