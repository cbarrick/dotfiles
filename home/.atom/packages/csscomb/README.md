# Atom Editor Plugin for CSScomb

Sort properties of one or more CSS/SCSS/Less rules using
[CSScomb](http://csscomb.com/).

## CSScomb Configuration

The plugin uses the following strategy to determine the CSScomb configuration to use.

* First, it looks for a user configuration; a `csscomb` property in your Atom
  `config.cson`.
* Next, it looks for a project configuration; `.csscomb.json` or `.csscomb.cson`
  in your project root.
* If no configuration is found, it falls back to the predefined "csscomb"
  configuration that ships with [csscomb.js](https://github.com/csscomb/csscomb.js/blob/master/config/csscomb.json).

Your configuration can be a CSScomb configuration object or the [name of a predefined configuration](https://github.com/csscomb/csscomb.js/tree/master/config).

## Using It

Press `ctrl-alt-c` or choose `Packages -> CSScomb -> Sort` or
`Edit -> Lines -> Sort with CSScomb`.

You can limit what CSScomb processes by using selections.

Note: Make sure to select entire CSS rules (selector, braces, and
properties; valid CSS), not just the property list.

The plugin uses the name of the file to determine the syntax
(css, scss, or less).
