#' ModLand helper functions
#'
#' \url{http://modland.com} is on of the largest online archive of module files. These functions
#' will assist in accessing this archive.
#'
#' Like the \url{http://modarchive.org}, modland provides access to a large collection of module files.
#' Compared to the \link{modArchive}, modLand provides limited searching features. However, it
#' does not require an API key.
#'
#' The functions documented here are provided as a convenience and depend
#' on third party services. Note that continuity of these services cannot
#' be guaranteed.
#'
#' Use \code{modLand.search.mod} to search through the modLand collection.
#'
#' Use \code{modLand.download.mod} to download a specific mod file as an S4 object.
#' @param search.text A single length \code{character} vector, containing
#' search text. Provided search pattern is searched in all fields (mod format,
#' author and title). Prefixes can be added to keywords for inclusive or exclusive
#' searches. For details see \url{https://www.exotica.org.uk/wiki/Modland#Searching}.
#' Note that modLand contains a wide range of tracker files, only mod-files
#' are supported by the \code{ProTrackR} package. It is therefore advisable to add the
#' keyword `mod' to the search string.
#' @param format A single length \code{character} vector, indicating the
#' tracker file format. `\code{Protracker}' is the option that is most likely to work in this package.
#' @param author A single length \code{character} vector, indicating the
#' module author name. Can be obtained from a \code{modLand.search.mod}.
#' @param title A single length \code{character} vector, indicating the
#' module title. Can be obtained from a \code{modLand.search.mod}.
#' @param mirror A single length \code{character} vector. Should contain one of the
#' mirrors listed in the `usage' section. Select a mirror site from which
#' the module file needs to be downloaded.
#' @param ... Argument that are passed on to \code{\link{read.module}}.
#' @return \code{modLand.search.mod} returns a \code{data.frame}.
#' The \code{data.frame} contains a search result in each row.
#' The data.frame contains a number of columns, each containing
#' \code{character} strings. The column `title' contains the mod file name;
#' The column named `author' contains the author name; the column named
#' `format' contains the tracker file format (only `\code{Protracker}'
#' is supported by this package); The collumn `collect' contains
#' modLand collections in which the mod is included; the column named
#' `url' contains a download link for the `ogg'-file generated on the
#' modLand server from the mod file. Note that ogg-files are not supported
#' by the ProTrackR package. Use \code{modLand.download.mod} to download
#' the mod file.
#'
#' \code{modLand.download.mod} attempts to download the specified mod
#' file and return it as a \code{\link{PTModule}} object. It will throw
#' errors when the mod file is not available or when there are network
#' problems...
#' @name modLand
#' @aliases modLand.search.mod
#' @aliases modLand.download.mod
#' @rdname modLand
#' @examples
#' \dontrun{
#' ## Search for a funky tune:
#'
#' modland <- modLand.search.mod("elekfunk mod")
#'
#' ## The ogg file can be downloaded (in this case to the tempdir()),
#' ## but it is not supported by the ProTrackR package...
#'
#' utils::download.file(modland$url[1], tempdir())
#'
#' ## Instead, use the following approach to download the module:
#'
#' mod <- modLand.download.mod(modland$format[1],
#'                             modland$author[1],
#'                             modland$title[1])
#'
#' }
#' @author Pepijn de Vries
#' @export
modLand.search.mod <- function(search.text) {
  con <- url(paste0("https://www.exotica.org.uk/mediawiki/extensions/ExoticASearch/Modland_xbmc.php?qs=",
                    utils::URLencode(search.text)))
  modland <- readLines(con)
  close(con)
  ## when there are no results, the length of the file is 2 lines long
  if (length(modland) <= 2) {
    return(data.frame(
      title   = character(0),
      author  = character(0),
      format  = character(0),
      collect = character(0),
      url     = character(0),
      stringsAsFactors = F
    ))
  }
  modland <- XML::xmlTreeParse(modland)
  modland <- XML::xmlApply(modland, XML::xmlToList)
  modland <- lapply(modland, rbind)
  modland <- as.data.frame(do.call(rbind, modland))
  modland <- lapply(modland, unlist)
  modland <- as.data.frame(do.call(cbind, modland),
                           stringsAsFactors = F)
  modland
}

#' @rdname modLand
#' @export
modLand.download.mod <- function(format,
                                 author,
                                 title,
                                 mirror = c("modland.com",
                                            "ftp.modland.com",
                                            "antarctica.no",
                                            "ziphoid.com",
                                            "exotica.org.uk"),
                                 ...) {
  mirror.args <- c("modland.com",
                   "ftp.modland.com",
                   "antarctica.no",
                   "ziphoid.com",
                   "exotica.org.uk")
  mirror <- match(match.arg(mirror, mirror.args), mirror.args)
  mirror <- c("http://modland.com/pub/modules/",
              "ftp://ftp.modland.com/pub/modules/",
              "http://modland.antarctica.no/pub/modules/",
              "http://modland.ziphoid.com/pub/modules/",
              "http://files.exotica.org.uk/modland/?file=pub/modules/")[mirror]
  url.suffix <- paste(utils::URLencode(format),
                      utils::URLencode(author),
                      utils::URLencode(title),
                      sep = "/")
  download.url <- paste0(mirror, url.suffix)
  read.module(download.url, ...)
}
