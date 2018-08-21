#!/bin/bash
# Calculate the gradient of the metric map
# Use watershed algorithm (Ref: Gordon et al., 2014)
# Ting Xu, Mar 2015, Aug 2018
## =========================================
WBDIR=?
BaseDir=? # Code Directory
export PATH=${WBDIR}:$PATH
## =========================================
FWHM1=?  # Pre-smooth kernel before gradient calculation
FWHM2=? # Smooth kernel of gradient
Sigma1=`echo "$FWHM / ( 2 * ( sqrt ( 2 * l ( 2 ) ) ) )" | bc -l`
Sigma2=`echo "$FWHM2 / ( 2 * ( sqrt ( 2 * l ( 2 ) ) ) )" | bc -l`
## =========================================
fsaverage=fsaverage5
metric_nifti=$1 # the metric map. Example: ThePath/?h.metric.fsaverage5.nii.gz 
mask_nifti=$2   # the mask of the metric map: Example: ?h.mask.fsaverage5.nii.gz
surface=$3     # the surface on which gradient is calculated. Example: L.midthickness.fsaverage5.surf.gii
output_dir=$4  # output directory
## =========================================
ThePath=`dirname ${metric_nifti}`
metric_map=`basename ${metric_nifti}`
metric_name=${metric_map:3:${#metric_map}-10}
hemi=${metric_map::2}

# lh/rh for *.nii.gz format, L/R for gifti format
if [[ ${hemi} == "lh" ]]; then
  Hemi="L"
elif [[ ${hemi} == "rh" ]]; then
  Hemi="R"
fi

node_neighbors_file=${BaseDir}/template/${fsaverage}/${hemi}.neighbors_IndexStart0.txt

mask_map=`basename ${mask_nifti}`
mask_name=${mask_map:3:${#mask_map}-10}
hemi_mask=${mask_map::2}

surface_map=`basename ${surface}`
Hemi_surface=${surface_map::1}

## =========================================
if [[ ${hemi} != ${hemi_lh} ]] || [[ ${Hemi} != ${Hemi_surface} ]]; then
	exit "Check: the hemisphere of metric, mask and surface should be the same"
fi
## =========================================
echo "============================="
echo "-> Input: ${metric_nifti} ..."
echo "-> Compute the gradient ..."
echo "============================="
mkdir -p ${output_dir}

wb_command -metric-convert -from-nifti ${metric_nifti} ${surface} ${output_dir}/${Hemi}.${metric_name}.func.gii
wb_command -metric-convert -from-nifti ${mask_nifti} ${surface} ${output_dir}/${Hemi}.${mask_name}.func.gii

wb_command -metric-gradient ${surface} ${output_dir}/${Hemi}.${metric_name}.func.gii ${output_dir}/${Hemi}.${metric_name}.sm${FWHM1}.gradient.func.gii -presmooth ${Sigma1} -roi ${output_dir}/${Hemi}.${mask_name}.func.gii

wb_command -metric-smoothing ${surface} ${output_dir}/${Hemi}.${metric_name}.sm${FWHM1}.gradient.func.gii ${Sigma2} ${output_dir}/${Hemi}.${metric_name}.sm${FWHM1}.gradient.sm${FWHM2}.func.gii -roi ${output_dir}/${Hemi}.${mask_name}.func.gii

wb_command -metric-convert -to-nifti ${output_dir}/${Hemi}.${metric_name}.sm${FWHM1}.gradient.sm${FWHM2}.func.gii ${output_dir}/${hemi}.${metric_name}.sm${FWHM1}.gradient.sm${FWHM2}.nii.gz

gmapfile=${output_dir}/${hemi}.${metric_name}.sm${FWHM1}.gradient.sm${FWHM2}.nii.gz
labelfile=${output_dir}/${hemi}.${metric}.sm${FWHM}.gradient.sm${FWHM2}.watershed_parcels.nii.gz
emapfile=${output_dir}/${hemi}.${metric}.sm${FWHM}.gradient.sm${FWHM2}.watershed_edges.nii.gz

pushd ${BaseDir}
matlab -nodisplay -r "m_watershed_gradient2edge('${gmapfile}', '${labelfile}', '${emapfile}', '${mask_nifti}', '${node_neighbors_file}')"
popd

wb_command -metric-convert -from-nifti ${labelfile} ${surface} ${output_dir}/${Hemi}.${metric}.sm${FWHM}.gradient.sm${FWHM2}.watershed_parcels.func.gii
wb_command -metric-convert -from-nifti ${emapfile} ${surface} ${output_dir}/${Hemi}.${metric}.sm${FWHM}.gradient.sm${FWHM2}.watershed_edges.func.gii

wb_command -metric-reduce 'map*mask' ${output_dir}/${Hemi}.${metric}.sm${FWHM}.gradient.sm${FWHM2}.watershed_edges.func.gii MEAN ${output_dir}/${Hemi}.${metric}.sm${FWHM}.gradient.sm${FWHM2}.watershed_edges.dense.func.gii -only-numeric
wb_command -metric-math 'map*mask' ${output_dir}/${Hemi}.${metric}.sm${FWHM}.gradient.sm${FWHM2}.watershed_edges.dense.func.gii -var map ${output_dir}/${Hemi}.${metric}.sm${FWHM}.gradient.sm${FWHM2}.watershed_edges.dense.func.gii -var mask ${output_dir}/${Hemi}.${mask_name}.func.gii


