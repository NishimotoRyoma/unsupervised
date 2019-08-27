#---------#
# package #
#---------#

library(kernlab)


#データの変換
data.kpca <- scale(Boston[,-14])



#------#
# kPCA #
#------#
#pcv : 結果を取りだす
#主成分をいくつまで採用するかは目的によって異なる
#例えば、以下のようにbiplotを用いて二次元平面に可視化したい場合は
#第二主成分までを用いる
res.kpca<-kpca(data.kpca,kernel="rbfdot",kpar=list(sigma=3),features=2)
plot(res.kpca@pcv)
