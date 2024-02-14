#' ProTracker Period Table
#'
#' Table of ProTracker period values and corresponding, octave, tone and fine tune
#'
#' Table of ProTracker period values used in calculating the
#' playback sampling rate of samples for specific tones.
#' These are the values that are actually used by ProTracker,
#' they cannot be calculated directly due to
#' undocumented rounding inconsistencies. This lookup table is therefore
#' a requirement.
#'
#' @docType data
#' @name period_table
#' @format a `data.frame` with fourteen columns:
#' 
#'   * The column named 'octave': `integer` value \[1,3\]
#'   * The column named 'finetune': `integer` value \[-8, 7\] used to tune a sample
#'   * The columns named 'C-' to `B-': represent the twelve (semi)tones.
#'     The values in these columns are the period values for the corresponding
#'     tone, octave and finetune.
#'
#' @family period.operations
#' @examples
#' data("period_table")
NULL

#' Paula clock table
#'
#' Table that provides audio output frequencies for the Commodore Amiga
#' original chipset.
#'
#' Paula was one of the custom chips on the original Commodore Amiga. This chip
#' was dedicated (amongst other tasks) to controlling audio playback. The
#' chip's output rate depended on the video mode used:
#' either '[PAL](https://en.wikipedia.org/wiki/PAL)'
#' or '[NTSC](https://en.wikipedia.org/wiki/NTSC)'. This table provides the
#' output rate for both video modes that can be used in calculating sample rates.
#'
#' @docType data
#' @name paula_clock
#' @format a `data.frame` with two columns:
#' 
#'   * 'frequency' A `numeric` value representing Paula's output rate in Hz.
#'   * 'video' A `character` string representing the two video modes.
#'
#' @references <https://en.wikipedia.org/wiki/Original_Chip_Set#Paula>
#' @examples
#' data("paula_clock")
NULL

#' ProTracker Funk Table
#'
#' Small list of numbers used by an obscure audio effect in ProTracker
#'
#' This dataset is included for completeness sake. It is not yet used by any
#' class, method or function in the [ProTrackR][ProTrackR-package] package. It may
#' very well be obsolete for recent ProTracker versions.
#' @docType data
#' @name funk_table
#' @format A `numeric` `vector` of length 16 holding values to be
#' used in ProTracker funk repeat effects.
#' @references <https://fossies.org/linux/uade/amigasrc/players/tracker/eagleplayers/mod32_protracker/PTK_versions.txt>
#' @examples data("funk_table")
NULL

#' Example of a PTModule object
#'
#' A [`PTModule`] object included in the package as example.
#'
#' This PTModule object is based on an original ProTracker module file
#' I've composed in the late nineteen nineties. It is used as example for many
#' of the [ProTrackR][ProTrackR-package] methods and you can use it to test your own
#' code. It can also be exported back to the original ProTracker module file
#' by using [`write.module`].
#' @docType data
#' @name mod.intro
#' @format A [`PTModule`] object containing 4
#' [`PTSample`] objects (and 27 empty `PTSample`
#' objects, adding up to the 31 samples a `PTModule` should hold) and 4
#' [`PTPattern`] objects.
#' @examples
#' data("mod.intro")
#' print(mod.intro)
#' plot(mod.intro)
#'
#' \dontrun{
#' playSample(mod.intro)
#'
#' ## Save as an original module file,
#' ## which can be played with ProTracker (or several modern audio players):
#' write.module(mod.intro, "intro.mod")
#' }
#' @author Pepijn de Vries
NULL
