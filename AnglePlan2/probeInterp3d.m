function [refLine,indexSurface3d] = probeInterp3d(probePoints,axisLim,template)
[m,p,s] = best_fit_line(probePoints(:,1),probePoints(:,2),probePoints(:,3));
t = -axisLim:axisLim;
x = round(m(1)+p(1)*t); y = round(m(2)+p(2)*t); z = round(m(3)+p(3)*t);
refLine = [x;y;z]';
refLine = refLine(refLine(:,1)>0 & refLine(:,1)<axisLim,:);
refLine = refLine(refLine(:,2)>0 & refLine(:,2)<size(template,2),:);
refLine = refLine(refLine(:,3)>0 & refLine(:,3)<size(template,3),:);
for i = 1:size(refLine,1)
    lineBrain(i,1) = template(refLine(i,1),refLine(i,2),refLine(i,3));
end
lineBrain = double(lineBrain);
index1 = find(lineBrain>1,3,'first'); index2 = find(lineBrain>1,3, 'last');
indexSurface1 = refLine(index1(3),:);
indexSurface2 = refLine(index2(1),:);

if indexSurface1(1)>indexSurface2(1)
    indexSurface3d = indexSurface2;
else 
    indexSurface3d = indexSurface1;
end
end
