# SWAT-HM-pre-post-processing
SWAT-HM model preprocessing and post-processing package

SWAT-HM is a watershed-scale metal fate and transport model, which coupled a heavy metal module with the well-established SWAT model ([ref 1](https://www.sciencedirect.com/science/article/pii/S0048969717325305) and [ref 2](https://www.sciencedirect.com/science/article/pii/S0022169420301591))

1. Package overview
This package contains several folders to enforce preprecossing and post-preocessing functions for SWAT-HM model

1.1 code folder contains Python and matlab scripts for preprocessing and post-preocessing

1.2 data folder contains TxtInOut of SWAT-HM model, and input excel file for preprecessing, and GIS shape files (e.g., rivers, subbasin, hrus) for visualization

1.3 docs folder contains SWAT-HM user manual

2. SWAT-HM input files prepare (preprocessing)

2.1. code: 

[metlab](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/tree/main/code/matlab/preprocessing) 

[python](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/tree/main/code/python/preprocessing)

2.2. files types: 
  metal.dat (metal parameters file)
  
  xxp.dat (point source file) 
  
  xxx.hml (hru level file)
  
  xxx.swq (river water quality file)

3. SWAT-HM output Visualization  (postprocessing)

3.1. outhml.hru
code
parameters
Data for visualization: hru shape file in Data/TxtInOut files 
Here is an [example] of the result

3.2. outhml.rch
code
parameters
Data for visualization: file.cio in the TxtInOut folder, observed data, and output.rch file
Here is an [example] of the result

3.3. outhml.sub
code
parameters
Data for visualization: Subbasin shape file in Data/TxtInOut files
Here is an [example](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python_pro/post/pic_output_line/1_line.png) of the result.

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
