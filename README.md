# Java module for Puppet

**Manages java deployment, configuration and keystores.**

This module is provided by [Camptocamp](http://www.camptocamp.com/)

## Classes

 * java
 * java::dev
 * java::jai
 * java::jai-imageio
 * java::params
 * java::v6

### java

The java class includes `java::v6` for all supported operating systems.

### java::dev

The `java::dev` installs `maven2` and `ant`. You need to include `java` or `java::v6`.

### java::jai

The `java::jai` class installs jai from source into the proper java directories.

### java::jai-imageio

The `java::jai-imageio` class installs jai-imageio from source into the proper java directories.

### java::params

The `java::params` class defines the parameters for the `java` module.

### java::v6

This class installs Java v6.

## Definitions

 * java::keystore::import
 * java::keystore::import::cert
 * java::keystore::import::key
 * java::keystore::keypair

### java::keystore::import

The `java::keystore::import` definition allows to import a java keystore.

### java::keystore::import::cert

The `java::keystore::import` definition allows to import an SSL certificate into a java keystore.

### java::keystore::import::key

The `java::keystore::import` definition allows to import an SSL key into a java keystore.

### java::keystore::import::key

The `java::keystore::import` definition allows to cerate or delete an SSL keypair from a java keystore.
