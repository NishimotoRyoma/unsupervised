# -*- coding: utf-8 -*-
from sklearn.cluster import SpectralClustering
import numpy as np

X = np.array([[1,1],[2,1],[1,0],
            [4,7],[3,5],[3,6]])


#--------------------#
# SpectralClustering #
#--------------------#
### Parameters ###
#n_clusters    : integer ::クラスタ数
#eigen_solver    : "amg" or "logpcg" ::固有値分解の方法
#random_state    : int ::乱数のseed
#n_int    : int=10 :: k-meansの実行回数(局所解のため),最も良いものが採用される
#gamma    : float=1.0 ::　kernelの係数
#   affinity='nearest_neighbors'の時、gammaは無視する。
#affinity    : default="rbf" or,‘nearest_neighbors’, ‘precomputed’ ::隣接行列
#n_neighbors    : integer :: nearest neighbors を用いて隣接行列を作る場合指定するk近傍
#assign_labels    : default="kmeans" or "discretize"

### Method ###
#fit(X)     :affinity matrix を作成する
#fit_predict(X)     :Xに対してクラスタリングを行いクラスタラベルを返す


clustering = SpectralClustering(
    n_clusters=2,
    assign_labels="kmeans",
    random_state=0).fit(X)



#example
#See SCexample
