function [projArea2,x,y,z] = getObliqueSliceMask(atlas,plane,xvector,maskPath,st)
[atlasSlice,x,y,z] = obliqueslice(permute(atlas,[2,1,3]),plane(1:3),xvector);
x = floor(x);y = floor(y); z=floor(z);
x(x<1 | x>size(atlas,1)) = nan; 
y(y<1 | y>size(atlas,2)) = nan; 
z(z<1 | z>size(atlas,3)) = nan;
atlasSliceIndex = cat(3,x,y,z);
atlasSliceMask = zeros(size(atlasSlice));
for i = 1:size(x,1)
    for j = 1:size(x,2)
        index = atlasSliceIndex(i,j,:);
        if not(isnan(index))
            atlasSliceMask(i,j) = atlas(atlasSliceIndex(i,j,1),atlasSliceIndex(i,j,2),atlasSliceIndex(i,j,3));
        end
    end
end
% generate oblique slice mask     
projIndx = find(cellfun(@(x)contains(x,maskPath),st.structure_id_path));
projIdAll = st.id(projIndx);
projIndx = ismember(double(atlasSliceMask(:)),double(projIdAll));
projArea = zeros(size(atlasSliceMask));
projArea(projIndx) = 1;
projArea2 = logical(projArea);
end