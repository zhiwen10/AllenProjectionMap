function [cpoint] = plotProjectionVolume3d(ax0,brainGridData,dataFolder,mask3d,nameList1,color1,angle)
plotBrainGrid(brainGridData,ax0);
% plot all points 
hold on;
%% threshold 3d volume within mask and within threshold
threshold  = 0.1;
for i = 1:numel(nameList1)
    clear x y z
    S = dir(fullfile(dataFolder,[char(nameList1(i)) '*.nrrd']));
    filename = fullfile(S.folder,S.name);
    filteredProj = projectionVolumeFilter(mask3d,filename,threshold);
    % find weighted center points
    cpoint(i,:) = findWeightedCenter(filteredProj);
    indx1 = find(filteredProj>0);
    [x,y,z] = ind2sub(size(filteredProj),indx1);
    scatter3(x,y,z,3,'MarkerFaceColor',color1(i,:),'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0)
    hold on
end
xlim([0 160]); ylim([0 264]); zlim([0 228]);
view(angle(1),angle(2))
end