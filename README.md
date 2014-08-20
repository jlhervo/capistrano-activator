# Capistrano::Activator

**Note: this plugin works only with Capistrano 3.** Plase check the capistrano
gem version you're using before installing this gem:
`$ bundle show | grep capistrano`

### About

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-activator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-activator

### Usage

If you're deploying a standard capistrano app, all you need to do is put
the following in `Capfile` file:

    require 'capistrano/activator'
    
To setup the server, run:

    $ cap production setup
    
Don't forget to prefix command with `bundle exec` if you use bundler to manage gem dependencies.


### How it works

Check here for the full capistrano deployment flow
[http://capistranorb.com/documentation/getting-started/flow/](http://capistranorb.com/documentation/getting-started/flow/).

The following tasks run during the `setup` task:

* `activator:copy_scripts`<br/>
copies compilation and startup scripts to `#{shared_path}/scripts`.
* `activator:copy_config`<br/>
copies application configuration and logger configuration (optional) to target host directory (ensure the Play! configuration file has been removed from project repository).

Compilation script task runs after the `deploy:published` task. Content of this script can be found in `#{shared_path}/scripts/activator_stage` file.

 ***Note that NodeJS engine is used by default during assets compilation and must be installed on target host***. Set `:activator_node_assets_compilation` options to `false` if you want to use Trireme default engine (slower).
 
### Tasks
 
Start the web server using startup script located in `#{shared_path}/scripts/activator_start`. 
 
	$ cap production activator:start
	
Stop the currently running server instance (using pid file located in `#{shared_path}/pids` directory). Prints an error if no instance is running on the target host.

	$ cap production activator:stop 	
 	

### Configuration

Here's the list of options and the defaults for each option:

* `set :activator_config_file`<br/>
Configuration file path for your app. Defaults to `conf/#{stage}.conf`,
example: `conf/production.conf`.

* `set :activator_logger_file`<br/>
Logger configuration file path for your app. Defaults to `conf/#{stage}_logger.xml`. <br/>
Note that specifying a logger configuration is purely **optional**. Default behavior is to redirect application outputs to standard `application.log` file in `#{shared_path}/logs` directory.

* `set :activator_apply_evolutions`<br/>
Default `false`. Set this option to `true` if you want Play! database evolutions to be applied on application start.

* `set :activator_db_name`<br/>
Name of the Play! database as configured in ORM (Ebean/Anorm) section of the app configuration file. Defaults to `default`. Used in conjonction with previous `activator_apply_evolutions` option. 

* `set :activator_http_address`<br/>
HTTP address Play! Netty server will listen on. Defaults to `0.0.0.0`. If you put your app behind a web server like Nginx on the same machine, be free to use a less permissive address, example: `127.0.0.1`.

* `set :activator_http_port`<br/>
HTTP port Play! Netty server will listen on. Defaults to `9000`.

* `set :activator_mem`<br/>
Maximum memory allocated to JVM instance of your app. Defaults to `1024`. 

* `set :activator_jvm_args`<br/>
Additional arguments to pass to JVM instance of your app. Defaults to `nil`.

* `set :activator_node_assets_compilation`<br/>
Enable NodeJS engine when using sbt-web plugins (faster than default Trireme one). Defaults to `true`. NodeJS **must be installed** on the remote machine.

### Contributing

1. Fork it ( https://github.com/jlhervo/capistrano-activator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### License

[MIT](LICENSE.md)
