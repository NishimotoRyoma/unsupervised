#---------#
# package #
#---------#
library(clustrd)
library(stats)

#---------#
# cluspca #
#---------#
#data : metric data
#nclus : クラスタ数
#ndim : 次元数
#method : "RKM" or "FKM" :: Reduced k-means or Factorial k-means
#alpha : 0.5でRKM,0でFKM,1でTandem
#nstart : 推定回数

#Reduced K-means
data(macro)
outRKM = cluspca(macro, 3, 2, method = "RKM", rotation = "varimax", scale = FALSE, nstart = 10) 
summary(outRKM)
#Scatterplot (dimensions 1 and 2) and cluster description plot
#クラスタごとにどのような性質が強いか可視化できる
#selective biasがありそうなのが気になるが、それっぽく出る
plot(outRKM, cludesc = TRUE)




#選択アルゴリズムを実装してみる
#とりあえずパラメータ数は２個でReduced K-meansで作ってみる
selPar=function(data,mnclus,mndim,ndiv,R,nstart=10)
{
  #-----#
  # par #
  #-----#
  #data : matrix
  #mnclus : maxクラスタ数
  #mndim : max次元数(=<mnclust)
  #ndiv : dataを何個に分割するか(ndiv,ndiv,nrow(data)-2*ndiv)
  #R : 何回分割するか
  
  if(dim(data)[1]-2*ndiv<0){print("error")}
  else
  {
    res.dmat=matrix(999999,mnclus,mndim) #一時的にdistanceを保存する
    res.mat=matrix(0,mnclus,mndim) #最頻値を求めるために、どの組みが選ばれたか数えていく
    try(
    for(r in 1:R)
    {
      #データの分割
      index=sample(1:dim(data)[1],dim(data)[1],replace=FALSE)
      data1 = data[index[1:ndiv],]
      data2 = data[index[(ndiv+1):(2*ndiv)],]
      data3 = data[index[(2*ndiv+1):dim(data)[1]],]
      #rownames(data1)=1:ndiv
      #rownames(data2)=1:ndiv
      #rownames(data3)=1:(dim(data)[1]-2*ndiv)
      #繰り返しクラスタリングを行う
      for(k in 2:mnclus)
      {
        for(d in 2:mndim)
        {
          if(k>=d){
            
            #c1
            #なんかここでうまくいってなかった
            #原因特定　：なんか設定上クラスタ数と次元は２以上じゃないとダメらしい
            outRKM1=cluspca(
              as.matrix(data1),
              nclus=k,
              ndim=d,
              method = "RKM", 
              rotation = "varimax", 
              scale = FALSE, 
              nstart=nstart)
            #c2
            outRKM2=cluspca(
              data2,
              nclus=k,
              ndim=d,
              method = "RKM", 
              rotation = "varimax", 
              scale = FALSE, 
              nstart=nstart)
            #Zに関して再度クラスタリング
            transD3=cluspca(
              data3,
              nclus=k,
              ndim=d,
              method = "RKM", 
              rotation = "varimax", 
              scale = FALSE, 
              nstart=nstart)$obscoord
            
            resd31=c()
            resd32=c()
            for(d3 in 1:dim(transD3)[1])
            {
              temp.c1.dist=c()
              temp.c2.dist=c()
              #それぞれのクラスタリングにおけるcentroidと比較を行って新しいデータに対してクラスタリングする
              for(kk in 1:k)
              {
                temp.c1.dist[kk]=sum(abs(transD3[d3,]-outRKM1$centroid[kk,]))
                temp.c2.dist[kk]=sum(abs(transD3[d3,]-outRKM2$centroid[kk,]))
              }
              #分類されたクラスタナンバーを順番に保存
              resd31[d3]=which.max(temp.c1.dist)
              resd32[d3]=which.max(temp.c2.dist)
              
            }
            temp3=0
            for(i in 1:dim(transD3)[1])
            {
              for(ii in 1:dim(transD3)[1])
              {
                temp1 = as.numeric(resd31[i]==resd31[ii])
                temp2 = as.numeric(resd32[i]==resd32[ii])
                temp3 = temp3 + as.numeric(temp1+temp2==1)
              }
            }
            res.dmat[k,d] =temp3
          }

        }
      }
      #距離最小の次元数、クラスタ数を求める
      len=which(res.dmat==min(res.dmat))
      #if(length(len)>1){print("距離最小の組みが複数出てきた")}
      #else{
      #cdim=ceiling(len/dim(res.dmat)[1])
      #rdim=len-(cdim-1)*dim(res.dmat)[1]
      res.mat[len]=res.mat[len]+1
      #}
    })
    #最頻値の次元数、クラスタ数を求める
    #複数出てくる可能性がある
    print("行がクラスタ数、列が次元数、最頻値が最適")
    return(res.mat)
  }
}


selPar(data=Boston[,-14],mnclus=5,mndim=5,ndiv=230,R=30)

