{
	
	outDir="data/mfcc/";
	print($3, (outDir substr($1,0,index($1,".wav")) "mfc"))
}