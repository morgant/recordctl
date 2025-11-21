# CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

_n/a_

## [0.3.0] - 2025-11-21

### Added

* `recordctl`:
    * New dump (`-d`) option for dumping all controls and their possible values (equivalent to sndioctl(1) `-d`)
    * Implemented previously stubbed monitor (`-m`) mode (equivalent to sndioctl(1) `-m`), including:
        * New `-c` for specifying the number of seconds between checks for changes to control values
    * New `mix.monitor` control exposing and manipulating sndiod(8) configuration for a [monitor mix](https://www.openbsd.org/faq/faq13.html#recordmon) via rcctl(8):
        * Checks whether sndiod(8) flags configured in rcctl(8) end with `-m play,mon -s mon` (mix monitor) or not
        * Warns if running sndiod(8) process has different flags than configured in rcctl(8)
        * Restarts sndiod(8) via rcctl(8) when setting control value, if necessary
* `CHANGELOG.md`:
    * Added this CHANGELOG file with detailed documentation for all prior releases

### Changed

* `recordctl`:
    * Only requires root privileges when setting control values, not getting/monitoring control values
    * Improved warnings and error messages when incompatible options and arguments are combined
    * General improvements to code structure
* Documentation:
    * Significant rewrite of README and `recordctl.8` manual page to reflect:
        * Displays and manipulates more than just sysctl(8) recording controls, but also sndiod(8) configuratiion via rcctl(8)
        * Document and provide examples for new:
            * `mix.monitor` control
            * Dump (`-d`) and monitor (`-m`) modes

## [0.2.0] - 2025-10-24

### Added

* `recordctl`:
    * New list all (`-a`) option to show both audio and video record control states
    * New no name (`-n`) option to suppress printing control name and only print the value
* `Makefile`:
    * New `uninstall` target

### Changed

* `recordctl`:
    * Now lists audio and video record states (`-a`) by default, instead of toggling states (`-t`)
    * Changed options for showing/setting audio & video record state (`-a` & `-v`, respectively) to a control syntax like OpenBSD's sysctl(8), mixerctl(8), and sndioctl(1): `record.audio` and `record.video`, respectively
    * Improved built-in help (`-h`)
    * Replaced use of `echo` with `printf`
* Documentation:
    * Moved manual page from section 1 to section 8 to better reflect that `recordctl` manipulates system configuration
    * Updated `recordctl.8` manual page and README to reflect new control syntax, options, and defaults
* `Makefile`:
    * Restructured for easier maintenance and expansion

### Removed

* `recordctl`:
    * Removed previously supported state aliases for control values `0` (`0`, `no`, `off`, or `disable`) and `1` (`1`, `yes`, `on`, or `enable`), so controls now only accept values `0..1`

## [0.1.2] - 2024-09-07

## Changed

* `recordctl`:
    * Requires root privileges or exits with an error

## [0.1.1] - 2024-08-10

### Added

* New `recordctl.1` manual page
* New `Makefile` with `install` target to install `recordctl` script and `recordctl.1` manual page

## [0.1.0] - 2024-07-29

### Added

* `recordctl`:
    * Sets or toggles audio and/or video recording in the OpenBSD kernel via sysctl(8)'s `kern.audio.record` and/or `kern.video.record`, respectively:
        * Toggles both audio and video recording by default
        * Supports explicitly setting either/both audio (`-a`) or video (`-v`) recording to 'enabled' (`1`, `yes`, `on`, or `enable`) or 'disabled' (`0`, `no`, `off`, or `disable`) states
        * Supports quieting (`-q`) output of sysctl(8) output when setting state
    * Stubs a monitor (`-m`) mode (see sndioctl(1) `-m`) for future implementation

[unreleased]: https://github.com/morgant/recordctl/compare/0.3...main
[0.3.0]: https://github.com/morgant/recordctl/compare/0.2...0.3
[0.2.0]: https://github.com/morgant/recordctl/compare/0.1.2...0.2
[0.1.2]: https://github.com/morgant/recordctl/compare/0.1.1...0.1.2
[0.1.1]: https://github.com/morgant/recordctl/compare/0.1...0.1.1
[0.1.0]: https://github.com/morgant/recordctl/releases/tag/0.1
