wavFile=$1

htkFile="data/tmp/audio.mfcc"
resultDir="data/results/raw/"

echo "Running HCopy file " $wavFile

HCopy  -C data/config/analysis.config $wavFile $htkFile

wavSamples=`HList -h -e 0 -F WAV $wavFile | gawk '{if(NR == 4){print $3}}'`

htkSamples=`HList -h -e 0 -F HTK $htkFile | gawk '{if(NR == 4){print $3}}'`
htkFrameRate=`HList -h -e 0 -F HTK $htkFile | gawk '{if(NR == 3){print $6}}'` 

wavFrameRate=44100
echo $wavSamples | gawk -v wavFrame=$wavFrameRate -v wavSampl=$wavSamples -v htkSampl=$htkSamples -v htkFrame=$htkFrameRate 'BEGIN{coeff=(htkSampl*(htkFrame/1000000))/(wavSampl*(1/wavFrame))}{}END{print coeff > "coeff"}' 

coeff=`echo "$htkSamples * ($htkFrameRate / 1000000) / ($wavSamples * ( 1 / $wavFrameRate))" | bc -l`


HVite -C data/config/config -H data/model/hmm6/hmmdefs  -H data/model/hmm6/macros  -i $resultDir"recout.mlf" -w data/def/wdnet -p 1 data/def/dict data/monophones0 $htkFile

# coeff=`cat coeff`
cat $resultDir"recout.mlf" | gawk -v coeff=$coeff 'BEGIN{OFS = "\t"; printf("Selection\tView\tChannel\tBegin Time (S)\tEnd Time (S)\tLow Freq (Hz)\tHigh Freq (Hz)\n")}{if($3 == "sig"){print NR-1,	"Waveform 1",	1, (($1/coeff)/10000000), (($2/coeff)/10000000), 0, 22500}}' > $resultDir"tmp_sig.txt"
