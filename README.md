NAME
====

One Time Storage

USAGE
=====

``` bash
  $ curl -k -T https://localhost:8081/write/README.md
  $ curl -k -o get.md https://localhost:8081/read/README.md
```

DESCRIPTION
===========

This module is written to compare with `momental_storage`.

This is for just a compare, not for production use.

This can store a file per `PUT`, and `GET` after it,
but the file will be deleted after `GET`.

INSTALL
=======

Place SSL certificate file to `priv/ssl`.

``` bash
  $ mkdir priv/pub
  $ make
```
