% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/06PTModule.r
\docType{methods}
\name{write.module}
\alias{write.module}
\alias{write.module,PTModule,ANY-method}
\alias{write.module,PTModule,character-method}
\title{Export an PTModule object as a ProTracker module file}
\usage{
\S4method{write.module}{PTModule,ANY}(mod, file)

\S4method{write.module}{PTModule,character}(mod, file)
}
\arguments{
\item{mod}{A valid PTModule object to be saved as a ProTracker *.mod file}

\item{file}{either a filename to write to, or a file connection, that
allows to write binary data (see \code{\link[base:connections]{base::file}}).}
}
\value{
Writes to a module file but returns nothing.
}
\description{
Export an \code{\link{PTModule}} object as a ProTracker module file,
conform ProTracker 2.3A specifications.
}
\details{
The routine to write ProTracker modules is based on the referenced version
of ProTracker 2.3A. This means that the routine may not be able to
write files that ar compatible with later or earlier ProTracker versions.
}
\examples{
\dontrun{
## get the PTModule object provided with the ProTrackR package
data("mod.intro")

## save the object as a valid ProTracker module file:
write.module(mod.intro, "intro.mod")

## or create the connection yourself:
con <- file("intro2.mod", "wb")
write.module(mod.intro, con)

## don't forget to close the connection after you're done:
close(con)
}
}
\references{
\url{https://wiki.multimedia.cx/index.php?title=Protracker_Module}
}
\seealso{
Other io.operations: 
\code{\link{read.module}()},
\code{\link{read.sample}()},
\code{\link{write.sample}()}

Other module.operations: 
\code{\link{PTModule-class}},
\code{\link{appendPattern}()},
\code{\link{clearSamples}()},
\code{\link{clearSong}()},
\code{\link{deletePattern}()},
\code{\link{fix.PTModule}()},
\code{\link{modToWave}()},
\code{\link{moduleSize}()},
\code{\link{patternLength}()},
\code{\link{patternOrderLength}()},
\code{\link{patternOrder}()},
\code{\link{playMod}()},
\code{\link{playingtable}()},
\code{\link{rawToPTModule}()},
\code{\link{read.module}()},
\code{\link{trackerFlag}()}
}
\author{
Pepijn de Vries
}
\concept{io.operations}
\concept{module.operations}
