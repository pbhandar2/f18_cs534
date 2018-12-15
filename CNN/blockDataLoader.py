"""
    The data loader class for the block I/O plot that we have.
    Author: Pranav Bhandari <bhandaripranav94@gmail.com> 2018/11
"""

import pandas as pd
from torch.utils.data.dataset import Dataset
from skimage import io, transform
import matplotlib.pyplot as plt
from PIL import Image

class BlockDataLoader(Dataset):
    def __init__(self, csv_path, transformations=None, img_size=(256, 256)):
        self.index_data = pd.read_csv(csv_path)
        self.transformations = transformations
        self.img_size = img_size

    def __len__(self):
        return len(self.index_data)

    def __getitem__(self, idx):
        image_location = self.index_data.iloc[idx, 0]
        label = self.index_data.iloc[idx, 1]
        raw_img = Image.open(image_location)
        img = raw_img.resize(self.img_size)
        return self.transformations(img), label




