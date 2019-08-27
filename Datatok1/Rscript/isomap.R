#---------#
# package #
#---------#

library(vegan)


#isomap
#データ間の距離を入力する
#ndim : 出力する次元
#k : k近傍グラフのk
#いいデータセットが見当たらなかったので省略
data=
res.iso=isomap(dist(data),ndim=2,k=5)
