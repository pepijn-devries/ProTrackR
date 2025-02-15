validity.PTCell <- function(object)
{
  if (length(object@data) != 4) return (FALSE)
  # Data in vector should be of type raw
  if (typeof(object@data) != "raw") return (FALSE)

  # max. 32 samples (including number 0) allowed:
  if (sampleNumber(object) > 0x1F) return (FALSE)

  period.value = .periodFromCell(object)
  if (period.value != 0)
  {
    # only octave 1 up to 3 allowed
    if (!(octave(period.value) %in% as.character(1:3))) return (FALSE)
    # period value should be in ProTracker period table
    if (!(period.value %in%
          unlist(ProTrackR::period_table[ProTrackR::period_table$tuning == 0,
                       !(names(ProTrackR::period_table) %in% c("octave", "tuning"))]))) return (FALSE)
  }
  return (TRUE)
}

#' The PTCell class
#'
#' The `PTCell` class is the smallest possible element of a [`PTPattern`]
#' table. It holds all information on which note to play, at which frequency,
#' with which effect and what kind of triggers or jumps should be applied.
#'
#' The `PTCell` class consists of a `vector` of four `raw` values,
#' as specified in the 'Slots' section. A cell will tell which [`PTSample`]
#' is to be played at which frequency (corresponding to a note and octave). If
#' no octave or note is specified, nothing will be played, or if a sample was
#' started to play on the same [`PTTrack`], this sample will continue
#' playing. The `PTCell` can also hold `effect()` codes which
#' can be used to add audio effects to the sample being played, change the
#' speed/tempo at which patterns are played, or trigger jumps to other positions
#' within a [`PTPattern`] or to other positions in the
#' [`patternOrder`] table.
#'
#' @slot data A `vector` of class `raw` of length 4. The `raw`
#' data is stored identical to the way it is stored in a ProTracker module
#' file. The `character` representation is easier to understand, and
#' with the [ProTrackR][ProTrackR-package] package it shouldn't be necessary to manipulate
#' the `raw` data directly.
#'
#' The structure is illustrated with an example. Let's start with a
#' `character` representation of a `PTCell` as an example: `"C-3 1B A08"`.
#' The left-hand part of this string shows that this cell will play note "C" in
#' octave 3. The middle part shows that [`PTSample`] number `0x1B = 27`
#' will be played. The right-hand part of the string shows that effect "A08"
#' will be applied (which is a volume slide down).
#'
#' The `raw` representation of this example would be `"10 d6 ba 08"`,
#' or when I replace the actual values with symbols: `"sp pp se ee"`. Where
#' `"ss"` represents the sample number, `"eee"` represents the [`effect()`]
#' code and `"ppp"` represents the period value. The correct note and octave
#' can be derived by looking up the period value in the [`period_table`]
#' (which is also implemented in the following methods: [`note()`],
#' [`octave()`] and [`periodToChar()`]).
#' The period value `0x0d6 = 214` corresponds with note "C"
#' in octave 3.
#' @name PTCell-class
#' @rdname PTCell-class
#' @aliases PTCell
#' @examples
#' data("mod.intro")
#'
#' ## get the PTCell from mod.intro at
#' ## PTPattern #1, PTTrack #1 and row #1:
#'
#' cell <- PTCell(mod.intro, 1, 1, 1)
#'
#' ## get the note of this cell:
#' note(cell)
#'
#' ## get the octave of this cell:
#' octave(cell)
#'
#' ## get the sampleNumber of this cell:
#' sampleNumber(cell)
#'
#' ## get the effect code of this cell:
#' effect(cell)
#'
#' ## get the raw data of this cell:
#' as.raw(cell)
#'
#' ## get the character representation of this cell:
#' as.character(cell)
#' @exportClass PTCell
#' @family cell.operations
#' @author Pepijn de Vries
setClass("PTCell",
         representation(data = "raw"),
         prototype(data = raw(4)),
         validity = validity.PTCell)

#' Extract and replace raw data
#'
#' Information of [`PTCell`], [`PTTrack`] and
#' [`PTPattern`] objects are stored as `raw` values. This
#' method can be used to extract and replace this raw data. [`PTModule`]
#' objects can also be converted to raw data but not replaced by it.
#'
#' A [`PTCell`] is an element of a [`PTTrack`] which
#' in turn is an element of a [`PTPattern`]. A [`PTPattern`]
#' tells a tracker which sample to play at which frequency on which of the
#' four audio channels and with which effects. A [`PTCell`] in essence
#' holds all this information as described at the documentation of
#' the [`PTCell-class`].
#'
#' Data in these objects are stored in these objects in a `raw` form,
#' to save working memory and to comply to the ProTracker file specifications
#' (see documentation of each of these classes for more details). This method
#' can be used to extract and replace raw data.
#'
#' The `PTModule` object has a more complex structure but can also be converted
#' into raw data (the way it would be stored in a ProTracker module file). However,
#' this object cannot be replaced by raw data.
#'
#' @docType methods
#' @rdname as.raw
#' @name as.raw
#' @aliases as.raw,PTCell-method
#' @aliases as.raw,PTTrack-method
#' @aliases as.raw,PTPattern-method
#' @param x A [`PTCell`], [`PTTrack`] or
#' [`PTPattern`] object, for which the raw data needs to extracted
#' or replaced. A [`PTModule`] object is also allowed, but this
#' object cannot be replaced.
#' @param value `raw` data with which the `raw` data in object
#' `x` needs to be replaced.
#'
#' If `x` is a `PTCell` object, `value`
#' should be a `vector` of four `raw` values (conform specifications
#' provided at the documentation of the [`PTCell-class`]).
#'
#' If `x` is a `PTTrack` object, `value`
#' should be a 64 by 4 `matrix` holding `raw` values (conform specifications
#' provided at the documentation of the [`PTTrack-class`]).
#'
#' If `x` is a `PTPattern` object, `value`
#' should be a 64 by 16 `matrix` holding `raw` values (conform specifications
#' provided at the documentation of the [`PTPattern-class`]).
#' @returns For `as.raw`, a length 4 vector, 64 by 4 matrix or a 64 by 16
#' matrix of `raw` data is returned, when x is of class `PTCell`,
#' `PTTrack` or `PTPattern`, respectively.
#'
#' If `x` is a `PTModule` object, the `raw` data returned will
#' have the same format as the ProTracker file format.
#'
#' For `as.raw<-`, a copy of object `x` is returned in which the
#' `raw` data is replaced by `value`.
#'
#' @examples
#' data("mod.intro")
#'
#' ## Get the raw data of the PTCell at
#' ## pattern #1, track #1 and row #1
#' ## of mod.intro:
#' as.raw(PTCell(mod.intro, 1, 1, 1))
#'
#' ## idem for PTTrack #1 of pattern #1:
#' as.raw(PTTrack(mod.intro, 1, 1))
#'
#' ## idem for PTPattern #1:
#' as.raw(PTPattern(mod.intro, 1))
#'
#' ## replace raw data of PTCell 1, 1, 1
#' ## with that of PTCell 2, 1, 1:
#' as.raw(PTCell(mod.intro, 1, 1, 1)) <-
#'   as.raw(PTCell(mod.intro, 2, 1, 1))
#'
#' @family raw.operations
#' @author Pepijn de Vries
#' @export
setMethod("as.raw", "PTCell", function(x){
  x@data
})

setGeneric("as.raw<-", function(x, value) standardGeneric("as.raw<-"))

#' @rdname as.raw
#' @name as.raw<-
#' @aliases as.raw<-,PTCell,raw-method
#' @export
setReplaceMethod("as.raw", c("PTCell", "raw"), function(x, value){
  x@data <- value
  validObject(x)
  return(x)
})

#' Character representation of ProTrackR objects
#'
#' Create a `character` representation of [`PTCell`],
#' [`PTTrack`] or [`PTPattern`] objects.
#'
#' A [`PTCell`] is an element of a [`PTTrack`] which
#' in turn is an element of a [`PTPattern`]. A [`PTPattern`]
#' tells a tracker which sample to play at which frequency on which of the
#' four audio channels and with which effects. A [`PTCell`] in essence
#' holds all this information as described at the documentation of
#' the [`PTCell-class`].
#'
#' Data in these objects are stored in these objects in a `raw` form,
#' to save working memory and to comply to the ProTracker file specifications.
#' As the raw data is not easy to interpret, this method is provided to
#' make your life (and the interpretation of the objects) easier.
#'
#' This method generates a character representation of each of the three objects.
#' These character representations can be coerced back to their original classes
#' with the following methods: [`PTCell-method`],
#' [`PTTrack-method`] and [`PTPattern-method`].
#'
#' @docType methods
#' @rdname as.character
#' @name as.character
#' @aliases as.character,PTCell-method
#' @aliases as.character,PTTrack-method
#' @aliases as.character,PTPattern-method
#' @param x An object of any of the following classes: [`PTCell`],
#' [`PTTrack`] or [`PTPattern`].
#' @returns Returns a single character string when `x` is of class
#' [`PTCell`].
#'
#' Returns a `vector` of length 64 of the type `character` when `x` is of class
#' [`PTTrack`].
#'
#' Returns a 64 by 4 `matrix` of the type `character` when `x` is of class
#' [`PTPattern`].
#' @examples
#' data("mod.intro")
#'
#' as.character(   PTCell(mod.intro, 1, 1, 1))
#'
#' as.character(PTTrack(mod.intro, 1, 1))
#'
#' as.character(PTPattern(mod.intro, 1))
#'
#' @family character.operations
#' @author Pepijn de Vries
#' @export
setMethod("as.character", "PTCell", function(x){
  paste(periodToChar(.periodFromCell(x)),
        toupper(sprintf("%02x", sampleNumber(x))),
        effect(x))
})

#' Print ProTrackR objects
#'
#' A method to print [ProTrackR][ProTrackR-package] S4 class objects.
#'
#' @docType methods
#' @rdname print
#' @name print
#' @aliases print,PTCell-method
#'
#' @param x Either a [`PTModule`], [`PTPattern`],
#' [`PTTrack`], [`PTCell`] or
#' [`PTSample`] object.
#' @param ... further arguments passed to or from other methods
#' @returns Depending on the class of `x`, returns either nothing
#' (`NULL`) or a `character` representation
#' of object `x`.
#'
#' @examples
#' data("mod.intro")
#' print(mod.intro)
#' print(PTPattern(mod.intro, 1))
#' print(PTTrack(mod.intro, 1, 1))
#' print(PTCell   (mod.intro, 1, 1, 1))
#' print(PTSample (mod.intro, 1))
#' @author Pepijn de Vries
#' @export
setMethod("print", "PTCell", function(x, ...){
  print(as.character(x), ...)
})

setMethod("show", "PTCell", function(object){
  print(object)
})

setGeneric(".periodFromCell", function(x) standardGeneric(".periodFromCell"))
setMethod(".periodFromCell", "PTCell", function(x){
  return(loNybble(x@data[1])*256 + as.integer(x@data[2]))
})

setGeneric("effect", function(x) standardGeneric("effect"))
setGeneric("effect<-", function(x, value) standardGeneric("effect<-"))

#' Extract or replace effect/trigger codes
#'
#' The 3 right-hand symbols of a `character` representation of a
#' [`PTCell`] represent an effect or trigger code. This method
#' can be used to extract or replace this code.
#'
#' When a [`PTCell`] is represented by a `character` string,
#' the last three symbols represent a hexadecimal effect or trigger code.
#' In general the first of the three symbols indicates a type of effect or
#' trigger, whereas the latter two generally indicate a magnitude or a
#' position for effects and triggers.
#'
#' Effects can for instance be volume or frequency slides. The codes can
#' also affect the module tempo or cause position jumps.
#'
#' When replacing this code, all three digit hexadecimal `character`
#' strings are accepted, although not all codes will represent a valid
#' effect or trigger. See
#' <https://wiki.openmpt.org/Manual:_Effect_Reference#MOD_Effect_Commands>
#' for a valid list of effect codes.
#' @rdname effect
#' @name effect
#' @aliases effect,PTCell-method
#' @param x A `PTCell` from which the effect code needs to be extracted.
#' @param value A `character` string containing a three hexadecimal digit
#' effect code. All hexadecimal codes are accepted, not all will produce
#' meaningful effects.
#' @returns For `effect`, a `character` string with the three hexadecimal
#' digit effect code will be returned.
#'
#' For `effect<-`, a copy of object `x` with effect code `value`
#' will be returned.
#' @examples
#' data("mod.intro")
#'
#' ## the PTCell in row #1, of pattern #1, track #1
#' ## has effect code "A08", which is a volume slide down (0xA)
#' ## with speed 0x8:
#' effect(PTCell(mod.intro, 1, 1, 1))
#'
#' ## this is how you can change an effect:
#' cell <- PTCell("C-2 01 000")
#' effect(cell) <- "C20"
#'
#' ## the above expression sets the volume (effect 0xC)
#' ## to 50% (0x20 which is halve of the maximum 0x40)
#' @author Pepijn de Vries
#' @family cell.operations
#' @export
setMethod("effect", "PTCell", function(x){
  bytes <- c(as.raw(loNybble(x@data[3])), x@data[4])
  return(substr(paste(toupper(format(bytes)), collapse = ""), 2, 4))
})

#' @rdname effect
#' @name effect<-
#' @aliases effect<-,PTCell,character-method
#' @export
setReplaceMethod("effect", c("PTCell", "character"), function(x, value){
  value <- toupper(value)[[1]]
  if (nchar(value) != 3) stop ("Value should be a character string of
                              3 hexadecimal digits.")
  if (is.na(as.integer(paste(0, value, sep = "x"))))  stop ("Value should be a character string of
                              3 hexadecimal digits.")
  nyb1 <- as.numeric(paste("0", substr(value, 1, 1), sep = "x"))
  x@data[3] <- as.raw(hiNybble(x@data[3])*0x10 + nyb1)
  x@data[4] <- as.raw(paste("0", substr(value, 2, 3), sep = "x"))
  return(x)
})

setGeneric("sampleNumber", function(x) standardGeneric("sampleNumber"))
setGeneric("sampleNumber<-", function(x, value) standardGeneric("sampleNumber<-"))

#' Extract or replace a sample number
#'
#' Extract or replace a [`PTSample`] index number from a
#' [`PTCell`] object.
#'
#' The [`PTSample`] index number in a [`PTCell`] object,
#' indicates which sample from a [`PTModule`] object needs to be played.
#' This method can be used to extract or replace this index from a
#' [`PTCell`] object.
#' @rdname sampleNumber
#' @name sampleNumber
#' @aliases sampleNumber,PTCell-method
#' @param x A `PTCell` object from which the [`PTSample`] index
#' number needs to be be extracted or replaced.
#' @param value A `numeric` replacement value for the index. Valid indices
#' range from 1 up to 31. A value of 0 can also be assigned, but will not play
#' any sample.
#' @returns For `sampleNumber`, a `numeric` value representing the
#' sample index number of object `x` is returned.
#'
#' For `sampleNumber<-`, an copy of object `x` is returned in which
#' the sample index number is replaced with `value`.
#' @examples
#' data("mod.intro")
#'
#' ## get the sample index number of PTCell at pattern #3,
#' ## track #2, row #1 from mod.intro (which is 2):
#'
#' sampleNumber(PTCell(mod.intro, 1, 2, 3))
#'
#' ## replace the sample index number of PTCell at pattern #3,
#' ## track #2, row #1 from mod.intro with 1:
#'
#' sampleNumber(PTCell(mod.intro, 1, 2, 3)) <- 1
#' @family cell.operations
#' @author Pepijn de Vries
#' @export
setMethod("sampleNumber", "PTCell", function(x){
  return (hiNybble(x@data[1])*0x10 + hiNybble(x@data[3]))
})

#' @rdname sampleNumber
#' @name sampleNumber<-
#' @aliases sampleNumber<-,PTCell,numeric-method
#' @export
setReplaceMethod("sampleNumber", c("PTCell", "numeric"), function(x, value){
  value <- as.integer(value[[1]])
  if (value < 0 || value > 0x1f) stop ("Sample number out of range [0-31]!")
  if (.periodFromCell(x) == 0 && value != 0) stop("Can't assign a sample number without a note!")
  value <- as.raw(value)
  x@data[1] <- as.raw(loNybble(x@data[1]) + hiNybble(value)*0x10)
  x@data[3] <- as.raw(loNybble(x@data[3]) + loNybble(value)*0x10)
  return(x)
})

setGeneric("octave", function(x) standardGeneric("octave"))
setGeneric("octave<-", function(x, value) standardGeneric("octave<-"))

#' Extract or replace an octave
#'
#' Obtain an octave number from a period value or extract or replace a
#' note of a [`PTCell`] object.
#'
#' Period values are used by ProTracker to set a playback sample rate
#' and in essence determine the key and octave in which a sound is played.
#' This method can be used to obtain the octave number associated with a
#' period value (according to the ProTracker [`period_table`],
#' assuming zero [`fineTune`]). If the period value is not in the
#' [`period_table`], the octave number associated with the
#' period closest to this value in the table is returned.
#'
#' The octave number can also be obtained or replaced for a
#' [`PTCell`] object.
#' @rdname octave
#' @name octave
#' @aliases octave,numeric-method
#' @param x Either a (`vector` of) numeric value(s), representing a period
#' value. It can also be a [`PTCell`] object.
#' @param value A `numeric` value representing the octave number with which
#' that of object `x` needs to be replaced. 0, 1 and 3 are valid octave
#' numbers. Use zero to disable both the note and octave for object `x`.
#'
#' Note that the octave can only be set for [`PTCell`]s for which
#' a note is already defined.
#' @returns For `octave`, a `numeric` value representing the octave number
#' is returned.
#'
#' For `octave<-`, a copy of `PTCell` object `x` in which the
#' octave number is replaced by `value` is returned.
#' @examples
#' data("mod.intro")
#'
#' ## get the octave number of PTCell at pattern #3, track #2,
#' ## row #1 from mod.intro (which is number 3):
#'
#' octave(PTCell(mod.intro, 1, 2, 3))
#'
#' ## replace the octave number of PTCell at pattern #3, track #2,
#' ## row #1 from mod.intro with 2:
#'
#' octave(PTCell(mod.intro, 1, 2, 3)) <- 2
#'
#' ## get the octave numbers associated with the period
#' ## values 200 up to 400:
#'
#' octave(200:400)
#' @author Pepijn de Vries
#' @family period.operations
#' @family note.and.octave.operations
#' @export
setMethod("octave", "numeric", function(x){
  x <- as.list(x)
  position <- lapply(x, function(x){
    if (x == 0) return (-1)
    mins <- abs(as.matrix(ProTrackR::period_table[,-1:-2]) - x)
    which(mins == min(mins))
  })
  position <- lapply(position, function(x){
    if (any(x == -1)) return (0)
    row <- (x - 1)%%nrow(ProTrackR::period_table)
    ft <- ProTrackR::period_table$tuning[row + 1]
    row <- row[abs(ft) == min(abs(ft))]
    row <- min(row)
    return(1 + row%%3)
  })
  return (unlist(position))
})

#' @rdname octave
#' @aliases octave,PTCell-method
#' @export
setMethod("octave", "PTCell", function(x){
  return(octave(.periodFromCell(x)))
})

#' @rdname octave
#' @name octave<-
#' @aliases octave<-,PTCell,numeric-method
#' @export
setReplaceMethod("octave", c("PTCell", "numeric"), function(x, value){
  value <- as.integer(value)
  if (value < 0 || value > 3) stop ("Octave out of range [0-3].")
  nt <- note(x)
  if (value == 0) nt <- "--"
  period <- unsignedIntToRaw(noteToPeriod(paste(nt, value, sep = "")), 2)
  x@data[1] <- as.raw(hiNybble(x@data[1])*0x10 + loNybble(period[1]))
  x@data[2] <- period[2]
  return(x)
})

setGeneric("note", function(x) standardGeneric("note"))
setGeneric("note<-", function(x, value = c("C-", "C#", "D-",
                                           "D#", "E-", "F-",
                                           "F#", "G-", "G#",
                                           "A-", "A#", "B-", "--")){
  standardGeneric("note<-")
})

#' Extract or replace a note
#'
#' Obtain a note from a period value or extract or replace a note of a
#' [`PTCell`] object.
#'
#' Period values are used by ProTracker to set a playback sample rate and in
#' essence determine the key in which a sound is played. This method can be used
#' to obtain the note (key) associated with a period value (according to the
#' ProTracker [`period_table`], assuming zero [`fineTune`]).
#' If the period value is not in the [`period_table`], the note associated
#' with the period closest to this value in the table is returned.
#'
#' The note can also be obtained or replaced for a [`PTCell`] object.
#' @rdname note
#' @name note
#' @aliases note,numeric-method
#' @param x Either a (`vector` of) numeric value(s), representing a period
#' value. It can also be a [`PTCell`] object.
#' @param value A `character` string representing the chromatic scale note
#' with which the current note needs to be replaced. Should have any of the following values:
#' `"C-"`, `"C#"`, `"D-"`, `"D#"`, `"E-"`, `"F-"`,
#' `"F#"`, `"G-"`, `"G#"`, `"A-"`, `"A#"`, `"B-"`,
#' or `"--"`.
#' Right-hand dashes can be omitted from these strings. Both upper and lower case are
#' accepted.
#'
#' If an [`octave`] is not yet specified for `PTCell` `x`,
#' it will be set to 1.
#'
#' Assigning a value of `"--"` will remove both the note and octave from
#' object `x`.
#' @returns For `note`, a `character` string representing the note
#' is returned.
#'
#' For `note<-`, a copy of `PTCell` object `x` in which the
#' note is replaced by `value` is returned.
#' @examples
#' data("mod.intro")
#'
#' ## get the note of PTCell at pattern #3, track #2,
#' ## row #1 from mod.intro (which is note "C-"):
#'
#' note(PTCell(mod.intro, 1, 2, 3))
#'
#' ## replace the note of PTCell at pattern #3, track #2,
#' ## row #1 from mod.intro with "A-":
#'
#' note(PTCell(mod.intro, 1, 2, 3)) <- "A-"
#'
#' ## get the notes associated with the period
#' ## values 200 up to 400:
#'
#' note(200:400)
#'
#' @family period.operations
#' @family note.and.octave.operations
#' @family cell.operations
#' @author Pepijn de Vries
#' @export
setMethod("note", "numeric", function(x){
  x <- as.list(x)
  position <- lapply(x, function(x){
    if (x == 0) return (-1)
    mins <- abs(as.matrix(ProTrackR::period_table[,-1:-2]) - x)
    which(mins == min(mins))
  })
  position <- lapply(position, function(x){
    if (any(x == -1)) return("--")
    row <- (x - 1)%%nrow(ProTrackR::period_table)
    col <- floor((x - 1)/nrow(ProTrackR::period_table))
    ft  <- ProTrackR::period_table$tuning[row + 1]
    col <- col[abs(ft) == min(abs(ft))]
    col <- min(col)
    return(names(ProTrackR::period_table)[-1:-2][1 + col])
  })
  return (unlist(position))
})

#' @rdname note
#' @aliases note,PTCell-method
#' @export
setMethod("note", "PTCell", function(x){
  return(note(loNybble(x@data[1])*256 + as.numeric(x@data[2])))
})

#' @rdname note
#' @name note<-
#' @aliases note<-,PTCell,character-method
#' @export
setReplaceMethod("note", c("PTCell", "character"), function(x, value){
  value <- toupper(value)
  value[nchar(value) == 1] <- paste(value[nchar(value) == 1], "-", sep = "")
  value <- match.arg(value)
  if (value == "--") oct <- 0 else oct    <- octave(x)
  if (value != "--" && oct == 0) oct <- 1
  period <- unsignedIntToRaw(noteToPeriod(paste(value, oct, sep = "")), 2)
  x@data[1] <- as.raw(hiNybble(x@data[1])*0x10 + loNybble(period[1]))
  x@data[2] <- period[2]
  return(x)
})

setGeneric("noteUp", function(x, sample.nr = "all") standardGeneric("noteUp"))

#' Raise or lower notes and octaves
#'
#' Methods to raise or lower notes in [`PTCell`],
#' [`PTTrack`] and [`PTPattern`] objects.
#'
#' @rdname noteManipulation
#' @name noteUp
#' @aliases noteUp,PTCell-method
#' @param x A [`PTCell`], [`PTTrack`] or
#' [`PTPattern`] object for which the notes need to be lowered
#' or raised.
#' @param sample.nr A single positive `integer` value, or a `vector` of
#' positive `integer`s, listing the indices of samples, for which the notes
#' need to be lowered or raised. A `character` string equal to `"all`"
#' is also allowed (this is in fact the default), in which case notes of all
#' sample indices are raised or lowered.
#' @returns Returns an object of the same class as object `x`, in which
#' the notes for samples selected with `sample.nr` are raised or lowered.
#'
#' In case raised or lowered notes would lead to notes that are out of
#' ProTracker's range, the returned notes remain unchanged.
#' @examples
#'
#' ## raise note from C-2 to C#2:
#' noteUp(PTCell("C-2 01 000"))
#'
#' @author Pepijn de Vries
#' @family note.and.octave.operations
#' @export
setMethod("noteUp", "PTCell", function(x, sample.nr){
  if (sample.nr[[1]] != "all")
  {
    sample.nr <- abs(as.integer(sample.nr))
    if (!(sampleNumber(x) %in% sample.nr)) return (x)
  }
  note   <- note(.periodFromCell(x))
  if (note == "--") return (x)
  octave <- octave(.periodFromCell(x))
  notes  <- names(ProTrackR::period_table)[-1:-2]
  index  <- which(notes %in% note)
  note   <- notes[((index) %% 12) + 1]
  octave <- octave + as.integer(index/12)
  if (octave > 3) return(x)
  x <- PTCell(paste(note, octave, sprintf("%02x", sampleNumber(x)), effect(x)))
  return(x)
})

setGeneric("noteDown", function(x, sample.nr = "all") standardGeneric("noteDown"))

#' @rdname noteManipulation
#' @name noteDown
#' @aliases noteDown,PTCell-method
#' @examples
#'
#' ## lower note from C-2 to B-1:
#' noteDown(PTCell("C-2 01 000"))
#'
#' @export
setMethod("noteDown", "PTCell", function(x, sample.nr){
  if (sample.nr[[1]] != "all")
  {
    sample.nr <- abs(as.integer(sample.nr))
    if (!(sampleNumber(x) %in% sample.nr)) return (x)
  }
  note   <- note(.periodFromCell(x))
  if (note == "--") return (x)
  octave <- octave(.periodFromCell(x))
  notes  <- names(ProTrackR::period_table)[-1:-2]
  index  <- which(notes %in% note)
  note   <- notes[((index - 2) %% 12) + 1]
  octave <- octave - as.integer(1 - (index - 1)/11)
  if (octave < 1) return (x)
  x <- PTCell(paste(note, octave, sprintf("%02x", sampleNumber(x)), effect(x)))
  return(x)
})

setGeneric("octaveUp", function(x, sample.nr = "all") standardGeneric("octaveUp"))

#' @rdname noteManipulation
#' @name octaveUp
#' @aliases octaveUp,PTCell-method
#' @examples
#'
#' ## raise note from octave 2 to octave 3:
#' octaveUp(PTCell("C-2 01 000"))
#'
#' @export
setMethod("octaveUp", "PTCell", function(x, sample.nr){
  if (sample.nr[[1]] != "all")
  {
    sample.nr <- abs(as.integer(sample.nr))
    if (!(sampleNumber(x) %in% sample.nr)) return (x)
  }
  oct <- octave(x) + 1
  if (oct > 3) return (x)
  octave(x) <- oct
  return(x)
})

setGeneric("octaveDown", function(x, sample.nr = "all") standardGeneric("octaveDown"))

#' @rdname noteManipulation
#' @name octaveDown
#' @aliases octaveDown,PTCell-method
#' @examples
#'
#' ## lower note from octave 2 to octave 1:
#' octaveDown(PTCell("C-2 01 000"))
#'
#' @export
setMethod("octaveDown", "PTCell", function(x, sample.nr){
  if (sample.nr[[1]] != "all")
  {
    sample.nr <- abs(as.integer(sample.nr))
    if (!(sampleNumber(x) %in% sample.nr)) return (x)
  }
  oct <- octave(x) - 1
  if (oct < 1) return (x)
  octave(x) <- oct
  return(x)
})
