import os
import gzip
import matplotlib.pyplot as plt
import json

def make_matrix(data, lbn):
	list_lbn = list(lbn)

	min_lbn = min(list_lbn)
	max_lbn = max(list_lbn)

	cur_lbn = min_lbn

	f = open("MSR_{}_{}.json".format(bin_count, class_name), "w+")
	json_string = json.dumps(data)
	f.write(json_string)
	f.close()




main_path = "/home/pranav/Downloads/MS_Enterprise_Traces/Exchange-Server-Traces/Exchange/"
walk = os.walk(main_path)
file_array = []
class_name = "mail"
file_count = 0
all_data = {}
bin_count = 0

lbn_number_set = []
for i in range(10):
    lbn_number_set.append(set([]))

plt.figure(bin_count)

for file_name in walk.__next__()[2]:
    full_file_path = os.path.join(main_path, file_name)
    f = gzip.open(full_file_path, 'r')
    print("WORKING WITH FILE {}".format(full_file_path))
    start_flag = 0
    line_count = 0
    line = f.readline().strip()
    file_count += 1

    while (line):
        line = line.decode("utf-8")

        if (start_flag):

            #print(line)

            if "DiskWrite" in line or "DiskRead" in line:

                split_line = line.split(",")
                timestamp = int(split_line[1])
                offset = int(split_line[5], 0)
                disk = int(split_line[8])
                io_size = int(split_line[6], 0)

                all_data[disk] = {
                    offset: [timestamp]
                }

                if "DiskWrite" in line:
                    plt.scatter(timestamp, int("{}{}".format(disk,offset)))
                elif "DiskRead" in line:
                    plt.scatter(timestamp, int("{}{}".format(disk,offset)))

                if (file_count > 2):
                    bin_count += 1
                    start_time = 0
                    file_count = 0

                    make_matrix(all_data, lbn_number_set)

                    all_data = {}

                    for i in range(10):
                        lbn_number_set[i] = set([])

                    plt.savefig("MSR_{}_{}.png".format(bin_count, class_name))
                    plt.figure(bin_count)

                    #exit()





        if "EndHeader" in str(line):
            start_flag = 1

        line = f.readline().strip()
