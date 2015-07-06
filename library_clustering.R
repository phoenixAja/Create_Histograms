#Author = Phoenix Logan
#Usage: cluster libraries for SM 

clust_files <- list.files(".", pattern="*txt")
scanned_file <- readLines(clust_files[1])

file_info <- vector(mode="character", length = length(scanned_file))
spl_file <- strsplit(scanned_file, "[_ ]")
for (j in seq_along(spl_file)) {
  glue_file <- paste(spl_file[j][[1]][1], spl_file[j][[1]][4])
  file_info[[j]] <- glue_file
}

positions <- grep("lcp 0", file_info)
file_new <- file_info[-positions]
# the uniques
file_uniques <- unique(file_info) 
#get the counts
library_tables <- table(file_new)

z <- strsplit(library_tables)

for (i in seq_along(file_uniques)){
  stored_uniques <- vector(mode = "numeric", length = length(file_uniques))
  split_line <- strsplit(file_new[i], " ")
  g <- grep(split_line[2], file_new)
  stored_uniques[i] <- paste(file_new[i], length(g), " ")
}
