import Augmentor
import sys
data = sys.argv[1]
output = sys.argv[2]

def run_aug_1(data, out):
    p = Augmentor.Pipeline(data, output_directory=out)
    p.random_distortion(probability=1, grid_width=2, grid_height=2, magnitude=2)
    p.process()

def run_aug_2(data, out):
    p = Augmentor.Pipeline(data, output_directory=out)
    p.flip_left_right(probability = 1)
    p.process()

def run_aug_3(data, out):
    p = Augmentor.Pipeline(data, output_directory=out)
    p.flip_top_bottom(probability = 1)
    p.process()

run_aug_1(data, output)
run_aug_2(data, output)
run_aug_3(data, output)
