import os
import sys
from data_lib import get_label
import numpy as np

data_dir = sys.argv[1]
num_train = int(sys.argv[2])
num_test = int(sys.argv[3])
num_val = int(sys.argv[4])

all_files = {
	"home": [],
	"web": [],
	"mail": []
}


# Need to go through each sub_directory
for sub_dir in os.walk(data_dir).__next__()[1]:
	label = get_label(sub_dir)
	if len(label):

		# THIS IS BECAUSE THE LOCATION OF DATA LABELER AND THE MAIN FILE WE RUN IS NOT THE SAME
		rel_data = "./test_data"
		rel_path = os.path.join(rel_data, sub_dir)
		full_path = os.path.join(data_dir, sub_dir)

		# Go through each file in a subdirectory 
		for file_name in os.walk(full_path).__next__()[2]:
			all_files[label].append("{},{}\n".format(os.path.join(rel_path, file_name), label))



import random
all_array = []
train_array = []
test_array = []
val_array = []

for key in all_files:
	random.shuffle(all_files[key])

for key in all_files:
	train_array += all_files[key][0:int(num_train/3)]
	test_array += all_files[key][int(num_train/3):int(num_train/3)+int(num_test/3)]
	val_array += all_files[key][int(num_train/3)+int(num_test/3):int(num_train/3)+int(num_test/3)+int(num_val/3)]

random.shuffle(train_array)
random.shuffle(test_array)
random.shuffle(val_array)

keys = list(all_files.keys())
selected_index = []
count = [0,0,0]


train = open(os.path.join(data_dir, "train.csv"), "w+")
test = open(os.path.join(data_dir, "test.csv"), "w+")
val = open(os.path.join(data_dir, "val.csv"), "w+")

for line in train_array:
	train.write(line)

for line in test_array:
	test.write(line)

for line in val_array:
	val.write(line)





# for i in range(3):

# train_part = int(num_train/3)

# train_all = all_files["home"][0:train_part] + all_files["web"][0:train_part] + all_files["mail"][0:train_part]
# test_all = all_files["home"][0:train_part] + all_files["web"][0:train_part] + all_files["mail"][0:train_part]


# for i in range(num_train+num_test+num_val):
# 	found = 0

# 	index = random.randint(0,2)
# 	key = keys[index]

# 	cur_count = count[index]

# 	if (num_train > 0):
# 		train.write(all_files[key][cur_count])
# 		count[index] += 1
# 		num_train -= 1
# 	elif (num_test > 0):
# 		test.write(all_files[key][cur_count])
# 		count[index] += 1
# 		num_test -= 1
# 	elif (num_val > 0):
# 		val.write(all_files[key][cur_count])
# 		count[index] += 1
# 		num_test -= 1
# 	else:
# 		break


















