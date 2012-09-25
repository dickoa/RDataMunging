require(stringr)

unmunged <- readLines("toMunge/DMWPC6_cd.txt")
unmunged <- c("%%", unmunged)
unmungedlist <- strsplit(paste(unmunged,  collapse = "@"), "%%")[[1]][-1]
unmungedlist <- sapply(unmungedlist, strsplit, "@")
unmungedlist <- lapply(unmungedlist, '[', -1)


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
