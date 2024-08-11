# recordctl
by Morgan Aldridge <morgant@makkintosshu.com>

## OVERVIEW

An overly-complex, but very convenient, utility for [OpenBSD](https://www.openbsd.org/) which provides a simple interface for enabling/disabling/toggling audio and/or video recording in the kernel with sensible defaults.

It really just saves keystrokes so I can just type `doas recordctl` instead of `doas sysctl kern.{audi,vide}o.record=1` to enable both audio & video recording. Even better, another `doas recordctl` will disable both audio & video recording again without needing to type the whole `doas sysctl kern.{audi,vide}o.record=0`.

## FEATURES

* Explicitly enable/disable either/both `kern.audio.record` & `kern.video.record`
* Toggle the state of either/both `kern.audio.record` & `kern.video.record`
* Defaults to toggling both audio/video recording states

## INSTALLATION

```
git clone git@github.com:morgant/recordctl.git
cd recordctl
doas make install
```

## USAGE

To toggle both audio/video recording states:

```
doas recordctl
```

To toggle just the audio recording state:

```
doas recordctl -ta
```

To explicitly disable just the video recording state:

```
doas recordctl -v 0
```

## LICENSE

Released under the [MIT license](LICENSE).
