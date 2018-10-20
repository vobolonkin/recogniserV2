rm(list=ls(all=T))
require(tuneR)
require(monitoR)


sigDir<-"/Volumes/VladBackup/Birds/StarlingCalls/Ron Sinclair_Turretfield_2009/"
lfn<-"MU000_20091021_172000.wav"
ifn=paste0(sigDir, lfn)

sta=0
sto=30
wL<-mono(readWave(ifn, from=sta, to=sto, units="minutes"))

hopt=0.01
wint=hopt*2.5

ars<-list(  samples=wL,
            minfreq = 3000,
            maxfreq = 10000,
            fbtype = "mel",
            numcep = 12,
            hoptime = hopt, 
            wintime = wint
)


ars$minfreq<-1000



mf<-do.call("melfcc", ars)

##Grid picture by min and max freq
#Saved as "gridDensityMinMaxFreq*.pdf"

op<-par(mfcol=c(4, 4), mar=c(1,1,1,1))
for (minfre in c(1000, 2000)){
#for (minfre in c(3000, 5000)){
    cat(minfre,"\n")
  for (wco in c(2, 5)){
 #   cat("\t",maxfre,"\n")
    for(hopt in c(0.02, 0.05)){
      cat("\t\t",hopt,"\n")
      for (numc in c(36, 48)){
        cat("\t\t",numc,"\n")
        ars$minfreq<-minfre
        ars$numcep<-numc
        ars$maxfreq<-5000
        ars$hoptime=hopt
        ars$wintime=wco*hopt
        mf<-do.call("melfcc", ars)
        plot(density(colSums(t(abs(mf)))), xlim=c(100,400), ylim=c(0,0.05), main="")
        title(main=paste("i",ars$minfreq, " x:", ars$maxfreq, " h:", hopt, " w:",wco, "n:", numc, sep=""), line=-1)
        grid()
      }
    }
  }
}

### By windows
ars<-list(  samples=wL,
            minfreq = 3000,
            maxfreq = 10000,
            fbtype = "mel",
            numcep = 12,
            hoptime = hopt, 
            wintime = wint
)




(
  x,
  minfreq = 3000,
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


for(mf in c(200, 500, 1000, 2000, 3000, 4000, 5000))