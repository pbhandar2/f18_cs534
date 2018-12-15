import torch


def error(output, target):
	all_labels = ["home", "mail", "web"]
	res = []
	for t in output:
		max_index = 0
		max_val = 0
		for i, t_i in enumerate(t):
			if t_i > max_val:
				max_index = i
				max_val = t_i
		res.append(max_index)

	res = torch.tensor(res).cuda()

	return len((res == target).nonzero())