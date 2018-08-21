Readme for surface parcellation and parcel creation code


This matlab code runs gradient-based parcellation of fMRI timecourse data in CIFTI format. All subjects should be registered to a common CIFTI space (we recommend the fs_LR 32k space for surface elements, but any space may be used).

This code is provided "as is", without any warranty. We cannot provide technical support for this code. For general questions, please contact Evan Gordon (egordon@npg.wustl.edu) or Tim Laumann (laumannt@wusm.wustl.edu).

When publishing results using this code, please cite the following papers:

Cohen AL, Fair DA, Dosenbach NUF, Miezin FM, Dierker D, Van Essen DC, Schlaggar BL, Petersen SE. 2008. Defining functional areas in individual human brains using resting functional connectivity MRI. Neuroimage. 41:45–57.

Gordon EM, Laumann TO, Adeyemo B, Huckins JF, Kelley WM, Petersen SE. 2014. Generation and Evaluation of a Cortical Area Parcellation from Resting-State Correlations. Cereb Cortex. Advance Access.

Wig GS, Laumann TO, Petersen SE. 2014. An approach for parcellating human cortical areas using resting-state correlations. Neuroimage. 93:276–291.




Primary functions are:

surface_parcellation.m - in each cortical hemisphere, computes gradients for each subject on each subject's surface, averages those gradients, smooths the average gradients on the atlas surface, and runs watershed-based edge detection on each vertex's group-average gradient map, resulting in a group-average edge map for each vertex. The edge maps from each vertex are averaged to create a final group-average edge density map. 

parcel_creator.m - builds discrete parcels from edge density maps, based on a threshold for separating parcels (we recommend approximately the 40-50th percentile of edge map values, but results should be checked to ensure this does not result in over- or under-parcellation).



Dependent functions are:

Connectome Workbench, which can be downloaded from http://www.humanconnectome.org/software/connectome-workbench.html

The code in the cifti-matlab-master folder, which is based on code released by Robert Oostenveld (https://github.com/oostenveld/cifti-matlab), with minor modifications to optimize reading of fMRI cifti time series data. 

node_neighbors.txt - this represents the node adjacencies of the fs_LR 32k surface. IMPORTANT: this file must be changed if using a different surface format. Node adjacencies can be generated from a surface using the Caret software (caret_command -surface-topology-neighbors).

paircorr_mod.m - fast (but RAM-demanding) method of calculating pairwise correlations between all timecourses in a timeseries  

FisherTransform.m - code to apply the Fisher transformation to correlations

metric_minima_all.m - code to detect local minima in gradient maps

watershed_algorithm_all_par.m - code to detect edges in gradient maps by applying the watershed-by-flooding algorithm. NOTE: this code utilizes Matlab's parallel computing toolbox, and so will run much faster if that toolbox is installed.