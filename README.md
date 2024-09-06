# recordctl
by Morgan Aldridge <morgant@makkintosshu.com>

## OVERVIEW

An overly-complex, but very convenient, utility for [OpenBSD](https://www.openbsd.org/) which provides a simple interface for enabling/disabling/toggling audio and/or video recording in the kernel with sensible defaults.

It is intended to save keystrokes so that I only need to type `recordctl` instead of `doas sysctl kern.{audi,vide}o.record=1` to enable both audio & video recording. Even better, another `recordctl` will disable both audio & video recording again without needing to type the whole `doas sysctl kern.{audi,vide}o.record=0`.

## FEATURES

* Explicitly enable/disable either/both `kern.audio.record` & `kern.video.record`
* Toggle the state of either/both `kern.audio.record` & `kern.video.record`
* Defaults to toggling both audio/video recording states
* Verifies that the user is either root or permitted to execute the required sysctl(8) commands by doas.conf(5) rules
* If run as a non-root user with the relevant doas.conf(5) rules, it will automatically execute sysctl(8) commands via doas(1)
* Can optionally be run in a non-interactive mode, which will ensure that all required doas.conf(5) rules include 'nopass' (especially for use in scripts)

## INSTALLATION

```
git clone git@github.com:morgant/recordctl.git
cd recordctl
doas make install
```

## USAGE

To toggle both audio/video recording states:

```
recordctl
```

To toggle just the audio recording state:

```
recordctl -ta
```

To explicitly disable just the video recording state:

```
recordctl -v 0
```


## ADVANCED CONFIGURATION & SECURITY CONSIDERATIONS

For ultimate convenience, though at higher risk to privacy and security, one can add the following lines to their `/etc/doas.conf` (replacing `<user>` with the appropriate username) to have `recordctl` both automatically utilize doas(1) and not be prompted for a password:

```
permit nopass <user> cmd sysctl args kern.audio.record=0
permit nopass <user> cmd sysctl args kern.audio.record=1
permit nopass <user> cmd sysctl args kern.video.record=0
permit nopass <user> cmd sysctl args kern.video.record=1
```

This is especially useful if executing `recordctl` from non-interactive terminals, scripts, or X11 applications where the user cannot input a password.

The aforementioned _four_ doas.conf(5) rules are _highly preferred_ over a single `permit nopass <user> cmd sysctl` rule, which would be allowed to set _any_ kernel variable without a password. Additionally, they are also suggested instead of executing `doas recordctl` so that the only commands needing to be run as a privileged user are the specific sysctl(8) commands.

**IMPORTANT**: All that said, permitting enabling of audio & video recording in the kernel by an unprivileged user without a password negates much of the reason for having audio & video recording disabled by default in the kernel, even when restricted to only a single user. You must take great care in considering the risks in doing so and whether it is appropriate for your specific situation.

## FURTHER READING

* [sysctl(8)](https://man.openbsd.org/man8/sysctl.8)
* [doas(1)](https://man.openbsd.org/doas)
* [doas.conf(5)](https://man.openbsd.org/doas.conf)

## LICENSE

Released under the [MIT license](LICENSE).
