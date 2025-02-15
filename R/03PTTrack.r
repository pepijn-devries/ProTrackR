validity.PTTrack <- function(object)
{
  # Data should consist of a raw maximumPatternTableRowCount x 4 matrix
  if (!all(dim(object@data) == c(maximumPatternTableRowCount, 4))) return (FALSE)
  # Data in matrix should be of type raw
  if (typeof(object@data) != "raw") return (FALSE)
  # All cell data should also be OK

  # max. 32 samples (including number 0) allowed:
  samp.num <- hiNybble(object@data[,1])*0x01 + hiNybble(object@data[,3])
  if (any(samp.num > 0x1F)) return (FALSE)

  per      <- loNybble(object@data[,1])*0x100 + as.integer(object@data[,2])
  oct      <- octave(per)

  # only octaves 1 up to 3 are allowed:
  if (any(!(oct[per != 0] %in% c(1:3)))) return (FALSE)

  # only period values from period_table are allowed:
  if (any(!(per[per != 0] %in% unlist(ProTrackR::period_table[ProTrackR::period_table$tuning == 0,
                                                              !(names(ProTrackR::period_table) %in% c("octave", "tuning"))]))))
    return (FALSE)

  return(TRUE)
}

#' The PTTrack class
#'
#' The four audio channels of the Commodore Amiga are represented as tracks
#' (the `PTTrack` class) in a [`PTPattern`].
#'
#' The Commodore Amiga original chipset supported four audio channels. Meaning
#' that audio could be played simultaneously and independently on each of these
#' channels. Two channels (2 and 3) were hardware-mixed fully to the right stereo
#' outputs and the other two (1 and 4) fully to the left stereo outputs.
#'
#' This class represents such a single channel, referred to as a track. A [`PTPattern`] is
#' composed of four such channels. As a ProTracker pattern consists of 64 rows,
#' a `PTTrack` object is also (implicitly) composed of 64
#' [`PTCell`] objects.
#'
#' Use the [`PTTrack-method`] to construct or coerce objects to a
#' `PTTrack-class` object, or to replace such an object.
#'
#' @slot data A `matrix` (64 rows, 4 columns) of class `raw`.
#' Each row implicitly represents a [`PTCell`] object, where
#' the raw data is formatted as specified at the [`PTCell-class`]
#' documentation. Use the [`PTCell-method`] to make an element of
#' a `PTTrack` object explicitly of class [`PTCell`].
#' Row numbers correspond with the row numbers of [`PTPattern`]
#' objects.
#' @name PTTrack-class
#' @rdname PTTrack-class
#' @aliases PTTrack
#' @exportClass PTTrack
#' @examples
#' data("mod.intro")
#'
#' ## Get track number 2 from pattern
#' ## number 1 of mod.intro:
#' chan1 <- PTTrack(mod.intro, 2, 1)
#'
#' ## Create a blank track:
#' chan2 <- new("PTTrack")
#'
#' ## Get two more tracks:
#' chan3 <- PTTrack(mod.intro, 1, 2)
#' chan4 <- PTTrack(mod.intro, 4, 3)
#'
#' ## combine the four tracks in a
#' ## new PTPattern:
#' patt <- PTPattern(cbind(
#'   as.character(chan1),
#'   as.character(chan2),
#'   as.character(chan3),
#'   as.character(chan4)
#' ))
#' @author Pepijn de Vries
setClass("PTTrack",
         representation(data = "matrix"),
         prototype(data = matrix(rep(as.raw(new("PTCell")),
                                     maximumPatternTableRowCount),
                                 nrow = maximumPatternTableRowCount, byrow = TRUE)),
         validity = validity.PTTrack)

#' @rdname as.character
#' @family track.operations
#' @export
setMethod("as.character", "PTTrack", function(x){
  apply(x@data, 1, function(x) as.character(new("PTCell", data = x)))
})

#' @rdname as.raw
#' @export
setMethod("as.raw", "PTTrack", function(x){
  x@data
})

#' @rdname as.raw
#' @aliases as.raw<-,PTTrack,matrix-method
#' @export
setReplaceMethod("as.raw", c("PTTrack", "matrix"), function(x, value){
  x@data <- value
  validObject(x)
  return(x)
})

#' @rdname print
#' @aliases print,PTTrack-method
#' @export
setMethod("print", "PTTrack", function(x, ...){
  print(as.character(x), ...)
})

setMethod("show", "PTTrack", function(object){
  print(object)
})

#' @rdname noteManipulation
#' @aliases noteUp,PTTrack-method
#' @export
setMethod("noteUp", "PTTrack", function(x, sample.nr){
  x@data <- t(apply(x@data, 1, function(x) noteUp(new("PTCell", data = x), sample.nr)@data))
  return (x)
})

#' @rdname noteManipulation
#' @aliases noteDown,PTTrack-method
#' @export
setMethod("noteDown", "PTTrack", function(x, sample.nr){
  x@data <- t(apply(x@data, 1, function(x) noteDown(new("PTCell", data = x), sample.nr)@data))
  return (x)
})

#' @rdname noteManipulation
#' @aliases octaveUp,PTTrack-method
#' @export
setMethod("octaveUp", "PTTrack", function(x, sample.nr){
  x@data <- t(apply(x@data, 1, function(x) octaveUp(new("PTCell", data = x), sample.nr)@data))
  return (x)
})

#' @rdname noteManipulation
#' @aliases octaveDown,PTTrack-method
#' @export
setMethod("octaveDown", "PTTrack", function(x, sample.nr){
  x@data <- t(apply(x@data, 1, function(x) octaveDown(new("PTCell", data = x), sample.nr)@data))
  return (x)
})
