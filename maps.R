maps<-function(object,mode="driving",arrival="21600",auth=NULL,region=NULL){
n.dirs <- NROW(object) # Total number of directions in the query
data <- matrix(NA,n.dirs,2) # Matrix for results
n.blocks <- ceiling(n.dirs/10) # Number of blocks

# Generate the inital URL for the whole query.
# The URL is a combination of strings.
if (n.blocks==1){
  u <- gen.url(object,mode,arrival,auth,region)
} else {
  blocks <- list()
  for (i in 1:n.blocks){
    if (i != n.blocks){
      blocks <- c(blocks,gen.url(object[(i-1)*10+1:10,],mode,arrival,auth,region))
    } else {
      blocks <- c(blocks,gen.url(object[-(1:((i-1)*10)),],mode,arrival,auth,region))
    }
  }
}

# Check, whether one URL exceeds the maximum string length and split the respective entry if necessary
for (i in 1:n.blocks){
  if (length(strsplit(blocks[[i]],split="")[[1]])>1950){
    subblocks <- list()
    j <- 1 # Initial condition of j
    if (i==n.blocks) {n.dirs <- NROW(object[-(1:((i-1)*10)),])} else {n.dirs <- 10}
    while (j < n.dirs){
      for (k in n.dirs:j){
        u <- gen.url(object[(i-1)*10+j:k,],mode,arrival,auth,region)
        if (length(strsplit(u,split="")[[1]])<1950) {break}
      }
      subblocks <- c(subblocks,u)
      j <- j + k
    }
    blocks[[i]] <- unlist(subblocks)
  }
}

pb <- txtProgressBar(width=75,style=3)
for (i in 1:length(blocks)){
  for (k in 1:length(blocks[[i]])){
    f <- file(blocks[[i]][k])
    dat <- fromJSON(file=f)
    Sys.sleep(1.1)
    close(f)
    if (dat[[2]][1]=="You have exceeded your rate-limit for this API.") {
      stop("You have exceeded your rate-limit for this API.")
    }
    if (dat[[4]]=="MAX_ELEMENTS_EXCEEDED") {
      stop("Maximum amount of elements is larger than allowed.")
    }
    n.dirs <- length(dat[[3]])
    dist <- c()
    dur <- c()
    for (j in 1:n.dirs){
      if (!is.null(dat$rows[[j]]$elements[[j]]$distance$value)){
        dist <- append(dist,dat$rows[[j]]$elements[[j]]$distance$value/1000)
        dur <- append(dur,dat$rows[[j]]$elements[[j]]$duration$value/3600)
      } else {
        dist <- append(dist,NA)
        dur <- append(dur,NA)
      }
    }
    data[(i-1)*10+1:n.dirs,1:2] <- c(dist,dur)
  }
  setTxtProgressBar(pb,i/n.blocks)
}

res <- data.frame(object,data)
names(res) <- c("From","To","Distance (km)","Duration (h)")

if (anyNA(res[,3])) {warning("Error(s) in data download. Results contain NAs.")}
return(res)
}
