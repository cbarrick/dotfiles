[![Build Status](http://img.shields.io/travis/yujinakayama/atom-auto-update-packages/master.svg)](https://travis-ci.org/yujinakayama/atom-auto-update-packages)

# Auto-Update-Packages for Atom

Keep your Atom packages up to date.

![Screenshot](https://f.cloud.github.com/assets/83656/2521579/c30d4b2a-b4ac-11e3-898a-5c763e9a1c5a.png)

## Installation

```bash
$ apm install auto-update-packages
```

## Usage

Just sit tight. :)

`auto-update-packages` automatically checks for package updates every 6 hours by default.
If any updates are available, it installs them and notifies you via OS X Notification Center.

Note that after the update you need to **Reload** (⌃⌥⌘L)
to apply the updates to the opened Atom window.

If you're impatient,
run **Packages** menu > **Auto Update Packages** > **Update Now**.

## Configuration

You can configure `auto-update-packages`
either
in the Settings view (**Preferences...** in **Atom** menu)
or
in `~/.atom/config.cson` (**Open Your Config** in **Atom** menu):

### Interval Minutes

* Config Key Path: `auto-update-packages.intervalMinutes`
* Default: 360 minutes (6 hours)
* Minimum: 15 minutes

Specify an auto-update interval.
If you specify a value less than 15, it will be handled as 15 internally.

Note that `auto-update-packages` does not adhere the value strictly.
It has some margin around 5%.

## License

Copyright (c) 2014 Yuji Nakayama

See the [LICENSE.txt](LICENSE.txt) for details.
