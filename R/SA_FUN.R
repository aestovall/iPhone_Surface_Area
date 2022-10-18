
triPts<-function(vert, tri){
  tri.m<-as.matrix(tri+1)
  
  p.v<-apply(tri.m, 1, function(x) data.frame(vert[as.numeric(x[2]),],
                                              vert[as.numeric(x[3]),],
                                              vert[as.numeric(x[4]),]) )
  p<-do.call(rbind, p.v)
  colnames(p)<-c('p1X', 'p1Y', 'p1Z',
                 'p2X', 'p2Y', 'p2Z',
                 'p3X', 'p3Y', 'p3Z')
  return(p)
}

AreaOfTriangle<-function(p1X, p1Y, p1Z, 
                         p2X, p2Y, p2Z,
                         p3X, p3Y, p3Z, id)
{
  ax = p2X - p1X
  ay = p2Y - p1Y
  az = p2Z - p1Z
  bx = p3X - p1X
  by = p3Y - p1Y
  bz = p3Z - p1Z
  cx = ay*bz - az*by
  cy = az*bx - ax*bz
  cz = ax*by - ay*bx
  
  return (c(as.numeric(0.5 * sqrt(cx*cx + cy*cy + cz*cz))))
}    

SA <- function(x){
  
  header<-fread(x, nrows = 1, sep = " ", skip=1)
  vert<-fread(x, nrows = header$V1 , sep = " ", skip=2)
  tri<-fread(x, nrows = header$V2 , sep = " ", skip=2+header$V1)
  
  triVert<-triPts(vert, 
                  tri)
  
  AOT<-AreaOfTriangle(p1X = triVert[,1], p1Y = triVert[,2], p1Z = triVert[,3], 
                      p2X = triVert[,4], p2Y = triVert[,5], p2Z = triVert[,6],
                      p3X = triVert[,7], p3Y = triVert[,8], p3Z = triVert[,9])
  
  
  triVert.cent<-data.frame(x=(triVert[,1]+triVert[,4]+triVert[,7])/3,
                           y=(triVert[,2]+triVert[,5]+triVert[,8])/3,
                           z=(triVert[,3]+triVert[,6]+triVert[,9])/3,
                           AOT=AOT)
  
  fwrite(triVert.cent,gsub(".off","_SA.asc",x), sep = " ")
  
  return(triVert.cent)
}