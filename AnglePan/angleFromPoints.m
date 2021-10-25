%% get angles from 2 points on the plane
probeV = [pointOrthog(3,1)-pointOrthog(7,1), pointOrthog(3,2)-pointOrthog(7,2),pointOrthog(3,3)-pointOrthog(7,3)];
% Azimuth on yz plane (rotate from coronal xz plane)
coronalAngle = atan2(probeV(2),probeV(3));
coronalAngle1 = rad2deg(coronalAngle); % angle from coronal plane
% Elevation from yz plan 
APAngle = atan2(probeV(1),sqrt(probeV(2)^2+probeV(3)^2));
APAngle1 = rad2deg(APAngle);
%% 4 shank spin angle
% angle between 2 planes is equivalent to angles of their normal vectors
% normal vector for plane before spin
preSpin = cross(probeV,[0 0 1]);
% angle between preSpin and postSpin plane
angleSpin = atan2(norm(cross(preSpin,xvector)),dot(preSpin,xvector));
angleSpin1 = rad2deg(angleSpin);
%% Transform spherical coordinates (angles) to Cartesian vector and point
length = norm(probeV);
[x,y,z] = sph2cart(coronalAngle,APAngle,length);
pointNew = [pointOrthog(7,1)+z,pointOrthog(7,2)+y,pointOrthog(7,3)+x];
figure; 
aax = subplot(1,1,1);
angle1 = [-70,-90];
angle2 = [-90,10];
plotCenter3d(brainGridData,aax,pointOrthog,color1,angle1);
surf(x1,y1,z1,T,'EdgeColor','None','HandleVisibility','off','FaceAlpha',0.6);
colormap(aax,'gray')
hold on;
% for i = 1:7
% drawPoint3d(pointOrthog(i,:),'MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','none'); 
% text(10,10,10,['point' num2str(i)]);
% pause(0.5);
% end
drawPoint3d(pointNew,'MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','none');
axis on;
%% draw points on other shanks
probeRef = [pointOrthog(7,:);pointOrthog(3,:)];
probeV2 = repmat(probeRef,3,1); 
probeV2(1:2,3) = probeV2(1:2,3)+5; probeV2(3:4,3) = probeV2(3:4,3)+10;
probeV2(5:6,3) = probeV2(5:6,3)+15;
%% spin shanks along reference probe by spin angle
axang = [probeV(1) probeV(2) probeV(3) angleSpin];
rotm = axang2rotm(pi/2-axang);
zerocentered_probe = probeV2-repmat(probeRef,3,1); 
rotated_probe=rotm*zerocentered_probe';
rotated_probe = rotated_probe(1:3,:)'+ repmat(probeRef,3,1); 
%% check points after spinning are close to the oblique plane
for i = 1:6
    d(i) = distancePointPlane(rotated_probe(i,:), plane1);
end
%%
figure; 
aax = subplot(1,1,1);
angle1 = [-70,-90];
angle2 = [-90,10];
plotCenter3d(brainGridData,aax,pointOrthog,color1,angle1);
surf(x1,y1,z1,T,'EdgeColor','None','HandleVisibility','off','FaceAlpha',0.6);
colormap(aax,'gray')
% hold on;
% drawPoint3d(pointNew,'MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','none');
for i = 1:6
hold on;
% drawPoint3d(probeV2(i,:),'MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','none');
drawPoint3d(rotated_probe(i,:),'MarkerSize',3,'MarkerFaceColor','k','MarkerEdgeColor','none');
end
%% sanity check test
% % point1 = [160,264,228];
% point1 = [1,10,sqrt(3)];
% coronalAngle = atan2(point1(2),point1(3));
% APAngle = atan2(point1(1),sqrt(point1(2)^2+point1(3)^2));
% coronalAngle1 = rad2deg(coronalAngle);
% APAngle1 = rad2deg(APAngle);
% length = norm(point1);
% [x,y,z] = sph2cart(coronalAngle,APAngle,length);
% pointNew = [z,y,x];
% figure; 
% drawPoint3d(pointNew,'MarkerSize',6,'MarkerFaceColor','k','MarkerEdgeColor','none'); 
%% find oblique plane from 4 shanks
shankRowVector = rotated_probe(3,:)-rotated_probe(1,:);
shankPlane = [pointOrthog(7,:),probeV,shankRowVector];
orthogVector = cross(shankPlane(4:6),shankPlane(7:9));
[T,x1,y1,z1] = obliqueslice(permute(template,[2,1,3]),shankPlane(1:3),orthogVector);
figure;
ax9 = subplot(1,1,1)
hb1 = imshow(T,[]);
for j = 1:numel(nameList)
    data1 = squeeze(dataAll(:,:,:,j));
    [TheColorImage,x1,y1,z1] = obliqueslice(permute(data1,[2,1,3]),shankPlane(1:3),orthogVector);
    imageSize = size(TheColorImage);
    colorIntensity = TheColorImage/max(TheColorImage(:));
    thisColor = color1(j,:);
    thisColorImage = cat(3, thisColor(1)*ones(imageSize),...
        thisColor(2)*ones(imageSize), thisColor(3)*ones(imageSize)); 
    hold on
    hb2(j) = imshow(thisColorImage);
    hold off
    set(hb2(j),'AlphaData',colorIntensity);
end
%%
axisLim = size(template,1);
[refLine,indexSurface3d] = probeInterp3d(probeRef,axisLim,template);
[refLine2d] = oblique3dto2d(refLine,x1,y1,z1,T);
for i = 1:3
[shankLine{i},shankSurface3d{i}] = probeInterp3d(rotated_probe((2*i-1):(2*i),:),axisLim,template);
[shankLine2d{i}] = oblique3dto2d(shankLine{i},x1,y1,z1,T);
end
%%
figure; 
aax = subplot(1,3,1);
angle1 = [-70,-90];
angle2 = [-90,10];
plotCenter3d(brainGridData,aax,pointOrthog,color1,angle1);
surf(x1,y1,z1,T,'EdgeColor','None','HandleVisibility','off','FaceAlpha',0.6);
colormap(aax,'gray')
drawPoint3d(refLine,'MarkerSize',1,'MarkerFaceColor','k','MarkerEdgeColor','none');
for i = 1:3
    drawPoint3d(shankLine{i},'MarkerSize',1,'MarkerFaceColor','k','MarkerEdgeColor','none');
    % drawPoint3d(indexSurface3d,'MarkerSize',6,'MarkerFaceColor','r','MarkerEdgeColor','none');
end
text(200,400,{['From coronal plane: ' num2str(round(coronalAngle1*10)/10) ' degree'],...
    ['From midline: ' num2str(round(APAngle1*10)/10) ' degree'], ...
    ['Spin: ' num2str(round(angleSpin1*10)/10) ' degree']});
aax1 = subplot(1,3,2);
angle1 = [-70,-90];
angle2 = [-90,10];
plotCenter3d(brainGridData,aax1,pointOrthog,color1,angle2);
surf(x1,y1,z1,T,'EdgeColor','None','HandleVisibility','off','FaceAlpha',0.6);
colormap(aax1,'gray')
drawPoint3d(refLine,'MarkerSize',1,'MarkerFaceColor','k','MarkerEdgeColor','none');
for i = 1:3
    drawPoint3d(shankLine{i},'MarkerSize',1,'MarkerFaceColor','k','MarkerEdgeColor','none');
    % drawPoint3d(indexSurface3d,'MarkerSize',6,'MarkerFaceColor','r','MarkerEdgeColor','none');
end
ax9 = subplot(1,3,3);
hb1 = imshow(T,[]);
for j = 1:numel(nameList)
    data1 = squeeze(dataAll(:,:,:,j));
    [TheColorImage,x1,y1,z1] = obliqueslice(permute(data1,[2,1,3]),shankPlane(1:3),orthogVector);
    imageSize = size(TheColorImage);
    colorIntensity = TheColorImage/max(TheColorImage(:));
    thisColor = color1(j,:);
    thisColorImage = cat(3, thisColor(1)*ones(imageSize),...
        thisColor(2)*ones(imageSize), thisColor(3)*ones(imageSize)); 
    hold on
    hb2(j) = imshow(thisColorImage);
    hold off
    set(hb2(j),'AlphaData',colorIntensity);
end
hold on;
scatter(refLine2d(:,2),refLine2d(:,1),3,'r','filled');
hold on; 
for i = 1:3
    shankLine2dTemp = shankLine2d{i};
    scatter(shankLine2dTemp(:,2),shankLine2dTemp(:,1),3,'r','filled');
    hold on;
end