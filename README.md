## SWAT-HM-pre-post-processing
_SWAT-HM model preprocessing, running, and postprocessing package_

__SWAT-HM__ is a watershed-scale metal fate and transport model, which coupled a heavy metal module with the well-established SWAT ([SWAT2012](https://swat.tamu.edu/software/)) model. SWAT-HM operates at a daily time step, tracking the stores and fluxes of dissolved and particulate metals in both the land and in-stream phases of a catchment. ([ref 1](https://www.sciencedirect.com/science/article/pii/S0048969717325305) and [ref 2](https://www.sciencedirect.com/science/article/pii/S0022169420301591))

### 1. Package overview

_This package contains several folders to enforce preprecossing, running and postpreocessing functions for SWAT-HM model_

1.1. `docs folder` contains [SWAT-HM user manual](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/tree/main/docs)

1.2. `code folder` contains _python_ and _matlab_ scripts for preprocessing and postpreocessing

1.3. `data folder` contains TxtInOut files of SWAT-HM model, input excel database file for preprecessing, and GIS shape files (e.g., rivers, subbasin, hrus) for visualization

### 2. Procedure

preprocessing [>>](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/README.md###3.SWAT-HM-preprocessing) running [>>](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/README.md###4.SWAT-HM-running) postprocessing

### 3. SWAT-HM preprocessing

_Copy original TxtInout of SWAT model, then prepare extra input files of SWAT-HM models before running_ 

3.1. excel database file ([HeavyMetalModuleDataBase.xls](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/tree/main/data))

3.2. code: 
[matlab version](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/tree/main/code/matlab/preprocessing);  [python version](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/tree/main/code/python/preprocessing)

3.3. Input files types: 

 * `metal.dat` (metal parameters file)
  
 * `xp.dat` (point source file) 
  
 * `x.hml` (hru level file)
  
 * `x.swq` (river water quality file)
 

### 4. SWAT-HM running

click `SWAT2012HM.exe` executable file in Data/TxtInOut

### 5. SWAT-HM postprocessing

_SWAT-HM output Visualization (4 types)_  

5.1. outhml.hru

* code: [`analyse_output.py`](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/analyse_output.py)

* parameters: [`config.py`](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/config.py)

* Data for visualization: hru shape file in Data/Shapes, and outhml.hru file in Data/TxtInOut 

* Here is an [example](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/data/Visualization/pic_output_hru_map/2012-01.png) of the result

5.2. outhml.rch (line)

* code: [`analyse_output.py`](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/analyse_output.py)

* parameters: [`config.py`](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/config.py)

* Data for visualization: observed data, and output.rch file

* Here is an [example](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/data/Visualization/pic_output_rch_line/1_line.png) of the result

5.3. outhml.rch (map)

* code: [`analyse_output.py`](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/analyse_output.py)

* parameters: [`config.py`](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/config.py)

* Data for visualization: river and basin shape files in Data/Shapes, and output.rch file in the Data/TxtInOut

* Here is an [example](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/data/Visualization/pic_output_rch_map/2012-01.png) of the result

5.4. outhml.sub

* code: [`analyse_output.py`](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/analyse_output.py)

* parameters: [`config.py`](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/config.py)

* Data for visualization: Subbasin shape file in Data/Shapes, and outhml.sub in Data/TxtInOut

* Here is an [example](https://github.com/LyntonZhou/SWAT-HM-pre-post-processing/blob/main/code/python/postprocessing/pic_output_sub_map/2012-01.png) of the result.

### Contributor
Dr. [Lingfeng Zhou](https://www.researchgate.net/profile/Lingfeng-Zhou) (CRAES, China)

Dr. [Yaobin Meng](https://nsem.bnu.edu.cn/fjs/120716.htm) (Beijing Normal University, China)

### Support

If you have any suggestions, want to report errors, and have scientific collaboration, please contact me (`zhoulf@mail.bnu.edu.cn`).
