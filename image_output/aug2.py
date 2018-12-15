import Augmentor
import sys
data = sys.argv[1]
out = sys.argv[2]


p = Augmentor.Pipeline(data, output_directory=out)
p.flip_left_right(probability = 1)
p.process()
