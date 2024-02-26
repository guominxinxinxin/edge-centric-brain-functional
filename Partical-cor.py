import numpy as np
import csv
from scipy.stats import kruskal
import pandas as pd
import statsmodels.api as sm

#循环计算偏相关分析
#心脑耦合相关系数与mccb得分之间的偏相关性，控制性别、年龄和教育程度
# 读取XLSX文件
path = 'C:/02DATA/EEG_ECG/MddSiHc/Corrcoef-DATA-154/Second-dif/People-data/THREE.xlsx'
data = pd.read_excel(path, sheet_name='Sheet3', header= None)
arr = np.empty((115, 2))
x = 0
#循环mccb选项和心脑耦合系数，先是所有心脑系数，再是mccb
for i in range(3,8):
    for j in range(8, 31):
        DATA = pd.DataFrame({'var1': data.values[:, j], 'var2': data.values[:, i], 'control_var1': data.values[:, 0],
                             'control_var2': data.values[:, 1], 'control_var3': data.values[:, 2]})
        # 添加常数列作为回归模型的截距
        DATA['intercept'] = 1

        # 构建回归模型
        model = sm.OLS(DATA['var1'], DATA[['var2', 'control_var1', 'control_var2', 'control_var3', 'intercept']])

        # 拟合模型并计算偏相关系数
        results = model.fit()
        partial_corr_coefficient = results.params['var2']

        # 计算p值
        p_value = results.pvalues['var2']
        arr[x, 0] = p_value
        arr[x, 1] = partial_corr_coefficient
        x += 1

path = 'C:/02DATA/EEG_ECG/MddSiHc/Corrcoef-DATA-154/Second-dif/People-data/Partical-cor/mddsi.xlsx'
df = pd.DataFrame(arr)
df.to_excel(path, index = False)
