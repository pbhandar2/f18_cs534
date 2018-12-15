def get_label(sub_dir):
	cur_label = ''
	if 'home' in sub_dir:
		cur_label = 'home'
	elif 'mail' in sub_dir:
		cur_label = 'mail'
	elif 'web' in sub_dir:
		cur_label  = 'web'
	return cur_label






