validity.PTSample <- function(object)
{
  if (length(object@name)       != 22)                 return(FALSE)
  if (length(object@finetune)   != 1)                  return(FALSE)
  if (length(object@volume)     != 1)                  return(FALSE)
  if (length(object@wloopstart) != 2)                  return(FALSE)
  if (length(object@wlooplen)   != 2)                  return(FALSE)
  if (2*rawToUnsignedInt(object@wloopstart) > length(object@left))   return(FALSE)
  if ((2*(rawToUnsignedInt(object@wlooplen) +
          rawToUnsignedInt(object@wloopstart)) > length(object@left)) &&
      rawToUnsignedInt(object@wlooplen) != 1)       return(FALSE)
  # loop length can only be zero when the sample is empty
  if (rawToUnsignedInt(object@wlooplen) == 0 &&
      length(object@left) > 0)                         return(FALSE)
  if (object@bit != 8)                                 return(FALSE)
  if (!object@pcm)                                     return(FALSE)
  if (as.integer(object@volume)   > 0x40)              return(FALSE)
  if (as.integer(object@finetune) > 0x0F)              return(FALSE)
  if (length(object@right) > 0)                        return(FALSE)
  if (length(object@left)  > 2*0xFFFF)                 return(FALSE)
  # sample length should be even!
  if ((length(object@left)%%2) == 1)                   return(FALSE)
  return (TRUE)
}

#' The PTSample class
#'
#' This class holds audio fragments with meta-information, to be used in
#' [`PTModule`] objects.
#'
#' This class holds audio fragments with meta-information (so-called samples),
#' to be used in [`PTModule`] objects. This class extends
#' the [`tuneR::Wave`] class from [`tuneR::tuneR`]. It therewith inherits
#' all properties and cool methods available from the [`tuneR::tuneR`] package.
#' This allows you, for instance, to generate power spectra ([`tuneR::powspec`])
#' of them. You can also plot the waveform with the [`plot-Wave`][tuneR::plot_Wave_channel] method.
#' See [`tuneR::tuneR`] for all possibilities with [`tuneR::Wave`]
#' objects.
#' If you want you can also explicitly coerce [`PTSample`] to
#' [`tuneR::Wave`] objects like this: `as(new("PTSample"), "Wave")`.
#'
#' The [`PTSample`] class has some slots that are additional to the
#' [`tuneR::Wave`] class, as ProTracker requires additional information on
#' the sample with respect to its name, fine tune, volume and loop positions.
#' The [`PTSample`] class restricts the enherited [`tuneR::Wave`]
#' class such that it will only hold 8 bit, mono, pcm waves with a maximum of
#' `2*0xffff = 131070` samples, as per ProTracker standards. The length should
#' always be even.
#'
#' `PTSample`s can be imported and exported using the
#' [`read.sample`] and [`write.sample`] methods respectively.
#' [`tuneR::Wave`] objects and `raw` data can be coerced to
#' `PTSample`s with the [`PTSample-method`].
#'
#' @slot name A `vector` of length 22 of class `raw`, representing
#' the name of the `PTSample`. It is often used to include
#' descriptive information in a [`PTModule`]. The name
#' of a sample can be extracted or replaced with the [`name`] method.
#' @slot finetune Single value of class `raw`. The [`loNybble`]
#' of the `raw` value, represents the sample fine tune value ranging from -8 up to
#' 7. This value is used to tweak the playback sample rate, in order to tune it.
#' Negative values will lower the sample rate of notes, positive values will
#' increase the sample rate of notes. Period values corresponding to specific
#' notes and fine tune values are stored in the [`period_table`].
#' The fine tune value can be extracted or replace with the [`fineTune`]
#' method.
#' @slot volume Single value of class `raw`. The raw data corresponds with
#' the default playback volume of the sample. It ranges from 0 (silent) up to
#' 64 (maximum volume). The volume value can be extracted or replaced with the
#' [`volume`] method.
#' @slot wloopstart A `vector` of length 2 of class `raw`. The `raw`
#' data represent a single unsigned number representing the starting position of
#' a loop in the sample. It should have a value of `0` when there is no loop.
#' Its value could range from `0` up to `0xffff`. To get the actual position
#' in bytes the value needs to be multiplied with 2 and can therefore only be
#' can only be even. The sum of the loop start position and the loop length should
#' not exceed the [`sampleLength`]. Its value can be extracted or
#' replaced with the [`loopStart`] method.
#' @slot wlooplen A `vector` of length 2 of class `raw`. The `raw`
#' data represent a single unsigned number representing the length of
#' a loop in the sample. To get the actual length in bytes, this value needs to
#' be multiplied by 2 and can therefore only be even. It should have a value of
#' `2` when there is no loop.
#' Its value could range from `2` up to `2*0xffff` (= `131070`) and
#' can only be even (it can be `0` when the sample is empty). The sum of the
#' loop start position and the loop length should
#' not exceed the [`sampleLength`]. Its value can be extracted or
#' replaced with the [`loopLength`] method.
#' @slot left Object of class `numeric` representing the waveform of the
#' left channel. Should be `integer` values ranging from 0 up to 255.
#' It can be extracted or replaced with the [`waveform`] method.
#' @slot right Object of class `numeric` representing the right channel.
#' This slot is inherited from the [`tuneR::Wave`] class and should be
#' `numeric(0)` for all `PTSample`s, as they are all mono.
#' @slot stereo Object of class `logical` whether this is a stereo representation.
#' This slot is inherited from the [`tuneR::Wave`] class. As
#' `PTSample`s are always mono, this slot should have the value `FALSE`.
#' @slot samp.rate Object of class `numeric` representing the sampling rate.
#' @slot bit Object of class `numeric` representing the bit-wise quality.
#' This slot is inherited from the [`tuneR::Wave`] class. As
#' `PTSample`s are always of 8 bit quality, the value of this slot
#' should always be 8.
#' @slot pcm Object of class `logical` indicating whether wave format is PCM.
#' This slot is inherited from the [`tuneR::Wave`] class, for
#' `PTSample`s its value should always be `TRUE`.
#'
#' @name PTSample-class
#' @rdname PTSample-class
#' @aliases PTSample
#' @family sample.operations
#' @author Pepijn de Vries
#' @exportClass PTSample
setClass("PTSample",
         representation(name       = "raw",
                        finetune   = "raw",
                        volume     = "raw",
                        wloopstart = "raw",
                        wlooplen   = "raw"),
         prototype(name       = raw(22),
                   finetune   = raw(1),
                   volume     = as.raw(0x40),
                   wloopstart = raw(2),
                   wlooplen   = raw(2),
                   samp.rate  = 16574.28, #can't seem to be able to call a function (noteToSampleRate) from the constructor
                   bit        = 8,
                   stereo     = FALSE),
         contains = "Wave",
         validity = validity.PTSample)

#' Resample data
#'
#' Resample `numeric` data to a different rate.
#'
#' This function resamples `numeric` data (i.e., audio data) from a
#' source sample rate to a target sample rate. At the core it uses
#' the [`stats::approx`] function.
#' @rdname resample
#' @name resample
#' @param x A `numeric` `vector` that needs to be resampled.
#' @param source.rate The rate at which `x` was sampled in Hz (or
#' another unit, as long as it is in the same unit as `target.rate`).
#' @param target.rate The desired target sampling rate in Hz (or
#' another unit, as long as it is in the same unit as `source.rate`).
#' @param ... Arguments passed on to [`stats::approx`].
#' To simulate the Commodore Amiga hardware, it's best to
#' use '`method = "constant"` for resampling 8 bit samples.
#' @returns Returns a resampled `numeric` `vector` of length
#' `round(length(x) * target.rate / source.rate)` based on `x`.
#' @examples
#' some.data <- 1:100
#'
#' ## assume that the current (sample) rate
#' ## of 'some.data' is 100, and we want to
#' ## resample this data to a rate of 200:
#' resamp.data <- resample(some.data, 100, 200, method = "constant")
#' @author Pepijn de Vries
#' @export
resample <- function(x, source.rate, target.rate, ...)
{
  x <- as.numeric(x)
  source.rate <- as.numeric(source.rate[[1]])
  target.rate <- as.numeric(target.rate[[1]])
  if (source.rate <= 0) stop ("Source rate should be greater than 1.")
  if (target.rate <= 0) stop ("Target rate should be greater than 1.")
  xout <- seq(1, length(x) + 1, length.out = round(length(x)*target.rate/source.rate))
  return(stats::approx(x, xout = xout, rule = 2, ...)[[2]])
}

setGeneric("fineTune", def = function(sample) standardGeneric("fineTune"))
setGeneric("fineTune<-", def = function(sample, value) standardGeneric("fineTune<-"))

#' Fine tune a PTSample
#'
#' Extract or replace the fine tune value of a [`PTSample`].
#'
#' [`PTSample`]s can be tuned with their fine tune values.
#' The values range from -8 up to 7 and affect the playback sample rate of
#' specific notes (see [`period_table`]). This method can be used
#' to extract this value, or to safely replace it.
#'
#' @docType methods
#' @rdname fineTune
#' @name fineTune
#' @aliases fineTune,PTSample-method
#' @param sample A [`PTSample`] for which the fine tune value
#' needs to be extracted or replace.
#' @param value A `numeric` value ranging from -8 up to 7, representing
#' the fine tune.
#' @returns For `fineTune` the fine tune value, represented by an
#' `integer` value ranging from -8 up to 7, is returned.
#'
#' For `fineTune<-` A [`PTSample`] `sample`, updated
#' with the fine tune `value`, is returned.
#' @examples
#' data("mod.intro")
#'
#' ## get the finetune of the first sample of mod.intro:
#'
#' fineTune(PTSample(mod.intro, 1))
#'
#' ## Let's tweak the finetune of the first sample of
#' ## mod.intro to -1:
#'
#' fineTune(PTSample(mod.intro, 1)) <- -1
#'
#' @family sample.operations
#' @author Pepijn de Vries
#' @export
setMethod("fineTune", "PTSample", function(sample){
  return(nybbleToSignedInt(sample@finetune))
})

#' @rdname fineTune
#' @name fineTune<-
#' @aliases fineTune<-,PTSample,numeric-method
#' @export
setReplaceMethod("fineTune", c("PTSample", "numeric"), function(sample, value){
  sample@finetune <- signedIntToNybble(value[[1]])
  return(sample)
})

setGeneric("volume", function(sample) standardGeneric("volume"))
setGeneric("volume<-", function(sample, value) standardGeneric("volume<-"))

#' Default playback volume of PTSample
#'
#' Extract or replace the default volume of a [`PTSample`].
#'
#' [`PTSample`]s have a default playback volume, ranging from
#' `0` (silent) up to 64 (maximum volume). This method can be used
#' to extract this value, or to safely replace it.
#'
#' @docType methods
#' @rdname volume
#' @name volume
#' @aliases volume,PTSample-method
#' @param sample A [`PTSample`] for which the default volume
#' needs to be extracted or replace.
#' @param value A `numeric` value ranging from 0 up to 64, representing
#' the volume level.
#' @returns For `volume` the volume value, represented by an
#' `integer` value ranging from 0 up to 64, is returned.
#'
#' For `volume<-` A [`PTSample`] `sample`, updated
#' with the volume `value`, is returned.
#' @examples
#' data("mod.intro")
#'
#' ## get the volume of the first sample of mod.intro:
#'
#' volume(PTSample(mod.intro, 1))
#'
#' ## Let's lower the volume of this sample to 32
#' ## (or as a hexadecimal: 0x20):
#'
#' volume(PTSample(mod.intro, 1)) <- 0x20
#'
#' @family sample.operations
#' @author Pepijn de Vries
#' @export
setMethod("volume", "PTSample", function(sample){
  return(rawToUnsignedInt(sample@volume))
})

#' @rdname volume
#' @name volume<-
#' @aliases volume<-,PTSample,numeric-method
#' @export
setReplaceMethod("volume", c("PTSample", "numeric"), function(sample, value){
  value <- as.integer(value[[1]])
  if (value < 0 || value > 64) stop("Volume out of range [0-64]!")
  sample@volume <- as.raw(value)
  return (sample)
})

setGeneric("loopStart", function(sample) standardGeneric("loopStart"))
setGeneric("loopStart<-", function(sample, value) standardGeneric("loopStart<-"))

#' The loop start position of a PTSample
#'
#' Extract or replace the loop start position of a [`PTSample`].
#'
#' [`PTSample`]s can have loops, marked by a starting position
#' and length of the loop (in samples), for more details see the
#' [`PTSample-class`]. This method can be used to extract
#' the loop starting position or safely replace its value.
#'
#' @docType methods
#' @rdname loopStart
#' @name loopStart
#' @aliases loopStart,PTSample-method
#' @param sample A [`PTSample`] for which the loop start position
#' needs to be extracted or replace.
#' @param value An even `numeric` value giving the loop starting position in
#' samples ranging from 0 up to 131070. The sum of the [`loopStart`] and
#' [`loopLength`] should not exceed the [`sampleLength`].
#'
#' Use a `value` of either `character` `"off"` or `logical`
#' `FALSE`, in order to turn off the loop all together.
#' @returns For `loopStart` the loop start position (in samples), represented by
#' an even `integer` value ranging from 0 up to 131070, is returned.
#'
#' For `loopStart<-` A [`PTSample`] `sample`, updated
#' with the loop start position ``value`', is returned.
#' @examples
#' data("mod.intro")
#'
#' ## get the loop start position of the
#' ## first sample of mod.intro:
#'
#' loopStart(PTSample(mod.intro, 1))
#'
#' ## Let's change the starting position of
#' ## the loop to 500
#'
#' loopStart(PTSample(mod.intro, 1)) <- 500
#'
#' ## Let's turn off the loop all together:
#'
#' loopStart(PTSample(mod.intro, 1)) <- FALSE
#'
#' @family sample.operations
#' @family loop.methods
#' @author Pepijn de Vries
#' @export
setMethod("loopStart", "PTSample", function(sample){
  return(2*rawToUnsignedInt(sample@wloopstart))
})

#' @rdname loopStart
#' @name loopStart<-
#' @aliases loopStart<-,PTSample-method
#' @export
setReplaceMethod("loopStart", c("PTSample", "ANY"), function(sample, value){
  value <- value[[1]]
  if (is.na(value) || value == "off" || (is.logical(value) && value == FALSE))
  {
    sample@wloopstart <- unsignedIntToRaw(0, 2)
    sample@wlooplen <- unsignedIntToRaw(1, 2)
  } else
  {
    value <- as.integer(round(value/2))
    if (value < 0 || value > (0xffff)) stop("Loop start out of range [0-(2*0xffff)]!")
    if ((value + rawToUnsignedInt(sample@wlooplen))*2 > length(sample@left)) stop("Loop start plus length is greater than sample length")
    sample@wloopstart <- unsignedIntToRaw(value, 2)
  }
  return (sample)
})

setGeneric("loopLength", function(sample) standardGeneric("loopLength"))
setGeneric("loopLength<-", function(sample, value) standardGeneric("loopLength<-"))

#' The loop length of a PTSample
#'
#' Extract or replace the loop length of a [`PTSample`].
#'
#' [`PTSample`]s can have loops, marked by a starting position
#' and length of the loop (in samples), for more details see the
#' [`PTSample-class`]. This method can be used to extract
#' the loop length or safely replace its value.
#'
#' @docType methods
#' @rdname loopLength
#' @name loopLength
#' @aliases loopLength,PTSample-method
#' @param sample A [`PTSample`] for which the loop length
#' needs to be extracted or replace.
#' @param value An even `numeric` value giving the loop length in
#' samples ranging from 2 up to 131070 (It can be 0 when the sample is
#' empty). The sum of the [`loopStart`] and
#' [`loopLength`] should not exceed the [`sampleLength`].
#'
#' Use a `value` of either `character` `"off"` or `logical`
#' `FALSE`, in order to turn off the loop all together.
#' @returns For `loopLength` the loop length (in samples), represented by
#' an even `integer` value ranging from 0 up to 131070, is returned.
#'
#' For `loopLength<-` A [`PTSample`] `sample`, updated
#' with the loop length `value`, is returned.
#' @examples
#' data("mod.intro")
#'
#' ## get the loop length of the
#' ## first sample of mod.intro:
#'
#' loopLength(PTSample(mod.intro, 1))
#'
#' ## Let's change the length of
#' ## the loop to 200
#'
#' loopLength(PTSample(mod.intro, 1)) <- 200
#'
#' ## Let's turn off the loop all together:
#'
#' loopLength(PTSample(mod.intro, 1)) <- FALSE
#'
#' @family loop.methods
#' @family sample.operations
#' @author Pepijn de Vries
#' @export
setMethod("loopLength", "PTSample", function(sample){
  return(2*rawToUnsignedInt(sample@wlooplen))
})

#' @rdname loopLength
#' @name loopLength<-
#' @aliases loopLength<-,PTSample-method
#' @export
setReplaceMethod("loopLength", c("PTSample", "ANY"), function(sample, value){
  value <- value[[1]]
  value <- as.integer(round(value/2))
  if (is.na(value) || value == "off" || value == FALSE)
  {
    sample@wloopstart <- unsignedIntToRaw(0, 2)
    sample@wlooplen <- unsignedIntToRaw(1, 2)
    if (length(sample@left) == 0) sample@wlooplen <- unsignedIntToRaw(0, 2)
  } else
  {
    if (value == 0 && length(sample) == 0)
      sample@wlooplen <- unsignedIntToRaw(0, 2)
    else
    {
      if (value < 1|| value > (0xffff)) stop("Loop length out of range [1 - (2*0xffff)]!")
      if (value > 1 && (value + rawToUnsignedInt(sample@wloopstart))*2 > length(sample@left)) stop("Loop start plus length is greater than sample length")
      sample@wlooplen <- unsignedIntToRaw(value, 2)
    }
  }
  return (sample)
})

setMethod("show", "PTSample", function(object){
  print(object)
})

#' @rdname print
#' @aliases print,PTSample-method
#' @export
setMethod("print", "PTSample", function(x, ...){
  cat("\nPTSample Object:\n")
  cat(paste("\tSample name:" , rawToCharNull(x@name), "\n", sep = "\t\t\t"))
  cat(paste("\tSample length (samples):", length(x@left), "\n", sep = "\t"))
  cat(paste("\tSample length (seconds):", length(x@left)/noteToSampleRate(), "\n", sep = "\t"))
  cat(paste("\tSample volume (0-64):", as.integer(x@volume), "\n", sep = "\t\t"))
  cat(paste("\tLoop start position:", 2*rawToUnsignedInt(x@wloopstart), "\n", sep = "\t\t"))
  cat(paste("\tLoop length:", 2*rawToUnsignedInt(x@wlooplen), "\n", sep = "\t\t\t"))
  cat(paste("\tFinetune:", fineTune(x), "\n", sep = "\t\t\t"))
})

setGeneric("playSample", function(x, silence = 0, wait = TRUE,
                                  note = "C-3", loop = 1, ...){
  standardGeneric("playSample")
})

#' Play audio samples
#'
#' Method to play [`PTSample`]s or all such samples from
#' [`PTModule`] objects as audio.
#'
#' This method plays [`PTSample`]s and such samples from
#' [`PTModule`] objects, using the [`audio::play`] method
#' from the audio package. Default [`fineTune`] and [`volume`]
#' as specified for the [`PTSample`] will be applied when playing
#' the sample.
#' @rdname playSample
#' @name playSample
#' @aliases playSample,PTSample-method
#' @param x Either a [`PTSample`] or a [`PTModule`] object.
#' In the latter case, all samples in the module will be played in order.
#' @param silence Especially for short samples, the [`audio::play`] routine
#' can be a bit buggy: playing audible noise, ticks or parts from other samples at the end of the sample.
#' By adding silence after the sample, this problem is evaded. Use this argument
#' to specify the duration of this silence in seconds. When, `x` is a
#' [`PTModule`] object, the silence will also be inserted in
#' between samples.
#' @param wait A `logical` value. When set to `TRUE` the playing
#' routine will wait with executing any code until the playing is finished.
#' When set to `FALSE`, subsequent R code will be executed while playing.
#' @param note A `character` string specifying the note to be used for
#' calculating the playback sample rate (using [`noteToSampleRate`]).
#' It should start with the note (ranging from `A' up to `G') optionally followed
#' by a hash sign (`#') if a note is sharp (or a dash (`-') if it's not) and finally
#' the octave number (ranging from 1 up to 3). A valid notation would for instance
#' be 'F#3'.
#' The [`fineTune`] as specified for the sample will also be used as
#' an argument for calculating the playback rate. A custom `finetune`
#' can also be passed as an argument to [`noteToSampleRate`].
#' @param loop A positive `numeric` indicating the duration of a looped
#' sample in seconds. A looped sample will be played at least once, even if
#' the specified duration is less than the sum of [`loopStart`]
#' position and the [`loopLength`].
#' See [`loopStart`] and [`loopLength`] for details on how
#' to set (or disable) a loop.
#' @param ... Further arguments passed on to [`noteToSampleRate`].
#' Can be used to change the video mode, or finetune argument for the call to that method.
#' @returns Returns nothing but plays the sample(s) as audio.
#' @examples
#' if (interactive()) {
#'   data("mod.intro")
#'
#'   ## play all samples in mod.intro:
#'   playSample(mod.intro, 0.2, loop = 0.5)
#'
#'   ## play a chromatic scale using sample number 3:
#'   for (note in c("A-2", "A#2", "B-2", "C-3", "C#3",
#'                  "D-3", "D#3", "E-3", "F-3", "F#3",
#'                  "G-3", "G#3"))
#'   {
#'     playSample(PTSample(mod.intro, 3), note = note, silence = 0.05, loop = 0.4)
#'   }
#'
#'   ## play the sample at a rate based on a specific
#'   ## video mode and finetune:
#'   playSample(PTSample(mod.intro, 3), video = "NTSC", finetune = -5)
#' }
#' @author Pepijn de Vries
#' @family sample.operations
#' @family sample.rate.operations
#' @family play.audio.routines
#' @export
setMethod("playSample", "PTSample", function(x, silence, wait, note, loop, ...){
  finetune <- fineTune(x)
  vl <- volume(x)/0x40
  silence <- abs(as.numeric(silence[[1]]))
  wait <- as.logical(wait[[1]])
  note <- as.character(note[[1]])
  loop <- abs(as.numeric(loop[[1]]))
  if (loop == 0) stop ("'loop' should be greater than 0.")
  wf <- NULL
  if ("finetune" %in% names(list(...)))
    sr <- noteToSampleRate(note, ...)
  else
    sr <- noteToSampleRate(note, finetune, ...)
  if (loopState(x))
  {
    n_samp <- round(loop*sr)
    if (loopStart(x) + loopLength(x) > n_samp) n_samp <- loopStart(x) + loopLength(x)
    wf <- loopSample(x, n_samples = n_samp)
  }
  x <- as(x, "Wave")
  if (!is.null(wf)) x@left <- wf
  rm(wf)
  x@samp.rate <- sr
  if(silence > 0) x <- tuneR::bind(x,
                                   silence(silence, samp.rate = sr,
                                           bit = 8, pcm = TRUE, xunit = "time"))
  if (wait)
  {
    audio::wait(audio::play(vl*(x@left - 128)/128,
                            rate = sr))
  } else
  {
    audio::play(vl*(x@left - 128)/128,
                rate = sr)
  }
  invisible()
})

setGeneric("read.sample", function(filename, what = c("wav", "mp3", "8svx", "raw")) standardGeneric("read.sample"))

#' Read an audio file and coerce to a PTSample object
#'
#' Reads audio files from "wav" and "mp3" files, using [`tuneR::tuneR`]
#' methods. Commodore Amiga native formats "8svx" and "raw" can also be read.
#'
#' This method provides a wrapper for the [`tuneR::readWave`] and
#' [`tuneR::readMP3`] methods from [`tuneR::tuneR`]. It also
#' provides the means to import audio from file formats native to the Commodore
#' Amiga. Simple [8svx](https://en.wikipedia.org/wiki/8SVX) files (also known
#' as "iff" files) can be read. This uses the [`AmigaFFH::read.iff`] method
#' from the [`AmigaFFH::AmigaFFH`] package.
#' It was also common practice to store audio samples as raw data on the
#' Commodore Amiga, where each byte simply represented a signed integer value
#' of the waveform.
#'
#' All audio will be coerced to 8 bit mono with a maximum length of
#' `2*0xffff` = `131070` bytes (= samples) as per ProTracker standards.
#' @rdname read.sample
#' @name read.sample
#' @aliases read.sample,character-method
#' @param filename A `character` string representing the filename to be read.
#' @param what A `character` string indicating what type of file is to be
#' read. Can be one of the following: `"wav"` (default), `"mp3"`,
#' `"8svx"` or `"raw"`. The `AmigaFFH` package needs to be
#' installed in order to read 8svx files.
#' @returns Returns a `PTSample` object based on the file read.
#' @examples
#' data("mod.intro")
#'
#' f <- tempfile(fileext = ".iff")
#' ## create an audio file which we can then read:
#' write.sample(PTSample(mod.intro, 2), f, "8svx")
#'
#' ## read the created sample:
#' snare <- read.sample(f, "8svx")
#' print(snare)
#'
#' @note As per ProTracker standards, a sample should have an even length
#' (in bytes). If a sample file has an odd length, a `raw` `0x00` value
#' is added to the end.
#' @family sample.operations
#' @author Pepijn de Vries
#' @family io.operations
#' @export
setMethod("read.sample", c("character", "ANY"), function(filename, what = c("wav", "mp3", "8svx", "raw")){
  samp_name <- substr(basename(filename), 1, 22)
  if (match.arg(what) == "wav")
  {
    result <- tuneR::readWave(filename, from = 1, to = 2*0xffff)
    result <- PTSample(result)
    name(result) <- samp_name
    return(result)
  }
  if (match.arg(what) == "mp3")
  {
    result <- tuneR::readMP3(filename)
    result <- PTSample(result)
    name(result) <- samp_name
    return(result)
  }
  readRaw <- function (con)
  {
    result <- NULL
    repeat
    {
      l1 <- length(result)
      result <- c(result, readBin(con, "raw", 1024, endian = "big"))
      l2 <- length(result)
      if ((l2 - l1) < 1024 || length(result) > 2*0xffff) break
    }
    if (length(result) > 2*0xffff)
    {
      warning("Sample is too long. It is clipped!")
      result <- result[1:(2*0xffff)]
    }
    # length should be even:
    if ((length(result) %% 2) == 1)
    {
      result <-  c(result, raw(0))
    }
    return(result)
  }
  if (match.arg(what) == "8svx")
  {
    if (!("AmigaFFH" %in% utils::installed.packages())) stop("You need to install package 'AmigaFFH' in order to load 8svx files.")
    result <- AmigaFFH::read.iff(filename)
    samp.name <- raw(22)
    try(samp.name <- AmigaFFH::getIFFChunk(result, c("8SVX", "NAME"))@chunk.data[[1]], silent = TRUE)
    samp.name <- samp.name[1:22]
    samp.name[is.na(samp.name)] <- raw(1)
    result <- AmigaFFH::interpretIFFChunk(result)[[1]]
    if (!("IFF.8SVX" %in% class(result))) stop("Not an 8SVX IFF file!")
    ## XXX maybe it is possible to preserve loop-information from the 8SVX file
    ## in future versions
    result <- PTSample(result[[1]])
    result@name <- samp.name
    return (result)
  }
  if (match.arg(what) == "raw")
  {
    con <- file(filename, "rb")
    BODY_data <- readRaw(con)
    close(con)
    result <- new("PTSample",
                  left = as.integer(rawToSignedInt(BODY_data) + 128),
                  samp.rate = noteToSampleRate(),
                  wlooplen = as.raw(0:1))
    name(result) <- samp_name
    return (result)
  }
})

setGeneric("write.sample", function(sample, filename, what = c("wav", "8svx", "raw")) standardGeneric("write.sample"))

#' Write a PTSample object to an audio file
#'
#' Write a `PTSample` as a "wav", "8svx" or "raw" audio file.
#'
#' This method provides a wrapper for the [`tuneR::writeWave`] method
#' from [`tuneR::tuneR`]. It also provides the means to export audio
#' to file formats native to the Commodore Amiga. `PTSample`s can be
#' exported as simple (uncompressed) [8svx](https://en.wikipedia.org/wiki/8SVX)
#' files also known as "iff" files). In addition they can be exported as raw data,
#' where each byte simply represents a signed integer value of the waveform.
#'
#' @rdname write.sample
#' @name write.sample
#' @aliases write.sample,PTSample,character-method
#' @param sample A `PTSample` object that needs to be exported to an audio
#' file.
#' @param filename A `character` string representing the filename to which
#' the audio needs to be saved.
#' @param what A `character` string indicating what type of file is to be
#' exported. Can be one of the following: `"wav"` (default),
#' `"8svx"` or `"raw"`. The `AmigaFFH` package needs to be
#' installed in order to write 8svx files.
#' @returns Saves the audio to a file, but returns nothing.
#' @examples
#' data("mod.intro")
#' 
#' ## Export the second sample of mod.intro as a wav file:
#' write.sample(PTSample(mod.intro, 2), tempfile(fileext = ".wav"), "wav")
#'
#' ## Export the second sample of mod.intro as an 8svx file:
#' write.sample(PTSample(mod.intro, 2), tempfile(fileext = ".iff"), "8svx")
#'
#' ## Export the second sample of mod.intro as a raw file:
#' write.sample(PTSample(mod.intro, 2), tempfile(fileext = ".raw"), "raw")
#' @family sample.operations
#' @author Pepijn de Vries
#' @family io.operations
#' @export
setMethod("write.sample", c("PTSample", "character", "ANY"), function(sample, filename, what = c("wav", "8svx", "raw")){
  if (match.arg(what) == "wav")
  {
    tuneR::writeWave(sample, filename)
  }
  if (match.arg(what) == "8svx")
  {
    if (!("AmigaFFH" %in% utils::installed.packages())) stop("You need to install package 'AmigaFFH' in order to write 8svx files.")
    out <- AmigaFFH::WaveToIFF(sample)
    out@chunk.data[[1]]@chunk.data <- c(
      out@chunk.data[[1]]@chunk.data[1:2],
      methods::new("IFFChunk", chunk.type = "ANNO", chunk.data = list(charToRaw("ProTrackR"))),
      methods::new("IFFChunk", chunk.type = "NAME", chunk.data = list(sample@name)),
      out@chunk.data[[1]]@chunk.data[3]
    )
    AmigaFFH::write.iff(out, filename)
  }
  if (match.arg(what) == "raw")
  {
    con <- file(filename, "wb")
    writeBin(signedIntToRaw(sample@left - 128), con)
    close(con)
  }
  invisible()
})

setGeneric("name", function(x) standardGeneric("name"))
setGeneric("name<-", function(x, value) standardGeneric("name<-"))

#' Obtain or replace the name of a PTModule or PTSample
#'
#' The name of both a [`PTModule`] and
#' [`PTSample`] are stored as `raw` data.
#' This method returns the name as a `character` string, or it can
#' be used to assign a new name to a [`PTModule`] or
#' [`PTSample`].
#'
#' The name of a [`PTModule`] and
#' [`PTSample`] is stored as a `vector` of
#' `raw` data with a length of 20 or 22 respectively. This method
#' provides the means for getting the name as a `character` string
#' or to safely redefine the name of a [`PTModule`] or
#' [`PTSample`] object. To do so,
#' the provided name (`value`) is converted to a `raw` `vector`
#' of length 20 or 22 respectively. Long names may therefore get clipped.
#'
#' @docType methods
#' @rdname name
#' @name name
#' @aliases name,PTSample-method
#' @param x A [`PTModule`] or a [`PTSample`]
#' object for which to obtain or replace the name.
#' @param value A `character` string which should be used to replace the
#' name of [`PTModule`] or [`PTSample`] `x`.
#' @returns For `name`, the name of the [`PTModule`] or
#' [`PTSample`] object as a `character` string is returned.
#'
#' For `name<-`, object `x` with an updated name is returned.
#' @examples
#' data("mod.intro")
#'
#' ## get the name of mod.intro:
#' name(mod.intro)
#'
#' ## I don't like the name, let's change it:
#' name(mod.intro) <- "I like this name better"
#'
#' ## Note that the provided name was too long and is truncated:
#' name(mod.intro)
#'
#' ## print all sample names in the module:
#' unlist(lapply(as.list(1:31), function(x)
#'   name(PTSample(mod.intro, x))))
#'
#' @family character.operations
#' @family sample.operations
#' @author Pepijn de Vries
#' @export
setMethod("name", "PTSample", function(x){
  return(rawToCharNull(x@name))
})

#' @rdname name
#' @name name<-
#' @aliases name<-,PTSample,character-method
#' @export
setReplaceMethod("name", c("PTSample", "character"), function(x, value){
  if (length(value) > 1) warning("Provided name has more than 1 element. Only first element used.")
  value <- as.character(value)[[1]]
  value <- charToRaw(value)
  if (length(value) > 22)
  {
    warning("Name is too long and will be truncated.")
    value <- value[1:22]
  }
  if (length(value) < 22) value <- c(value, raw(22 - length(value)))
  x@name <- value
  return (x)
})

setGeneric("sampleLength", function(sample) standardGeneric("sampleLength"))

#' Get the length of a PTSample
#'
#' Gets the length (in samples = bytes) of an audio fragment stored as a
#' [`PTSample`].
#'
#' [`PTSample`]s are 8 bit mono audio fragments. This method
#' returns the length of this fragment expressed as number of samples (which
#' also equals the number of bytes).
#' @rdname sampleLength
#' @name sampleLength
#' @aliases sampleLength,PTSample-method
#' @param sample A `PTSample` object for which the length needs to be returned.
#' @returns Returns a `numeric` value representing the number of samples
#' (bytes) the `PTSample` object `sample` is composed of.
#' @examples
#' data("mod.intro")
#'
#' ## Show the length of the second sample in mod.intro
#' sampleLength(PTSample(mod.intro, 2))
#'
#' @family sample.operations
#' @author Pepijn de Vries
#' @export
setMethod("sampleLength", "PTSample", function(sample){
  return(length(sample@left))
})

setGeneric("waveform", function(sample, start.pos = 1, stop.pos = sampleLength(sample), loop = TRUE) standardGeneric("waveform"))
setGeneric("waveform<-", function(sample, value) standardGeneric("waveform<-"))

#' Extract or replace a PTSample waveform
#'
#' Extract or replace the waveform of a [`PTSample`] object. The
#' waveform is represented by a `vector` of numeric values ranging from
#' 0 up to 255.
#'
#' Sample waveforms are stored as 8 bit signed short integer values ranging
#' from -128 up to +127 in original ProTracker files. However, as the
#' [`PTSample`] class extends the [`tuneR::Wave`] class,
#' the waveforms are represented by integer values ranging from 0 up to 255
#' in the [ProTrackR][ProTrackR-package] package. As per ProTracker specifications,
#' samples are of 8 bit mono quality and can only have an even length with
#' a maximum of `2*0xffff` = `131070`. This method can be used to
#' extract a waveform or replace it.
#' @rdname waveform
#' @name waveform
#' @aliases waveform,PTSample-method
#' @param sample A [`PTSample`] object from which the waveform needs to
#' be extracted or replaced.
#' @param start.pos A `numeric` starting index, giving the starting
#' position for the waveform to be returned. Default value is `1`. This
#' index should be greater than zero.
#' @param stop.pos A `numeric` stopping index, giving the stopping
#' position for the waveform to be returned. Default value is
#' `sampleLength(sample)` This index should be greater than
#' `start.pos`.
#' @param loop A `logical` value indicating whether the waveform
#' should be modulated between the specified loop positions
#' (see [`loopStart`] and [`loopLength`]),
#' or the waveform should stop at the end of the sample (padded with `NA`
#' values beyond the sample length). Will do the first
#' when set to `TRUE` and the latter when set to `FALSE`.
#' @param value A `vector` of numeric values ranging from 0 up to 255,
#' representing the waveform that should be used to replace that of object
#' `sample`. The length should be even and not exceed `2*0xffff` =
#' `131070`. [`loopStart`] and [`loopLength`] will
#' be adjusted automatically when they are out of range for the new waveform.
#'
#' Use `NA` to generate an empty/blank [`PTSample`] object.
#' @returns For `waveform`, the waveform of `sample` is returned
#' as a `vector` of `numeric` values ranging from 0 up to 255.
#' If `loop` is set to `FALSE`
#' and the starting position is beyond the sample length, `NA` values
#' are returned. If `loop` is set to `TRUE` and the starting
#' position is beyond the sample loop (if present, see
#' [`loopState`]), the waveform is modulated between the loop
#' positions.
#'
#' For `waveform<-`, a copy of object `sample` is returned in which
#' the waveform has been replaced with `value`.
#' @examples
#' data("mod.intro")
#'
#' ## Loop sample #1 of mod.intro beyond it's
#' ## length of 1040 samples:
#' wav1 <- waveform(PTSample(mod.intro, 1),
#'                  1, 5000)
#'
#' ## get the waveform from sample #2
#' ## of mod.intro:
#' wav2 <- waveform(PTSample(mod.intro, 2))
#'
#' ## create an echo effect using
#' ## the extracted waveform:
#' wav2 <- c(wav2, rep(128, 1000)) +
#'         c(rep(128, 1000), wav2)*0.25 - 25
#'
#' ## assign this echoed sample to
#' ## sample #2 in mod.intro:
#' waveform(PTSample(mod.intro, 2)) <- wav2
#'
#' ## Blank out sample #1 in mod.intro:
#' waveform(PTSample(mod.intro, 1)) <- NA
#'
#' @family integer.operations
#' @family sample.operations
#' @author Pepijn de Vries
#' @export
setMethod("waveform", "PTSample", function(sample, start.pos, stop.pos, loop){
  start.pos  <- as.integer(abs(start.pos[[1]]))
  stop.pos   <- as.integer(abs(stop.pos[[1]]))
  if (start.pos < 1) stop("Starting position should be greater than or equal to 1...")
  if (start.pos > stop.pos && stop.pos != 0) stop("Starting position should be greater than stopping position...")
  if (stop.pos == 0) return (numeric(0))
  loop       <- as.logical(loop[[1]])
  samp_range <- start.pos:stop.pos
  if (loop && loopState(sample))
  {
    ls <- loopStart(sample)
    samp_range[samp_range > (ls + 1)] <-
      ((samp_range[samp_range > (ls + 1)] - (ls + 1)) %% loopLength(sample)) + ls + 1
  }
  return (as.integer(sample@left)[samp_range])
})

#' @rdname waveform
#' @name waveform<-
#' @aliases waveform<-,PTSample-method
#' @export
setReplaceMethod("waveform", c("PTSample", "ANY"), function(sample, value){
  value <- as.numeric(value)
  if (loopLength(sample) == 0 && length(value) > 0) sample@wlooplen <- unsignedIntToRaw(1, 2)
  if (any(is.na(value)) && length(value) > 1) stop ("NAs are not allowed in the data, if length > 1!")
  if (!any(is.na(value)) && (length(value)%%2) == 1)
  {
    warning("Length of data is odd. A value of 128 is added to the end.")
    value <- c(value, 128)
  }
  if (length(value) > 2*0xffff)
  {
    warning("Data exceeds maximum length (131070). Data will be truncated!")
    value <- value[1:(2*0xffff)]
  }
  if (!any(is.na(value)) && (any(value < 0) || any(value > 255)))
  {
    warning("Some values are out of range [0-255], data will be normalised to the required range")
    min_v <- min(value)
    max_v <- max(value)
    value <- as.integer(round(255*(value - min_v)/(max_v - min_v)))
  }
  if (loopStart(sample) > length(value))
  {
    warning("Sample loop start is outside the new range. It is set to 0.")
    sample@wloopstart <- raw(2)
  }
  if ((loopStart(sample) + loopLength(sample)) > length(value))
  {
    warning("Sample loop end is outside the new range. It's set to its maximum.")
    loopend <- as.integer((length(value) - loopStart(sample))/2)
    if (loopend == 0) loopend <- 1
    sample@wlooplen <- unsignedIntToRaw(loopend, 2)
  }
  if (any(is.na(value)) || length(value) == 0)
  {
    sample@left <- integer(0)
    if (loopStart(sample) == 0 && loopLength(sample) == 2) loopLength(sample) <- 0
  } else
  {
    sample@left <- value
  }
  return(sample)
})

setGeneric("loopSample", function(sample, times, n_samples) standardGeneric("loopSample"))

#' Looped waveform of a sample
#'
#' Generate a looped [`waveform`] of a [`PTSample`] object.
#'
#' For playing routines, it can be useful to generate repeats of a sample loop.
#' This method returns the waveform of a [`PTSample`] where the
#' loop is repeated ``times`' times or has a length of ``n_samples`'.
#' @rdname loopSample
#' @name loopSample
#' @aliases loopSample,PTSample-method
#' @param sample A [`PTSample`] object that needs to be looped.
#' @param times A positive `integer` value indicating the number of
#' times a sample loop should be repeated. This argument is ignored if
#' `n_samples` is specified.
#' @param n_samples A positive `integer` value indicating the desired length
#' of the looped waveform in number of samples. This argument overrules the
#' `times` argument.
#' @returns Returns a [`waveform`] represented by a `numeric`
#' `vector` of values ranging from 0 up to 255. Has a length of
#' `n_samples` when that argument is specified.
#' @examples
#' data("mod.intro")
#'
#' ## Loop sample number 4 10 times:
#' wform <- loopSample(PTSample(mod.intro, 4), times = 10)
#' plot(wform, type = "l")
#'
#' ## Loop sample number 4, such that its
#' ## final length is 5000 samples:
#' wform <- loopSample(PTSample(mod.intro, 4), n_samples = 5000)
#' plot(wform, type = "l")
#'
#' @family loop.methods
#' @family sample.operations
#' @author Pepijn de Vries
#' @export
setMethod("loopSample", c("PTSample", "ANY", "ANY"), function(sample, times, n_samples){
  if (missing(times) && missing(n_samples)) stop ("Either 'times' or 'n_samples' should be specified.")
  if (!loopState(sample)) stop("No loop set to sample...")
  if (!missing(times))
  {
    times <- as.integer(abs(times[[1]]))
    n_samples <- loopStart(sample) + times*loopLength(sample)
  }
  if (!missing(n_samples)) n_samples <- as.integer(abs(n_samples[[1]]))
  return (waveform(sample, 1, n_samples))
})

setGeneric("loopState", function(sample) standardGeneric("loopState"))

#' Get PTSample loop state
#'
#' Determines whether a loop is specified for a [`PTSample`] object.
#'
#' The loop state is not explicitly stored in a [`PTSample`] object.
#' It can be derived from the [`loopStart`] position and
#' [`loopLength`]. This method is provided as a convenient method
#' to get the state. Use either [`loopStart`] or [`loopLength`]
#' to change the state.
#' @rdname loopState
#' @name loopState
#' @aliases loopState,PTSample-method
#' @param sample A [`PTSample`] object for which the loop state needs
#' to be determined.
#' @returns Returns a `logical` value indicating whether a loop is (`TRUE`)
#' or isn't (`FALSE`) specified for the `sample`.
#' @examples
#' data("mod.intro")
#'
#' ## Get the loop status of sample number 1
#' ## (it has a loop):
#' loopState(PTSample(mod.intro, 1))
#'
#' ## Get the loop status of sample number 2
#' ## (it has no loop):
#' loopState(PTSample(mod.intro, 2))
#' @family loop.methods
#' @family sample.operations
#' @author Pepijn de Vries
#' @export
setMethod("loopState", c("PTSample"), function(sample){
  return (!(loopLength(sample) <= 2 && loopStart(sample) == 0))
})
