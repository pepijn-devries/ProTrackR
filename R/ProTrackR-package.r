#' Manipulate and play ProTracker Modules. A description of the package,
#' ProTracker effect commands and test cases.
#'
#' The ProTrackR package can import and export module files from the music tracker
#' ProTracker from the Commodore Amiga machine. This package can also render
#' and play module files. Furthermore, the package provides the means to manipulate and analyse
#' the modules.
#'
#' ProTracker is a popular music tracker to sequence music on a Commodore
#' Amiga machine. This package offers the opportunity to import, export, manipulate
#' an play ProTracker module files. Even though the file format could be considered
#' archaic, it still remains popular to this date. This package intends to contribute
#' to this popularity and therewith keeping the legacy of ProTracker and the
#' Commodore Amiga alive.
#'
#' Some experience with ProTracker (or any other
#' music tracker) will promote the ease of use of this package. However,
#' the provided documentation and exernal links should help you,
#' when you're starting from scratch. A good place to start reading
#' this manual would be the documentation of the [`PTModule-class`],
#' which describes the structure of a ProTracker module and how it is
#' implemented in this package. You should also have a look at the documentation
#' of the [`PTPattern`], [`PTTrack`], [`PTCell`] and
#' [`PTSample`] classes, which are all elements of the
#' [`PTModule`].
#' @section Current issues and future developments:
#' For the development state of this package, please check the
#' [README section on GitHub](https://pepijn.devries.github.com/ProTrackR/).
#'
#' Currently, not all effect commands are implemented, although most common
#' ones are. I will work on implementing the remaining effect commands (see
#' also section below). ProTracker also has specific interpretations that
#' are currently not all implemented correctly.
#'
#' Sample switching (that is when a module switches from one sample number
#' to another, without specifying a new note) is also something that is implemented
#' differently by varying module players. This package currently does not implement
#' such switches conform ProTracker specs.
#'
#' Period values, which dictate at which fequency samples should be played, are
#' censored both by Amiga hardware and software coded limits in the original
#' ProTracker. Documentation on these limits are ambiguous. I've made a first
#' attempt to implement these bounds in the current version of the
#' package after consulting with Olav
#' S\ifelse{latex}{\out{{\o}}}{\ifelse{html}{\out{&oslash;}}{o}}rensen (who created
#' a ProTracker clone for modern machines: <https://16-bits.org/pt.php>).
#' I'm really grateful for his input and doing some checks on an actual
#' Amiga.
#'
#' I also realise that the documentation of this package may be a bit cryptic
#' at some points. I would like to improve it where I can, but for that I need a
#' fresh perspective from the users. So please feel free to provide constructive
#' feedback such that I can improve the quality of this package.
#' @section ProTracker Effect Commands:
#' As explained before, effect commands are composed of a three hexadecimal digits.
#' The first digit indicates the type of effect, trigger or jump that should be applied,
#' the latter two digits indicate the magnitude of the effect. An exception are
#' commands starting with the digit 'E', for which the first two digits specify
#' the type of effect and only the last digit represents the magnitude. Below
#' all available effect commands (or codes if you will) are listed with the
#' magnitudes labelled 'x' or 'xy'. The overview shows which commands are used
#' for which kind of effect and whether it is implemented (between brackets) in
#' the playing routines of this package.
#' 
#' But first a few words on speed and tempo in ProTracker. Both are two sides of
#' the same coin, both affect the overall speed with which patterns are played.
#' Speed is defined as the number of 'ticks' per pattern row and tempo sets
#' the duration of each tick.
#' So by increasing the speed value, or decreasing the tempo, the overall playing
#' speed of the pattern table is reduced. At the default tempo of 125, the duration
#' of a tick equals the vertical blank period of the monitor (1/50 seconds for PAL
#' and 1/60 seconds NTSC video systems). They can be set with the Fxy command.
#'
#' On the Commodore Amiga the chip responsible for audio output (Paula),
#' the audio playback of samples can be controlled by the user in two ways:
#' the playback rate of the sample can be changed by specifying 'period'
#' values (see e.g. [`periodToSampleRate`]) and specifying a
#' volume which is linearly scaled between 0 (silent) and 64 (maximum).
#' Period and volumes can only be changed at the start of each tick. This is
#' why the effects will be affected by the speed setting, but not the tempo.
#' 
#' And now, without further ado, the overview of effect commands:
#' | Code | Effect | Description | Status |
#' | ---- | ------ | ----------- | ------ |
#' | 0xy | Arpeggio | This effect alternates the pitch each tick to simulate a chord. xy needs to be greater then 00. First the specified note is played, then the pitch is increased with x semitones, then with y semitones. | Partly implemented |
#' | 1xy | Porta up | Decrease the period value with xy every tick but the first. | Implemented |
#' | 2xy | Porta down | Increase the period value with xy every tick but the first. | Implemented |
#' | 3xy | Porta to note | Change the period value with xy every tick but the first, untill the specified target note is reached. | Implemented |
#' | 4xy | Vibrato | Oscillate the pitch with magnitude x. Where y relates to the oscillation frequency. | Implemented |
#' | 5xy | Porta to note + Volume slide | A combination of effects 3xy and Axy. | Implemented |
#' | 6xy | Vibrato + Volume slide | A combination of effects 4xy and Axy. | Implemented |
#' | 7xy | Tremolo | Oscillate the volume with magnitude x. Where y relates to the oscillation frequency. | Implemented |
#' | 8xy | Not implemented | This effect command is not implemented in ProTracker, nor will it be in this package. | Not implemented |
#' | 9xy | Set sample offset | This effect causes the note to start playing at an offset (of 256 times xy samples) into the sample, instead of just from the start. | Implemented |
#' | Axy | Volume slide | Change the volume every but the first tick: increase with x, decrease with y. | Implemented |
#' | Bxy | Position jump | Jump to position xy of the [`patternOrder`] table. | Implemented |
#' | Cxy | Set volume | Set the volume with xy. | Implemented |
#' | Dxy | Pattern break | Break to row xy in the next pattern. Note: xy is (even though it is a hexadecimal) interpreted as a decimal. | Implemented |
#' | E0x | Turn filter on/off | If x is even, the (emulated) hardware filter is turned on (for all tracks). It is turned off if x is odd. | Implemented |
#' | E1x | Porta up (fine) | The period value is decreased with x, at the first tick. | Implemented |
#' | E2x | Porta down (fine) | The period value is increased with x, at the first tick. | Implemented |
#' | E3x | Glissando Control | This effect causes a change in the effect 3xy (porta to note).  It toggles whether to do a smooth slide or whether to slide in jumps of semitones. When x is 0 it uses a smooth slide, non-zero values will result in jumps. | Not yet implemented |
#' | E4x | Vibrato Waveform | This effect sets the waveform for the vibrato command to follow. With x modulo 4 equals 0, a sine wave is used, with 1 ramp down, with 2 or 3 a square wave. Values greater than 4 causes the ossicating waveform not to retrigger it when a new note is played. | Implemented |
#' | E5x | Set finetune | Set the finetune with x, where x is interpreted as a signed nybble. | Partly implemented |
#' | E6x | Pattern loop | Set pattern loop start with E60, and loop x times when x is non-zero. | Implemented |
#' | E7x | Tremolo waveform | Same as E4x, but this controls the wave form for the tremolo effect (7xy) rather then the vibrato effect. | Implemented |
#' | E8x | Not implemented | According to official documentation this command is not implemented in ProTracker, but it is. Applies a filter on a looped sample, therewith destroying the original sample data. | Not implemented |
#' | E9x | Retrigger note | Retrigger the note every x-th tick. | Implemented |
#' | EAx | Volume slide up (fine) | Increase the volume with x at the first tick. | Implemented |
#' | EBx | Volume slide down (fine) | Decrease the volume with x at the first tick. | Implemented |
#' | ECx | Cut note | Cut the volume of the note to zero after x ticks. | Implemented |
#' | EDx | Delay note | The note is triggered with a delay of x ticks. | Implemented |
#' | EEx | Pattern delay | The duration of the row in ticks is multiplied by (x + 1). | Implemented |
#' | EFx | Not implemented | According to official documentation this command is not implemented in ProTracker, but it is. It flips sample data in a looped sample, therewith destroying the original sample data. | Not implemented |
#' | Fxy | Set speed or tempo | When xy is smaller then 32, it sets the speed in ticks per row. When xy is greater then 31, it will set the tempo, wich is inversely related to the duration of each tick. Speed and tempo can be defined in combination. | Implemented |
#' @section Test cases:
#' The interpretation of the effect commands can be tedious. They often vary
#' between module players. Even ProTracker can have a quirky (and unexpected) ways
#' of handling the effect commands. This package aims at staying as close to
#' ProTracker 'standards' as possible.
#'
#' The current version already implements most effect commands and common quirks
#' when it comes to their interpretation. My subjective estimate is that it will
#' correctly play roughly 95% of the ProTracker modules on [ModArchive](https://modarchive.org). Some
#' Less common unexpected behaviour is documented by the team behind [OpenMPT](https://wiki.openmpt.org/Main_Page), for which they developed
#' several test cases. The table below shows which test cases this package passes
#' and which it does not.
#' | Test module | Status |
#' | ----------- | ------ |
#' | [AmigaLimitsFinetune.mod](https://wiki.openmpt.org/Development:_Test_Cases/MOD#AmigaLimitsFinetune.mod) | Fail |
#' | [ArpWraparound.mod](https://wiki.openmpt.org/Development:_Test_Cases/MOD#ArpWraparound.mod) | Fail |
#' | [DelayBreak.mod](https://wiki.openmpt.org/Development:_Test_Cases/MOD#DelayBreak.mod) | Pass |
#' | [finetune.mod](https://wiki.openmpt.org/Development:_Test_Cases/MOD#finetune.mod) | Fail |
#' | [PatLoop-Break.mod](https://wiki.openmpt.org/Development:_Test_Cases/MOD#PatLoop-Break.mod) | Pass |
#' | [PatternJump.mod](https://wiki.openmpt.org/Development:_Test_Cases/MOD#PatternJump.mod) | Pass |
#' | [PortaSmpChange.mod](https://wiki.openmpt.org/Development:_Test_Cases/MOD#PortaSmpChange.mod) | Fail |
#' | [PortaTarget.mod](https://wiki.openmpt.org/Development:_Test_Cases/MOD#PortaTarget.mod) | Pass |
#' | [PTInstrSwap.mod](https://wiki.openmpt.org/Development:_Test_Cases/MOD#PTInstrSwap.mod) | Fail |
#' | [ptoffset.mod](https://wiki.openmpt.org/Development:_Test_Cases/MOD#ptoffset.mod) | Pass |
#' | [PTSwapEmpty.mod](https://wiki.openmpt.org/Development:_Test_Cases/MOD#PTSwapEmpty.mod) | Fail |
#' | [VibratoReset.mod](https://wiki.openmpt.org/Development:_Test_Cases/MOD#VibratoReset.mod) | Pass |
#'
#' @aliases EffectCommands
#' @references
#' Some basic information on ProTracker:
#' <https://en.wikipedia.org/wiki/Protracker>
#'
#' Some basic information on music trackers in general:
#' <https://en.wikipedia.org/wiki/Music_tracker>
#'
#' A tutorial on ProTracker on YouTube:
#' <https://www.youtube.com/playlist?list=PLVoRT-Mqwas9gvmCRtOusCQSKNQNf6lTc>
#'
#' Some informal but extensive technical documentation on ProTracker:
#' <ftp://ftp.modland.com/pub/documents/format_documentation/Protracker%20effects%20(FireLight)%20(.mod).txt>
#' @importFrom audio play wait
#' @importFrom graphics plot
#' @importFrom lattice xyplot
#' @importFrom methods as new validObject
#' @importFrom signal butter filter
#' @importFrom stats aggregate approx
#' @importFrom tuneR MCnames mono readMP3 readWave Wave WaveMC writeWave
#' @importFrom utils installed.packages URLencode
#' @keywords internal
"_PACKAGE"
NULL
