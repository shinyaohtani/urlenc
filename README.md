# Urlenc

The simplest way to URL encode / decode from STDIN. URL encoding is a generic name, more accurately called Percent-encoding. The URL encoding is by far the most well-known name, so we intentionally named this gem Urlenc.

See about Percent-encoding: [wikipedia](https://en.wikipedia.org/wiki/Percent-encoding)

## Installation

Just install from rubygems:

    $ gem install urlenc

## Usage

```bash
$ # decode
$ echo "http://sample%20Text%21/" | urlenc -d
http://sample Text!/

$ # encode with split by /
$ echo "http://sample Text!/" | urlenc -es
http://sample%20Text%21/

$ # or just encode
$ echo "http://sample Text!/" | urlenc -e
http%3A%2F%2Fsample%20Text%21%2F
```

```
Usage: urlenc {decode/encode} [options]
 Required:
    -d, --decode    Decode/unescape STDIN. %22Sample%20Text%21%22 to "Sample Text!"
    -e, --encode    Encode/escape   STDIN. "Sample Text!" to %22Sample%20Text%21%22

 Optional:
    -s, --split     Split before Encode/escape. http://sample Text!/ to http://sample%20Text%21/

 Common options:
    -h, --help      Show this message
    -V, --version   Show version
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome!
1. Fork it ( https://github.com/shinyaohtani/urlenc )
1. Create your feature branch (git checkout -b my-new-feature)
1. Commit your changes (git commit -am 'Add some feature')
1. Push to the branch (git push origin my-new-feature)
1. Create a new Pull Request


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Urlenc project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/urlenc/blob/master/CODE_OF_CONDUCT.md).
