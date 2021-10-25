function mask3d = create3dMask(maskPath,st,atlas)
% maskPath = '/997/8/567/688/';
indx = find(cellfun(@(x)contains(x,maskPath),st.structure_id_path));
idAll = st.id(indx);
indx2 = ismember(double(atlas(:)),double(idAll));
area = zeros(size(atlas)); area(indx2) = 1; mask3d = logical(area);
end