# -*- coding: utf-8 -*-


'''
sub 示例
'''
# # 画图类型
# DRAW_TYPE = "map"
#
# FILE_TYPE = "sub"
#
# START_DATE = "2012-01-01"
# END_DATE = "2014-01-01"
#
# # shp
# INPUT_SHP_PATH = "../../../data/Shapes2/subs1.shp"
# INPUT_OUTPUTDATA_PATH = "../../../data/TxtInOut2/outhml.sub"
# INPUT_OBS_PATH = "input_files/input_1.txt"
#
# SELECT_COL = 'HM_ATMOkg'
#
# OUTPUT_DIR = "../../../data/Visualization/pic_output_sub_map"
#
# RCH = 1

'''
hru示例
'''
# # 画图类型
# DRAW_TYPE = "map"
#
# FILE_TYPE = "hru"
#
# START_DATE = "2012-01-01"
# END_DATE = "2014-01-01"
#
# # shp
# PRO_DIR = "../../../data/TxtInOut2"
# INPUT_SHP_PATH = "../../../data/Shapes2/hru1.shp"
# INPUT_OUTPUTDATA_PATH = "../../../data/TxtInOut2/outhml.hru"
# INPUT_OBS_PATH = "input_files/input_1.txt"
#
# SELECT_COL = 'DisHMkg/ha'
#
# OUTPUT_DIR = "../../../data/Visualization/pic_output_hru_map"
#
# RCH = 1
#

'''
rch 示例
'''
# # 画图类型
# DRAW_TYPE = "line"
#
# FILE_TYPE = "rch"
#
# START_DATE = "2012-01-01"
# END_DATE = "2014-01-01"
#
# # shp
# INPUT_SHP_PATH = "../../../data/Shapes2/subs1.shp"
# INPUT_OUTPUTDATA_PATH = "../../../data/TxtInOut2/outhml.rch"
# INPUT_OBS_PATH = "input_files/input_1.txt"
#
# SELECT_COL = 'DisHM_INkg'
#
# OUTPUT_DIR = "../../../data/Visualization/pic_output_rch_line"
#
# RCH = 1



'''
rch 地图示例
'''
# 画图类型 map地图 line折线
DRAW_TYPE = "map"

# 文件类型目前有rch,hru,sub 三种
FILE_TYPE = "rch"

# 做图日期范围
START_DATE = "2012-01-01"
END_DATE = "2014-01-01"

# 输入的shp
INPUT_SHP_PATH = "../../../data/Shapes2/subs1.shp"
# 如果喂rch 的map类型则需要输入basin边界shp文件
INPUT_BASIN_SHP_PATH = "../../../data/Shapes2/basin1.shp"

# 输入的输出数据文件地址
INPUT_OUTPUTDATA_PATH = "../../../data/TxtInOut2/outhml.rch"
# rch折线需要输入真实观测数据
INPUT_OBS_PATH = "input_files/input_1.txt"

# 需要做图的列对应INPUT_OUTPUTDATA_PATH文件中的列
SELECT_COL = 'DisHM_INkg'

# 输出图片目录 需要提前创建好
OUTPUT_DIR = "../../../data/Visualization/pic_output_rch_map"

# rch折线需要输入做图的rch编号
RCH = 1