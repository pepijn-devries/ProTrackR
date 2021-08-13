#' Manipulate and play ProTracker Modules
#'
#' The ProTrackR package can import and export module files from the music tracker
#' ProTracker from the Commodore Amiga machine. This package can also simply
#' play audio samples from the module, more complex playing routines are in
#' development. The package does provide the means to manipulate and analyse
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
#' this manual would be the documentation of the \code{\link{PTModule-class}},
#' which describes the structure of a ProTracker module and how it is
#' implemented in this package. You should also have a look at the documentation
#' of the \code{\link{PTPattern}}, \code{\link{PTTrack}}, \code{\link{PTCell}} and
#' \code{\link{PTSample}} classes, which are all elements of the
#' \code{\link{PTModule}}.
#' @section Future developments:
#' This package is far from perfect, but it is in such a state that it can
#' be useful to others, and have therefore published it. There's much room
#' for improvement and I intend to work on that.
#' However, as I'm working on this project in my spare time, developments
#' may not move forwards as fast as I'd like them to, or may eventually even
#' come to a halt. Keeping this disclaimer in mind, there is one major
#' revision I will try to work on the coming time (next to some minor ones).
#'
#' Obviously a decent player and mixing routing is currently missing and is
#' on my top wish list. This means there is a lot to do, especially when
#' I want the audio to be emulated accurately. I will probably implement
#' these routines in phases. I hope to soon add a preliminary method for
#' playing (or at least generating audio files from) modules.
#'
#' This method will at first hopefully just play the right samples at the
#' right speed/tempo in the right order and at the right frequency.
#' Then I hoop to properly implement the effects. Also, the channels need
#' to be mixed, hopefully in a way that is at least comparable to what
#' the Commodore Amiga does. The developments listed above may also progress
#' in parallel.
#'
#' This preliminary method will be published as such, for testing purposes.
#' Once I'm happy with the result this method will become deprecated and
#' replaced by a final version of the method.
#'
#' I also realise that the documentation of this package may be a bit cryptic
#' at some points. I would like to improve it where I can, but for that I need a
#' fresh perspective from the users. So please feel free to provide constructive
#' feedback such that I can improve the quality of this package.
#' @docType package
#' @name ProTrackR
#' @author Pepijn de Vries
#' @references
#' Some basic information on ProTracker:
#' \url{https://en.wikipedia.org/wiki/Protracker}
#'
#' Some basic information on music trackers in general:
#' \url{https://en.wikipedia.org/wiki/Music_tracker}
#'
#' A tutorial on ProTracker on YouTube:
#' \url{https://www.youtube.com/playlist?list=PLVoRT-Mqwas9gvmCRtOusCQSKNQNf6lTc}
#' @importFrom audio play wait
#' @importFrom lattice xyplot
#' @importFrom methods as new validObject
#' @importFrom seewave resamp
#' @importFrom tuneR Wave readWave readMP3 writeWave
#' @importFrom utils tail
#' @importFrom graphics plot
NULL
