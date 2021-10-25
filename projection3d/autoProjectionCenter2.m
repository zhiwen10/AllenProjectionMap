function [cpoint] = autoProjectionCenter2(dataAll,mask3d,nameList1,threshold)
%% threshold 3d volume within mask and within threshold
threshold  = 0.1;
for i = 1:numel(nameList1)
    clear x y z
    data = squeeze(dataAll(:,:,:,i));
    data(not(mask3d)) = 0;
    data(:,:,1:114) = 0;                                                   % all left hemisphere intenisties are ignored before find center 
    IntensityMax = max(data(:));
    data(data<=IntensityMax*threshold)=0;                                   % set Intensity threshold to be above 10% to get rid of noisy pixels
    filteredProj = data;
    % find weighted center points
    cpoint(i,:) = findWeightedCenter(filteredProj);
end
end