require(stringr)

unmunged <- readLines("toMunge/DMWPC8_cd_long.txt")

## skip the 3 first line and last line ( metadata )
unmunged <- head(tail(unmunged, -3), -1)

## take the header
names <- strsplit(head(unmunged, 1), " ")[[1]]
names <- names[nchar(names) > 0]

### each field length
x <- nchar(strsplit(head(unmunged, 1), " ")[[1]])

s <- 0
j <- 0
ncharlist <- list()
for (i in seq_along(x[-1])) {
    if (x[i] != 0) {
        s <- x[i]
    } else {
        s <- s + 1
    }
    if (x[i+1] !=  0) {
        j <- j + 1
        ncharlist[j] <- s + 1
    }
}

## not safe but the fact that i and j are not local to
## the for loop and if control struct
j <- j + 1
ncharlist[j] <- x[i+1]
ncharlist <- unlist(ncharlist)

unmunged <- tail(unmunged, -1)

## remove empty line
unmunged <- unmunged[sapply(unmunged, nchar) > 0]
## remove lines with "-------"
unmunged <- unmunged[!str_detect(unmunged, "^\\-")]
newtrack <- unmunged[str_detect(unmunged, "^\\+")]
CD <- unmunged[!str_detect(unmunged, "^\\+")]

newtrack <- str_trim(str_replace_all(newtrack, "\\+", ""))

resultclean <- list()

for (i in 1:4) {
    resultclean[[i]] <- str_sub(CD, start = cumsum(c(0, ncharlist))[i], end = cumsum(c(0, ncharlist))[i+1])
}

names(resultclean) <- names

## extra white space at the begining and the end
resultclean <- lapply(resultclean, str_trim)

othertrack <- resultclean

## every two track correspond to one entry in resultclean list
for (i in seq_len(length(othertrack))) othertrack[[i]] <- rep(othertrack[[i]], each = 2)
othertrack$Title <- newtrack


othertrack <- as.data.frame(othertrack)
resultclean <- as.data.frame(resultclean)
finalresult <- rbind(resultclean, othertrack)
finalresult <- arrange(finalresult, Artist, Label, Label, Released)
finalresult
### save data
write.csv(finalresult, "./Munged/DMWPC8_cd_long.csv", row.names = FALSE)








