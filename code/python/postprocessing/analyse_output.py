"""
@author: wangzhenqiang
@email:  wangzhenqiang@ishumei.com
@data:   8/3/22 12:32 PM
@desc:
"""

import matplotlib.pyplot as plt
import pandas as pd
import geopandas as gpd
import shapely
import datetime

shapely.speedups.disable()
gpd.options.use_pygeos = True

# 画图类型
DRAW_TYPE = "map"

START_DATE = "2000-01-01"
END_DATE = "2008-01-01"

# shp
INPUT_SHP_PATH = "../../../Watershed/subs2.shp"
INPUT_OUTPUTDATA_PATH = "../../../data/TxtInOut2/"
INPUT_OBS_PATH = "input_files/input_1.txt"

SELECT_COL = 'SedDisHMkg/m3'

OUTPUT_DIR = "pic_output_map"

RCH = 1


# 地图类型做图
def make_map_pic():
    # 加载数据输入数据
    data_output = pd.read_table(INPUT_OUTPUTDATA_PATH, sep='\s+')
    data_shp = gpd.read_file('Shapes/subs2.shp')
    start_date = datetime.datetime.strptime(START_DATE, "%Y-%m-%d")
    end_date = datetime.datetime.strptime(END_DATE, "%Y-%m-%d")
    # 时间合法性判断
    if start_date > end_date:
        print("START_DATE can not > EDN_DATE")
    # 获取时间范围列表
    date_list = pd.date_range(START_DATE, END_DATE, freq='1M').strftime("%Y-%m").tolist()
    for date in date_list:
        year_month = date.split("-")
        year = year_month[0]
        month = year_month[1]
        data_filted = data_output.loc[(data_output["YEAR"] == int(year)) & (data_output["MON"] == int(month)), :]
        data_merge = data_shp.merge(data_filted, left_on='OBJECTID', right_on='RCH', how='left')
        data_merge.plot(SELECT_COL, k=4, cmap=plt.cm.Greens, alpha=1.0, figsize=(9, 9), legend=True)  # 图形初步，如图2所示
        plt.savefig(f"{OUTPUT_DIR}/{date}.png")
        print(f"save pic {OUTPUT_DIR}/{date}.png")


# 折线类型做图
def make_line_pic():
    data_obs = pd.read_table(INPUT_OBS_PATH, sep='\s+', header=None, names=["ID", "DESC", f"obs_{SELECT_COL}"])
    data_output = pd.read_table(INPUT_OUTPUTDATA_PATH, sep='\s+')
    data_rch = data_output.loc[(data_output["RCH"] == RCH) & (data_output["MON"] != data_output["YEAR"]), :]
    data_rch['MON'].apply(lambda x: '{:0>2d}'.format(x))

    data_rch["DATE"] = data_rch["YEAR"].map(str) + data_rch["MON"].map(str)
    data_rch["ID"] = range(1, len(data_rch) + 1)
    m_data = data_rch.merge(data_obs, left_on='ID', right_on='ID', how='left')
    data_merge = m_data.loc[:, [f"obs_{SELECT_COL}", SELECT_COL]]
    data_merge.plot()
    plt.savefig(f"{OUTPUT_DIR}/{RCH}_line.png")
    print(f"save pic {OUTPUT_DIR}/{RCH}_line.png")


if DRAW_TYPE == "map":
    make_map_pic()
elif DRAW_TYPE == "line":
    make_line_pic()
