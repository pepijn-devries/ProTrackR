#' Convert MODPlug pattern into a PTPattern object
#'
#' Convert pattern data from text or clipboard, originating from the modern
#' MODPlug tracker and convert it into a \code{PTPattern} or \code{PTBlock}
#' object.
#'
#' The Open MODPlug Tracker (\url{https://www.openmpt.org}) is a modern
#' music tracker that is for free. It too can handle ProTracker modules.
#' This function assists in moving pattern data from Open MPT to R.
#'
#' Simply select and copy the pattern data to the system's clipboard
#' and use this function to import it to R as a \code{\link{PTPattern}} or
#' \code{\link{PTBlock}} object.
#'
#' @param text A \code{vector} of \code{character}s, representing MOD pattern data
#' obtained from OpenMPT. If set to \code{NULL} (default), the text will be read
#' from the system's clipboard.
#' @param what A \code{character} string that indicates what type of object
#' should be returned. Can be "PTPattern" or "PTBlock".
#' @return Depending on the value of the argument \code{what}, it will
#' return either a \code{\link{PTPattern}} or \code{\link{PTBlock}} object.
#'
#' @name MODPlugToPTPattern
#' @rdname MODPlugToPTPattern
#' @examples
#' \dontrun{
#' ## This is what Mod Plug Pattern data looks like on
#' ## the systems clipboard:
#' modPlugPattern <- c("ModPlug Tracker MOD",
#'                     "|C-601...A08|C-602...C40|A#403...F06|A#504......",
#'                     "|...01...A08|C-602...C30|........A01|........A02",
#'                     "|...01...A08|C-602......|........A01|C-604......",
#'                     "|...........|C-602......|........A02|........A02",
#'                     "|...01...A08|C-602......|........120|D-604......",
#'                     "|...........|A#504...C08|........A02|........A02",
#'                     "|...01...A08|C-602......|........220|D#604......",
#'                     "|...........|A#504...C08|........A01|........A02",
#'                     "|...01...A08|C-602......|........A01|F-604......",
#'                     "|...........|A#604...C08|........A01|........A02",
#'                     "|...01...A08|C-602......|........A01|D#604......",
#'                     "|...........|G-604...C08|........A01|........A02",
#'                     "|G-601......|C-602......|........A01|D-604......",
#'                     "|........A08|F-604...C08|...........|........A02",
#'                     "|F-601......|C-602......|...........|C-604......",
#'                     "|........A08|A#504...C08|...........|........A02",
#'                     "|C-601...A08|C-602...C40|A#403...F06|A#504......",
#'                     "|...01...A08|C-602...C30|........A01|........A02",
#'                     "|...01...A08|C-602......|........A01|D-604......",
#'                     "|...........|C-602......|........A02|........A02",
#'                     "|...01...A08|C-602......|........120|F-504......",
#'                     "|...........|A#504...C08|........A02|........A02",
#'                     "|...01...A08|C-602......|........220|G-504......",
#'                     "|...........|A#504...C08|........A01|........A02",
#'                     "|...01...A08|C-602......|........A01|A#504......",
#'                     "|...........|A#604...C08|........A01|........A01",
#'                     "|...01...A08|C-602......|........A01|...........",
#'                     "|...........|G-604...C08|........A01|........A01",
#'                     "|G-501......|C-602......|........A01|...........",
#'                     "|........A08|F-504...C08|...........|........A01",
#'                     "|A-501......|C-602......|...........|...........",
#'                     "|........A08|G-504...C08|...........|........A01",
#'                     "|E-601...A08|C-602...C40|D-503......|D-604......",
#'                     "|...01...A08|C-602...C30|........A01|........A02",
#'                     "|...01...A08|C-602......|........A01|E-604......",
#'                     "|...........|C-602......|........A02|........A02",
#'                     "|...01...A08|C-602......|........126|F#604......",
#'                     "|...........|D-604...C08|........A02|........A02",
#'                     "|...01...A08|C-602......|........226|G-604......",
#'                     "|...........|E-604...C08|........A01|........A02",
#'                     "|...01...A08|C-602......|........A01|A-604......",
#'                     "|...........|D-604...C08|........A01|........A02",
#'                     "|...01...A08|C-602......|........A01|G-604......",
#'                     "|...........|D-604...C08|........A01|........A02",
#'                     "|B-601......|C-602......|........A01|F#604......",
#'                     "|........A08|D-604...C08|...........|........A02",
#'                     "|A-601......|C-602......|...........|E-604......",
#'                     "|........A08|E-504...C08|...........|........A02",
#'                     "|D-601...A08|C-602...C40|C-503......|C-604......",
#'                     "|...01...A08|C-602...C30|........A01|........A02",
#'                     "|...01...A08|C-602......|........A01|D-604......",
#'                     "|...........|C-602......|........A02|........A02",
#'                     "|...01...A08|C-602......|........12B|E-604......",
#'                     "|...........|G-604...C08|........A02|........A02",
#'                     "|...01...A08|C-602......|........22B|F-604......",
#'                     "|...........|G-604...C08|........A01|........A02",
#'                     "|...01...A08|C-602......|........A01|G-604......",
#'                     "|...........|E-604...C08|........A01|........A02",
#'                     "|...01...A08|C-602......|........A01|F-604......",
#'                     "|...........|C-604...C08|........A01|........A02",
#'                     "|A-601......|C-602......|........A01|E-604......",
#'                     "|........A08|G-604...C08|...........|........A02",
#'                     "|G-601......|F-604...C08|...........|D-604......",
#'                     "|........A08|C-604...C08|...........|........A02")
#'
#' ## You could read it directly from the clipboard,
#' ## by leaving text NULL (default). Here we provide
#' ## the text specified above:
#' pat <- MODPlugToPTPattern(modPlugPattern, "PTPattern")
#'
#' ## look it is a "PTPattern" object now:
#' class(pat)
#'
#' ## we can also only import the first 10 lines as a
#' ## PTBlock:
#' blk <- MODPlugToPTPattern(modPlugPattern[1:10], "PTBlock")
#' }
#' @author Pepijn de Vries
#' @family MODPlug.operations
#' @family pattern.operations
#' @export
MODPlugToPTPattern <- function(text = NULL, what = "PTPattern") {
  what <- match.arg(what, c("PTPattern", "PTBlock"))
  if (is.null(text)) {
    text <- readLines("clipboard")
  } else {
    if (typeof(text) != "character") stop("argument 'text' should be a vector of characters.")
  }
  if (text[[1]] != "ModPlug Tracker MOD") warning("The text does not seem to represent OpenMPT MOD data")

  result <- utils::read.table(text = text[-1], sep = "|", comment.char = "'")[,-1]
  # replace dots and spaces by dashes:
  result <- gsub(" ", "-", as.matrix(result), fixed = T)
  result <- gsub(".", "-", as.matrix(result), fixed = T)

  # remove information that is not used by ProTracker
  result <- apply(result, 2, function(x) paste0(substr(x, 1, 5), substr(x, 9, 11)))

  # MODPlug octave numbers are offset by 3 compared to ProTracker:
  result <- suppressWarnings(apply(result, 2, function(x) paste0(substr(x, 1, 2),
                                                                 as.integer(substr(x, 3, 3)) - 3,
                                                                 substr(x, 4, 8))))
  result <- gsub("NA", "-", result, fixed = T)
  result <- apply(result, 2, function(x) paste0(substr(x, 1, 3),
                                                gsub("-", "0", substr(x, 4, 8), fixed = T)))

  # MODPlug uses decimal numbers to represent sample numbers
  # ProTracker uses hexadecimals:
  result <- suppressWarnings(apply(result, 2, function(x) paste0(substr(x, 1, 3),
                                                                 sprintf("%02X", as.integer(substr(x, 4, 5))),
                                                                 substr(x, 6, 8))))
  result <- gsub("NA", "--", result, fixed = T)

  result <- apply(result, 1, function(x){
    lapply(1:length(x), function(y) PTCell(x[y]))
  })
  result <- matrix(unlist(result), length(result), byrow = T)

  if (what == "PTPattern") {
    pat <- new("PTPattern")
    pat <- pasteBlock(pat, result, 1, 1)
    result <- pat
  }

  return(result)
}

#' Convert PTPattern data into a MODPlug pattern
#'
#' Use a \code{\link{PTPattern}} or \code{\link{PTBlock}} to create
#' a pattern table with a MODPlug flavour.
#'
#' The Open MODPlug Tracker (\url{https://www.openmpt.org}) is a modern
#' music tracker that is for free. It too can handle ProTracker modules.
#' This function assists in moving pattern data from R to Open MPT.
#'
#' @param x Either a \code{\link{PTPattern}} object or a
#' \code{\link{PTBlock}} object from which an Open
#' MODPlug Tracker pattern should be created.
#' @param to.clipboard A \code{logical} value, indicating whether the
#' result should be copied to the system's clipboard (\code{TRUE}) or
#' should be returned as a \code{vector} of \code{character}s
#' (\code{FALSE}).
#' @return Returns an invisible \code{NULL} when
#' argument \code{to.clipboard} is set to \code{TRUE}.
#' Returns an Open MODPlug Tracker flavoured pattern table as
#' a \code{vector} of \code{character}s when it is set to \code{FALSE}.
#'
#' @name PTPatternToMODPlug
#' @rdname PTPatternToMODPlug
#' @examples
#' \dontrun{
#' ## get some pattern data
#'
#' pattern <- PTPattern(mod.intro, 1)
#'
#' ## Now create a MODPlug pattern from this.
#' ## The result is placed on the system clipboard.
#' ## You can check by pasting it into a text
#' ## editor, or better yet, the MODPlug Tracker.
#'
#' PTPatternToMODPlug(pattern)
#'
#' ## If you want to handle the pattern data
#' ## in R:
#'
#' patModPlug <- PTPatternToMODPlug(pattern, F)
#'
#' ## We can do the same with a block:
#'
#' block <- PTBlock(pattern, 1:10, 2:3)
#' PTPatternToMODPlug(block)
#' }
#' @author Pepijn de Vries
#' @family MODPlug.operations
#' @family pattern.operations
#' @export
PTPatternToMODPlug <- function(x, to.clipboard = T) {
  if (class(x) != "PTPattern" && !.validity.PTBlock(x)) stop ("x is neither a PTPattern nor a PTBlock object.")
  # convert the information that is provided into a matrix of characters
  # and work with that.
  if (class(x) != "PTPattern") {
    pat <- as.character(x)
  } else {
    pat <- apply(x, 2, function(y) unlist(lapply(y, function(z) as.character(z))))
  }
  pat <- gsub(" ", "", pat, fixed = T)
  pat <- suppressWarnings(apply(pat, 2, function(y) paste0(substr(y, 1, 2),
                                                                 as.character(as.integer(substr(y, 3, 3)) + 3),
                                                                 substr(y, 4, 8))))
  pat <- gsub("NA", "-", pat, fixed = T)
  pat <- suppressWarnings(apply(pat, 2, function(y) paste0(substr(y, 1, 3),
                                                           sprintf("%02i", as.integer(paste0("0x", substr(y, 4, 5)))),
                                                           substr(y, 6, 8))))
  pat <- gsub("NA", "--", pat, fixed = T)
  pat <- gsub("(?!\\A)\\G0|(?=0{2,})0", ".", pat, perl = T)
  pat <- gsub("(?!\\A)\\G-|(?=-{2,})-", ".", pat, perl = T)
  pat <- apply(pat, 2, function(y) paste0(substr(y, 1, 5), "...", substr(y, 6, 8)))
  pat <- apply(pat, 2, function(y) paste0("|", y))
  pat <- apply(pat, 1, paste0, collapse = "")
  pat <- c("ModPlug Tracker MOD", pat)
  if (to.clipboard) {
    writeLines(pat, "clipboard")
    return(invisible(NULL))
  } else {
    return(pat)
  }
}
