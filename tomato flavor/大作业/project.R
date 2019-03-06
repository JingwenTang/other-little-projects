library(xlsx)
library(MASS)
library(psych)
outcome = as.data.frame(read.xlsx("E:/third-2nd/多元统计分析/大作业/tomato.xlsx",sheetIndex = 1))[,-1]
chemical = as.data.frame(read.xlsx("E:/third-2nd/多元统计分析/大作业/tomato.xlsx",sheetIndex = 2))[,-1]
plot(outcome$Overall.Flavor.Intensity)
plot(outcome$OVERALL.LIKING)
barplot(outcome$Overall.Flavor.Intensity,main = "barplot of overall flavor intensity")
barplot(outcome$OVERALL.LIKING,main = "barplot of overall liking")
pairs(outcome)
par(pty = "m")
pairs(chemical)
outcome.sub = outcome[,2:7]

likefit0 = lm(outcome$OVERALL.LIKING~1,data = outcome.sub)
likefit1 = lm(outcome$OVERALL.LIKING~.,data = outcome.sub)
likefit.step=stepAIC(likefit0,scope=list(upper=likefit1, lower=~1), direction="both",k=2)
likefit.step$anova
likefit = lm(outcome$OVERALL.LIKING ~ TEXTURE + Sweetness + Sourness + Umami + 
               Bitter + Salty,data = outcome)
summary(likefit)

flavorfit0 = lm(outcome$Overall.Flavor.Intensity~1,data = outcome.sub)
flavorfit1 = lm(outcome$Overall.Flavor.Intensity~.,data = outcome.sub)
flavorfit.step=stepAIC(likefit0,scope=list(upper=likefit1, lower=~1), direction="both",k=2)
flavorfit.step$anova
flavorfit = lm(outcome$Overall.Flavor.Intensity ~ TEXTURE + Sweetness + Sourness + Umami + 
               Bitter + Salty,data = outcome)
summary(flavorfit)
cor(outcome$OVERALL.LIKING,outcome$Overall.Flavor.Intensity)
plot(outcome$OVERALL.LIKING,outcome$Overall.Flavor.Intensity)


fa.parallel(outcome.sub,fa="pc",n.iter=100,show.legend=F,main = "Scree plot with parallel analysis of flavor")
cor(outcome.sub)
outcome.pc<-princomp(outcome.sub,cor=TRUE)
summary(outcome.pc,loadings=TRUE)

outcome.pc$scores[,1:2]
par(pty="s")
plot(outcome.pc$scores[,1],outcome.pc$scores[,2],
     ylim=range(outcome.pc$scores[,1]),
     xlab="PC1",ylab="PC2",type="n",lwd=2)
text(outcome.pc$scores[,1],outcome.pc$scores[,2],
     labels=abbreviate(row.names(outcome)),cex=0.7,lwd=2)
library(car)
dataEllipse(outcome.pc$scores[,1],outcome.pc$scores[,2],levels = 0.90)
outcome_pc = principal(outcome.sub,nfactors = 2,rotate = "none")
outcome_pc
round(unclass(outcome_pc$weights),2)



fa.parallel(chemical,fa="pc",n.iter=100,show.legend=F,main = "Scree plot with parallel analysis of chemicals")
cor(chemical)
chemical.pc<-princomp(chemical,cor=TRUE)
summary(chemical.pc,loadings=TRUE)
chemicalpar.pc$scores[,1:7]
par(pty="s")
plot(chemical.pc$scores[,1],chemical.pc$scores[,2],
     ylim=range(chemical.pc$scores[,1]),
     xlab="PC1",ylab="PC2",type="n",lwd=2)
text(chemical.pc$scores[,1],chemical.pc$scores[,2],
     labels=abbreviate(1:89),cex=0.7,lwd=2)
chemical_pc = principal(chemical,nfactors = 7)
chemical_pc


#regression analysis
par(mfrow=c(1,2))
plot(outcome.pc$scores[,1],outcome$OVERALL.FLAVOR.INTENSITY,xlab="PC1")
plot(outcome.pc$scores[,2],outcome$OVERALL.FLAVOR.INTENSITY,xlab="PC2")
summary(lm(outcome$Overall.Flavor.Intensity~outcome.pc$scores[,1]+outcome.pc$scores[,2]))
plot(outcome.pc$scores[,1],outcome$OVERALL.LIKING,xlab="PC1")
plot(outcome.pc$scores[,2],outcome$OVERALL.LIKING,xlab="PC2")
summary(lm(outcome$OVERALL.LIKING~outcome.pc$scores[,1]+outcome.pc$scores[,2]))

par(mfrow=c(1,1))
library(psych)
correlations = cor(outcome.sub)
fa.parallel(correlations,n.obs = 89,fa = "fa",n.iter = 100,show.legend = F,main = "Scree plots with parallel analysis of factor analysis of outcome")
fa = fa(r = correlations,nfactors = 2,rotate = "none",fm = "ml")
fa
fa.varimax = fa(correlations,nfactors = 2,rotate = "varimax",fm = "ml")
fa.varimax


CCAdata1 <- outcome.sub #此处选取原始数据第1、2、3列为第一组指标
#第二组指标
CCAdata2 <- chemical #此处选取原始数据第4、5、6列为第二组指标

#对第一、二组指标进行中心化和标准化，用于消除数据数量级的影响
CCAdata1_Z<-scale(CCAdata1)  #（输出序号1）
CCAdata2_Z<-scale(CCAdata2)  #（输出序号2）

#cancor用于典型相关分析的计算及输出
ca<-cancor(CCAdata1_Z,CCAdata2_Z);ca  #（输出序号3）


#样本数据在典型变量下得分计算及输出
U<-as.matrix(CCAdata1_Z)%*% ca$xcoef ; U   #xcoef为第一组指标数据的典型载荷（输出序号4）
V<-as.matrix(CCAdata2_Z)%*% ca$ycoef ; V   #ycoef为第二组指标数据的典型载荷（输出序号5）

corcoef.test<-function(r, n, p, q, alpha=0.1)
{
  m<-length(r); Q<-rep(0, m); lambda <- 1
  for (k in m:1)
  {
    lambda<-lambda*(1-r[k]^2);
    Q[k]<- -log(lambda)
  }
  s<-0; i<-m
  for (k in 1:m)
  {
    Q[k]<- (n-k+1-1/2*(p+q+3)+s)*Q[k]
    chi<-1-pchisq(Q[k], (p-k+1)*(q-k+1))
    if (chi>alpha)
    {
      i<-k-1; break
    }
    s<-s+1/r[k]^2
  }
  i
}

#典型相关系数检验结果
corcoef_test <- corcoef.test(r=ca$cor,n=20,p=3,q=3) #n代表训练数据样本数，p代表第一组指标数，q代表第二组指标数（输出序号7）
#画相关变量U和V的数据散点图，此处因为前面每组指标均有三个变量，故画三个
#画相关变量U1和V1为坐标的数据散点图（输出序号6）
par(mfrow=c(1,3))
plot(U[,1], V[,1], xlab="U1", ylab="V1")
#画相关变量U1和V1为坐标的数据散点图
plot(U[,2], V[,2], xlab="U2", ylab="V2")
#画相关变量U1和V1为坐标的数据散点图
plot(U[,3], V[,3], xlab="U3", ylab="V3")
plot(U[,4], V[,4], xlab="U4", ylab="V4")
plot(U[,5], V[,5], xlab="U5", ylab="V5")
plot(U[,6], V[,6], xlab="U6", ylab="V6")
