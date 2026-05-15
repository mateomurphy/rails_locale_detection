# Changelog

## 3.0.1 (2026-05-15)

* Corrected `required_ruby_version` to `>= 3.1` to match the supported CI matrix
* Documented `ActionController::API` support in the README
* Added a compatibility line to the top of the README
* Extracted changelog into `CHANGELOG.md`

## 3.0 (2026-05-15)

* Rails 6.1, 7.0, 7.1, 7.2, and 8.0 compatibility
* Dropped support for Rails < 6.1 and Ruby < 3.1
* `ActionController::API` controllers are now supported alongside `ActionController::Base`
* Replaced Travis CI with GitHub Actions
* Internal cleanup: removed legacy version conditionals, modernized syntax, dropped the `timecop` dev dependency in favor of ActiveSupport's `freeze_time`

## 2.3 (2018-06-16)

* Update dependencies

## 2.2 (2017-04-22)

* Cookie is now set only when the locale differs from the previous value, to avoid Set-Cookie headers being sent with every request

## 2.1 (2016-08-01)

* Rails 5 compatibility

## 2.0 (2015-10-14)

* Rails 4 compatibility
* Namespace has been changed from Rails::LocaleDetection to RailsLocaleDetection,
    although the previous namespace is still supported for legacy config files
* Locale detection has been moved to a separate object, to avoid polluting controllers with extra methods.
* Detection order has been changed to `param` first, as this make more sense in most contexts.
* Shortcut locale accessors are now mixed into views as well
