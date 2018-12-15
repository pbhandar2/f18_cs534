from blockDataLoader import BlockDataLoader
import torch
import torch.nn as nn
from torchvision import transforms
from ready_cnn import ReadyNet
from torch.autograd import Variable
import matplotlib.pyplot as plt
from skimage import io, transform
import sys
from CNN_lib import error




if (len(sys.argv) != 7):
    print("Usage: python3 main.py Learning_Rate Batch_Size Num_Epochs Dropout L2 Num_Layer")
    exit()

gpu_count = torch.cuda.device_count()
learning_rate = float(sys.argv[1])
batch_size = int(sys.argv[2])
num_epochs = int(sys.argv[3])
dropout = float(sys.argv[4])
l2 = float(sys.argv[5])
num_hidden_nodes = int(sys.argv[6])
num_layer = 6
img_size = (256, 256)
device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')

print("Num GPU: {}, Learning Rate: {}, Batch Size: {}, Num Epochs: {}, Dropout: {}, L2: {}, Hidden: {}, num_layer: {}".format(gpu_count, learning_rate, batch_size, num_epochs, dropout, l2, num_hidden_nodes, 6))


# image transformations
transformations = transforms.Compose([transforms.ToTensor()])
criterion = nn.CrossEntropyLoss()
model = ReadyNet(num_hidden_nodes=num_hidden_nodes)
model.cuda()
optimizer = torch.optim.Adam(model.parameters(), lr=learning_rate, weight_decay=l2)
all_labels = ["home", "mail", "web"]

train_block_loader = BlockDataLoader("./test_data/train.csv", transformations=transformations)
test_block_loader = BlockDataLoader("./test_data/test.csv", transformations=transformations)
val_block_loader = BlockDataLoader("./test_data/val.csv", transformations=transformations)

train_data_loader = torch.utils.data.DataLoader(dataset=train_block_loader, batch_size=batch_size, shuffle=True)
test_data_loader = torch.utils.data.DataLoader(dataset=test_block_loader, batch_size=batch_size, shuffle=True)
val_data_loader = torch.utils.data.DataLoader(dataset=val_block_loader, batch_size=batch_size, shuffle=True)
all_train_error = []
all_val_error = []

for i in range(num_epochs):
	print("EPOCH: {}".format(i))
	total_error = 0 
	total_iteration = 0
	model.train()
	for idx, (img, labels) in enumerate(train_data_loader):

		# get the output from the CNN
		img = img.to(device)
		outputs = model(img).to(device)

		label_vals = []
		for l in labels:
			label_vals.append(all_labels.index(l))

		target = Variable(torch.LongTensor(label_vals)).cuda()
		loss = criterion(outputs, target)
		loss.backward()
		optimizer.zero_grad()
		optimizer.step()

		correct = error(outputs, target)

		total_error += correct/len(target)
		
		total_iteration += 1

		print("Loss: {}, Error: {}".format(loss, correct/len(target)))

	avg_train = total_error/total_iteration
	print("AVERAGE ERROR: {}".format(str(total_error/total_iteration)))
	all_train_error.append(total_error/total_iteration)

	if (avg_train < 0.15):
		break

	model.eval()
	total_correct = 0
	total = 0
	with torch.no_grad():
		for idx, (img, labels) in enumerate(val_data_loader):

			# get the output from the CNN
			img = img.to(device)
			outputs = model(img).to(device)

			label_vals = []
			for l in labels:
				label_vals.append(all_labels.index(l))

			target = Variable(torch.LongTensor(label_vals)).cuda()
			total_correct += error(outputs, target)
			total_error += total_correct/len(target)
			
			total += len(target)

		print("Validation Error: {}".format(total_correct/total))
		avg_val_error = total_correct/total
		all_val_error.append(total_correct/total)

		if (avg_val_error < 0.15):
			break


model.eval()
total_correct = 0
total = 0
with torch.no_grad():
	for idx, (img, labels) in enumerate(test_data_loader):

		# get the output from the CNN
		img = img.to(device)
		outputs = model(img).to(device)

		label_vals = []
		for l in labels:
			label_vals.append(all_labels.index(l))

		target = Variable(torch.LongTensor(label_vals)).cuda()
		total_correct += error(outputs, target)
		total += len(target)

	print("Test Error: {}".format(total_correct/total))

print("Min train: {} at {}, Min val: {} at {}".format(min(all_train_error), all_train_error.index(min(all_train_error)), min(all_val_error), all_val_error.index(min(all_val_error))))


# Save the model checkpoint
torch.save(model.state_dict(), 'model_{}_{}_{}_{}_200.ckpt'.format(learning_rate, batch_size, num_epochs, num_hidden_nodes))