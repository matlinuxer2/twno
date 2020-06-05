#!/usr/bin/env python

import pandas as pd
import datetime
import json
import sys
import locale

fpath = sys.argv[1]
dpath = sys.argv[2]

df = pd.read_excel('data.xls','歷年Yearly', skiprows=3 )

cols = df.iloc[0,:]
rows = df.iloc[:,0]


collection = {}
collection2 = {}

for row_idx in range(0,rows.__len__()-11,3):
    year =  int( df.iloc[row_idx,0].split("\n")[1] )
    data = []

    for col_idx in range(3, 3+100):
        if year <= 1991 and col_idx > 85:
            continue

        old = int( col_idx - 3 )
        num = int( df.iloc[row_idx,col_idx] )
        data.append( num )

    collection[year] = data

f = open( dpath, "w")
f.write( json.dumps(collection, indent=2, ensure_ascii=False, sort_keys=True) )
f.close()
