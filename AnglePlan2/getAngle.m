function [coronalAngle,APAngle,angleSpin] = getAngle(point1, point2, xvector)
%% get angles from 2 points on the plane
% probeV = [pointOrthog(3,1)-pointOrthog(7,1), pointOrthog(3,2)-pointOrthog(7,2),pointOrthog(3,3)-pointOrthog(7,3)];
probeV = [point1(1)-point2(1), point1(2)-point2(2),point1(3)-point2(3)];
% Azimuth on yz plane (rotate from coronal xz plane)
coronalAngle = atan2(probeV(2),probeV(3));
% Elevation from yz plan 
APAngle = atan2(probeV(1),sqrt(probeV(2)^2+probeV(3)^2));
%% 4 shank spin angle
% angle between 2 planes is equivalent to angles of their normal vectors
% normal vector for plane before spin
preSpin = cross(probeV,[0 0 1]);
% angle between preSpin and postSpin plane
angleSpin = atan2(norm(cross(preSpin,xvector)),dot(preSpin,xvector));
end