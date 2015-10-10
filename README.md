# RSpec TextMate Bundle

This bundle works with **TextMate 2** and **RSpec 2 and 3**. For TextMate 1 and/or RSpec 1 please use the legacy version from the branch “rspec1-textmate1”.

## Installation

Open up TextMate’s preferences, go to “Bundles” and make sure “RSpec” is checked.

## Running RSpec examples

Commands for running examples:

 * __Run Examples__ <kbd>⌘R</kbd>: Run all examples in the current spec file.
 * __Run Single Example__ <kbd>⇧⌘R</kbd>: Run the example on the current line (also works for example groups).
 * __Run Examples in Selected Files/Directories__ <kbd>⌥⇧⌘R</kbd>: Run all examples from the files / directories selected in the file browser. If nothing is selected, run all examples in `spec/`. Hint: <kbd>⇧⌘A ⌥⇧⌘R</kbd> is a quick way to run all specs (<kbd>⇧⌘A</kbd> deselects everything in the file browser).
 * __Run Again__ <kbd>⌥⌘R</kbd>: Repeat the last run command (can be example file, single example or examples in selected files).
 
If your project has an `.rspec` file in its root, the last two commands – “Run Examples in Selected Files/Directories” and “Run Again” – are available everywhere in your project (even in files that not using the “RSpec” mode).
 
## Configuring TextMate for running examples

The bundle runs RSpec in a subshell. The command to start RSpec is determined as such:

 * If a binstub (`bin/rspec`) is present, it is used for running RSpec (this works great for preloaders like [Spring](https://github.com/rails/spring), too).
 * If there is no binstub, but `Gemfile.lock` is present, RSpec is run via `bundle exec rspec`.
 * If there is neither a binstub nor a `Gemfile.lock`, RSpec is simply run via `rspec` (__not recommended__ – use only if you know exactly what you’re doing).

Running RSpec / Ruby from a subshell means that TextMate must be configured to work with whatever Ruby version manager you're using ([rbenv](https://github.com/sstephenson/rbenv), [rvm](http://rvm.io/), …). Normally, this means customizing the `$PATH` variable. See [Defining a $PATH](http://blog.macromates.com/2014/defining-a-path/) in the TextMate blog for details and caveats.


## Configuration

In addition to the standard TextMate shell variables, the RSpec
TextMate bundle supports the following:

#### TM\_RSPEC\_FORMATTER

Set a custom formatter other than RSpec's TextMate formatter. Use
the full classname, e.g. `'Spec::Core::Formatters::WebKit'`

#### TM\_RSPEC\_OPTS

Use this to set RSpec options just as you would in an `.rspec`
file.

## RVM Integration

[__NOTE: Information in this section may be outdated__]

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

