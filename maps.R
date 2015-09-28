maps<-function(object,mode="driving",arrival="21600",auth=NULL,region=NULL){
  goog <- "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
  from <- paste(levels(object[,1]),collapse="|")
  to <- paste(levels(object[,2]),collapse="|")
  
  mod<-paste("&mode=",mode,sep="")
  arriv<-paste("&arrival_time=",arrival,sep="")
  aut<-paste("&key",auth,sep="")
  reg<-paste("&region=",region,sep="")
  
  u <- paste(goog,from,"&destinations=",to,sep="")
  if(mode=="transit") u<-paste(u,mod,arriv,sep="")
  if(!is.null(region)) u<-paste(u,reg,sep="")
  if(!is.null(auth)) u<-paste(u,aut,sep="")
  f <- file(u)
  dat <- fromJSON(file=f)
  
  dist <- c()
  dur <- c()
  for (i in 1:nrow(object)){
    dist <- append(dist,dat$rows[[i]]$elements[[1]]$distance$value/1000) # extract kilometers
    dur <- append(dur,dat$rows[[i]]$elements[[1]]$duration$value/3600) # extract hours of journey
  }
  close(f)

  res <- cbind(object, data.frame("distance"=dist,"duration"=dur))
  return(res)
}
