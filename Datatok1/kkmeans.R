library(kernlab)


#カーネルkmeansではないっぽい
#多分重み付きカーネルkmeans
#@で出力する
#.Data : クラスわけ
#size : 各クラスの個数
#centers : クラスタの中心
res.kkmeans=kkmeans(as.matrix(iris[,-5]),centers=3,kernel="rbfdot",kpar=list(sigma=2))
