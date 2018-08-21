function [] = m_gradient2edge(gradient_nifti_file, edge_nifti_file, fs_vertex_nonadj, hemi)
% edge detection on fsaverage5 surface
% nonmaxima suppression procedure
% suppressing vertices that are not local maxima with repect to at least 2 pairs of spatially adjacent vertex gradient values in the gradient image
% Ref: Wig et al., 2013; 2014
% Ting Xu, Aug 2014
%% ============================

% Input: gradient_nifti_file
% Output: edge_nifti_file
% e.g. fs_vertex_nonadj = 'templates/fsaverage5/mid_nonadj.mat'


addpath(genpath('core/gifti_matlab'))
%%
load(fs_vertex_nonadj)
if strcmp(hemi, 'lh')
    nonadj = lh_nonadj;
elseif strcmp(hemi, 'rh')
    nonadj = rh_nonadj;
else
    error('Check the hemisphere flag: lh or rh')
end
%%
hdr = load_nifti(gradient_nifti_file);
gmap_all = squeeze(hdr.vol);

dims = size(gmap_all);
edgemap = zeros(size(gmap_all));
nvertex = dims(1);

for nv=1:dims(2)
    if rem(nv, 500) == 0
        fprintf('->%d%% ', round(nv/dims(2)*100));
    end
gmap = gmap_all(:,nv);
for i = 1:nvertex
    pair = nonadj{i};
    if sum(all(gmap(i) > gmap(pair),2)) >= 2
    edgemap(i, nv) = 1;
    end
end
end
% save
hdr.vol = reshape(edgemap, size(hdr.vol));
save_nifti(hdr, edge_nifti_file)

exit

