function [shankPlane,shankLine,shankSurface3d,shankLine2d] = rotateAndSliceProbePlane(coronalAngle,APAngle,spinAngle,centerPoint,template)
%% Transform spherical coordinates (angles) to Cartesian vector and point
% coronalAngle = 0; APAngle = pi/2; spinAngle = 0;
% length = norm(probeV);
length = 14; % 14*50 = 700um;
[x,y,z] = sph2cart(coronalAngle,APAngle,length);
pointNew = [centerPoint(1)+z,centerPoint(2)+y,centerPoint(3)+x];
%% draw points on other shanks
shankRef = [centerPoint;pointNew];
probeV = pointNew-centerPoint;
shank2 = shankRef; shank2(:,3) = shank2(:,3)+5;
shank3 = shankRef; shank3(:,3) = shank3(:,3)+10;
shank4 = shankRef; shank4(:,3) = shank4(:,3)+15;
shankAll = [shankRef; shank2; shank3; shank4];
%% spin shanks along reference probe by spin angle
probeV = probeV./norm(probeV);
axang = [probeV(1) probeV(2) probeV(3) -spinAngle];
rotm = axang2rotm(axang);
zerocentered_probe = shankAll-repmat(shankRef,4,1); 
rotated_probe=(rotm*zerocentered_probe')';
rotated_probe = rotated_probe+ repmat(shankRef,4,1); 
% q = quaternion(cos(spinAngle/2), probeV(1)*sin(spinAngle/2), probeV(2)*sin(spinAngle/2), probeV(3)*sin(spinAngle/2));
% rotated_probe = rotatepoint(q, zerocentered_probe);
%% check points after spinning are close to the oblique plane
% for i = 1:size(rotated_probe,1)
%     d(i) = distancePointPlane(rotated_probe(i,:), plane1);
% end
%% find oblique plane from 2d space of the rotated 4 shanks 
shankRowVector = rotated_probe(3,:)-rotated_probe(1,:);
shankPlane = [centerPoint,probeV,shankRowVector];
orthogVector = cross(shankPlane(4:6),shankPlane(7:9));
[T,x1,y1,z1] = obliqueslice(permute(template,[2,1,3]),shankPlane(1:3),orthogVector);
%% get all points along shanks in 3d and 2d
axisLim = size(template,1);
for i = 1:4
    [shankLine{i},shankSurface3d{i}] = probeInterp3d(rotated_probe((2*i-1):(2*i),:),axisLim,template);
    [shankLine2d{i}] = oblique3dto2d(shankLine{i},x1,y1,z1,T);
end
