import os
import gzip
import numpy as np
import pandas as pd
from filetimes import filetime_to_dt, dt_to_filetime

main_path = "./Exchange"
walk = os.walk(main_path)
file_array = []
class_name = "mail"
g = open("mail_full_MSR_30min.csv", "w+")



all_data = {}

bin_count = 1
start_time = -1
cur_time = -1
end_time = -1

# VARIABLES TO RESET #####################
num_read = 0
num_write = 0
total_read_size = 0
total_write_size = 0

total_timestamp_array = []
read_timestamp_array = []
write_timestamp_array = []

total_access_distance = []
read_access_distance = []
write_access_distance = []

total_prev_access = [0,0,0,0,0,0,0,0,0,0]
read_prev_acess = [0,0,0,0,0,0,0,0,0,0]
write_prev_acess = [0,0,0,0,0,0,0,0,0,0]

total_seq_access_length = [1,1,1,1,1,1,1,1,1,1]
total_all_seq = [[],[],[],[],[],[],[],[],[],[]]
read_seq_access_length = [1,1,1,1,1,1,1,1,1,1]
read_all_seq = [[],[],[],[],[],[],[],[],[],[]]
write_seq_access_length = [1,1,1,1,1,1,1,1,1,1]
write_all_seq = [[],[],[],[],[],[],[],[],[],[]]

# VARIABLES TO RESET #####################



file_count = 0

for file_name in walk.__next__()[2]:
    full_file_path = os.path.join(main_path, file_name)
    f = gzip.open(full_file_path, 'r')
    print("WORKING WITH FILE {}".format(full_file_path))
    start_flag = 0
    line_count = 0
    line = f.readline().strip()
    file_count += 1
    while(line):
        line = line.decode("utf-8")


        if (start_flag):

            if "DiskWrite" in line or "DiskRead" in line:

                split_line = line.split(",")
                timestamp = int(split_line[1])
                offset = int(split_line[5], 0)
                disk = int(split_line[8])
                io_size = int(split_line[6], 0)

                #print(split_line)

                # First iteration
                if (start_time == -1):
                    start_time = timestamp

                cur_time = timestamp
                if (cur_time < end_time):
                    cur_time += end_time

                time_diff = cur_time - start_time



                # If the time difference is more than 30 min than gotta collect your stats
                if (file_count > 2):
                    bin_count += 1

                    start_time = 0
                    file_count = 0

                    # calculate read and write size mean
                    read_size_mean = 0
                    if (num_read):
                        read_size_mean = total_read_size / num_read
                    write_size_mean = 0
                    if (num_write):
                        write_size_mean = total_write_size / num_write

                    # TOTAL AVERAGE SEQ
                    total_seq = 0
                    total_seq_length = 0
                    # print(all_seq)
                    for seq in total_all_seq:
                        total_seq += len(seq)
                        total_seq_length += np.sum(seq)
                    total_avg_seq = total_seq_length / total_seq

                    # READ AVERAGE SEQ
                    total_seq = 0
                    total_seq_length = 0
                    # print(all_seq)
                    for seq in read_all_seq:
                        total_seq += len(seq)
                        total_seq_length += np.sum(seq)
                    read_avg_seq = total_seq_length / total_seq

                    # WRITE AVERAGE SEQ
                    total_seq = 0
                    total_seq_length = 0
                    # print(all_seq)
                    for seq in write_all_seq:
                        total_seq += len(seq)
                        total_seq_length += np.sum(seq)
                    write_avg_seq = total_seq_length / total_seq

                    # AVERAGE ACCESS DISTANCE
                    avg_read_access = np.mean(read_access_distance)
                    avg_write_access = np.mean(write_access_distance)
                    avg_total_access = np.mean(total_access_distance)

                    # BURSTINESS
                    burst_read = np.var(read_timestamp_array) / np.mean(read_timestamp_array)
                    burst_write = np.var(write_timestamp_array) / np.mean(write_timestamp_array)
                    burst_total = np.var(total_timestamp_array) / np.mean(total_timestamp_array)

                    print("{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}\n".format(bin_count, str(num_read),
                                                                                  str(read_size_mean),
                                                                                  str(read_avg_seq),
                                                                                  str(burst_read),
                                                                                  str(avg_read_access),
                                                                                  str(num_write),
                                                                                  str(write_size_mean),
                                                                                  str(write_avg_seq),
                                                                                  str(burst_write),
                                                                                  str(avg_write_access),
                                                                                  str(total_avg_seq),
                                                                                  str(burst_total),
                                                                                  str(avg_total_access),
                                                                                  class_name))

                    g.write("{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}\n".format(bin_count, str(num_read),
                                                                                    str(read_size_mean),
                                                                                    str(read_avg_seq),
                                                                                    str(burst_read),
                                                                                    str(avg_read_access),
                                                                                    str(num_write),
                                                                                    str(write_size_mean),
                                                                                    str(write_avg_seq),
                                                                                    str(burst_write),
                                                                                    str(avg_write_access),
                                                                                    str(total_avg_seq),
                                                                                    str(burst_total),
                                                                                    str(avg_total_access),
                                                                                    class_name))
                    num_read = 0
                    num_write = 0
                    total_read_size = 0
                    total_write_size = 0

                    total_timestamp_array = []
                    read_timestamp_array = []
                    write_timestamp_array = []

                    total_access_distance = []
                    read_access_distance = []
                    write_access_distance = []

                    total_prev_access = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
                    read_prev_acess = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
                    write_prev_acess = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

                    total_seq_access_length = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
                    total_all_seq = [[], [], [], [], [], [], [], [], [], []]
                    read_seq_access_length = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
                    read_all_seq = [[], [], [], [], [], [], [], [], [], []]
                    write_seq_access_length = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
                    write_all_seq = [[], [], [], [], [], [], [], [], [], []]

                if "DiskWrite" in split_line[0]:
                    num_write += 1
                    total_write_size += io_size
                    #print(disk)
                    prev = write_prev_acess[disk]
                    diff = abs(offset - prev)

                    if (diff == 512):
                        write_seq_access_length[disk] += 1
                    else:
                        write_all_seq[disk].append(write_seq_access_length[disk])
                        write_seq_access_length[disk] = 1

                    write_access_distance.append(diff)
                    write_timestamp_array.append(time_diff)
                elif "DiskRead" in split_line[0]:
                    num_read += 1
                    total_read_size += io_size
                    prev = read_prev_acess[disk]
                    diff = abs(offset - prev)

                    if (diff == 512):
                        read_seq_access_length[disk] += 1
                    else:
                        read_all_seq[disk].append(read_seq_access_length[disk])
                        read_seq_access_length[disk] = 1

                    read_access_distance.append(diff)
                    read_timestamp_array.append(time_diff)

                prev = total_prev_access[disk]
                diff = abs(offset - prev)
                total_access_distance.append(diff)

                if (diff == 512):
                    total_seq_access_length[disk] += 1
                else:
                    total_all_seq[disk].append(total_seq_access_length[disk])
                    total_seq_access_length[disk] = 1

                total_prev_access[disk] = offset
                total_timestamp_array.append(time_diff)



        if "EndHeader" in str(line):
            start_flag = 1

        line = f.readline().strip()








