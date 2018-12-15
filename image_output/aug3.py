import Augmentor
import sys
data = sys.argv[1]
out = sys.argv[2]


p = Augmentor.Pipeline(data, output_directory=out)
p.flip_top_bottom(probability = 1)
p.process()
