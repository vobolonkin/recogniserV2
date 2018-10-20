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


#mf<-do.call("melfcc", ars)

##Grid picture by min and max freq
#Saved as "gridDensityMinMaxFreq*.pdf"

op<-par(mfcol=c(4, 4), mar=c(1,1,1,1))
for (mafre in c(5000, 20000)){
#for (minfre in c(3000, 5000)){
    cat(mafre,"\n")
  for (wco in c(1.5, 3)){
 #   cat("\t",maxfre,"\n")
#    for(hopt in c(0.01, 0.05)){
      cat("\t\t",hopt,"\n")
      for (numc in c(6, 12, 24, 36)){
        cat("\t\t",numc,"\n")
        ars$minfreq<-2000
        ars$numcep<-numc
        ars$maxfreq<-mafre
        ars$hoptime=0.025
        ars$wintime=wco*hopt
        mf<-do.call("melfcc", ars)
        plot(density(colSums(t(abs(mf[,-1])))),
             #xlim=c(0,200), ylim=c(0,0.05), 
             main="")
        title(main=c(paste("i",ars$minfreq, " x:", ars$maxfreq, " h:", hopt, " w:",wco, "n:", numc, sep=""),"mf[,-1]"), line=-1)
        grid()
      }
    }
  }
}
