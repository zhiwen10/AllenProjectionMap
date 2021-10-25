%% sanity check test
point1 = [160,264,228];
% point1 = [1,10,sqrt(3)];
coronalAngle = atan2(point1(2),point1(3));
APAngle = atan2(point1(1),sqrt(point1(2)^2+point1(3)^2));
coronalAngle1 = rad2deg(coronalAngle);
APAngle1 = rad2deg(APAngle);
length = norm(point1);
[x,y,z] = sph2cart(coronalAngle,APAngle,length);
pointNew = [z,y,x];
figure; 
drawPoint3d(pointNew,'MarkerSize',6,'MarkerFaceColor','k','MarkerEdgeColor','none'); 