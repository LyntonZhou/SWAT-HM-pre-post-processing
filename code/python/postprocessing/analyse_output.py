# -*- coding: utf-8 -*-

import matplotlib.pyplot as plt
import pandas as pd
import geopandas as gpd
import shapely
import datetime
from . import config

shapely.speedups.disable()
gpd.options.use_pygeos = True


# 地图类型做图
def make_map_pic():
    # 加载数据输入数据
    data_output = pd.read_table(config.INPUT_OUTPUTDATA_PATH, sep='\s+')
    data_shp = gpd.read_file('Shapes/subs2.shp')
    start_date = datetime.datetime.strptime(config.START_DATE, "%Y-%m-%d")
    end_date = datetime.datetime.strptime(config.END_DATE, "%Y-%m-%d")
    # 时间合法性判断
    if start_date > end_date:
        print("START_DATE can not > EDN_DATE")
    # 获取时间范围列表
    date_list = pd.date_range(config.START_DATE, config.END_DATE, freq='1M').strftime("%Y-%m").tolist()
    for date in date_list:
        year_month = date.split("-")
        year = year_month[0]
        month = year_month[1]
        data_filted = data_output.loc[(data_output["YEAR"] == int(year)) & (data_output["MON"] == int(month)), :]
        data_merge = data_shp.merge(data_filted, left_on='OBJECTID', right_on='RCH', how='left')
        data_merge.plot(config.SELECT_COL, k=4, cmap=plt.cm.Greens, alpha=1.0, figsize=(9, 9), legend=True)  # 图形初步，如图2所示
        plt.savefig(f"{config.OUTPUT_DIR}/{date}.png")
        print(f"save pic {config.OUTPUT_DIR}/{date}.png")


# 折线类型做图
def make_line_pic():
    data_obs = pd.read_table(config.INPUT_OBS_PATH, sep='\s+', header=None, names=["ID", "DESC", f"obs_{config.SELECT_COL}"])
    data_output = pd.read_table(config.INPUT_OUTPUTDATA_PATH, sep='\s+')
    data_rch = data_output.loc[(data_output["RCH"] == config.RCH) & (data_output["MON"] != data_output["YEAR"]), :]
    data_rch['MON'].apply(lambda x: '{:0>2d}'.format(x))

    data_rch["DATE"] = data_rch["YEAR"].map(str) + data_rch["MON"].map(str)
    data_rch["ID"] = range(1, len(data_rch) + 1)
    m_data = data_rch.merge(data_obs, left_on='ID', right_on='ID', how='left')
    data_merge = m_data.loc[:, [f"obs_{config.SELECT_COL}", config.SELECT_COL]]
    data_merge.plot()
    plt.savefig(f"{config.OUTPUT_DIR}/{config.RCH}_line.png")
    print(f"save pic {config.OUTPUT_DIR}/{config.RCH}_line.png")


if config.DRAW_TYPE == "map":
    make_map_pic()
elif config.DRAW_TYPE == "line":
    make_line_pic()
