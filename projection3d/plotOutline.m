function plotOutline(areaPath,st,section,hemisphere)
% cortex path
% areaPath = '/997/8/567/623/477/';
indx = find(cellfun(@(x)contains(x,areaPath),st.structure_id_path));
idAll = st.id(indx);
indx2 = ismember(double(section(:)),double(idAll));
area = zeros(size(section));
area(indx2) = 1;
if hemisphere == -1
    area(:,size(section,2)/2+1:size(section,2)) = 0;
elseif hemisphere == 1
    area(:,1:size(section,2)/2) = 0;
end
area1 = logical(area);
c1 = contourc(double(area1>0), [0.5 0.5]);
coordsReg1 = makeSmoothCoords(c1);
for cidx1 = 1:numel(coordsReg1)
    % h = fill(gca, coordsReg1(cidx1).x,coordsReg1(cidx1).y, 'w', 'EdgeColor', 'k'); 
    h = plot(gca, coordsReg1(cidx1).x,coordsReg1(cidx1).y, 'w'); 
    h.LineWidth = 2.0;
    hold on;
end
end