import torch
import torch.nn as nn
import torchvision
import torchvision.transforms as transforms
import pdb

class ConvNet(nn.Module):
    def __init__(self, num_hidden_nodes = 32, num_classes=3, img_size=256, kernel_size_conv=5, kernel_size_pool=2, conv_stride=1, pool_stride=2):
        super(ConvNet, self).__init__()
        self.num_hidden_nodes = num_hidden_nodes

        # The first layer with 4 channel input 
        self.layer1 = nn.Sequential(
            nn.Conv2d(4, num_hidden_nodes, kernel_size=kernel_size_conv, stride=conv_stride, padding=2),
            nn.BatchNorm2d(num_hidden_nodes),
            nn.ReLU(),
        ).cuda()

        self.layer2 = nn.Sequential(
            nn.Conv2d(num_hidden_nodes, num_hidden_nodes, kernel_size=kernel_size_conv, stride=conv_stride, padding=2),
            nn.BatchNorm2d(num_hidden_nodes),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=kernel_size_pool, stride=pool_stride)
        ).cuda()

        self.layer3 = nn.Sequential(
            nn.Conv2d(num_hidden_nodes, num_hidden_nodes, kernel_size=kernel_size_conv, stride=conv_stride, padding=2),
            nn.BatchNorm2d(num_hidden_nodes),
            nn.ReLU(),
        ).cuda()

        self.layer4 = nn.Sequential(
            nn.Conv2d(num_hidden_nodes, num_hidden_nodes, kernel_size=kernel_size_conv, stride=conv_stride, padding=2),
            nn.BatchNorm2d(num_hidden_nodes),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=kernel_size_pool, stride=pool_stride)
        ).cuda()

        self.num_max_pool_layers = 3
        self.num_classes = num_classes
        
        last_dim = int(img_size/2**(2))
        self.fc = nn.Linear(last_dim * last_dim * self.num_hidden_nodes, self.num_classes).cuda()

    def forward(self, x):
        #pdb.set_trace()
        out = self.layer1(x)
        out = self.layer2(out)
        out = self.layer3(out)
        out = self.layer4(out)
        out = out.reshape(out.size(0), -1)
        out = self.fc(out).clamp(min=0)
        return out










