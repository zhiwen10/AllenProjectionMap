function [cpoint] = autoProjectionCenter(dataFolder,mask3d,nameList1)
%% threshold 3d volume within mask and within threshold
threshold  = 0.1;
for i = 1:numel(nameList1)
    clear x y z
    S = dir(fullfile(dataFolder,[char(nameList1(i)) '*.nrrd']));
    filename = fullfile(S.folder,S.name);
    filteredProj = projectionVolumeFilter(mask3d,filename,threshold);
    % find weighted center points
    cpoint(i,:) = findWeightedCenter(filteredProj);
end
end