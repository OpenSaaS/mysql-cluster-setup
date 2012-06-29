Description
===========

This is a fork of the Opscode [haproxy](https://github.com/opscode/cookbooks/tree/master/haproxy) cookbook (originally v.1.0.4), that has been modified to configure app load balancers from a data bag items.

Changes
=======
## v1.1.0:
    
* Forked and modified to pull configuration data from a data bag.

## v1.0.4:

* [COOK-806] - load balancer should include an SSL option 
* [COOK-805] - Fundamental haproxy load balancer options should be configurable

## v1.0.3:

* [COOK-620] haproxy::app_lb's template should use the member cloud private IP by default

## v1.0.2:

* fix regression introduced in v1.0.1

## v1.0.1:

* account for the case where load balancer is in the pool

## v1.0.0:

* Use `node.chef_environment` instead of `node['app_environment']`

Requirements
============

## Platform

Tested on Ubuntu 8.10 and higher.

## Cookbooks:

Attributes
==========

* `node['haproxy']['incoming_port']` - sets the port on which haproxy listens
* `node['haproxy']['member_port']` - the port that member systems will be listening on, default 80
* `node['haproxy']['enable_admin']` - whether to enable the admin interface. default true. Listens on port 22002.
* `node['haproxy']['app_server_role']` - used by the `app_lb` recipe to search for a specific role of member systems. Default `webserver`.
* `node['haproxy']['balance_algorithm']` - sets the load balancing algorithm; defaults to roundrobin.
* `node['haproxy']['member_max_connections']` - the maxconn value to be set for each app server
* `node['haproxy']['x_forwarded_for']` - if true, creates an X-Forwarded-For header containing the original client's IP address. This option disables KeepAlive.
* `node['haproxy']['enable_ssl']` - whether or not to create listeners for ssl, default false
* `node['haproxy']['ssl_member_port']` - the port that member systems will be listening on for ssl, default 8443
* `node['haproxy']['ssl_incoming_port']` - sets the port on which haproxy listens for ssl, default 443
* `node['haproxy']['config_data_items']` - a list of items from the `haproxy` data bag. These will be used to write the configuration file (see below).

Usage
=====

Use either the default recipe or the `app_lb` recipe.

When using the default recipe, modify the haproxy.cfg.erb file with listener(s) for your sites/servers.

The `app_lb` recipe reads configuration information from items in an `haproxy` data bag. To get started, define a role and include the `id`s for the data bag items in the `config_data_items` attribute.

A sample role, `haproxy_demo` might look like this:

    name "haproxy_demo"
    description "demo haproxy recipe"
    run_list(
      "recipe[haproxy::default]",
      "recipe[haproxy::app_lb]",
    )
    override_attributes(
      "haproxy" => {
        'incoming_port' => "80",
        'balance_algorithm' => "roundrobin",
        'config_data_items' => ['appserver1', 'appserver2']
      }
    )

The above role references `appserver1` and `appserver2` data bag items (stored in, e.g. `haproxy/appserver1.json`). These data bags would look something like this:

    {
        "id": "appserver1",
        "hostname":"appserver1.example.com", # hostname to which connections are proxied
        "ipaddress": "192.168.0.1", # ip address of target system
        "port":"8080",              # port to which connections are proxied
        "proxy_weight": 1,          # preference to give this system
        "max_connections":100, 
        "ssl_port":"443"            # port to which SSL connections are proxied
    }

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)
Author:: Brad Montgomery (<bmontgomery@coroutine.com>)

Copyright:: 2009-2012, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
