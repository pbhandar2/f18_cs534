file_loc = "../../MSR_data/src2_0.csv.gz"

import pandas 

df = pandas.read_csv(file_loc, compression="gzip")

print(df)
