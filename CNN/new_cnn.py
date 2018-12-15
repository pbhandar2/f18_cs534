import torch 
import torch.nn as nn
import torchvision
import torchvision.transforms as transforms
import pdb
from blockDataLoader import BlockDataLoader
import matplotlib.pyplot as plt


# Device configuration
device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')

# Hyper parameters
num_epochs = 1
num_classes = 3
batch_size = 100
learning_rate = 0.001
transformations = transforms.Compose([transforms.ToTensor()])
all_labels = ["home", "mail", "web"]

# MNIST dataset
train_block_loader = BlockDataLoader("./test_data/train_index.csv", transformations=transformations)
test_block_loader = BlockDataLoader("./test_data/test_index.csv", transformations=transformations)
#val_block_loader = BlockDataLoader("./test_data/val.csv", transformations=transformations)

# Data loader
train_loader = torch.utils.data.DataLoader(dataset=train_block_loader, batch_size=batch_size, shuffle=True)
test_loader = torch.utils.data.DataLoader(dataset=test_block_loader, batch_size=batch_size, shuffle=True)
#val_loader = torch.utils.data.DataLoader(dataset=val_block_loader, batch_size=batch_size, shuffle=True)


# Convolutional neural network (two convolutional layers)
class ConvNet(nn.Module):
    def __init__(self, num_classes=10):
        super(ConvNet, self).__init__()
        self.layer1 = nn.Sequential(
            nn.Conv2d(4, 16, kernel_size=5, stride=1, padding=2),
            nn.BatchNorm2d(16),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2))
        self.layer2 = nn.Sequential(
            nn.Conv2d(16, 32, kernel_size=5, stride=1, padding=2),
            nn.BatchNorm2d(32),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2))
        self.fc = nn.Linear(64*64*32, num_classes)
        
    def forward(self, x):
        out = self.layer1(x)
        
        out = self.layer2(out)
        self.out = out
        out = out.reshape(out.size(0), -1)
        out = self.fc(out)
        return out

    def get_last_out(self, real, pred, index, sub_index):
        #pdb.set_trace()
        images = self.out.cpu()

        #print(len(labels)) #4
        #print(len(images)) #100? How? I need last 100 labels. I see. 
        
        for i, image in enumerate(images):
            if (i == sub_index):
                cur_image = image[1]
                #pdb.set_trace()
                plt.imshow(cur_image)
                plt.savefig("/home/pranav/Desktop/data/{}_{}_{}.png".format(real, pred, index))

        return self.out

model = ConvNet(num_classes).to(device)

# Loss and optimizer
criterion = nn.CrossEntropyLoss()
optimizer = torch.optim.Adam(model.parameters(), lr=learning_rate)

# Train the model
total_step = len(train_loader)
for epoch in range(num_epochs):
    for i, (images, labels) in enumerate(train_loader):
        images = images.to(device)
        label_vals = []
        for l in labels:
            label_vals.append(all_labels.index(l))

        target = torch.LongTensor(label_vals).cuda()
        
        # Forward pass
        outputs = model(images)

        loss = criterion(outputs, target)
        
        # Backward and optimize
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        

        print ('Epoch [{}/{}], Step [{}/{}], Loss: {:.4f}' 
               .format(epoch+1, num_epochs, i+1, total_step, loss.item()))



# Test the model
model.eval()  # eval mode (batchnorm uses moving mean/variance instead of mini-batch mean/variance)
with torch.no_grad():
    correct = 0
    total = 0
    b = 0
    for images, labels in test_loader:
        images = images.to(device)
        label_vals = []
        for l in labels:
            label_vals.append(all_labels.index(l))
        
        target = torch.LongTensor(label_vals).cuda()
        outputs = model(images)
        _, predicted = torch.max(outputs.data, 1)
        total += target.size(0)
        for i,p in enumerate(predicted):
            if (target[i] != predicted[i]):
                x = model.get_last_out(target[i], predicted[i], b*batch_size+i, i)
                print("{} predicted as {} at b {} and i {} so index {}".format(target[i], predicted[i], b, i, b*batch_size+i))
        correct += (predicted == target).sum().item()
        b += 1
    print('Test Accuracy of the model on the 10000 test images: {} %'.format(100 * correct / total))

# Save the model checkpoint
torch.save(model.state_dict(), 'model.ckpt')