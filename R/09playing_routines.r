setGeneric("playingtable",
           function(mod, starting.position = 1, ticks = 6, speed = 0x7D){
             standardGeneric("playingtable")
           })

setMethod("playingtable", "PTModule", function(mod, starting.position, ticks, speed){
  # XXX to be exported in later releases

  #' Title XXX
  #'
  #' Description XXX
  #'
  #' Details XXX
  #' @rdname playingtable
  #' @name playingtable
  #' @aliases playingtable,PTModule-method
  #' @param mod XXX
  #' @param starting.position XXX
  #' @param ticks XXX
  #' @param speed XXX
  #' @return XXX
  #' @examples
  #' ## XXX
  #' @author Pepijn de Vries
  #' @export

  # xxx checken of alle input juist is!
  pat_play_tables <- lapply(mod@patterns, function(pattern){
    result <- data.frame(position = NA,
                         pattern = NA,
                         row = 1:maximumPatternTableRowCount,
                         tick = NA,
                         speed = NA)
    block <- PTBlock(pattern, 1:maximumPatternTableRowCount, 1:maximumTrackCount)
    effect_codes <- matrix(lapply(block, function(cell){
      effectCode(effect(cell))}), maximumPatternTableRowCount, maximumTrackCount)
    effect_mags  <- matrix(unlist(lapply(block, function(cell){
      effectMagnitude(effect(cell))})), maximumPatternTableRowCount, maximumTrackCount)
    ticks <- matrix(NA, maximumPatternTableRowCount, maximumTrackCount)
    ticks[effect_codes == "F" & effect_mags <= 0x1F] <-
      effect_mags[effect_codes == "F" & effect_mags <= 0x1F]
    ticks <- unlist(apply(ticks, 1, function(x){
      x <- x[!is.na(x)]
      if (length(x) == 0) return (NA) else return(tail(x, 1))
    }))
    result$ticks <- ticks
    speed <- matrix(NA, maximumPatternTableRowCount, maximumTrackCount)
    speed[effect_codes == "F" & effect_mags > 0x1F] <-
      effect_mags[effect_codes == "F" & effect_mags > 0x1F]
    speed <- unlist(apply(speed, 1, function(x){
      x <- x[!is.na(x)]
      if (length(x) == 0) return (NA) else return(tail(x, 1))
    }))
    result$speed         <- speed
    result$loop          <- NA # E6X codes
    result$position.jump <- NA # BXX codes
    result$pattern.break <- NA # DXX codes
    return(result)
  })
  result <- NULL
  for (i in starting.position:patternOrderLength(mod))
  {
    ## xxx dit moet nog complexer, rekening houden met position jumps
    pat_tab <- pat_play_tables[[1 + patternOrder(mod)[i]]]
    pat_tab$position <- i
    pat_tab$pattern  <- 1 + patternOrder(mod)[i]
    result <- rbind(result, pat_tab)
  }
  return(result)
})
