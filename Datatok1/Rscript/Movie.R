#---------#
# package #
#---------#
library(OpenImageR)
library(MASS)

#-------#
# input #
#-------#
#s :　主成分の次元
#X : 動画をフレームごとに行列として並べたもの
s=3
X<- readRDS("lobdata.rds")

res.pca <- prcomp(X,center=FALSE)
A <- res.pca$rotation
#主成分行列を作成(s次元)
Lmat <- (X%*%A[,1:s]%*%t(A[,1:s]))
#残り
Emat <- X-Lmat
E.abs <- abs(E)


#結果の可視化
fnum <- 110#何フレーム目か指定
tmp.org <- matrix(X[fnum,], 160, 128)
tmp.low <- matrix(Lmat[fnum,], 160, 128)
tmp.err <- matrix(Emat[fnum,], 160, 128)
#可視化
par(mfrow=c(1,3))
image(tmp.org[,128:1], axes = FALSE, col =grey(seq(0, 1, length = 256)), asp = 128/160)#オリジナルフレーム
image(tmp.low[,128:1], axes = FALSE, col =grey(seq(0, 1, length = 256)), asp = 128/160)#低ランク
image(tmp.err[,128:1], axes = FALSE, col =grey(seq(0, 1, length = 256)), asp = 128/160)#誤差の絶対値


fnum <- 200#何フレーム目か指定
tmp.org <- matrix(X[fnum,], 160, 128)
tmp.low <- matrix(Lmat[fnum,], 160, 128)
tmp.err <- matrix(Emat[fnum,], 160, 128)
#可視化
par(mfrow=c(1,3))
image(tmp.org[,128:1], axes = FALSE, col =grey(seq(0, 1, length = 256)), asp = 128/160)#オリジナルフレーム
image(tmp.low[,128:1], axes = FALSE, col =grey(seq(0, 1, length = 256)), asp = 128/160)#低ランク
image(tmp.err[,128:1], axes = FALSE, col =grey(seq(0, 1, length = 256)), asp = 128/160)#誤差の絶対値
