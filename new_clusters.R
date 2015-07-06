
file_list <- list.files(".", pattern="*txt")
col_names <- colnames(file_list[1])
graph_cols <- c( "dark blue", "magenta", "darkcyan", "slateblue", "red", "olivedrab4", "orangered1")

fh <- read.table(file_list[1], header=TRUE, sep= " ")
fh_df <- as.data.frame(fh)
fd <- density(fh_df$Weight)
plot(fd, main = "G4 Density Plot Weight", col= "white")

for (i in seq_along(file_list)){ 
  par(new=TRUE)
  f <- read.table(file_list[i], header = TRUE, sep=" ")
  fd <- as.data.frame(f)
  fdens <- density(fd$Weight)
  plot(fdens, axes=F, main = "", xlab="", col=graph_cols[i], lwd= 2.5)
}

legend("topright", c(file_list), col=c(graph_cols), cex=0.5, pch=19, pt.cex =0.5)


