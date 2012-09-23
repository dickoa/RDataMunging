require(stringr)

unmunged <- readLines("./toMunge/wrangler_crimedat.txt")

## empty line starting with ","
unmunged <- str_replace_all(unmunged, "^\\,", "")
unmunged <- unmunged[sapply(unmunged, nchar) > 0]


### extract City name
unmunged <- str_replace_all(unmunged, "^Reported crime in ", "")

###
index <- str_locate_all(unmunged, "[A-Za-z]")
Ind <- sapply(index, function(x) length(x) > 0)
repind <- 5
state <- unmunged[Ind]
state <- str_replace(state, "\\,", "")
State <- rep(state, each = repind)

unmunged <- unmunged[!Ind]
unmunged <- paste(unmunged, State, sep = ",")
unmunged <- c(c("Year,Crime,State"), unmunged)


writeLines(unmunged, "./Munged/wrangler_crimedat.csv")
