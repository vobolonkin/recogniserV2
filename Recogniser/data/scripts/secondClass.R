



get_cepstrals<-function(wav){
  # wav
  win.duration<-length(wav)/4/wav@samp.rate
  win.duration<-floor(win.duration*wav@samp.rate/2)/wav@samp.rate*2
  
  m1 <- melfcc(wav, wintime = win.duration-1/44100, hoptime = win.duration/2, numcep = 48, frames_in_rows = FALSE, minfreq = 6000)
  # stopifnot(length(m1) == 84)
  as.vector((m1))
  
}




combineNeighbours<-function(test.tab){
  # test.tab<-tab.clean
  test.tab<-test.tab[order(test.tab$Begin.Time..S.),]
  start<-test.tab$Begin.Time..S.[-1]
  finish<-test.tab$End.Time..S.[-nrow(test.tab)]
  comb<-start-finish
  test.tab$comb<-c(FALSE, comb<0.5)
  
  test.tab.comb<-test.tab[1,]
  rownames(test.tab)<-NULL
  for(i in 2:nrow(test.tab)){
    # i<-3
    if(!test.tab$comb[i]){
      test.tab.comb<-rbind(test.tab.comb, test.tab[i,])
    }else{
      test.tab.comb$End.Time..S.[nrow(test.tab.comb)]<-test.tab$End.Time..S.[i]
    }
  }
  
  test.tab.comb[,-8]
}


# load recount.mlf
run_classification<-function(){
  tab<-read.delim(file = "data/results/raw/tmp_sig.txt", stringsAsFactors = FALSE)
  
  tab.clean<-tab[tab$End.Time..S. - tab$Begin.Time..S. < 5,]
  if(nrow(tab.clean)>0){
    tab.comb<-combineNeighbours(tab.clean)
    # tab.comb<-(tab.clean)
  }
  test.tab<-tab.comb
  
  
  wave.list<-list()
  for(i in 1:nrow(test.tab)){
    # i<-4
    # test.tab[1,]
    print(i)
    test.wav<-readWave(wave.orig, 
                       from = test.tab$Begin.Time..S.[i], to = test.tab$End.Time..S.[i],
                       units = "seconds"
    )
    
    cepst<-get_cepstrals(test.wav)
    wave.list[[i]]<-cepst
    
  }
  wave.ds<-do.call(rbind, wave.list)
  
  
  
  
  wav.scale<-as.data.frame(scale(wave.ds))
  dim(wave.ds)
  names(wav.scale)<-paste("X", 1:ncol(wave.ds), sep="")
  
  
  keep<-model %>% predict_classes(as.matrix(wav.scale))
  table(keep)
  test.tab$Keep<-keep
  
  header<-c("Selection", "View", "Channel", "Begin Time (s)", "End Time (s)", "Low Freq (Hz)", "High Freq (Hz)", "Classification")
  
  test.tab$Begin.Time..S.<-round(test.tab$Begin.Time..S., 4)
  test.tab$End.Time..S.<-round(test.tab$End.Time..S., 4)
  
  nrow(test.tab)
  
  # test.tab.char<-as.matrix(test.tab[keep != 0,])
  test.tab.char<-as.matrix(test.tab)
  
  
  test.tab.out<-rbind(header, test.tab.char)
  dim(test.tab.out)
  
  write.table(test.tab.out, "data/results/selections_all.txt",col.names=FALSE, sep="\t", quote = FALSE, row.names = FALSE)
  write.table(test.tab.out[test.tab.out[,8] != 0,], "output/selections.txt",col.names=FALSE, sep="\t", quote = FALSE, row.names = FALSE)
}
