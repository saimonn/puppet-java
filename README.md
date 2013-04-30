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
 * java::keystore::keypair

### java::keystore::import

The `java::keystore::import` definition allows to import a java keystore.

### java::keystore::keypair

The `java::keystore::keypair` definition manages a keypair in a java keystore.
