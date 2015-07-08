
file_list <- list.files(".", pattern="*txt")
col_names <- colnames(file_list[1])
graph_cols <- c( "dark blue", "magenta", "darkcyan", "slateblue", "red", "olivedrab4", "orangered1")

find_mins <- function(file){
  fh <- read.table(file, header = TRUE, sep=" ")
  loc_min <- min(fh$SlogP)
  return(loc_min)
}
find_max <- function(file){
  fh <- read.table(file, header = TRUE, sep=" ")
  loc_max <- max(fh$SlogP)
  return(loc_max)
}

find_means <- function(file){
  fh <- read.table(file, header=TRUE, sep = " ")
  loc_mean <- mean(fh$SlogP)
  return(loc_mean)
}

mins <- sapply(file_list, find_mins)
global_min <- min(mins)
maxs <- sapply(file_list, find_max)
global_max <- max(maxs)
means <- sapply(file_list, find_means)
means <- format(round(means, 2))
fh <- read.table(file_list[1], header=TRUE, sep= " ")
fh_df <- as.data.frame(fh)
fd <- density(fh_df$SlogP)
plot(fd, main = "Group1 SlogP", col= "white", xlim = c(-5, 10), ylim= c(0, 0.4))

for (i in seq_along(file_list)){ 
  f <- read.table(file_list[i], header = TRUE, sep=" ")
  fd <- as.data.frame(f)
  fdens <- density(fd$SlogP)
  lines(fdens, col=graph_cols[i], lwd= 5)
}

legend("topright", c(file_list), col=c(graph_cols), cex=0.5, pch=19, pt.cex =0.5)
legend("topleft", legend = c(means), col=c(graph_cols), cex=0.5, pch=19, pt.cex =0.5)

