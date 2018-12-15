# f18_cs534

Machine Learning, CS534, Joyce Ho, Project Content

Pranav Bhandaripranav.bhandari@emory.edu
Department of Computer Science
Emory University
Atlanta, GA 30322, USA

Brandon C. Henley
brandon.c.henley@emory.edu
Department of Neurology
Emory University
Atlanta, GA 30322, USA

Ana Noriega
ananori@emory.edu
Department of Computer Science
Emory University
Atlanta, GA 30322, USA

Workload labels like user and web have traditionally represented distinct characteristicsof workloads. For instance, an archival workload often refers to a workload with a high writeto read ratio. Loose guidelines like high write to read ratio can lead to loss of generality as itcan be interpreted differently depending on the data source.  This means that traces sharingthe same labels can have distinct features.  We evaluate the labels to see how well theydifferentiate workloads from different sources based on features commonly used in block I/Oworkload characterization.  We see that the labels differentiate workloads from the samesource while they struggle to distinguish workloads coming from a different source.  Thislack of generality combined with the labels not being representative of workload featuressignifies the need for a robust feature based workload characterization framework.  We ranpreliminary experiments to come up with new labels that are representative of the featuresof the workload and got 100% accuracy even when the test data came from a data sourcenot used for training.

CONTENT:

- CNN directory contains the code and data for the CNN

	To run the CNN go in directory CNN and use the command 

	python3 new_cnn.py

	the settings are changed inside the file. 

	data_labeler.py labels the data in the test_data folder and updates the training and testing csv file for images inside the directory 

- CNN/test_data 
	copntains the data used in training the CNN
	
- Image Output
	contains more access plots might overlap with some on the test_data folder

- Augmentation
	contains scripts to augement images 

- more data preprocessing and access plots generation done using https://github.com/pbhandar2/skeletor_web


- Analyze_FIU_MSR_Data.m

	Cluster the data
	Data Modeling 

- Feature Extractor

	scripts to bin the data and extract basic features 

- 30Minute_Binned_Data.zip

	feature extracted from 30 Minute bin data
