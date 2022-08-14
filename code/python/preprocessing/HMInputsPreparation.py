# -*- coding: utf-8 -*-

import pandas as pd
import os

pd.set_option('display.notebook_repr_html',False)


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


PRO_DIR = "../../../data/TxtInOut2"
INPUT_FILE_DIR = '../../../data/HeavyMetalModuleDataBase2.xls'
SUB_NUM, HRU_NUM = get_base_num()


def write_file(filedir,filepath,lines,op_type):
    with open(f"{filedir}/{filepath}",op_type) as f:
        for l in lines:
            f.write(l)


def hml_parm(table_info):
    mat_dat = dict(table_info["Hml_Prameters"])
    mat_dat_str = "".join([mat_dat["ID"][0].astype(str).rjust(3),
           mat_dat["Name"][0].rjust(10),
           mat_dat["Eqn"][0].astype(str).rjust(3),
           round(mat_dat["Kd1"][0],3).astype(str).rjust(10),
           round(mat_dat["Kd2"][0],3).astype(str).rjust(10),
           round(mat_dat["Kd3"][0],3).astype(str).rjust(10),
           round(mat_dat["k1"][0],6).astype(str).rjust(10),
           round(mat_dat["k-1"][0],6).astype(str).rjust(10),
           round(mat_dat["ksol"][0],3).astype(str).rjust(10),
           round(mat_dat["kweth"][0],6).astype(str).rjust(10),
           round(mat_dat["ku"][0],6).astype(str).rjust(10),
           round(mat_dat["gamma"][0],6).astype(str).rjust(10),
           round(mat_dat["ka"][0],3).astype(str).rjust(10),
           round(mat_dat["kd"][0],3).astype(str).rjust(10),
           round(mat_dat["kwash"][0],3).astype(str).rjust(10),]) + "\r\n"
    print('1 metal.dat file is modified')
    write_file(PRO_DIR,"mat.dat",[mat_dat_str],"w")


def hml_hru(table_info):
    hml_data = dict(table_info["Hml_Hru"])
    hru_list = []
    for filename in os.listdir(PRO_DIR):
        if filename.endswith(".hru") and filename.startswith("0"):
            hru_list.append(str(filename[:9]))

    for i in range(len(hru_list)):
        hru_id = hru_list[i]
        hml_lines = []
        hruf = open(f"{PRO_DIR}/{hru_id}.hru","r")
        hrus = hruf.readlines()[0][6:]

        hml_lines.append(f" .hml {hrus}")
        hml_lines.append("Soil Heavy Metal Data\n")
        hml_lines.append(f"{'1'.rjust(10)}    |HML_P1: Metal number [#]\n")
        hml_lines.append(f"{round(hml_data['hmfraction'][i],6).astype(str).rjust(10)}    |HML_P2: Heavy metal Nonpoint source Area Fraction [-]\n")
        hml_lines.append(f"{round(hml_data['hmrock'][i],3).astype(str).rjust(10)}    |HML_P3: Heavy metal in Rock [kg/ha]\n")
        hml_lines.append(f"{round(hml_data['Labile hm concentration'][i],3).astype(str).rjust(10)}    |HML_P4: Labile metal in 1st layer soil [mg/kg]\n")
        hml_lines.append(f"{round(hml_data['Non-labile hm concentration'][i],3).astype(str).rjust(10)}    |HML_P5: Non-labile metal in 1st layer soil [mg/kg]\n")
        hml_lines.append(f"{round(hml_data['Enrichment ratio '][i],3).astype(str).rjust(10)}    |HML_P6: Enrichment ratio of heavy metal [-]\n")
        hml_lines.append(f"{round(hml_data['Total hm in Fertilizers'][i],3).astype(str).rjust(10)}    |HML_P8: Total metal input from agricultural use [g/ha/yr]\n")
        hml_lines.append(f"{round(hml_data['Fraction of labile hm in Fertilizers'][i],3).astype(str).rjust(10)}    |HML_P9: Fraction of labile metal in fertilizers or animal manure [-]\n")
        hml_lines.append(f"{round(hml_data['Total hm in atmospheric deposition'][i],3).astype(str).rjust(10)}    |HML_P10: Total metal input from atmospheric deposition [g/ha/yr]\n")
        hml_lines.append(f"{round(hml_data['Fraction of labile hm in atmospheric deposition'][i],3).astype(str).rjust(10)}    |HML_P11: Fraction of labile metal in atmospheric deposition [-]\n")
        hml_lines.append(f"{round(hml_data['Dissolved hm in groundwater'][i],3).astype(str).rjust(10)}    |HML_P12: Dissolved metal in groundwater [ug/L]\n")
        write_file(PRO_DIR, f"{hru_id}.hml", hml_lines, "w")
        print(f"{hru_id}.hml files are modified")

def hml_swq(table_info):
    swq_data = dict(table_info["Hml_Swq"])
    swq_list = []
    for filename in os.listdir(PRO_DIR):
        if filename.endswith(".swq") and filename.startswith("0"):
            swq_list.append(filename)

    for i in range(len(swq_list)):
        swq_filename = swq_list[i]
        swqf = open(f"{PRO_DIR}/{swq_filename}","r",encoding="ISO-8859-1")
        swqs = swqf.readlines()[:30]
        swqs.append("Heavy Metal Parameters: \n")
        swqs.append(f"     {round(swq_data['HML_STL'][i],4).astype(str).rjust(10)}     | SWQ_HML_STL: Settling velocity for Heavy Metal [m/d]\n")
        swqs.append(f"     {round(swq_data['HML_RSP'][i],4).astype(str).rjust(10)}     | SWQ_HML_RSP: Resuspension velocity for Heavy Metal [m/d]\n")
        swqs.append(f"     {round(swq_data['HML_MIX'][i],4).astype(str).rjust(10)}     | SWQ_HML_MIX: Mixing velocity for Heavy Metal [m/d]\n")
        swqs.append(f"     {round(swq_data['HML_BRY'][i],4).astype(str).rjust(10)}     | SWQ_HML_BRY: Burial velocity for Heavy Metal [m/d]\n")
        swqs.append(f"     {round(swq_data['LabileHML_CONC'][i],4).astype(str).rjust(10)}     | SWQ_HML_LabileCONC: Initial HM concentration in reach bed sediment [kg/m3]\n")
        swqs.append(f"     {round(swq_data['NonLabileHML_CONC'][i],4).astype(str).rjust(10)}     | SWQ_HML_NonLabileCONC: Initial HM concentration in reach bed sediment [kg/m3]\n")
        swqs.append(f"     {round(swq_data['HML_ACT'][i],4).astype(str).rjust(10)}     | SWQ_HML_ACT: Depth of active sediment layer for heavy metal [m]\n")
        write_file(PRO_DIR, swq_filename, swqs, "w")
        print(f"{swq_filename} files are modified")

def point_source(table_info):
    pointSource = table_info["PointSource"].values
    # print(pointSource)
    for i in range(1,SUB_NUM):
        psfilename = f"{i}p.dat"
        pslines = []
        pslines.append("2016/4/21 0:00:00 .dat file Daily Record Subbasin  10 ArcSWAT 2012.10_2.16 interface\n")
        pslines.append("    \n")
        pslines.append("    \n")
        pslines.append("    \n")
        pslines.append("    \n")
        pslines.append(" DAY YEAR          FLOCNST          SEDCNST         ORGNCNST         ORGPCNST          NO3CNST          NH3CNST          NO2CNST         MINPCNST         CBODCNST        DISOXCNST         CHLACNST       SOLPSTCNST       SRBPSTCNST        BACTPCNST       BACTLPCNST        CMTL1CNST        CMTL2CNST        CMTL3CNST\n")
        pslen = len(pointSource[0])
        for l in range(1, pslen):
            psinfo = [f"{str(pointSource[l][0].astype(int)).rjust(4)} {str(pointSource[l][1].astype(int)).rjust(4)}",
                      f"{(pointSource[l][i+2]*50000):.3E}".rjust(16)] + [f"{0:.3E}".rjust(16) for i in range(16)] + \
                     [f"{(pointSource[l][i+2]):.3E}".rjust(16)] + \
                     [f"{0:.3E}".rjust(16) for i in range(2)]
            pslines.append(" ".join(psinfo) + "\n")
        write_file(PRO_DIR, psfilename, pslines, "w")


# 读取xls（绝对路径）
table_info = pd.read_excel(io=INPUT_FILE_DIR,sheet_name=None)

handlers = ["hml_parm","hml_hru","hml_swq","point_source"]
for handler in handlers:
    if handler == "hml_parm":
        hml_parm(table_info)
    if handler == "hml_hru":
        hml_hru(table_info)
    if handler == "hml_swq":
        hml_swq(table_info)
    if handler == "point_source":
        point_source(table_info)
