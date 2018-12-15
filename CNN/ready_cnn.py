import torch
import torch.nn as nn
import torchvision
import torchvision.transforms as transforms
import pdb
import matplotlib.pyplot as plt


class ReadyNet(nn.Module):

	def __init__(self, num_classes=3, kernel_size_conv=6, kernel_size_pool=2, pool_stride=2, conv_stride=1, num_hidden_nodes=4, img_size=256):
		super(ReadyNet, self).__init__()
		self.num_hidden_nodes = num_hidden_nodes
		self.num_classes = num_classes
		self.layer1 = nn.Sequential(
			nn.Conv2d(4, num_hidden_nodes, kernel_size=kernel_size_conv, stride=conv_stride),
			nn.BatchNorm2d(num_hidden_nodes),
			nn.ReLU(),
			nn.MaxPool2d(kernel_size=kernel_size_pool, stride=pool_stride)
		)
		#num_hidden_nodes = int(img_size/2-kernel_size_conv/2)
		self.layer2 = nn.Sequential(
			nn.Conv2d(num_hidden_nodes, num_hidden_nodes, kernel_size=kernel_size_conv, stride=conv_stride),
			nn.BatchNorm2d(num_hidden_nodes),
			nn.ReLU(),
			nn.MaxPool2d(kernel_size=kernel_size_pool, stride=pool_stride)
		)

		last_dim = int(img_size/2**(2)) 

		self.fc = nn.Linear(last_dim * last_dim * self.num_hidden_nodes, self.num_classes)


	def forward(self, x):
		pdb.set_trace()
		out = self.layer1(x)
		out = self.layer2(out)
		out = out.reshape(out.size(0), -1)
		pdb.set_trace()
		out = self.fc(out).clamp(min=0)
		return out


