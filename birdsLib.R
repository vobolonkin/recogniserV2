library(tuneR)
library(monitoR)
library(dplyr)


samp.rate = 44100
hopt = 0.025
wint = hopt*3
kk=11 #median filter length


getMel <- function(x) {
  # produces melcepstrum coeffs
  # x -- Wave object
  require(tuneR)
  
  tmp<-melfcc(
    x,
    minfreq = 1000,
    maxfreq = 10000,
    fbtype = "mel",
    numcep = 12,
    hopt = hopt, 
    wint = wint
  )
  return(tmp)
}

getMCPow<-function(x, excl=1){
  # x -- typically -- melcepstrum coefficients
  colSums(t(abs(x[,-(excl)])))
}

showMCPow<-function(
  pov,
  xl=NULL, 
  hlines=c(quantile(pov, probs = c(0.25, 0.75))),
  hopt=0.025,
  samp.rate=44100,
  tit=""
)
{
  pov[is.nan(pov)]<-1
  mm=runmed(pov, k=kk)
  tt=(1:length(pov))*0.025
  plot(tt, pov, type="b", pch=1, cex=0.3,
       xlab = "time, sec",
       ylab = "pov, units",
       xlim = xl, 
       main=tit)
  lines(tt, mm, col=2, xlim=xl)
  abline(h=hlines, col="blue", lty=2)
  grid()
}

getAWins<-function(pov, thr=NULL ){
  pov[is.nan(pov)]<-0
  mm=runmed(pov, k=kk)
  if(is.null(thr)) thr=quantile(mm, 0.75)
  tmp<-diff(c(0,  as.numeric(mm > thr), 0))
  data.frame(start=which(tmp==1), end=which(tmp==-1))*hopt
}

inrange <- function(x, rr) {(x >= rr[1]) & (x <= rr[2])}

winsWav <- function(infile=ifn, outfile=ofn, ww=action.wins[ii,], pad=seq(0, 0.5*samp.rate)){
  #pad -- space between recors, in samples
  snd<-pad
  
  tmp<-apply(ww, 1, function(x) c(readWave(ifn, from=x[1], to=x[2], units = "sec")@left, pad))
  snd<-c(pad, do.call("c",tmp))
  snd<-Wave(left=snd)
  writeWave(snd,filename = outfile , extensible = F)
}

