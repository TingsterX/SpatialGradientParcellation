## Spatial Gradient Parcellation
Reference: 

[Xu et al.,2016](https://academic.oup.com/cercor/article-lookup/doi/10.1093/cercor/bhw241) Assessing Variations in Areal Organization for the Intrinsic Brain: From Fingerprints to Reliability. Cereb Cortex 2016.

[Xu et al., 2018](https://www.cell.com/cell-reports/pdf/S2211-1247(18)30394-2.pdf)Delineating the Macroscale Areal Organization of the
Macaque Cortex In Vivo. Cell Report 2018


### Software Requirements 

- [workbench](https://www.humanconnectome.org/software/connectome-workbench)
- Matlab

### Run
```
./x_gradient.sh PathToFile/<lh.functional_similarity.nii.gz> <ThePath/lh.mask.nii.gz> <L.midthickness.surf.gii> <OutDirectory>
```

## IMPORTANT!!
### The gradient should NOT be calculated on the template surface. Use the standarded (aligned) **native** surface all the time. 


### edge detection code

1. Gordon et al., 2016
Reference: [Gordon et al.,](https://academic.oup.com/cercor/article/26/1/288/2367115) Generation and Evaluation of a Cortical Area Parcellation from Resting-State Correlations. Cereb Cortex 2016. 

- [Code](https://sites.wustl.edu/petersenschlaggarlab/resources/)

2. Wig et al., 2016
Reference: [Wig et al.,](https://academic.oup.com/cercor/article-lookup/doi/10.1093/cercor/bht056) Parcellating an individual subject's cortical and subcortical brain structures using snowball sampling of resting-state correlations. 2014
- Code: m_gradient2edge.m





