import Augmentor
import sys
data = sys.argv[1]
out = sys.argv[2]


p = Augmentor.Pipeline(data, output_directory=out)
p.random_distortion(probability=1, grid_width=2, grid_height=2, magnitude=2)
p.process()
