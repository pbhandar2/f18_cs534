import pandas as pd
import numpy as np
from filetimes import filetime_to_dt, dt_to_filetime
import matplotlib.pyplot as plt

file_array = ['usr_0.csv.gz', 'usr_1.csv.gz', 'usr_2.csv.gz']
headers = ["time", "host", "disk", "type", "offset", "size", "response_time"]
data = []

# # Reading the first web file from MSR
# df = pd.read_csv(file_array[0], compression='gzip',
#                  error_bad_lines=False, header=None, names=headers)

# # concating the rest of the files from MSR
# for i in range(1, len(file_array)):
#     df = df.append(pd.read_csv(file_array[i], compression='gzip',
#                  error_bad_lines=False, header=None, names=headers))

start_time = -1

# df = df.set_index('time')
# df = df.sort_index()

class_name = "home"
f = open("home_full_MSR_30min.csv", "w+")

fig = plt.figure(figsize=[6,6])
ax = fig.add_subplot(111)
man_pad = 0
bin_count = 0

all_time = []
all_lbn = []

for file_name in file_array:
    df = pd.read_csv(file_name, compression='gzip',
                     error_bad_lines=False, header=None, names=headers)
    df = df.set_index('time')
    print("working with file {} .....".format(file_name))
    for index, row in df.iterrows():

        # First iteration
        if (start_time == -1):
            start_time = filetime_to_dt(int(index))

        # The current time and the difference
        cur_time = filetime_to_dt(int(index))
        time_diff = cur_time - start_time

        #print(time_diff.total_seconds())

        # If the time difference is more than 30 min than gotta collect your stats
        if (time_diff.total_seconds() > 1800):
            ax.set_ylim(min(all_lbn) - man_pad, max(all_lbn) + man_pad)
            ax.set_xlim(min(all_time) - man_pad, max(all_time) + man_pad)
            ax.axes.get_xaxis().set_visible(False)
            ax.axes.get_yaxis().set_visible(False)
            ax.set_frame_on(False)
            plt.savefig("{}_{}.png".format(class_name, bin_count), bbox_inches='tight',pad_inches=0.05)
            bin_count += 1
            start_time = cur_time
            plt.close()
            fig = plt.figure(figsize=[6,6])
            ax = fig.add_subplot(111)

            all_time = []
            all_lbn = []

        offset = int(row["offset"])
        disk = int(row["disk"])

        y = int("{}{}".format(row["disk"], row["offset"]))
        x = time_diff.total_seconds()

        all_lbn.append(y)
        all_time.append(x)

        if (row["type"] == "Read"):
            color="blue"
        else:
            color="red"

        #plt.scatter(x, y, color=color)
        ax.scatter(x, y, color=color, s=1, alpha=0.1)














