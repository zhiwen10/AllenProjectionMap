function plotCenter3d(brainGridData,ax1,exceldata,color1,angle)
plotBrainGrid(brainGridData,ax1);
hold on;
for i = 1:size(exceldata,1)
    drawPoint3d(exceldata(i,:),'MarkerSize',3,'MarkerFaceColor',color1(i,:),'MarkerEdgeColor','none'); 
end
axis equal;
hold on; 
% drawPlane3d(plane,'FaceAlpha',0.2);
% hold on
% scatter3(plane(1),plane(2),plane(3),3,'k','filled');
view(angle(1),angle(2))
% hold on
% plot3(plane(1)+[0 100*xvector(1)],plane(2)+[0 100*xvector(2)],plane(3)+[0 100*xvector(3)], ...
%     '-b','MarkerFaceColor','b');
% [template, meta] = nrrdread('average_template_50.nrrd');
% [T,x,y,z] = obliqueslice(permute(template,[1,3,2]),round(plane(1:3)),[1,0,0]);
% [T,x,y,z] = obliqueslice(permute(template,[2,1,3]),round(plane(1:3)),xvector);
% [T,x,y,z] = obliqueslice(permute(template,[3,1,2]),round(plane(1:3)),[1,0,0]);
% hold on;
% surf(x,y,z,T,'EdgeColor','None','HandleVisibility','off','FaceAlpha',0.6);
% colormap(ax1,'gray')
end