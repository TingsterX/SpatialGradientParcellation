## Spatial Gradient Parcellation

Reference: [Gordon et al.,](https://academic.oup.com/cercor/article/26/1/288/2367115) Generation and Evaluation of a Cortical Area Parcellation from Resting-State Correlations. Cereb Cortex 2016. [Code](https://sites.wustl.edu/petersenschlaggarlab/resources/)

Related Paper: [Xu et al.,](https://academic.oup.com/cercor/article-lookup/doi/10.1093/cercor/bhw241) Assessing Variations in Areal Organization for the Intrinsic Brain: From Fingerprints to Reliability. Cereb Cortex 2016. 

### Software Requirements 

- [workbench] (https://www.humanconnectome.org/software/connectome-workbench)
- Matlab

### Run
```
./x_gradient.sh ThePath/<lh.FC_Similarity.fsaverage5.nii.gz> <ThePath/lh.mask.fsaverage5.nii.gz> <L.midthickness.fsaverage5.surf.gii> <OutPath>
```

## Note
#### The gradient should NOT be calculated on the template surface. Use the standarded (aligned) native surface all the time. 


