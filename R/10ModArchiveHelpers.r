genre.table <- read.table(text = "
genre,                 genre.id
                          unset,                    unset
                          Alternative,                 48
                          Gothic,                      38
                          Grunge,                     103
                          Metal - Extreme,             37
                          Metal (general),             36
                          Punk,                        35
                          Chiptune,                    54
                          Demo Style,                  55
                          One Hour Compo,              53
                          Chillout,                   106
                          Electronic - Ambient,         2
                          Electronic - Breakbeat,       9
                          Electronic - Dance,           3
                          Electronic - Drum and Bass,   6
                          Electronic - Gabber,         40
                          Electronic - Hardcore,       39
                          Electronic - House,          10
                          Electronic - IDM,            99
                          Electronic - Industrial,     34
                          Electronic - Jungle,         60
                          Electronic - Minimal,       101
                          Electronic - Other,         100
                          Electronic - Progressive,    11
                          Electronic - Rave,           65
                          Electronic - Techno,          7
                          Electronic (general),         1
                          Trance - Acid,               63
                          Trance - Dream,              67
                          Trance - Goa,                66
                          Trance - Hard,               64
                          Trance - Progressive,        85
                          Trance - Tribal,             70
                          Trance (general),            71
                          Big Band,                    74
                          Blues,                       19
                          Jazz - Acid,                 30
                          Jazz - Modern,               31
                          Jazz (general),              29
                          Swing,                       75
                          Bluegrass,                  105
                          Classical,                   20
                          Comedy,                      45
                          Country,                     18
                          Experimental,                46
                          Fantasy,                     52
                          Folk,                        21
                          Fusion,                     102
                          Medieval,                    28
                          New Ages,                    44
                          Orchestral,                  50
                          Other,                       41
                          Piano,                       59
                          Religious,                   49
                          Soundtrack,                  43
                          Spiritual,                   47
                          Video Game,                   8
                          Vocal Montage,               76
                          World,                       42
                          Ballad,                      56
                          Disco,                       58
                          Easy Listening,             107
                          Funk,                        32
                          Pop - Soft,                  62
                          Pop - Synth,                 61
                          Pop (general),               12
                          Rock - Hard,                 14
                          Rock - Soft,                 15
                          Rock (general),              13
                          Christmas,                   72
                          Halloween,                   82
                          Hip-Hop,                     22
                          R and B,                     26
                          Reggae,                      27
                          Ska,                         24
                          Soul,                        25", header = T, sep = ",", stringsAsFactors = F, strip.white = T)

#html escape codes

htmlcodes <- read.table(text = "
                        char, code
                        8364, 'euro'
                        32, 'nbsp'
                        34, 'quot'
                        38, 'amp'
                        60, 'lt'
                        62, 'gt'
                        160, 'nbsp'
                        161, 'iexcl'
                        162, 'cent'
                        163, 'pound'
                        164, 'curren'
                        165, 'yen'
                        166, 'brvbar'
                        167, 'sect'
                        168, 'uml'
                        169, 'copy'
                        170, 'ordf'
                        172, 'not'
                        173, 'shy'
                        174, 'reg'
                        175, 'macr'
                        176, 'deg'
                        177, 'plusmn'
                        178, 'sup2'
                        179, 'sup3'
                        180, 'acute'
                        181, 'micro'
                        182, 'para'
                        183, 'middot'
                        184, 'cedil'
                        185, 'sup1'
                        186, 'ordm'
                        187, 'raquo'
                        188, 'frac14'
                        189, 'frac12'
                        190, 'frac34'
                        191, 'iquest'
                        192, 'Agrave'
                        193, 'Aacute'
                        194, 'Acirc'
                        195, 'Atilde'
                        196, 'Auml'
                        197, 'Aring'
                        198, 'AElig'
                        199, 'Ccedil'
                        200, 'Egrave'
                        201, 'Eacute'
                        202, 'Ecirc'
                        203, 'Euml'
                        204, 'Igrave'
                        205, 'Iacute'
                        206, 'Icirc'
                        207, 'Iuml'
                        208, 'ETH'
                        209, 'Ntilde'
                        210, 'Ograve'
                        211, 'Oacute'
                        212, 'Ocirc'
                        213, 'Otilde'
                        214, 'Ouml'
                        215, 'times'
                        216, 'Oslash'
                        217, 'Ugrave'
                        218, 'Uacute'
                        219, 'Ucirc'
                        220, 'Uuml'
                        221, 'Yacute'
                        222, 'THORN'
                        223, 'szlig'
                        224, 'agrave'
                        225, 'aacute'
                        226, 'acirc'
                        227, 'atilde'
                        228, 'auml'
                        229, 'aring'
                        230, 'aelig'
                        231, 'ccedil'
                        232, 'egrave'
                        233, 'eacute'
                        234, 'ecirc'
                        235, 'euml'
                        236, 'igrave'
                        237, 'iacute'
                        238, 'icirc'
                        239, 'iuml'
                        240, 'eth'
                        241, 'ntilde'
                        242, 'ograve'
                        243, 'oacute'
                        244, 'ocirc'
                        245, 'otilde'
                        246, 'ouml'
                        247, 'divide'
                        248, 'oslash'
                        249, 'ugrave'
                        250, 'uacute'
                        251, 'ucirc'
                        252, 'uuml'
                        253, 'yacute'
                        254, 'thorn'
                        ", sep = ",", header = T, quote = "'", strip.white = T)
htmlcodes$char <- intToUtf8(htmlcodes$char, T)
htmlcodes$code <- paste0("&", htmlcodes$code, ";")

htmlcodes <- rbind(htmlcodes, data.frame(
  char = intToUtf8(32:383, T),
  code = sprintf("&#%03i;", 32:383)
))

# An oversimplistic function to unescape html escape codes
.htmlUnescape <- function(text) {
  for (i in 1:nrow(htmlcodes))
    text <- gsub(htmlcodes$code[i], htmlcodes$char[i], text, fixed = T)
  Encoding(text) <- "UTF-8"
  return(text)
}

#' ModArchive helper functions
#'
#' \url{http://ModArchive.org} is the largest online archive of module files. These functions
#' will assist in accessing this archive.
#'
#' The \code{modArchive.info} function will retrieve info on a specific module from the
#' ModArchive. The \code{modArchive.search.mod}, \code{modArchive.search.genre} and
#' \code{modArchive.search.hash} functions can be used to find specific modules
#' in the archive. Use \code{modArchive.random.pick} to get module info on a random
#' module in the archive.
#'
#' Use the \code{modArchive.view.by}
#' function to browse the archive by specific aspects.
#' Note that the ModArchive also contains file formats other than ProTracker's MOD format.
#' This package can only handle the MOD format.
#'
#' The \code{modArchive.download} function will download a module from the archive.
#'
#' Use \code{modArchive.search.artist} to find artist details in the archive.
#'
#' Use \code{modArchive.request.count} to determine how many request you have
#' made in the current month with the specified key (see `ModArchive API key'
#' section for details).
#' Use \code{modArchive.max.requests} to determine how many request you are
#' allowed to make each month with the provided key (see `ModArchive API key'
#' section for details).
#'
#' @section ModArchive API key:
#' Since ProTrackR 0.3.4, the ModArchive helper functions have changed. In earlier
#' version, a lable html scraper was used, in 0.3.4 and later, this is replaced by
#' functions that more robustly use the Application Programming Interface (API)
#' provided by ModArchive. There are some downsides to this new approach: a
#' personal API key needs to be obtained from the ModArchive team; and the
#' ProTrackR package relies on yet another package (XML)
#' to parse the XML files that are returned by the API.
#'
#' So why is this switch? Well, first of all, this approach is better supported
#' by ModArchive. The personal API key is used to avoid excessive access by imposing
#' a monthly request limit (keep in mind that ModArchive provides free services and is
#' run by volunteers). The upside is that the XML files are a lot lighter than the
#' html files returned by the regular website. Therefore, the new functions are faster,
#' and they reduce the load on the ModArchive servers. The XML files also allow for
#' easier access to more of the ModArchive functionality as implemented in the
#' ModArchive helper functions described here.
#'
#' So how do you get your personal API key? First, you need to register at the
#' \href{https://modarchive.org/forums/}{ModArchive Forums}. Then follow the
#' instructions provided in this \href{https://modarchive.org/forums/index.php?topic=1950.0}{topic}
#' on the forum. For more info, see also the \href{http://modarchive.org/?xml-api}{API
#' page} on ModArchive.
#'
#' @param mod.id An \code{integer} code used as module identifier in the ModArchive database.
#' A \code{mod.id} can be obtained by performing a search with \code{modArchive.search.mod}.
#' When downloading a module, make sure that the identifier represents a MOD file, as
#' other types will result in an error.
#' @param search.text A \code{character} string to be used as terms to search
#' in the ModArchive.
#' @param search.where A \code{character} string indicating where in the module files
#' to search for the \code{search.text}. See usage section for the available options.
#' @param format.filter File format filter to be used in a search in the ModArchive.
#' See the usage section for all possible options. Default is "unset" (meaning that
#' it will search for any file format). Note that only the `MOD' format
#' is supported by this package.
#' @param size.filter File size filter to be used in a search in the ModArchive.
#' Needs to be a \code{character} string representation of a file size
#' category as specified on ModArchive.org.
#' See the usage section for all possible options. Default is "unset" (meaning that
#' it will search for any file size). Note that the maximum file size of a
#' module is approximately 4068 kilobytes, meaning that the largest file size
#' category is irrelevant for `MOD' files. Also note that the category names are
#' inconsistant, these are the literal catagories used by ModArchive
#' @param genre.filter Genre filter to be used in some of the overviews from the ModArchive.
#' Needs to be a \code{character} string representation of a genre
#' as specified on ModArchive.org.
#' See the usage section for all possible options.
#' This argument is deprecated in the function \code{modArchive.search} since ProTrackR
#' version 0.3.4, other functions will still accept this argument.
#' @param search.artist A character string representing the (guessed) artist name
#' or id number that you ar looking for in the archive.
#' @param search.hash The MD5 hash code of the specific module you are looking
#' for. See \url{http://modarchive.org/?xml-api-usage-level3} for details.
#' @param view.query A query to be used in combination with the \code{view.by}
#' argument. Use the queries in combination with \code{view.by} as follows:
#' \itemize{
#'   \item{\code{view_by_list}: Use a single capital starting letter to browse
#'   modules by name}
#'   \item{\code{view_by_rating_comments}: Provide a (user) rating by which you
#'   wish to browse the modules}
#'   \item{\code{view_by_rating_reviews}: Provide a (reviewer) rating by which you
#'   wish to browse the modules}
#'   \item{\code{view_modules_by_artistid}: Provide an artist id number
#'   for whom you wish to browse his/her modules}
#'   \item{\code{view_modules_by_guessed_artist}: Provide an artist guessed
#'   name for whom you wish to browser his/her modules}
#' }
#' @param api.key Most ModArchive functions require a personal secret API key. This key can
#' be obtained from the ModArchive forum. See `ModArchive API Key' section below for instructions
#' on how to obtain such a key.
#' @param page Many of the ModArchive returns paginated tables. When this argument
#' is omitted, the first page is returned. Use an integer value to return a specific
#' page. The total number of pages of a search or view is returned as an attribute
#' to the returned \code{\link[base]{data.frame}}.
#' @param view.by Indicate how the \code{modArchive.view.by} function should sort
#' the overview tables of modules. See `usage' section for the possible options.
#' @param ... arguments that are passed on to \code{\link{read.module}}.
#' @return \code{modArchive.info}, \code{modArchive.search.genre},
#' \code{modArchive.search.hash}, \code{modArchive.random.pick} and
#' \code{modArchive.view.by} will return a \code{\link{data.frame}}
#' containing information on modules in the ModArchive. Note that this
#' data.frame is formatted differently since ProTrackR 0.3.4, which
#' may cause backward compatibility issues.
#'
#' \code{modArchive.download} will download a module and return it as a
#' \code{\link{PTModule}} object.
#'
#' \code{modArchive.search.artist}  will return a \code{\link{data.frame}}
#' containing information on artists on the ModArchive.
#'
#' \code{modArchive.request.count} returns the number of ModArchive API request
#' that are left for this month, for the provided key.
#'
#' \code{modArchive.max.requests} returns the maximum monthly requests for the
#' provided key.
#' @name modArchive
#' @aliases modArchive.info
#' @aliases modArchive.download
#' @aliases modArchive.search.mod
#' @aliases modArchive.search.genre
#' @aliases modArchive.search.hash
#' @aliases modArchive.search.artist
#' @aliases modArchive.random.pick
#' @aliases modArchive.view.by
#' @aliases modArchive.request.count
#' @aliases modArchive.max.requests
#' @rdname modArchive
#' @examples
#' \dontrun{
#' ## most of the example below will fail as they require a
#' ## real modArchive API key. The key used in these example
#' ## is just a dummy. See details on how to get a key
#' ## in the section 'ModArchive API Key' in the manual.
#'
#' ## Search for the module that is also used as
#' ## an example in this package:
#' search.results <- modArchive.search.mod("*_-_intro.mod",
#'                                         size.filter = "0-99",
#'                                         format.filter = "MOD",
#'                                         api.key = "<your key here>")
#'
#' ## apparently there are multiple modules in
#' ## database that have '_-_intro' in their
#' ## file name or title. Select the wanted
#' ## module from the list (the one with the
#' ## word 'protrackr' in the instrument names):
#' search.select <- subset(search.results,
#'                         grepl("protrackr", search.results$instruments))
#'
#' ## get the same details, but now only for
#' ## the specific module based on its ModArchive ID:
#' modArchive.info(search.select$id, api.key = "<your key here>")
#'
#' ## download the selected module from ModArchive.org:
#' mod <- modArchive.download(search.select$id)
#'
#' ## here's a randomly picked module from the ModArchive:
#' info.random <- modArchive.random.pick(api.key = "<your key here>")
#'
#' ## use modArchive.view.by to list the 2nd page
#' ## of MOD files that start with the letter 'A'
#' info.list  <- modArchive.view.by("A", "view_by_list", "MOD",
#'                                  page = 2,
#'                                  api.key = "<your key here>")
#'
#' ## list the modules of the artist with id number 89200:
#' artist.mods <- modArchive.view.by("89200", "view_modules_by_artistid",
#'                                   format.filter = "MOD",
#'                                   api.key = "<your key here>")
#'
#' ## here's how you can list MOD files of a
#' ## specific genre:
#' list.genre  <- modArchive.search.genre("Chiptune", "MOD",
#'                                        api.key = "<your key here>")
#'
#' ## get module info for a specific hash code
#' mod.hash    <- modArchive.search.hash("8f80bcab909f700619025bd7f2975749",
#'                                       "<your key here>")
#'
#' ## find modarchive artist info, search for artist name
#' ## or artist id:
#' artist.list <- modArchive.search.artist("89200",
#'                                         api.key = "<your key here>")
#'
#' ## How many requests did I make this month?:
#' modArchive.request.count("<your key here>")
#'
#' ## How many requests am I allowed to make each month?:
#' modArchive.max.requests("<your key here>")
#' }
#' @author Pepijn de Vries
#' @export
modArchive.info <- function(mod.id, api.key)
{
  mod.id      <- as.integer(mod.id[[1]])
  api.key     <- as.character(api.key[[1]])
  request.mod <- paste0("http://api.modarchive.org/xml-tools.php?key=",
                        api.key, "&request=view_by_moduleid&query=",mod.id)
  result <- .get.module.table(request.mod, "module")
  return(result)
}

.get.module.table <- function(xmlcode, what) {
  xmlcode <- XML::xmlParse(xmlcode, options = XML::NOCDATA)
  result <- XML::xmlToList(xmlcode)
  if (any("error" %in% names(result))) stop (as.character(result$error))
  totalpages  <- as.numeric(result$totalpages)
  results     <- as.numeric(result$results)

  if (what == "item") result <- result$items
  result <- lapply(result[names(result) == what], function(x) {
    lapply(x, function(x) {
      if (length(x) > 1) {
        x <- lapply(x, function(x) {
          x[is.null(x)] <- "NULL"
          x
        })
        x <- unlist(x)
        paste(apply(cbind(names(x), paste0("<", x, ">")), 1, paste,
                    collapse = "="), collapse = ";")
      } else
      {
        x[is.null(x)] <- ""
        x
      }
    })
  })

  result      <- lapply(result, function(x) {
    x <- lapply(x, function(x) if (length(x) == 0) return("") else return(x))
    data.frame(t(unlist(x)))
  })
  result      <- do.call(rbind, result)
  row.names(result) <- NULL
  if (what == "module") result      <- .fix.module.table(result)
  if (what == "item")   result      <- .fix.artist.table(result)
  attr(result, "results")    <- results
  attr(result, "totalpages") <- totalpages
  return(result)
}

.fix.module.table <- function(result) {
  result <- as.data.frame(as.matrix(result), stringsAsFactors = F)
  result$songtitle   <- .htmlUnescape(result$songtitle)
  result$instruments <- .htmlUnescape(result$instruments)
  result$comment     <- .htmlUnescape(result$comment)
  result$timestamp   <- as.POSIXct(as.numeric(result$timestamp),
                                   origin = "1970-01-01 00:00", tz = "CET")
  numeric_sel        <- c("bytes", "hits", "genreid", "id", "channels")
  result[,numeric_sel] <- as.data.frame(lapply(result[,numeric_sel], as.numeric))

  return(result)
}

.fix.artist.table <- function(result) {
  result <- as.data.frame(as.matrix(result), stringsAsFactors = F)
  result$timestamp   <- as.POSIXct(as.numeric(result$timestamp),
                                   origin = "1970-01-01 00:00", tz = "CET")
  numeric_sel        <- c("id", "isartist")
  result[,numeric_sel] <- as.data.frame(lapply(result[,numeric_sel], as.numeric))

  return(result)
}

#' @rdname modArchive
#' @export
modArchive.download <- function(mod.id, ...)
{
  mod.id <- as.integer(mod.id[[1]])
  con <- url(paste("http://api.modarchive.org/downloads.php?moduleid=", mod.id, sep = ""), "rb")
  mod <- read.module(con, ...)
  close(con)
  return (mod)
}

#' @rdname modArchive
#' @export
modArchive.search.mod <- function(search.text,
                                  search.where  = c("filename_or_songtitle", "filename_and_songtitle", "filename", "songtitle", "module_instruments", "module_comments"),
                                  format.filter = c("unset", "669", "AHX", "DMF", "HVL", "IT", "MED", "MO3", "MOD", "MTM", "OCT", "OKT", "S3M", "STM", "XM"),
                                  size.filter   = c("unset", "0-99", "100-299", "300-599", "600-1025", "1025-2999", "3072-6999", "7168-100000"),
                                  genre.filter = "deprecated",
                                  page,
                                  api.key)
{
  search.text   <- utils::URLencode(as.character(search.text[[1]]))
  search.where  <- match.arg(search.where)
  format.filter <- match.arg(format.filter)
  size.filter   <- match.arg(size.filter)
  api.key       <- as.character(api.key[[1]])
  if (!missing(genre.filter)) warning("Argument 'genre.filter' is deprecated in this function and not used since ProTrackR version 0.3.4. Use 'modArchive.view.by' to browse modules by genre.")

  xmlcode <- paste0("http://api.modarchive.org/xml-tools.php?key=",
                    api.key,
                    "&request=search&query=",
                    search.text,
                    "&type=",
                    search.where)
  if (format.filter != "unset") xmlcode <- paste0(xmlcode, "&format=",  format.filter)
  if (genre.filter  != "unset") xmlcode <- paste0(xmlcode, "&genreid=", genre.filter)
  if (size.filter   != "unset") xmlcode <- paste0(xmlcode, "&size=",    size.filter)
  if (!missing(page)) xmlcode <- paste0(xmlcode, "&page=", as.integer(page[[1]]))
  result <- .get.module.table(xmlcode, "module")
  return(result)
}

#' @rdname modArchive
#' @export
modArchive.request.count <- function(api.key) {
  return(.requests(4, api.key))
}

#' @rdname modArchive
#' @export
modArchive.max.requests <- function(api.key) {
  return(.requests(3, api.key))
}

.requests <- function(index, api.key)
{
  request.count <- XML::xmlTreeParse(paste0("http://api.modarchive.org/xml-tools.php?key=",
                                            api.key,
                                            "&request=view_requests"))
  count.root <- XML::xmlRoot(request.count)
  count.values <- XML::xmlSApply(count.root, function(x) XML::xmlSApply(x, XML::xmlValue))
  return(as.integer(count.values[[index]]))
}

#' @rdname modArchive
#' @export
modArchive.view.by <- function(view.query,
                               view.by = c("view_by_list",
                                           "view_by_rating_comments",
                                           "view_by_rating_reviews",
                                           "view_modules_by_artistid",
                                           "view_modules_by_guessed_artist"),
                               format.filter = c("unset", "669", "AHX", "DMF", "HVL", "IT", "MED", "MO3", "MOD", "MTM", "OCT", "OKT", "S3M", "STM", "XM"),
                               size.filter   = c("unset", "0-99", "100-299", "300-599", "600-1025", "1025-2999", "3072-6999", "7168-100000"),
                               page,
                               api.key) {
  view.query    <- as.character(view.query[[1]])
  format.filter <- match.arg(format.filter)
  size.filter   <- match.arg(size.filter)
  api.key       <- as.character(api.key[[1]])

  xmlcode <- paste0("http://api.modarchive.org/xml-tools.php?key=",
                    api.key,
                    "&request=", view.by,
                    "&query=",
                    view.query)
  if (format.filter != "unset") xmlcode <- paste0(xmlcode, "&format=",  format.filter)
  if (size.filter   != "unset") xmlcode <- paste0(xmlcode, "&size=",    size.filter)
  if (!missing(page)) xmlcode <- paste0(xmlcode, "&page=", as.integer(page[[1]]))
  result <- .get.module.table(xmlcode, "module")
  return(result)
}

#' @rdname modArchive
#' @export
modArchive.search.genre <- function(genre.filter  = c("unset", "Alternative", "Gothic", "Grunge", "Metal - Extreme", "Metal (general)", "Punk", "Chiptune", "Demo Style",
                                                      "One Hour Compo", "Chillout", "Electronic - Ambient", "Electronic - Breakbeat", "Electronic - Dance",
                                                      "Electronic - Drum and Bass", "Electronic - Gabber", "Electronic - Hardcore", "Electronic - House", "Electronic - IDM",
                                                      "Electronic - Industrial", "Electronic - Jungle", "Electronic - Minimal", "Electronic - Other",
                                                      "Electronic - Progressive", "Electronic - Rave", "Electronic - Techno", "Electronic (general)", "Trance - Acid",
                                                      "Trance - Dream", "Trance - Goa", "Trance - Hard", "Trance - Progressive", "Trance - Tribal", "Trance (general)",
                                                      "Big Band", "Blues", "Jazz - Acid", "Jazz - Modern", "Jazz (general)", "Swing", "Bluegrass", "Classical", "Comedy",
                                                      "Country", "Experimental", "Fantasy", "Folk", "Fusion", "Medieval", "New Ages", "Orchestral", "Other", "Piano",
                                                      "Religious", "Soundtrack", "Spiritual", "Video Game", "Vocal Montage", "World", "Ballad", "Disco", "Easy Listening",
                                                      "Funk", "Pop - Soft", "Pop - Synth", "Pop (general)", "Rock - Hard", "Rock - Soft", "Rock (general)", "Christmas",
                                                      "Halloween", "Hip-Hop", "R and B", "Reggae", "Ska", "Soul"),
                                    format.filter = c("unset", "669", "AHX", "DMF", "HVL", "IT", "MED", "MO3", "MOD", "MTM", "OCT", "OKT", "S3M", "STM", "XM"),
                                    size.filter   = c("unset", "0-99", "100-299", "300-599", "600-1025", "1025-2999", "3072-6999", "7168-100000"),
                                    page,
                                    api.key) {
  genre.filter  <- match.arg(genre.filter)
  genre.filter  <- genre.table$genre.id[genre.table$genre == genre.filter]
  format.filter <- match.arg(format.filter)
  size.filter   <- match.arg(size.filter)
  api.key       <- as.character(api.key[[1]])

  xmlcode <- paste0("http://api.modarchive.org/xml-tools.php?key=",
                    api.key,
                    "&request=search&type=genre&query=",
                    genre.filter)
  if (format.filter != "unset") xmlcode <- paste0(xmlcode, "&format=",  format.filter)
  if (size.filter   != "unset") xmlcode <- paste0(xmlcode, "&size=",    size.filter)
  if (!missing(page)) xmlcode <- paste0(xmlcode, "&page=", as.integer(page[[1]]))
  result <- .get.module.table(xmlcode, "module")
  return(result)
}

#' @rdname modArchive
#' @export
modArchive.search.artist <- function(search.artist, page, api.key) {
  api.key       <- as.character(api.key[[1]])
  search.artist <- as.character(search.artist[[1]])
  api.key       <- as.character(api.key[[1]])
  xmlcode <- paste0("http://api.modarchive.org/xml-tools.php?key=",
                    api.key,
                    "&request=search_artist&query=",
                    search.artist)
  if (!missing(page)) xmlcode <- paste0(xmlcode, "&page=", as.integer(page[[1]]))
  result <- .get.module.table(xmlcode, "item")
  return(result)
}

#' @rdname modArchive
#' @export
modArchive.search.hash <- function(search.hash, api.key) {
  search.hash   <- as.character(search.hash[[1]])
  api.key       <- as.character(api.key[[1]])
  xmlcode <- paste0("http://api.modarchive.org/xml-tools.php?key=",
                    api.key,
                    "&request=search&type=hash&query=",
                    search.hash)
  result <- .get.module.table(xmlcode, "module")
  return(result)
}

#' @rdname modArchive
#' @export
modArchive.random.pick <- function(genre.filter  = c("Alternative", "Gothic", "Grunge", "Metal - Extreme", "Metal (general)", "Punk", "Chiptune", "Demo Style",
                                                     "One Hour Compo", "Chillout", "Electronic - Ambient", "Electronic - Breakbeat", "Electronic - Dance",
                                                     "Electronic - Drum and Bass", "Electronic - Gabber", "Electronic - Hardcore", "Electronic - House", "Electronic - IDM",
                                                     "Electronic - Industrial", "Electronic - Jungle", "Electronic - Minimal", "Electronic - Other",
                                                     "Electronic - Progressive", "Electronic - Rave", "Electronic - Techno", "Electronic (general)", "Trance - Acid",
                                                     "Trance - Dream", "Trance - Goa", "Trance - Hard", "Trance - Progressive", "Trance - Tribal", "Trance (general)",
                                                     "Big Band", "Blues", "Jazz - Acid", "Jazz - Modern", "Jazz (general)", "Swing", "Bluegrass", "Classical", "Comedy",
                                                     "Country", "Experimental", "Fantasy", "Folk", "Fusion", "Medieval", "New Ages", "Orchestral", "Other", "Piano",
                                                     "Religious", "Soundtrack", "Spiritual", "Video Game", "Vocal Montage", "World", "Ballad", "Disco", "Easy Listening",
                                                     "Funk", "Pop - Soft", "Pop - Synth", "Pop (general)", "Rock - Hard", "Rock - Soft", "Rock (general)", "Christmas",
                                                     "Halloween", "Hip-Hop", "R and B", "Reggae", "Ska", "Soul"),
                                   format.filter = c("unset", "669", "AHX", "DMF", "HVL", "IT", "MED", "MO3", "MOD", "MTM", "OCT", "OKT", "S3M", "STM", "XM"),
                                   size.filter   = c("unset", "0-99", "100-299", "300-599", "600-1025", "1025-2999", "3072-6999", "7168-100000"),
                                   api.key) {
  genre.filter  <- match.arg(genre.filter)
  genre.filter  <- genre.table$genre.id[genre.table$genre == genre.filter]
  format.filter <- match.arg(format.filter)
  size.filter   <- match.arg(size.filter)
  api.key       <- as.character(api.key[[1]])

  xmlcode <- paste0("http://api.modarchive.org/xml-tools.php?key=",
                    api.key, "&request=random")
  if (format.filter != "unset") xmlcode <- paste0(xmlcode, "&format=",  format.filter)
  if (size.filter   != "unset") xmlcode <- paste0(xmlcode, "&size=",    size.filter)
  if (genre.filter  != "unset") xmlcode <- paste0(xmlcode, "&genreid=", genre.filter)
  result <- .get.module.table(xmlcode, "module")
  return(result)
}
