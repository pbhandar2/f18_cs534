import os
import sys

label_dict = {
    "storage_home1": "home",
    "storage_home2": "home",
    "storage_home3": "home",
    "storage_home4": "home",
    "storage_mail": "mail",
    "storage_online": "web",
    "storage_webmail": "mail",
    "storage_webusers": "web",
    "storage_webresearch": "web"
}

# Checking for trailing /
global_dir = sys.argv[1]
if (global_dir[-1] == "/"):
    global_dir = global_dir[:-1]

# the global csv file
global_csv = open("{}/index.csv".format(global_dir), "w+")

""" The function gets the label of the data from the folder where it belongs"""
def get_label(sub_dir):
    cur_label = ''
    if 'home' in sub_dir:
        cur_label = 'home'
    elif 'mail' in sub_dir:
        cur_label = 'mail'
    elif 'web' in sub_dir:
        cur_label  = 'web'
    return cur_label

"""The function generates a csv with the file names and the label."""
def generate_csv(dir, file_names, label):
    f = open("{}/index.csv".format(dir), "w+")
    file_count = 0
    for file_name in file_names:
        if 'index' not in file_name: 
            full_path = "{}/{}".format(dir, file_name)
            csv_entry = "{},{}\n".format(full_path, label)
            f.write(csv_entry)
            file_count += 1

    return file_count

"""Process the files in the dir - create an index file for it"""
def process_dir(data_dir):
    walk = os.walk(data_dir)
    file_names = walk.__next__()[2]
    label = get_label(data_dir)
    count = 0

    print("for subdir {} with label {}".format(data_dir, label))
    count = generate_csv(data_dir, file_names, label)
    return label, count


def update_data(data, label, count):
    if label in data:
        data[label] += count
    else:
        data[label] = count

    return data

print("Checking dir {}".format(global_dir))
walk = os.walk(global_dir)

total_line = 0
all_lines = []
generate_data = 1
data = {}

# going through each sub directory and getting the label and file names for it
for sub_dir in os.walk(global_dir).__next__()[1]:
    full_sub_dir_location = "{}/{}".format(global_dir, sub_dir)
    label, count = process_dir(full_sub_dir_location)

    data = update_data(data, label, count)

    if (generate_data):
        csv_open = open("{}/{}/index.csv".format(global_dir, sub_dir), "r+")
        line = csv_open.readline()
        while line:
            all_lines.append(line)
            global_csv.write(line)
            line = csv_open.readline()
            total_line += 1

count_arr = []
for key in data:
    count_arr.append(data[key])
print(data)
data_count = min(count_arr)
print("Get {} values from each class".format(data_count))

for key in data:
    data[key] = data_count

# split into train and test
if (generate_data):
    train = int(0.85 * total_line)
    test = total_line - train

    train_file = open("{}/train_index.csv".format(global_dir), "w+")
    test_file = open("{}/test_index.csv".format(global_dir), "w+")

    import random
    random.shuffle(all_lines)
    
    for i in range(len(all_lines)):
        label = all_lines[i].split(",")[1].rstrip()
        #print(label)
        
        if "msr_" in all_lines[i]:
            print(all_lines[i])
            test_file.write(all_lines[i])
        elif (data[label] > 10):
            train_file.write(all_lines[i])
            data[label] -= 1


	

print(data)










