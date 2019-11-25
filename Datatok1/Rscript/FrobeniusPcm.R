#画像圧縮
#---------#
# package #
#---------#
library(OpenImageR)


#-------#
# input #
#-------#
img.mat <- readImage("ota.jpg")#画像を読み込む
p=700#削減パラメータ数
#3dimがRGB


#グレースケールに変換
img.mat.gs <- apply(img.mat,c(1,2),mean)
nr <- nrow(img.mat.gs)#行数
nc <- ncol(img.mat.gs)#列数


#特異値分解はsvd関数で得られる
#$u : １個目の直交行列
#$d : 対角行列の対角成分
#$v : ２個目の直交行列
res.svd <- svd(img.mat.gs)

min_ncr=min(nc,nr)
dim_seq=1:(min_ncr-p)

img.low<-res.svd$u[,dim_seq]%*%diag(res.svd$d[dim_seq])%*%t(res.svd$v)[dim_seq,]

#可視化
par(mfrow = c(1,2))
image(t(img.mat.gs[nr:1,]), axes = FALSE, col = grey(seq(0, 1, length = 256)), asp = nr/nc)
image(t(img.low[nr:1,]), axes = FALSE, col = grey(seq(0, 1, length = 256)), asp = nr/nc)


#少しずつ削減パラメータを変更してみる
par(mfrow=c(2,2))
for(i in seq(5,20,5))
{
  p=min(nc,nr)-i
  img.low<-res.svd$u[,dim_seq]%*%diag(res.svd$d[dim_seq])%*%t(res.svd$v)[dim_seq,]
  image(t(img.low[nr:1,]), axes = FALSE, col = grey(seq(0, 1, length = 256)), asp = nr/nc)
}