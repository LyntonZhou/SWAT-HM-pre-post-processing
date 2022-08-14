## SWAT-HM-pre-post-processing
_SWAT-HM model preprocessing,running, and post-processing package_

__SWAT-HM__ is a watershed-scale metal fate and transport model, which coupled a heavy metal module with the well-established SWAT ([SWAT2012](https://swat.tamu.edu/software/)) model ([ref 1](https://www.sciencedirect.com/science/article/pii/S0048969717325305) and [ref 2](https://www.sciencedirect.com/science/article/pii/S0022169420301591))

### 1. Package overview

_This package contains several folders to enforce preprecossing, running and post-preocessing functions for SWAT-HM model_

1.1 `docs folder` contains [SWAT-HM user manual](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/tree/main/docs)

1.2 `code folder` contains _python_ and _matlab_ scripts for preprocessing and post-preocessing

1.3 `data folder` contains TxtInOut files of SWAT-HM model, input excel database file for preprecessing, and GIS shape files (e.g., rivers, subbasin, hrus) for visualization

### 2. SWAT-HM preprocessing

_preparing input files of SWAT-HM models before running_ 

2.1. excel database file ([HeavyMetalModuleDataBase.xls](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/tree/main/data))

2.2. code: 
[matlab version](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/tree/main/code/matlab/preprocessing);  [python version](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/tree/main/code/python/preprocessing)

2.3. files types: 

 * `metal.dat` (metal parameters file)
  
 * `xp.dat` (point source file) 
  
 * `x.hml` (hru level file)
  
 * `x.swq` (river water quality file)
 
 * `x.lwq` (lake water quality file)

### 3. SWAT-HM running

click `SWAT2012HM.exe` executable file in Data/TxtInOut

### 4. SWAT-HM postprocessing

_SWAT-HM output Visualization_  

4.1. outhml.hru

* code: [`analyse_output.py`](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/analyse_output.py)

* parameters: [`config.py`](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/config.py)

* Data for visualization: hru shape file in Data/Shapes, outhml.hru file in Data/TxtInOut 

* Here is an [example](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/pic_output_hru_map/2012-01.png) of the result

4.2. outhml.rch

* code: [`analyse_output.py`](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/analyse_output.py)

* parameters: [`config.py`](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/config.py)

* Data for visualization: file.cio in the TxtInOut folder, observed data, and output.rch file

* Here is an [example] of the result

4.3. outhml.sub

* code: [`analyse_output.py`](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/analyse_output.py)

* parameters: [`config.py`](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/config.py)

* Data for visualization: Subbasin shape file in Data/Shapes, and outhml.sub in Data/TxtInOut

* Here is an [example](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/pic_output_sub_map/2012-01.png) of the result.

### Contributor
Dr. [Lingfeng Zhou](https://www.researchgate.net/profile/Lingfeng-Zhou) (CRAES, China)

Dr. [Yaobin Meng](https://nsem.bnu.edu.cn/fjs/120716.htm) (Beijing Normal University, China)

### Support

If you have any suggestions, want to report errors, and have scientific collaboration, please contact me (`zhoulf@mail.bnu.edu.cn`).



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
