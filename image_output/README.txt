This invludes all the augmentations that will be performed on the images.

aug1 = random_distortion(probability=1, grid_width=2, grid_height=2, magnitude=2)
aug2 = p.flip_left_right(probability = 1)
aug2 = p.flip_top_bottom(probability = 1)
