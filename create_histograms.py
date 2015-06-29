import os
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.backends.backend_pdf
import sys

#Usage: write down the file to get histograms after program name

usr_file = sys.argv[1]

def read_file(file, name):
    line_list = []
    fh = file
    dfList = fh[name].tolist()
    float_lst = []
    for i in dfList:
        i = float(i)
        float_lst.append(i)
    float_array = np.array(float_lst)
    index = np.arange(len(dfList))
    fig = plt.figure()
    n, bins, patches = plt.hist(float_array, 60, facecolor='green', alpha=0.75)
    plt.xlabel("Value")
    plt.ylabel("Frequency")
    plt.title(name)
    plt.show() 
    fig.savefig(name+".png")
              

def main():
    fh = pd.read_csv(usr_file, sep=" ")
    new_dir = "images_"+usr_file[:len(usr_file)-4]
    if os.path.exists(new_dir):
        pass
    else:
        os.mkdir(new_dir)
    os.chdir(new_dir)
    for i in range(1,7):
        read_file(fh, fh.columns.values[i])
        
    
if __name__ == "__main__":
    main()
        