dat = readLines("E:/third-2nd/数据挖掘/script.txt")
sum(is.na(dat))
index = 1:length(dat)
library(stringr)
a = sapply(dat,str_detect,"^[0-9]{3,4}")
sum(a)
ind = index[a][-3]
script = rep(0,length(ind))
for (i in 1:(length(ind)-1)){
  script[i] = dat[ind[i]]
  for (j in ind[i]:(ind[i+1]-1)){
    script[i] = paste(script[i],dat[j+1],sep = ' ')
  }
}
script[length(ind)] = dat[ind[length(ind)]]
for (j in ind[length(ind)]:(length(dat))){
  script[length(ind)] = paste(script[length(ind)],dat[j+1],sep = ' ')
}
script[length(ind)] = paste(dat[ind[length(ind)]:(length(dat))],sep = ' ')
library(rvest)
library(xml2)
library(dplyr)
library(klaR)
library(wordcloud2)
library(tm)
library(igraph)
reuters = Corpus(VectorSource(script))


myStopwords = c(stopwords('english'),"and","for","has","may","the","who","all","any","are","ive","now","not","was","but","get",
                "out","off","mrs","did","too","why","ago","got","lot","own","let","sir","put","men","how","she","come","have",
                "only","that","this","very","what","also","been","here","just","make","mean","ones","part","your","back","done",
                "else","ever","from","like","look","said","them","then","they","were","when","will","give","tell","dont","into",
                "sins","with","rest","told","keep","guys","take","find","lets","none","came","side","over","took","home","more",
                "made","goes","than","many","some","stay","away","both","down","move","need","much","cant","wont","even","yall",
                "each","talk","does","left","sure","must","days","thou","should","always","anyone","myself","things","taking",
                "giving","cannot","coming","really","though","saying","before","allah","about","taken","those","would","wrong",
                "years","yours","doing","heart","other","right","thats","didnt","first","never","ready","their","there","thing",
                "being","could","point","still","going","ahead","think","these","today","given","lives","after","three","wasnt",
                "shown","youre","where","later","again","gonna","meant","every","bring","shall","which","causing","know",
                "00a0","god","yes","see","say","can","last","statement","everything","anything","one")
library(SnowballC)
reuters <-tm_map(reuters, PlainTextDocument)#去除标签

reuters <-tm_map(reuters, stripWhitespace)#去多余空白
reuters <- tm_map(reuters, tolower)#转换小写
reuters <- tm_map(reuters, removeWords, stopwords("english"))
reuters <- tm_map(reuters, removeWords, c("can","got","one","just","get","well"))
tm_map(reuters, stemDocument)
myTdm = TermDocumentMatrix(reuters,control = list(wordLengths = c(2,Inf)))
m = as.matrix(myTdm)
rachel = as.vector(m["rachel",])
ross = as.vector(m["ross",])
chandler = as.vector(m["chandler",])
joey = as.vector(m["joey",])
monica = as.vector(m["monica",])
phoebe = as.vector(m["phoebe",])
pdf("my plot.pdf", 4, 4)
plot(rachel,type = "n")
lines(1:225,rachel,type = 'l',col = "pink")
lines(1:225,ross,type = 'l',col = "blue")
lines(1:225,monica,type = 'l',col = "red")
lines(1:225,chandler,type = 'l',col = "green")
lines(1:225,joey,type = 'l',col = "black")
lines(1:225,ross,type = 'l',col = "yellow")
dev.off()
library(forecast)
rachel1 = ts(rachel)
ross1 = ts(ross)
opar = par(no.readonly = T)
par(mfrow = c(2,2))
ylim = c(min(rachel1),max(rachel1))
plot(rachel1,main = "rachel1 traveler series")
plot(ma(rachel1,3),main = "simple moving average k=3",ylim = ylim)
plot(ma(rachel1,7),main = "simple moving average k=7",ylim = ylim)
plot(ma(rachel1,15),main = "simple moving average k=15",ylim = ylim)

opar = par(no.readonly = T)
par(mfrow = c(2,2))
ylim = c(min(ross1),max(ross1))
plot(ross1,main = "ross1 traveler series")
plot(ma(ross1,3),main = "simple moving average k=3",ylim = ylim)
plot(ma(ross1,7),main = "simple moving average k=7",ylim = ylim)
plot(ma(ross1,15),main = "simple moving average k=15",ylim = ylim)

name = rbind("rachel","ross","monica","chandler","joey","phoebe")
maincha = rbind(rachel,ross,monica,chandler,joey,phoebe)
maincha = as.matrix(maincha,row.names=name)
n = rowSums(maincha)
library(ggplot2)
barplot(n,names.arg = name,main = "number of occurence of main characters",xlab = "names",ylab = "frequency",ylim = c(10000,14000),xpd = F)

findAssocs(myTdm,"rachel",0.6)
findAssocs(myTdm,"ross",0.6)

findAssocs(myTdm,"chandler",0.5)
findAssocs(myTdm,"monica",0.5)

findAssocs(myTdm,"phoebe",0.5)
findAssocs(myTdm,"joey",0.4)

pairs(maincha)

cor(t(maincha))

termfrequency = rowSums(as.matrix(myTdm))
termfrequency = subset(termfrequency,termfrequency>=1500)
qplot(names(termfrequency),termfrequency,geom = "bar",xlab = "Terms") + coord_flip()


library(wordcloud)
wordFreq = sort(rowSums(m),decreasing = T)
wordFreq = wordFreq[7:length(wordFreq)]
set.seed = 375
grayLevels = grey(((wordFreq)+5000)/(max(wordFreq)+5000))
wordcloud(words = names(wordFreq),freq = wordFreq,min.freq = 800,random.order = F,colors = grayLevels)
findFreqTerms(myTdm,lowfreq = 1000)

links_statement_full = c()
for(i in 1:10){
  links_statement_full[i] = paste("https://m.imdb.com/title/tt0108778/episodes/?season=",i,sep = "")
}
rate = c()
for(j in 1:10){
  page1 = read_html(links_statement_full[j])
  print(j)
  rate = cbind(rate,t(as.numeric(page1 %>% html_nodes(css = "strong:nth-child(4)")%>% html_text())))
  
}
rate = rate[-c(24,37,110,121,137,143,146,170,193,194,235)]
r = rbind(rate,maincha)
cor(t(r))
lm.sol <- lm(rate ~ rachel+ross+monica+chandler+joey+phoebe,data = as.data.frame(t(r)))
summary(lm.sol)
fit0=lm(rate~1,data=as.data.frame(t(r)))
fit1=lm(rate~.,data=as.data.frame(t(r)))
library(MASS)
step.f=stepAIC(fit0,scope=list(upper=fit1, lower=~1), direction="both",k=2)
step.f$anova
lm.sol <- lm(rate ~ ross+monica+rachel,data = as.data.frame(t(r)))
summary(lm.sol)

m = m[name,]
m1 = m[,1:23]#rr no mc
m3 = m[,47:72]#no rr no mc
m7 = m[,141:163]#no rr mc
m10 = m[,207:225]#rr mc
rate1 = mean(rate[1:23])#rr no mc
rate3 = mean(rate[47:72])#no rr no mc
rate7 = mean(rate[141:163])#no rr mc
rate10 = mean(rate[207:225])#rr mc
co1 = cor(t(m1))
co3 = cor(t(m3))
co7 = cor(t(m7))
co10 = cor(t(m10))
rr = rep(0,4)
mc = rep(0,4)
rr[1] = co1[1,2]
mc[1] = co1[3,4]
rr[2] = co3[1,2]
mc[2] = co3[3,4]
rr[3] = co7[1,2]
mc[3] = co7[3,4]
rr[4] = co10[1,2]
mc[4] = co10[3,4]
r = cbind(rate1,rate3,rate7,rate10)
plot(rr,r)
rrr = cbind(rr,t(r))
rrr = cor(rrr)
mcr = cbind(mc,t(r))
mcr = cor(mcr)
par(mfrow = c(1,1))
myTdm2 = removeSparseTerms(myTdm,sparse = 0.005)
m2 = as.matrix(myTdm2)
distMatrix = dist(scale(m2))
fit = hclust(distMatrix,method = "ward")
plot(fit)
rect.hclust(fit,k=10)
(groups = cutree(fit,k=10))
