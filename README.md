
# ProTrackR

<!-- badges: start -->

[![R-CMD-check](https://github.com/pepijn-devries/ProTrackR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/pepijn-devries/ProTrackR/actions/workflows/R-CMD-check.yaml)
[![ProTrackR2 status
badge](https://pepijn-devries.r-universe.dev/badges/ProTrackR)](https://pepijn-devries.r-universe.dev/ProTrackR)
[![version](https://www.r-pkg.org/badges/version/ProTrackR)](https://CRAN.R-project.org/package=ProTrackR)
![cranlogs](https://cranlogs.r-pkg.org/badges/ProTrackR)
<!-- badges: end -->

<img src="https://content.pouet.net/files/screenshots/00050/00050055.png" alt="ProTracker 2.3a" align="right" />

[ProTracker](https://en.wikipedia.org/wiki/Protracker) is music
sequencer software from the 1990s on the [Commodore
Amiga](https://en.wikipedia.org/wiki/Amiga) (see screenshot of version
2.3a on the right). This R package is designed to read, process and play
ProTracker module audio files.

## Installation

> Get CRAN version

``` r
install.packages("ProTrackR")
```

> Get development version from R-Universe

``` r
install.packages("ProTrackR", repos = c('https://pepijn-devries.r-universe.dev', 'https://cloud.r-project.org'))
```

## Usage

The package comes bundled with a tiny chiptune, which can easily be
played like so:

``` r
library(ProTrackR) |>
  suppressMessages()
data("mod.intro")

playMod(mod.intro, verbose = FALSE)
```

There are plethora of module files available on-line as well. Below you
can see how you can download such a file. It also show how you can
select an audio sample (number 25) from the module and calculate its
power spectrum:

``` r
elekfunk <- read.module("https://api.modarchive.org/downloads.php?moduleid=41529#elektric_funk.mod")

spec <- elekfunk |>
  PTSample(25) |>
  waveform() |>
  tuneR::powspec(wintime = 0.1, steptime = 0.001)

image(log10(spec), col = hcl.colors(100, palette = "Inferno"))
```

<img src="man/figures/README-power_cyberride-1.png" width="100%" />

While we are at it, why not play it:

``` r
playMod(elekfunk, verbose = FALSE)
```

## Package status and alternatives

This package is no longer actively developed. It will receive minimal
attention and only required updates for the latest CRAN policies. It is
surpassed by the alternatives listed below.

- [ProTrackR2](https://pepijn-devries.github.io/ProTrackR2/): A complete
  rewrite in C and C++ of the current package using the [ProTracker
  clone](https://github.com/8bitbubsy/pt2-clone) by Olav Sørensen. It
  has similar features as the current package but has a better
  implementation of the tracker interpretation and is a lot faster.
- [openmpt](https://pepijn-devries.github.io/openmpt/): An R port of
  [libopenmpt](https://lib.openmpt.org/libopenmpt/). It plays and
  renders a wide range of tracker music files, but they cannot be
  edited.

## Further reading

For some further reading and inspiration please have a look at the
following blog articles:

- [Chiptunes in R
  (1)](https://r-coders-anonymous.blogspot.com/2015/09/protrackr-chiptunes-in-r-part-one.html)
- [Chiptunes in R
  (2)](https://r-coders-anonymous.blogspot.com/2015/11/protrackr-chiptunes-in-r-part-two.html)
- [Chiptunes in R
  (3)](https://r-coders-anonymous.blogspot.com/2016/11/protrackr-chiptunes-in-r-part-three.html)
