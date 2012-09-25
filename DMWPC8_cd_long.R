require(stringr)

unmunged <- readLines("toMunge/DMWPC8_cd_long.txt")

## skip the 3 first line and last night ( metadata )
unmunged <- head(tail(unmunged, -3), -1)

## take the header
names <- strsplit(head(unmunged, 1), " ")[[1]]
names <- names[nchar(names) > 0]

unmunged <- tail(unmunged, -1)
## remove empty line
unmunged <- unmunged[sapply(unmunged, nchar) > 0]
## remove lines with "-------"
unmunged <- unmunged[!str_detect(unmunged, "^\\-")]

track <- unmunged[str_detect(unmunged, "^\\+")]
track <- str_replace_all(track, "\\+", "")
attr(track)
CD <- unmunged[!str_detect(unmunged, "^\\+")]
## repeat each CD record two times
CD
writeLines(CD, "tmp.txt")
paste(CD, collapse = "\n")
CD <- read.table("tmp.txt", header = FALSE, sep = "\t")

ls()



## get name for the final DF
names <- unique(c(sapply(unmungedlist, function(x) sapply(strsplit(x, ":"), '[', 1))))
## get the values into list
values <- lapply(unmungedlist, function(x) sapply(strsplit(x, ": "), '[', 2))
## values <- lapply(lapply(unmungedlist, str_replace_all, paste(c(names, "\\: "), collapse = "|"), ""), as.vector)
Dat <- as.data.frame(Reduce(rbind, values), row.names = TRUE, stringsAsFactors = FALSE)
names(Dat) <- names
Dat$Year <- as.numeric(Dat$Year)
str(Dat)

### save data
write.csv(Dat, "./Munged/DMWPC6_cd.csv", row.names = FALSE)
