function plotObliqueOutline(ax7,T2)    
% plot horizontal outline
c0 = contourc(double(T2>0), [0.5 0.5]);
coordsReg0 = makeSmoothCoords(c0);
for cidx0 = 1:numel(coordsReg0)
    h = plot(ax7, coordsReg0(cidx0).x,coordsReg0(cidx0).y, 'w'); 
    h.LineWidth = 1.0;
    hold on;
end
end