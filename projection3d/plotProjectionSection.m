function plotProjectionSection(areaMask,sectionNum,atlas,st,nameList1,color1)
% areaMask = '/997/8/343/313/';  %midbrain
% areaMask = '/997/8/567/623/477/';  %striatum
section = squeeze(atlas(:,sectionNum,:));
projIndx = find(cellfun(@(x)contains(x,areaMask),st.structure_id_path));
projIdAll = st.id(projIndx);
projIndx = ismember(double(section(:)),double(projIdAll));
projArea = zeros(size(section));
projArea(projIndx) = 1;
projArea2 = logical(projArea);
for i = 1:9
    S = dir([char(nameList1(i)) '*.nrrd']);
    [data, meta] = nrrdread(S.name);
    data1 = squeeze(data(:,sectionNum,:));
    IntensityMax = max(data1(:));
    [row, col] = find(data1> IntensityMax*0.1 & projArea2);    
    if i == 9
        [row, col] = find(data1> IntensityMax*0.3 & projArea2); 
    elseif i ==2
        [row, col] = find(data1> IntensityMax*0.05 & projArea2); 
    end
    scatter(col,row,6,color1(i,:),'filled');
    hold on;  
end
end