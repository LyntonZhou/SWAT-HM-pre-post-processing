# SWAT-HM-pre-post-processing
SWAT-HM model, preprocessing and post-processing, and input–output (I–O)

1. Package overview
This package contains to functions:  
1.1 watershed

2. SWAT-HM input files prepare
files types: xxp.dat (point source files), 

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

If you would like to contribute to the code, have any suggestions, want to report errors, and have scientific collaboration, please contact me.


参考 https://chrisschuerz.github.io/SWATplusR/index.html
参考 https://github.com/tamnva/R-SWAT

主要文件： 
xxp.dat
file.cio
output.rch .sub .hru
outhml.rch .sub .hru  
5类气象文件

只从（主要从） TxtInOut 读取信息
观测数据可另设路径

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

