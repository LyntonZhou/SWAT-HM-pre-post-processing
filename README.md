# SWAT-HM-pre-post-processing
SWAT-HM model, preprocessing and post-processing, and input–output (I–O)

参考 https://chrisschuerz.github.io/SWATplusR/index.html

后处理功能总结

主要文件： 
.p
file.cio
output.rch .sub .hru
outhml.rch .sub .hru  
5类气象文件

只从（主要从） TxtInOut 读取信息
观测数据可另设路径

Matlab GUI（不需要不做）

主配置文件：readfilecio.m

气象数据：
readClimate
readpcp readslr 等等
plotClimate
readpcp readslr 等等

日转换成月，年 DailyToMonthly1.m

plotRch('flowout', T=[2001,1;2009,12],rch=12)
   plotoutputrch swat 产生的
   plotouthmlrch swat-hm 产生的
   
空间展示 主要指的是subasin 或者 hru
plotSub('ero',T=[2001,1;2009,12],)

plotHru('ero',T=[2001,1;2009,12],)

结果：软著申请中的用户手册
