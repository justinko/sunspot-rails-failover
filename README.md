# sunspot-rails-failover

Sunspot comes with `MasterSlaveSessionProxy` that does the following:

> This session proxy implementation allows Sunspot to be used with a
> master/slave Solr deployment. All write methods are delegated to a master
> session, and read methods are delegated to a slave session.

What this simple gem does is provide failover support if the slave session
goes down. Reads *and* writes are called on the master session.

## Setup

Your config/sunspot.yml file should look something like this:

    development:
      master_solr:
        url: http://localhost:8984/solr
      solr:
        url: http://localhost:8985/solr
        
NOTE: You do *not* have to have a master session. If a master session is
not detected, sunspot-rails-failover will default to what sunspot_rails
provides.

Next, add an initializer (maybe initializers/sunspot.rb) with the following
code:

    Sunspot::Rails::Failover.setup
    
## Exception handling

sunspot-rails-failover supports exception handling for committing and
searching. Currently, it will use Hoptoad by default if it is installed.
The exception is passed to `HoptoadNotifier.notify`.

You can also use a custom class/module to customize how you want to handle the
exception. In `initializers/sunspot.rb`:

    module MyExceptionHandler
      def self.handle(exception)
        Notifier.deliver_exception_message(exception)
      end
    end
    
    Sunspot::Rails::Failover.exception_handler = MyExceptionHandler
    Sunspot::Rails::Failover.setup
    
## Copyright

Copyright (c) 2011 Justin Ko. See LICENSE for details.