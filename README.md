jboss-eap Cookbook
==================

This cookbook installs JBoss EAP 6 from a tar.gz and would probably work with JBoss AS 7 as well.  This has only been tested on RHEL 6.  This is a basic cookbook intended as a starting point for your environment.  By default this cookbook will install JBoss into /opt/jboss and setup the init script and log directoy. See the usage section for more details.

**Special attention should be paid to the permissions set on the jboss files as this cookbook sets them all to be writable by the jboss user and should not be considered a secure setup.**

Requirements
------------
- `java` - Not managed by this cookbook
- `JBoss EAP 6` - Packaged as a tar.gz and stored on a web server acccessible by the node.
 - Download the zip package "Red Hat JBoss Enterprise Application Platform 6.1.1" from [RHN](https://access.redhat.com/jbossnetwork/restricted/listSoftware.html?downloadType=distributions&product=appplatform&version=6.1.1) and repackage into a tar.gz

Attributes
----------
* `node['jboss-eap']['version']` - used for versioned directory name (Default: 6.1.1)
* `node['jboss-eap']['install_path']` - Base directory that will hold the versioned jboss directory and symlink (Default: /opt)
* `node['jboss-eap']['package_url']` - Url to obtain JBoss tar.gz package
* `node['jboss-eap']['checksum']` - sha256sum of package_url file
* `node['jboss-eap']['log_dir']` - Directory to hold JBoss logs (Default: /var/log/jboss)
* `node['jboss-eap']['jboss_user']` - User to run JBoss as (Default: jboss)
* `node['jboss-eap']['jboss_group']` - Group owner of JBoss (Default: jboss)
* `node['jboss-eap']['admin_user']` - Management console username (Does nothing if not set)
* `node['jboss-eap']['admin_passwd']` - Management console user passwd (Does nothing if not set)
* `node['jboss-eap']['start_on_boot']` - enables services (Default: false)

Usage
-----
#### jboss-eap::default
The default recipe downloads the EAP package and untar's it to the versioned directory (/opt/jboss-eap-6.1.1).  A jboss symlink is created that points to the versioned directory. (/opt/jboss points to /opt/jboss-eap-6.1.1).  The EAP supplied init script is copied to /etc/init.d/jboss and the configuration file is setup at /etc/jboss-as/jboss-as.conf.  jboss/standalone/logs is then symlinked to the supplied log directory.

Specifying an admin_user and admin_password will add the user to the JBoss management console.  Only one user is supported at this time.  TODO: Convert this to an array of users

#### Example role:

```ruby
name "jboss-eap-6_1_1-pip"
description "JBoss 6 EAP install"
run_list [
    "recipe[jboss-eap]",
    ]

default_attributes(
  "jboss-eap" => {
      "install_path" => "/opt",
    "package_url" => "https://yourserver.local/jboss/jboss-eap-6.1.tar.gz",
    "checksum" => "0ef5d62a660fea46e0c204a9f9f35ad4",
        "version" => "6.1.1",
        "admin_user" => "youradmin",
        "admin_passwd" => "ZYxalFHy-7A",
        "start_on_boot" => true
    }
  
)
```

License and Authors
-------------------
Authors: https://github.com/andrewfraley
