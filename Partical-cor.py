import numpy as np
import csv
from scipy.stats import kruskal
import pandas as pd
import statsmodels.api as sm

# read XLSX file
path = 'C:/02DATA/EEG_ECG/MddSiHc/Corrcoef-DATA-154/Second-dif/People-data/THREE.xlsx'
data = pd.read_excel(path, sheet_name='Sheet3', header= None)
arr = np.empty((115, 2))
x = 0

for i in range(3,8):
    for j in range(8, 31):
        DATA = pd.DataFrame({'var1': data.values[:, j], 'var2': data.values[:, i], 'control_var1': data.values[:, 0],
                             'control_var2': data.values[:, 1], 'control_var3': data.values[:, 2]})
      
        DATA['intercept'] = 1

    
        model = sm.OLS(DATA['var1'], DATA[['var2', 'control_var1', 'control_var2', 'control_var3', 'intercept']])

        #
        results = model.fit()
        partial_corr_coefficient = results.params['var2']

        # 
        p_value = results.pvalues['var2']
        arr[x, 0] = p_value
        arr[x, 1] = partial_corr_coefficient
        x += 1

path = 'C:/02DATA/EEG_ECG/MddSiHc/Corrcoef-DATA-154/Second-dif/People-data/Partical-cor/mddsi.xlsx'
df = pd.DataFrame(arr)
df.to_excel(path, index = False)
