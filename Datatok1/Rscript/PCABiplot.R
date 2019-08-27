
#---------#
# package #
#---------#
library(MASS)


#データの変換
data.pca <- scale(Boston[,-14])

#-----#
# PCA #
#-----#
#sdev : 標準偏差
#rotation : 固有ベクトル
#center : 特徴量平均値
#sclae : 正規化パラメータ
#x : 主成分スコア
#主成分をいくつまで採用するかは目的によって異なる
#例えば、以下のようにbiplotを用いて二次元平面に可視化したい場合は
#第二主成分までを用いる
res.pca=prcomp(data.pca)

#第一主成分(スコア)と第二主成分を用いて、二次元プロットを行う
biplot(res.pca)
