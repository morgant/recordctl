# recordctl
by Morgan Aldridge <morgant@makkintosshu.com>

## OVERVIEW

`recordctl` is a command line convenience utility for manipulating audio and video recording controls under [OpenBSD](https://www.openbsd.org/). OpenBSD defaults to disabling both audio and video recording at the kernel level for security and privacy reasons. recordctl(8) exists to simplify enabling, disabling, or toggling audio/video recording in the kernel as well as a system audio [monitor mix](https://www.openbsd.org/faq/faq13.html#recordmon) in the [sndiod(8)](https://man.openbsd.org/sndiod.8) audio server (useful for screencasting.)

recordctl(8) provides a simple, extensible, and shell script-friendly, command line interface with sensible defaults. Like its cousins [sysctl(8)](https://man.openbsd.org/sysctl.8), [mixerctl(8)](https://man.openbsd.org/mixerctl.8), and [sndioctl(1)](https://man.openbsd.org/sndioctl.1), the controls are described using a “Management Information Base” (MIB) style name, using a dotted set of components, and has options which make it easier to manage programmatically via shell scripts. Similar to sndioctl(1), it also provides a mode to continuously monitor and display controls' changes over time.

## FEATURES

* Manage the state of audio/video recording in the kernel:
    * Get, set, or toggle the value of sysctl(8)'s `kern.audio.record` with the shorter `record.audio` control
    * Get, set, or toggle the value of sysctl(8)'s `kern.video.record` with the shorter `record.video` control
    * Quickly toggle both `record.audio` and `record.video` with the `-t` (toggle) option
* Manage the configuration of an audio [monitor mix](https://www.openbsd.org/faq/faq13.html#recordmon) in sndiod(8):
    * Get, set, or toggle a monitor mix configuration with the `mix.monitor` control
    * Automatically restart sndiod(8), if necessary
* Defaults to showing the state of all controls (`record.audio`, `record.video`, and `mix.monitor`)
* Flexible and extensible syntax, similar to that of [sysctl(8)](https://man.openbsd.org/man8/sysctl.8), [mixerctl(8)](https://man.openbsd.org/mixerctl.8), and [sndioctl(1)](https://man.openbsd.org/sndioctl.1).
* Shell scripting convenience options:
    * `-n` to not output a control's name when getting/setting the value, simplifying setting shell variable values
    * `-q` to not output a control's name or value when setting the value, reducing the need to redirect output to `/dev/null`
* `-m` monitor mode which outputs the initial value of all controls and displays any change in value over time
* Getting control values does not require root privileges, but setting control values does
* Simplifies [doas(1)](https://man.openbsd.org/doas.1) and [doas.conf(5)](https://man.openbsd.org/doas.conf.5) configuration as you can more easily allow/restrict usage of recordctl(8) than the many potential parameters for sysctl(8) and rcctl(8)

## INSTALLATION & REMOVAL

### Prerequisites

* [OpenBSD 6.9](https://www.openbsd.org/69.html) or newer

Optional, if installing from this git repo:

* Git

### Install

Clone this git repository and install with `make`:

```
git clone git@github.com:morgant/recordctl.git
cd recordctl
doas make install
```

If you would like a specific unprivileged user to change recording controls without a password by executing recordctl(8) with [doas(1)](https://man.openbsd.org/doas), back up your [doas.conf(5)](https://man.openbsd.org/doas.conf) and add the following line to your `/etc/doas.conf` (replacing `<username>` with the appropriate username):

```
permit nopass <username> cmd recordctl
```

**IMPORTANT:** _Allowing an unprivileged user to change recording controls without entering a password will reduce the privacy and security of your OpenBSD system!_

### Uninstall

From the same local clone of the git repository:

```
doas make uninstall
```

## USAGE EXAMPLES

Online documentation (in the traditional sense: on a running OpenBSD system, not on the Internet) is available via the recordctl(8) manual page:

```
man recordctl
```

To show the state of all recording controls (`0` for disabled, `1` for enabled):

```
$ recordctl
record.audio=0
record.video=0
mix.monitor=0
```

To quickly toggle both audio/video recording states:

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
$ recordctl record.video
record.video=1
```

To explicitly disable just the video recording state:

```
# recordctl record.video=0
record.video=0
```

To show just the value, excluding the name, of the video recording state (useful for shell scripts):

```
$ recordctl -n record.video
0
```

To toggle both audio/video recording states without outputting the resulting state:

```
# recordctl -qt
```

To check whether an audio monitor mix, allowing recording of all the audio being output by the system, is configured in sndiod(8) server:

```
$ recordctl mix.monitor
mix.monitor=0
```

To configure an audio monitor mix in sndiod(8), appending `-m play,mon -s mon` to your existing sndiod(8) flags configured in rcctl(8) and restarting the sndiod(8) server process:

```
# recordctl mix.monitor=1
mix.monitor=1
```

If you had been running recordctl(8) in monitor mode (`-m`) prior to executing all of the above examples, it would have output as follows:

```
$ recordctl -m
record.audio=0
record.video=0
mix.monitor=0
record.audio=1  # changed
record.video=1  # changed
record.audio=0  # changed
record.video=0  # changed
record.audio=1  # changed
record.video=1  # changed
mix.monitor=1   # changed
```

## BUT, WHY?

While one can configure [sysctl.conf(5)](https://man.openbsd.org/sysctl.conf.5) to automatically enable audio and video recording in the OpenBSD kernel at boot, I do prefer the default privacy guarantee of having them disabled unless explicitly needed. That does mean I need to enable recording in the kernel before recording screencasts and voiceovers, joining web meetings and podcast recordings, etc. Of course, then remember to disable again afterwards.

It's easy to enable both audio and video recording from a terminal:

```
$ doas sysctl kern.{audi,vide}o.record=1
```

Then disable recording again when I've completed whichever task I needed it for:

```
$ doas sysctl kern.{audi,vide}o.record=0
```

That's still a fair amount to type. It's only a couple lines to insert into shell scripts, but since sysctl(8) requires root privileges (hence the use of [doas(1)](https://man.openbsd.org/doas.1)), there are further annoyances.

I can address them in one of the following ways:

1. Use doas(1) within personal, unprivileged, scripts and enter my password each time the commands are executed by the scripts (that gets annoying)
2. Execute my personal scripts with doas(1), thereby making them privileged (yikes, I don't like that!) and still having to enter my password
3. Configure my [doas.conf(5)](https://man.openbsd.org/doas.conf.5) to permit my user to execute sysctl(8) with root privileges and without requiring a password (less 'yikes!', but still far more permissive than I'm comfortable with)
4. Configure my doas.conf(5) to allow my user to use sysctl(8) to set only the `kern.audio.record` & `kern.video.record` controls with root privileges and without requiring a password (that requires four lines, one for each possible state, in `/etc/doas.conf`):  
    ```
    permit nopass myuser cmd sysctl args kern.audio.record=0
    permit nopass myuser cmd sysctl args kern.audio.record=1
    permit nopass myuser cmd sysctl args kern.video.record=0
    permit nopass myuser cmd sysctl args kern.video.record=1
    ```

That last option is the solution that makes me feel the most comfortable and safe, but it is annoying to have to cover each permutation in the configuration. At least it's just a one time thing, right?

Well, that's all without considering enabling/disabling a monitor mix in sndiod(8), which is likely to be very device specific and probably have more permutations. I've found that I can't leave a monitor mix configured all the time because some web meeting applications use the monitor mix, resulting in echo and feedback, so it is something that needs to be toggled.

Furthermore, is there a way to monitor or get notified when recording has been enabled or disabled in the kernel?

All my personal scripts were getting _quite_ complex and required _many_ additional lines of configuration in doas.conf(5)! There are scripts for screen recording & podcasting, joining web meetings, streaming to Twitch, controlling system/microphone/application sound levels via my MIDI controller, and controlling my window manager and microphone via my MIDI foot controller and pedals. Plus, all the times I just need to quickly enable/disable recording outside of a script.

So, _there's your answer_ as to why! I put the thought, effort, and time into writing one utility to simplify all of that.

Quick toggle of audio and video recording in the kernel? `doas recordctl -t`. Maybe I shouldn't have to enter my password just to toggle? I'll add `permit keepenv nopass linetrace cmd recordctl args -t` to my `/etc/doas.conf`. I really want to know when recording is enabled or disabled in the kernel? `recordctl -m`. Also, this means less maintenance of the individual scripts.

Ahhhh, much nicer!

## CHANGE LOG

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

## LICENSE

Released under the [MIT license](LICENSE).
