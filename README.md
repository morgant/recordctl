# recordctl
by Morgan Aldridge <morgant@makkintosshu.com>

## OVERVIEW

An overly-complex, but very convenient, utility for [OpenBSD](https://www.openbsd.org/) which provides a simple interface for enabling/disabling/toggling audio and/or video recording in the kernel with sensible defaults.

It is intended to save keystrokes so that I need only execute `doas recordctl -t`, instead of the lengthy `doas sysctl kern.{audi,vide}o.record=1`, to enable both audio and video recording when they are disabled (the default). Another `doas recordctl -t` will disable both audio and video recording again without needing to type the whole of `doas sysctl kern.{audi,vide}o.record=0`. One can also toggle just audio recording with `doas recordctl record.audio=!`.

Eventually, it will also support monitoring the state of audio & video recording in the kernel.

## FEATURES

* Explicitly enable/disable either/both `kern.audio.record` & `kern.video.record`
* Toggle the state of either/both `kern.audio.record` & `kern.video.record`
* Defaults to showing the state of both audio/video recording
* Flexible & extensible syntax, similar to that of [sysctl(8)](https://man.openbsd.org/man8/sysctl.8), [mixerctl(8)](https://man.openbsd.org/mixerctl.8), and [sndioctl(1)](https://man.openbsd.org/sndioctl.1).

## INSTALLATION

```
git clone git@github.com:morgant/recordctl.git
cd recordctl
doas make install
```

## USAGE

To show the audio/video recording states (`0` for disabled, `1` for enabled):

```
# recordctl
record.audio=0
record.video=0
```

To toggle both audio/video recording states:

```
# recordctl -t
record.audio=1
record.video=1
```

To toggle just the audio recording state:

```
# recordctl record.audio=!
record.audio=0
```

To show just the video recording state:

```
# recordctl record.video
record.video=1
```

To explicitly disable just the video recording state:

```
# recordctl record.video=0
record.video=0
```

To show just the value, excluding the name, of the video recording state (useful for shell scripts):

```
# recordctl -n record.video
0
```

To toggle both audio/video recording states without outputting the resulting state:

```
# recordctl -qt
```

## LICENSE

Released under the [MIT license](LICENSE).
