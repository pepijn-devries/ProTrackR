ProTrackR v0.3.9 (Release date: 2023-02-14)
=============

 * Added `pkgdown` website and README
 * switched to RMarkdown mode for roxygen2 documentation

ProTrackR v0.3.8 (Release date: 2023-08-22)
=============

 * Updates to comply with latest CRAN policies and Roxygen2 standards

ProTrackR v0.3.7 (Release date: 2020-02-03)
=============

 * Fixes to modArchive functions, due to changes to their API

 * Fix in structure and examples to pass CRAN tests.

 * Fix in validation functions in order to support changes in latest version of R

ProTrackR v0.3.6 (Release date: 2019-02-06)
=============

 * Added modLand helper functions.

 * Reading and writing 8svx samples with read.sample and write.sample
   is now implemented using the AmigaFFH package, which has a more
   robust implementation of Interchange File Format handlers.

 * Added a 'mix' argument to the 'modToWave'-method. When set to FALSE, the
   method can now return all individual channels (without mixing them).

 * The 'playWave'-method was updated such that it also accepts multi-channel
   waves (WaveMC), in order to make it compatible with the modification
   specified above.

 * Available documentation on which of the 4 channels are mixed to the left and
   right audio output channel respectively is inconsistent. This version will
   assume that channels 1 and 4 (or 0 and 3 using Amiga indexing) are mixed to
   the left channel and channels 2 and 3 (or 1 and 2 using Amiga indexing) are
   mixed to the right channel. This means that the output channels are now swapped
   compared to earlier versions of this package.

 * There was a bug in the implementation of the 'porta to note'
   effects (3 and 5), it is now fixed.

 * Added a new implementation of the generic 'as.raw' method, which allows to
   convert PTModule objects into raw data. Also added a 'rawToPTModule' method
   to achieve the inverse.

 * Endianess should have been set to "big" instead of "little" (whoops),
   luckily, this has no consequences as all data are read as raw data. I
   have corrected the code nonetheless

 * Minor corrections to manual

ProTrackR v0.3.5 (Release date: 2017-10-14)
=============

 * Added functions to exchange pattern data with
   MODPlug tracker.

 * Endianness is explicitely set to "little" when reading
   and writing samples and modules. As all data is read and
   written as raw, this should not affect the package
   functioning.

 * Removed unnecessary print statement from PTBlock
   routine.

 * Fixed a bug in the 'rawToCharNull' function.

 * Fixed a bug in the 'modToWave' routine that caused an error
   under rare conditions.

 * Setting stereo.separation to 0 was not handled correctly in
   'modToWave' routine. Channels were not mixed before
   converting to mono. This is now fixed.

ProTrackR v0.3.4 (Release date: 2016-11-25)
=============

 * added a "fix.PTModule" method that attempts to
   fix a module object when it is not conform
   ProTracker specs...

 * period limits for the porta effects have been fixed

 * inverted the logical interpretation of the
   'verbose' argument, as it was incorrect in
   earlier versions.

 * added and modified several of the 'modArchive'-
   functions, for better support from modarchive.org

 * modified S4-object validation functions such that
   they run faster.

 * modified 'write.module'-method such that it will
   write modules much faster

 * fixed bug in 'read.module'-method and modified it
   such that it will read modules much faster.

 * fixed bug in 'loopStart<-'-method

 * fixed bug in 'loopLength<-'-method

 * fixed bug in 'patternOrder<-'-method

 * fixed bug in 'appendPattern'-method

 * fixed bug in 'volume<-'-method

 * fixed bug in 'waveform<-'- and 'waveform'-method

ProTrackR v0.3.3 (Release date: 2016-03-26)
=============

 * Minor correction in manual.

ProTrackR v0.3.2 (Release date: 2016-03-25)
=============

 * Minor corrections in manual.

ProTrackR v0.3.1 (Release date: 2016-03-25)
=============

 * Modified the playing routine such that the porta
   effects can't slide period values below that of note
   B-3 or above 856. Period values are cut-off at these
   values after processing the other effects as well.
   Thanks must go to Olav Sørensen (who created a
   Protracker v2.3D clone for modern machines,
   https://16-bits.org/pt.php) for confirming these
   software and hardware limits.

 * Resampling routine in the modToWave-method is rewritten.
   It should be faster now.

 * The 9xy command is now implemented such that it
   emulates the ProTracker 'offset bug'. Therewith,
   the player routine now passes 'ptoffset.mod' test.

 * Bug in resampling of samples in 'modToWave'-
   routine is fixed.

 * 'modArchive' functions are added to the package.

 * Effect commands 'E4x' and 'E7x' are now implemented
   in the player routine.

 * Implementation of effect command '5xy' is fixed.

 * In the previous release, some generated wave data ended
   up out of range in the mixing procedure. This is now fixed.

 * The 'playWave'-method is modified such that it
   returns an 'audioInstance'-object (audio package)
   allowing control over the playback.

 * Minor corrections/improvements to the manual

 * Mixing when some tracks are turned off is fixed

ProTrackR v0.2.3 (Release date: 2015-11-07)
=============

 * Minor corrections in manual to pass
   CRAN checks.

ProTrackR v0.2.2 (Release date: 2015-11-07)
=============

 * Minor corrections in manual to pass
   CRAN checks.

ProTrackR v0.2.1 (Release date: 2015-11-07)
=============

 * 'clearSamples'-method was added to the package.

 * 'clearSong'-method was added to the package.

 * 'modToWave'-method was added to the package

 * 'playingtable'-method was added to the package

 * 'playMod'-method was added to the package

 * 'playWave'-method was added to the package

 * 'resample'-function added to the package
   to avoid 'seewave' dependency (which is
   not available for all platforms).

 * 'waveform'-method now includes additional
   arguments: 'start.pos', 'stop.pos' and 'loop'

 * removed 'utils' import...

 * 'name' method, for PTSample objects, incorrectly
   returned raw representation of the sample name
   instead of a character representation. This is
   now fixed.

 * 'playSample' was printing the names of additional
   (...) arguments in previous release. This was meant
   as a test and this behaviour was not intended for
   the release. It has been removed.

 * A section on ProTracker effect commands is
   added to the manual

 * Some minor corrections were made in the manual

ProTrackR v0.1.3 (Release date: 2015-09-25)
=============

 * Some more minor fixes to pass CRAN checks.


ProTrackR v0.1.2 (Release date: 2015-09-25)
=============

 * Minor fixes to pass CRAN checks.

 * In the 'playSample' method, the 'finetune' argument is
   now correctly passed to the 'noteToSampleRate' function.
   Before, it was only possible to play at the finetune
   specified for a sample.

 * Correction in the validity check for objects of S4 class
   'PTSample': wlooplen is allowed to have a value of zero
   when the sample is empty.

 * The prototype of the S4 class 'PTSample' is changed to
   set the wlooplen value to zero.

 * The slot descriptions for wloopstart and wlooplen in the
   'PTSample' documentation contained errors that were
   corrected.

 * The 'loopLength<-', the 'PTSample-method' and 'read.sample'
   methods were modified to handle the adjustments to the
   'PTSample' class.

 * Removed superfluous argument 'value' from the
   'patternLength' method

ProTrackR v0.1.1 (Release date: 2015-09-25)
=============

First release:

 * Provided the basis for importing, exporting and manipulating
   ProTracker modules.

 * Basic playing routine, playing the samples in the module
   only (not the module itself).
