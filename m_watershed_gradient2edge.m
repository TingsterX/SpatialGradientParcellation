function [] = m_watershed_gradient2edge(gmapfile, labelfile, emapfile, maskfile, neighborsfile
% watershed edge detection
% Ref: Gordon et al., 2014
% Modified from code Gordon et al., 2014

%% example:
% Input: gmapfile: gradient map(s), *.nii.gz 
% Input: maskfile: mask of the gradient, *.nii.gz
% Input: neighborsfile ='templates/fsaverage5/?h.neighbors_IndexStart0.txt'
% Input: hemi: 'lh' or 'rh'
% Output: emapfile: binarized edge map(s), *.nii.gz, 
% Output: labelfile: label map(s), *.nii.gz

%% ================================

addpath(genpath('/home/txu/lfcd/ccs/matlab'))
addpath('/home/txu/lfcd/code_papers/wb_Gordon2014')
watershed_step = 200;


% Read in node neighbor file
bufsize=16384;
[neighbors(:,1) neighbors(:,2) neighbors(:,3) neighbors(:,4) neighbors(:,5) neighbors(:,6) neighbors(:,7)] = ...
textread([neighborsfile],'%u %u %u %u %u %u %u','delimiter',' ','bufsize',bufsize,'emptyvalue',NaN);
neighbors = neighbors+1;
% mask
hdr = load_nifti(maskfile);
mask = squeeze(hdr.vol);
% gradient map
hdr = load_nifti(gmapfile);
gmap = squeeze(hdr.vol);
[nvertex, nvol] = size(gmap);

gmax = max(gmap(:));
gmap(mask==0,:) = gmax;

% get local minima of gradient map
disp('----- get local minimal of gradient map -----')
tic;
minimametrics = metric_minima_all(gmap,3,neighbors);
toc;
% watershed-by-flooding 
disp('----- watershed by flooding ------')
labels = xt_watershed_algorithm_all_par(gmap,minimametrics,watershed_step,1,neighbors);
% save edgemap
disp('----- save watershed edegs and label -----')
hdr.vol = reshape(labels, nvertex, 1, 1, nvol);
save_nifti(hdr, labelfile);
% save edgemap
edges = double(labels ==0);
edges(mask==0) = -1;
hdr.vol = reshape(edges, nvertex, 1, 1, nvol);
save_nifti(hdr, emapfile);
%%
exit
