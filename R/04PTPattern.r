validity.PTPattern <- function(object)
{
  # Data should consist of a raw maximumPatternTableRowCount x maximumTrackCount*4 matrix
  if (!all(dim(object@data) == c(maximumPatternTableRowCount, maximumTrackCount*4))) return (FALSE)
  # data should be of type raw
  if (typeof(object@data) != "raw") return (FALSE)
  # tracks should also be OK
  trackdat <- do.call(rbind, lapply(as.list(1:maximumTrackCount), function (x) {
    object@data[,-3 + ((x*4):(x*4 + 3))]
  }))
  # max. 32 samples (including number 0) allowed:
  samp.num <- hiNybble(trackdat[,1])*0x01 + hiNybble(trackdat[,3])
  if (any(samp.num > 0x1F)) return (FALSE)

  per      <- loNybble(trackdat[,1])*0x100 + as.integer(trackdat[,2])
  oct      <- octave(per)

  # only octaves 1 up to 3 are allowed:
  if (any(!(oct[per != 0] %in% c(1:3)))) return (FALSE)

  # only period values from period_table are allowed:
  if (any(!(per[per != 0] %in% unlist(ProTrackR::period_table[ProTrackR::period_table$tuning == 0,
                                                    !(names(ProTrackR::period_table) %in% c("octave", "tuning"))]))))
      return (FALSE)

  return(TRUE)
}

#' The PTPattern class
#'
#' The `PTPattern` (or simply pattern) is a table that determines which
#' samples are played at which notes in which octave, in which order and with
#' which effects.
#'
#' When a `PTPattern` table (or simply pattern) is played, each of the 64
#' rows (see the green mark in the illustration below for an example of a row)
#' are played subsequently at a specified speed/tempo.
#'
#' Note that ProTracker uses row indices that start at zero. However, this package
#' uses indices starting at one, conform R language definitions.
#'
#' \if{html}{\figure{patterntable.png}{Pattern Table}}
#' \if{latex}{\figure{patterntable.pdf}{options: width=6in}}
#'
#' The table has four columns (see the purple outline in the illustration
#' above as an example of a column), representing the four audio channels ([`PTTrack`])
#' of the Commodore Amiga. Samples listed in the same row at different
#' tracks will be played simultaneously.
#'
#' An element at a specific row and track will be referred to as a [`PTCell`]
#' (or simply cell). The cell determines which sample needs to be played at
#' which note and octave and what kind of [`effect`] or trigger should
#' be applied.
#'
#' With the [`PTPattern-method`], objects can be coerced to a pattern
#' table. This method can also be used to extract or replace patterns in
#' [`PTModule`] objects.
#'
#' @slot data A `matrix` (64 rows, 16 columns) of class `raw`.
#' Each row contains the `raw` concatenated data of 4 [`PTCell`] objects,
#' representing each of the 4 audio channels/tracks (as each [`PTCell`] object holds
#' 4 `raw` values, each row holds 4 x 4 = 16 `raw`
#' values). The `raw` data is formatted conform the specifications given
#' in the [`PTCell`] documentation.
#' @name PTPattern-class
#' @rdname PTPattern-class
#' @aliases PTPattern
#' @exportClass PTPattern
#' @family pattern.operations
#' @author Pepijn de Vries
setClass("PTPattern",
         representation(data = "matrix"),
         prototype(data = matrix(raw(maximumPatternTableRowCount*maximumTrackCount*4),
                                 ncol = maximumTrackCount*4,
                                 nrow = maximumPatternTableRowCount, byrow = TRUE)),
         validity = validity.PTPattern)

#' @rdname as.character
#' @export
setMethod("as.character", "PTPattern", function(x){
  result <- NULL
  for (i in 1:maximumTrackCount)
  {
    result <- cbind(result, apply(PTTrack(x, i)@data, 1, function(x) as.character(new("PTCell", data = x))))
  }
  return(result)
})

#' @rdname as.raw
#' @export
setMethod("as.raw", "PTPattern", function(x){
  x@data
})

#' @rdname as.raw
#' @aliases as.raw<-,PTPattern,matrix-method
#' @export
setReplaceMethod("as.raw", c("PTPattern", "matrix"), function(x, value){
  x@data <- value
  validObject(x)
  return(x)
})

#' @rdname print
#' @aliases print,PTPattern-method
#' @export
setMethod("print", "PTPattern", function(x, ...){
  print(as.character(x), ...)
})

setMethod("show", "PTPattern", function(object){
  print(object)
})

#' @rdname noteManipulation
#' @aliases noteUp,PTPattern-method
#' @export
#' @examples
#'
#' data("mod.intro")
#'
#' ## Raise the notes of all cells in pattern
#' ## number 2 of mod.intro:
#' noteUp(PTPattern(mod.intro, 2))
#'
#' ## Raise only the notes of sample number 4
#' ## in pattern number 2 of mod.intro:
#' noteUp(PTPattern(mod.intro, 2), 4)
#'
#' ## Raise only the notes of samples number 2 and 4
#' ## in pattern number 2 of mod.intro:
#' noteUp(PTPattern(mod.intro, 2), c(2, 4))
#'
setMethod("noteUp", "PTPattern", function(x, sample.nr){
  for (i in 1:maximumTrackCount)
  {
    x@data[,(i*4):(i*4 + 3) - 3] <- noteUp(PTTrack(x, i), sample.nr)@data
  }
  return (x)
})

#' @rdname noteManipulation
#' @aliases noteDown,PTPattern-method
#' @export
setMethod("noteDown", "PTPattern", function(x, sample.nr){
  for (i in 1:maximumTrackCount)
  {
    x@data[,(i*4):(i*4 + 3) - 3] <- noteDown(PTTrack(x, i), sample.nr)@data
  }
  return (x)
})

#' @rdname noteManipulation
#' @aliases octaveUp,PTPattern-method
#' @export
setMethod("octaveUp", "PTPattern", function(x, sample.nr){
  for (i in 1:maximumTrackCount)
  {
    x@data[,(i*4):(i*4 + 3) - 3] <- octaveUp(PTTrack(x, i), sample.nr)@data
  }
  return (x)
})

#' @rdname noteManipulation
#' @aliases octaveDown,PTPattern-method
#' @export
setMethod("octaveDown", "PTPattern", function(x, sample.nr){
  for (i in 1:maximumTrackCount)
  {
    x@data[,(i*4):(i*4 + 3) - 3] <- octaveDown(PTTrack(x, i), sample.nr)@data
  }
  return (x)
})
