.validity.PTBlock <- function(object){
  if (!("matrix" %in% class(object))) stop("Not a valid PTBlock")
  if (typeof(object) != "list") stop("Not a valid PTBlock")
  if (any(unlist(lapply(object, function(x) !("PTCell" %in% class(x)))))) stop("Not a valid PTBlock")
  if (any(unlist(lapply(object, length)) != 1)) stop("Not a valid PTBlock")
  if (any(!unlist(lapply(object, validObject)))) stop("Not a valid PTBlock")
  return(TRUE)
}

setGeneric("PTBlock", function(pattern, row, track) standardGeneric("PTBlock"))
#' Select and copy a range of PTCells into a PTBlock
#'
#' Select and copy a range of [`PTCell`]s from a
#' [`PTPattern`] into a `PTBlock`. This
#' allows a more flexible approach to select and modify
#' [`PTCell`]s and paste the modified cells back into
#' a [`PTPattern`].
#'
#' Most objects in this [ProTrackR][ProTrackR-package] package are very strict in the operations
#' that are allowed, in order to guarantee validity and compatibility with
#' the original ProTracker. This makes those objects not very flexible.
#'
#' This [`PTBlock`] is not a formal S4 object, in fact you
#' can hardly call it an object at all. It is just a `matrix`, where each
#' element holds a `list` with a single [`PTCell`].
#'
#' This `matrix` is very flexible and makes it easier to select and modify
#' the cells. This flexibility comes at a cost as validity is only checked
#' at the level of the [`PTCell`]s. The `PTBlock`
#' can be pasted back into a [`PTPattern`] with the
#' [`pasteBlock`] method. At which point validity will be checked again. If your modifications
#' resulted in violation of ProTracker standards, you should not be able to
#' paste the block into a pattern.
#'
#' @rdname PTBlock
#' @name PTBlock
#' @aliases PTBlock,PTPattern,numeric,numeric-method
#' @param pattern A [`PTPattern`] object from which the
#' `PTBlock` needs to be selected.
#' @param row A `numeric` index or indices of rows that needs to be
#' copied from the `pattern` into the PTBlock.
#' @param track A `numeric` index or indices of tracks that needs to be
#' copied from the `pattern` into the PTBlock.
#' @returns Returns a `matrix` from the selected `row`s and `track`s
#' from the `pattern`. Each element in the `matrix` is a `list` holding
#' a single [`PTCell`].
#' @examples
#' data("mod.intro")
#'
#' ## in most ProTrackR methods you can only select a single row or track.
#' ## with a PTBlock your selection is more flexible.
#'
#' ## select rows 4 up to 8 and tracks 2 up to 4, from the first
#' ## pattern table in mod.intro:
#'
#' block <- PTBlock(PTPattern(mod.intro, 1), 4:8, 2:4)
#'
#' ## 'block' is now a matrix with in each a list with a PTCell.
#' ## These can now easily be accessed and modified:
#'
#' cell1 <- block[1, 1][[1]]
#'
#' print(cell1)
#' @family block.operations
#' @author Pepijn de Vries
#' @export
setMethod("PTBlock", c("PTPattern", "numeric", "numeric"), function(pattern, row, track){
  cells <- apply(pattern@data, 1, function(x){
    index <- as.list(((1:maximumTrackCount)- 1)*4 + 1)
    lapply(index, function(y) PTCell(x[y:(y+3)]))
  })
  cells <- matrix(unlist(cells), 64, byrow = TRUE)
  return(cells[row, track, drop = FALSE])
})

setGeneric("pasteBlock", function(pattern, block, row.start, track.start) standardGeneric("pasteBlock"))

#' Paste a block of PTCell data into a PTPattern
#'
#' Paste a block of [`PTCell`] data into a [`PTPattern`] at
#' a specified location.
#'
#' A [`PTBlock`] is not a formal S4 class. It is a `matrix` where
#' each element holds a `list` of a single [`PTCell`] object. As
#' explained at the [`PTBlock`] method documentation, this allows for
#' a flexible approach of manipulating [`PTCell`] objects. The
#' `pasteBlock` method allows you to paste a [`PTBlock`] back into
#' a [`PTPattern`].
#'
#' The [`PTBlock`] will be pasted at the specified location and will
#' span the number of tracks and rows that are included in the [`PTBlock`].
#' The [`PTCell`]s in the `pattern` will be replaced by those
#' of the `block`. Elements of the `bock` that are out of the range
#' of the `pattern` are not included in the `pattern`.
#' @rdname pasteBlock
#' @name pasteBlock
#' @aliases pasteBlock,PTPattern,matrix,numeric,numeric-method
#' @param pattern A [`PTPattern`] object into which the `block`
#' needs to be pasted.
#' @param block A [`PTBlock`] holding the [`PTCell`] data
#' that needs to be pasted into the `pattern`.
#' @param row.start A positive `integer` value (ranging from 1 up to 64)
#' indicating the starting position (row) in the `pattern` to paste the
#' `block` into.
#' @param track.start A positive `integer` value (ranging from 1 up to 4)
#' indicating the starting position (track) in the `pattern` to paste the
#' `block` into.
#' @returns Returns a copy of `pattern` into which `block` is pasted.
#' @examples
#' data("mod.intro")
#'
#' block <- PTBlock(PTPattern(mod.intro, 1), 1:16, 1)
#'
#' ## Do some operations using lapply (the effect
#' ## code is set to "C10"):
#' block <- matrix(lapply(block, function(x) {(effect(x) <- "C10"); x}),
#'                 nrow(block), ncol(block), byrow = TRUE)
#'
#' ## Paste block back on the same position:
#' PTPattern(mod.intro, 1) <-
#'   pasteBlock(PTPattern(mod.intro, 1), block, 1, 1)
#'
#' ## You can also paste the block anywhere you like:
#' PTPattern(mod.intro, 1) <-
#'   pasteBlock(PTPattern(mod.intro, 1), block, 49, 2)
#'
#' @family block.operations
#' @family pattern.operations
#' @author Pepijn de Vries
#' @export
setMethod("pasteBlock", c("PTPattern", "matrix", "numeric", "numeric"),
          function(pattern, block, row.start, track.start){
  row.start     <- abs(as.integer(row.start[[1]]))
  if (!(row.start %in% 1:maximumPatternTableRowCount)) stop("Invalid row starting position")
  track.start <- abs(as.integer(track.start[[1]]))
  if (!(track.start %in% 1:maximumTrackCount)) stop("Invalid row starting position")
  block         <- .PTBlock.as.raw(block)
  nrow.end      <- nrow(block)
  ntrack.end  <- ncol(block)
  if ((nrow.end + row.start) > maximumPatternTableRowCount)
    nrow.end <- maximumPatternTableRowCount - row.start + 1
  if ((ntrack.end/4 + track.start) > maximumTrackCount)
    ntrack.end <- 4*(maximumTrackCount - track.start + 1)

  pattern@data[row.start:(row.start + nrow.end - 1),
               (track.start*4 - 3):(track.start*4 + ntrack.end - 4)] <-
    block[1:nrow.end, 1:ntrack.end]
  return(pattern)
})

.PTBlock.as.raw <- function(block)
{
  # test if the block is valid:
  .validity.PTBlock(block)
  return(matrix(unlist(lapply(t(block), as.raw)),
                nrow(block), 4*ncol(block), byrow = TRUE))
}
