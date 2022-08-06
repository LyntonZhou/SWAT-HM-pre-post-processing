# SWAT-HM-pre-post-processing
SWAT-HM model preprocessing and post-processing package

SWAT-HM is a watershed-scale metal fate and transport model (reference)

1. Package overview
This package contains several folders to enforce preprecossing and post-preocessing functions for SWAT-HM model  
1.1 watershed folder contains shape files (e.g., rivers, subbasin, hrus) for visulization
1.2 code folder tonains Python script for preprocessing and post-preocessing
1.3 data folder contains TxtInOut folder for SWAT-HM running
1.4 docs folder contains SWAT-HM user manual

2. SWAT-HM input files prepare
files types: xxp.dat (point source files), 
xxx.hml
xxx.swq

3. SWAT-HM outpot Visualization
3.1. outhml.hru
Data for visualization: TxtInOut files and hru shape file
Here is a screen shot of the result
3.2. outhml.rch
Data for visualization: file.cio in the TxtInOut folder, observed data, and output.rch file
Here is a screen shot of the result
3.3. outhml.sub
Data for visualization: Subbasin shape file can be found here, TxtInOut files
Here is a screen shot of the result.

If you have any suggestions, want to report errors, and have scientific collaboration, please contact me.


参考 https://chrisschuerz.github.io/SWATplusR/index.html
参考 https://github.com/tamnva/R-SWAT

主要文件： 
xxp.dat
file.cio
output.rch .sub .hru
outhml.rch .sub .hru  
5类气象文件

主配置文件：readfilecio.m

气象数据：
readClimate
readpcp readslr 等等
plotClimate
readpcp readslr 等等

plotRch('flowout', T=[2001,1;2009,12],rch=12)
   plotoutputrch swat 产生的
   plotouthmlrch swat-hm 产生的
   
空间展示 主要指的是subasin 或者 hru
plotSub('ero',T=[2001,1;2009,12],)

plotHru('ero',T=[2001,1;2009,12],)

