maps<-function(object,mode="driving"){
  library(rjson)
  n<-nrow(object)
  dist<-c()
  dur<-c()
  for (i in 1:n){
    if (mode=="transit"){
      u<-paste("http://maps.googleapis.com/maps/api/directions/json?origin=",object[i,1],
               "&destination=",object[i,2],
               "&mode=transit","&arrival_time=21600",sep="")
    }
    else {
      u<-paste("http://maps.googleapis.com/maps/api/directions/json?origin=",object[i,1],
               "&destination=",object[i,2],sep="")}
    if (inherits(try(dat<-fromJSON(file=file(u))), "try-error")){next}
    else {
      dist<-append(dist,as.numeric(dat[[2]][[1]][["legs"]][[1]][["distance"]][2])/1000)
      dur<-append(dur,as.numeric(dat[[2]][[1]][["legs"]][[1]][["duration"]][2])/60)
    }
    Sys.sleep(.5)
  }
  result<-data.frame(object,data.frame("distance"=dist,"duration"=dur))
  return(result)
}
