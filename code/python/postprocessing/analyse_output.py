# -*- coding: utf-8 -*-

import matplotlib.pyplot as plt
import pandas as pd
import geopandas as gpd
import shapely
import datetime
import os
from config import *

shapely.speedups.disable()
gpd.options.use_pygeos = True
pd.set_option('display.max_columns', 500)

def get_base_num():
    sub_num = 0
    hru_num = 0
    file_list = os.listdir(PRO_DIR)
    for file_name in file_list:
        if file_name.startswith("0"):
            if file_name.endswith(".sub"):
                sub_num += 1
            if file_name.endswith(".hru"):
                hru_num += 1
    return sub_num, hru_num


def prehandle_data(data):
    if FILE_TYPE == "hru":
        _, hru_num = get_base_num()
        data["MON"] = data["DAY"]
        data["YEAR"] = data["DAY"]
        now_year = -1
        month_num = 0
        lenth = len(data["DAY"])
        while (month_num * hru_num) < lenth:
            if data["DAY"][lenth - (month_num * hru_num + 1)] > 12:
                now_year = data["DAY"][lenth-(month_num * hru_num + 1)]
            else:
                start = lenth-((month_num + 1) * hru_num)
                end = lenth-(month_num * hru_num)
                data["YEAR"][start:end] = now_year
            month_num += 1
        return data
    return data



def get_join_col():
    if FILE_TYPE == "sub":
        return "OBJECTID", "SUB"
    if FILE_TYPE == "hru":
        return "HRU_ID", "HRU"

# 地图类型做图
def make_map_pic():
    # 加载数据输入数据
    data_output = pd.read_table(INPUT_OUTPUTDATA_PATH, sep='\s+', error_bad_lines=False, index_col=False)
    data_output = prehandle_data(data_output)
    data_shp = gpd.read_file(INPUT_SHP_PATH)
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
        left_on, right_on = get_join_col()
        data_merge = data_shp.merge(data_filted, left_on=left_on, right_on=right_on, how='left')
        data_merge.plot(SELECT_COL, k=4, cmap=plt.cm.Greens, alpha=1.0, figsize=(9, 9), legend=True)  # 图形初步，如图2所示
        plt.title(f"{date}_{SELECT_COL}")
        plt.savefig(f"{OUTPUT_DIR}/{date}.png")
        print(f"save pic {OUTPUT_DIR}/{date}.png")


# 折线类型做图
def make_line_pic():
    data_obs = pd.read_table(INPUT_OBS_PATH, sep='\s+', header=None, error_bad_lines=False, names=["ID", "DESC", f"obs_{SELECT_COL}"])
    data_output = pd.read_table(INPUT_OUTPUTDATA_PATH, sep='\s+', error_bad_lines=False)
    data_rch = data_output.loc[(data_output["RCH"] == RCH) & (data_output["MON"] != data_output["YEAR"]), :]
    data_rch['MON'].apply(lambda x: '{:0>2d}'.format(x))

    data_rch["DATE"] = data_rch["YEAR"].map(str) + data_rch["MON"].map(str)
    data_rch["ID"] = range(1, len(data_rch) + 1)
    m_data = data_rch.merge(data_obs, left_on='ID', right_on='ID', how='left')
    print(m_data[SELECT_COL])
    data_merge = m_data.loc[:, [f"obs_{SELECT_COL}", SELECT_COL]]
    data_merge.plot(title=f"{RCH}_{SELECT_COL}")
    plt.savefig(f"{OUTPUT_DIR}/{RCH}_line.png")
    print(f"save pic {OUTPUT_DIR}/{RCH}_line.png")


if DRAW_TYPE == "map":
    make_map_pic()
elif DRAW_TYPE == "line":
    make_line_pic()
