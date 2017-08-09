RandomPlateArray.f=function(n=3,evenWellAssays=TRUE){
  s=floor(93/n)
  blank=95-(s*n)
  x=c(rep_len(1:n,(s*n)),rep_len("blank",blank))
  
  #calculate the number of wells for RNA, flow, and biomass
  if (evenWellAssays==TRUE){
    no.wells=floor(s/3)
  }
  
  y=matrix(sample(x,size=(95), replace=FALSE, prob=NULL), nrow=8, ncol=12)
  #there will be a warning; it is okay
  y[8,12]="OW"
  colnames(y)=c(1:12)
  row.names(y)=c("A", "B", "C", "D", "E", "F", "G", "H")
  print("Member Well assignments. H12 is always an open well (OpenWell)")
  print(y)
  
  
  ##
  u=as.factor(c(1:n))
  
  #Randomly sample y for wells to pull for each of the assays
  out=NULL
  for (i in 1:length(u)){
    #subset each isolate's dataset to include matrix indices
    w=which(y == u[i], arr.ind = TRUE)
    
    assayset=c(rep(c("RNA"),((no.wells*n+2)/2)),rep(c("BIOMASS"),((no.wells*n)/3)),rep(c("FLOW CYTO."),((no.wells*n)/6)))
    z=dim(w)[1]-length(assayset)
    z2=rep("none",z)
    assayset2=c(assayset,z2)
    
    #randomly sample the isolate dataset
    assayset3=sample(assayset2,dim(w)[1],replace=FALSE)
    
    #assign assay
    w2=cbind(u[i],w,assayset3)
    out=rbind(out,w2)
  }
  colnames(out)=c("isolate","row", "col", "assayset3")
  #return(out)
  
  #reformat assays to match isolate map
  assay.mat=y
  for(j in 1:nrow(out)){
    assay.mat[as.numeric(out[j,2]),as.numeric(out[j,3])]=out[j,4]
  }
  print("Assay well assignments")
  print(assay.mat)
  
  return(list(y,assay.mat))
  
}
#How to use this script:
#Navigate to the working directory where the script is.
#load(RandomPlateArray.f)
r=RandomPlateArray.f(n=3)
