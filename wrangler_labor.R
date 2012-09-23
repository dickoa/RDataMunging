require(stringr)


unmunged <- readLines("toMunge/wrangler_labordat.txt")
unmungedlist <- strsplit(paste(unmunged,  collapse = "@"), "Series Id: ")[[1]][-1]
unmungedlist <- sapply(unmungedlist, strsplit, "@")
names(unmungedlist) <- sapply(unmungedlist, '[', 1)

## turn each list component into DF
list2df <- function(list) {
names <- c("Id", sapply(strsplit(list[-1], ":"), '[', 1))
values <- str_trim(c(list[1], sapply(strsplit(list[-1], ":"), '[', 2)))

if (!any(str_detect(names, "experience"))) {
  names <- c(names, "Labor force experience")
  values <- c(values, NA)
}


if (!any(str_detect(names, "Occupation"))) {
  names <- c(names, "Occupation")
  values <- c(values, NA)
}



Dat <- data.frame(t(values))
names(Dat) <- names
Dat
}

write.csv(Reduce(rbind, lapply(unmungedlist, list2df)), "Munged/wrangler_labordat.csv", row.names = FALSE)
