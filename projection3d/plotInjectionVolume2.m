function plotInjectionVolume2(dataAll,atlas1,nameList2,nameList,cortexMask,dataFolder,ax)
% plot horizontal outline
c0 = contourc(double(atlas1>0), [0.5 0.5]);
coordsReg0 = makeSmoothCoords(c0);
for cidx0 = 1:numel(coordsReg0)
    h = fill(ax, coordsReg0(cidx0).x,coordsReg0(cidx0).y, 'w', 'EdgeColor', 'k'); 
    h.LineWidth = 2.0;
    hold on;
end
axis equal;
% plot each brain injection vloumn
color1 = hsv(numel(nameList));
for i = 1:numel(nameList)
    clear data row col
    data = squeeze(dataAll(:,:,:,i));
    data(not(cortexMask)) = 0;
    data1 = squeeze(sum(data,1));
    IntensityMax = max(data1(:));
    [row, col] = find(data1> IntensityMax*0.65);
    hold on;
    scatter(ax,col,row,3,color1(i,:),'filled');
end
set(ax,'YDir','reverse')
colormap(color1)
originalSize1 = get(ax, 'Position');
cb = colorbar('YTickLabel', nameList,'YTick',0.06:1.04/numel(nameList):1.05) ;
cb.TickLabelInterpreter = 'none';
set(ax, 'Position', originalSize1);
axis image; 
axis off;
text(120, -50, 'Injection site','FontSize',12);
end