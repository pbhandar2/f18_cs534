import os 
import random

dir_name = "./test_data"
all_files = os.listdir(dir_name)
labels = ["home", "web", "mail"]
image_files = []
lines = []


for f in all_files:
	subdir = os.path.join(dir_name, f)
	if not os.path.isfile(subdir):
		files_subdir = os.listdir(subdir)
		for image_file in files_subdir:
			r = random.randint(0,2)
			l = labels[r]
			lines.append("{},{}\n".format(os.path.join(subdir, image_file),l))


random.shuffle(lines)

train_file = "./test_data/rand_label_train.csv"
test_file = "./test_data/rand_label_test.csv"

train = open(train_file, "w+")
test = open(test_file, "w+")

train_length = int(len(lines) * 0.80)

train_data = lines[:train_length]
test_data = lines[train_length:]

for l in train_data:
	train.write(l)

for l in test_data:
	test.write(l)






