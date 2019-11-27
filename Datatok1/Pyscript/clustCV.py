# -*- coding: utf-8 -*-
import numpy as np
from sklearn.model_selection import train_test_split
class ParamTune():
  #親クラス
  #パラメータの処理
  def __init__(self,paramlist,func,data):
    #paramlist : パラメータの辞書型列挙,len()を使用するので、値が１種類でもリストに入れること
    #func : 使用するunsupervisedの関数
    #data : 全データ
    self.paramlist=paramlist
    self.func=func
    self.data=data

  def getParamLength(self):
    #paranlistの長さを返す
    return len(self.paramlist)

  def getNumber(self):
    #パラメータの組回数を返す
    self.num=1
    for v in self.paramlist.values():
      self.num = self.num * len(v)
    return self.num

  
  def createEmptyDict(self):
    #空のパラメータdictを作る
    empdict={}
    for k in self.paramlist.keys():
      empdict.setdefault(k,)
    return empdict
  
  def createParamCombination(self):
    #全てのパラメータの組をリストで返す
    resList=[]
    self.n = self.getNumber()
    for i in range(self.n):
      tempdict=self.createEmptyDict()
      for k,v in self.paramlist.items():
        lenv=len(v)
        tempdict[k]=v[i%lenv]
      resList.append(tempdict)
    return(resList)

class UnsParamTuneProb(ParamTune):
    #子クラス
    #教師無し学習クラスタリングの不一致確率によるチューニング
    #sklearnのSpectralClusteringは次元削減を行ってからk-meansをかけるため、これを適用するのは難しい
    def __init__(self,paramlist,func,data,ratediv,R):
      #Rは全体に対する評価用データの割合
      super().__init__(paramlist,func,data)
      self.ratediv=ratediv
      self.R=R

    def splitData(self):
      #dataの分割
      #不一致確率のチューニングでは、次の要領で３分割する
      #c1 : １個目のクラスタリング用データ
      #c2 : ２個目のクラスタリング用データ
      #c3 : 評価用データ
      self.c3,self.test = train_test_split(self.data, test_size=self.ratediv)
      self.c1,self.c2 = train_test_split(self.test,test_size=0.5)
      CVdata=[]
      CVdata.append(self.c1)
      CVdata.append(self.c2)
      CVdata.append(self.c3)
      return(CVdata)
    
    def learnData(self,c1,c2,c3,paramdict):
      #c1,c2で学習した２種類のクラスタリングを用いて、c3のデータをクラスタリングし、その結果を出力する
      clustering1=self.func(**paramdict).fit(c1)
      clustering2=self.func(**paramdict).fit(c2)
      #
      res1=clustering1.predict(c3)
      res2=clustering2.predict(c3)
      cluster_resList=[]
      cluster_resList.append(res1)
      cluster_resList.append(res2)
      return(cluster_resList)
    
    def clustDistProb(self,cluster_resList):
      #learnDataの出力を入力することで、クラスタリング距離を計算する
      lenc3=len(cluster_resList[0])
      temp3=0
      for i in range(lenc3):
        for j in range(lenc3):
          temp1 = int(cluster_resList[0][i]==cluster_resList[0][j])
          temp2 = int(cluster_resList[1][i]==cluster_resList[1][j])
          temp3 = temp3 + int((temp1+temp2)==1)
      return(temp3)

    def paramTuning(self):
      #パラメータの組み合わせ全通りに対してチューニングを行う
      #繰り返し回数Rを与えて、最頻値で最も妥当なパラメータの組み合わせを探す
      allparameters=super().createParamCombination()
      CVres_vec=np.zeros(len(allparameters))
      lastreslist=[]
      for r in range(self.R):
        clustdistance=np.zeros(len(allparameters))
        for ii in range(len(allparameters)):
          alldata=self.splitData()
          clust1=alldata[0]
          clust2=alldata[1]
          clust3=alldata[2]
          clust_res=self.learnData(c1=clust1,c2=clust2,c3=clust3,paramdict=allparameters[ii])
          clustdistance[ii]=self.clustDistProb(clust_res)
        min_index=[i for i,x in enumerate(clustdistance) if x==min(clustdistance)]
        CVres_vec[min_index]=CVres_vec[min_index]+1
      
      #CVres_vecの結果が最大(最もたくさん選択)のパラメータの組を出力する
      #複数出てくる可能性もあるので、リストとして出力する。
      param_index=[i for i,x in enumerate(CVres_vec) if x==max(CVres_vec)]

      for i,x in enumerate(param_index):
        lastreslist.append(allparameters[x])
      return(lastreslist)


if __name__ == '__main__':
    import pandas as pd
    from sklearn.cluster import KMeans
    
    #試しデータ
    X =  pd.read_csv("http://pythondatascience.plavox.info/wp-content/uploads/2016/05/Wholesale_customers_data.csv")
    del(X['Channel'])
    del(X['Region'])
    X = np.array([X['Fresh'].tolist(),
                       X['Milk'].tolist(),
                       X['Grocery'].tolist(),
                       X['Frozen'].tolist(),
                       X['Milk'].tolist(),
                       X['Detergents_Paper'].tolist(),
                       X['Delicassen'].tolist()
                       ], np.int32)
    X=X.T
    
    
    #パラメータdictの設定
    P={"n_clusters":range(2,10),
    "random_state": [0]}
    
    #チューニング
    C=UnsParamTuneProb(P,KMeans,X,0.5,300)
    ss=C.paramTuning()