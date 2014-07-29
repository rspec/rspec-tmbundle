# RSpec TextMate Bundle

## Installation

### TextMate 2
This bundle is included TextMate’s bundle index. Just go to Preferences → Bundles and make sure “RSpec” is checked.

### TextMate 1
```bash
mkdir -p ~/Library/Application\ Support/TextMate/Pristine\ Copy/Bundles
cd ~/Library/Application\ Support/TextMate/Pristine\ Copy/Bundles
git clone git://github.com/rspec/rspec-tmbundle.git RSpec.tmbundle
osascript -e 'tell app "TextMate" to reload bundles'
```

## Supports RSpec 1, 2 and 3

`RSpec.tmbundle` works with RSpec versions 1, 2 and 3. Given that they work differently, the bundle tries its best to figure out which one you're using in each project when you try to run RSpec examples. 

__Summary:__ If your project has a binstub (`bin/rspec`), make sure you’ve customized TextMate’s `$PATH` to play nicely with your Ruby version manager ([rbenv](https://github.com/sstephenson/rbenv), [rvm](http://rvm.io/), …). If it has a `Gemfile`, the same goes for `$TM_RUBY`. If you’re using the Ruby bundled with Mac OS, you shouldn’t need to customize anything.

Now here come the gritty details. There are two ways the bundle can run RSpec:

### Running RSpec via binstub

If `bin/rspec` is present, the bundle uses that to run RSpec (great for projects using [Bundler binstubs](http://bundler.io/v1.6/man/bundle-exec.1.html#BUNDLE-INSTALL-BINSTUBS) or [Spring](https://github.com/rails/spring)). The binstub is run via a subshell. This shell inherits it’s `$PATH` from TextMate (init scripts like `.bashrc` are _not_ run), so make sure this is set to work correctly with rbenv, rvm or whatever you’re using. See [Defining a $PATH](http://blog.macromates.com/2014/defining-a-path/) in the TextMate blog for details and caveats.

### Running RSpec from Ruby

If no binstub is present, the bundle commands (which are Ruby scripts) run RSpec examples directly from their Ruby process. The important thing to consider here is the version of Ruby used for running the examples: 

The bundle commands start ruby via `${TM_RUBY:-ruby} …`, this means: 

1. If `$TM_RUBY` is set, that is used. (Can be set via Preferences → Variables.)
2. Otherwise, search `$PATH` for an executable named `ruby` and use that. This will most probably result in using the Ruby version bundled with Mac OS, unless you manually customize `$PATH` (again, see [Defining a $PATH](http://blog.macromates.com/2014/defining-a-path/) for details and caveats.)

The bundle then tries to determine which version of RSpec to use. Again, there are two options:

1. If a `Gemfile` is present, the RSpec version from `Gemfile.lock` is used (via Bundler). lorem
2. If no `Gemfile` is present, the bundle searches `vendor/plugins` and `vendor/gems` for a vendored version of RSpec:
    1. If a vendored version is found, it is used.
    2. If no vendored version is found, the bundle just tries to require RSpec directly. This means that RSpec must be available in Ruby’s `LOAD_PATH`. If you’re using Ruby 1.9 or newer this usually means that the most recent RSpec version installed via rubygems will get used.

If your `Gemfile` is located at a non-standard location, you can add `--bundler` to a file named `.rspec-tm` in your project’s root directory to force the RSpec bundle to use Bundler (you’ll need to make sure `BUNDLER_GEMFILE` is set, otherwise Bundler won’t find the Gemfile, too). 


## Configuration

In addition to the standard TextMate shell variables, the RSpecTextMate bundle supports the following:

### TM\_RSPEC\_FORMATTER

Set a custom formatter other than RSpec's TextMate formatter. Use the full classname, e.g. `'Spec::Core::Formatters::WebKit'`

### TM\_RSPEC\_OPTS

Use this to set RSpec options just as you would in an `.rspec` file.

### TM\_RSPEC\_HOME

If you're hacking on rspec yourself, point this to the`rspec-core` project directory for rspec-2, or the `rspec`
directory for rspec-1.

## RVM Integration

There are lots of ways to configure TextMate to work with `rvm`,
but this is the one that we recommend:

With rvm installed, take the full path to `rvm-auto-ruby`, 
found via: `which rvm-auto-ruby`

Next, set up a `TM_RUBY` option in
`TextMate/Preferences/Advanced/Shell Variables` that points to the
`rvm-auto-ruby` command.

Learn more at:

* [http://rvm.io/integration/textmate](http://rvm.io/integration/textmate)
* [http://groups.google.com/group/rubyversionmanager/browse_thread/thread/64b84bbcdf49e9b?fwc=1&pli=1](http://groups.google.com/group/rubyversionmanager/browse_thread/thread/64b84bbcdf49e9b?fwc=1&pli=1)

## History

Parts of `RSpec.tmbundle` are based on Florian Weber's TDDMate.

## License

The license of `RSpec.tmbundle` is the same as
[RSpec](http://github.com/rspec/rspec/blob/master/License.txt)'s.

