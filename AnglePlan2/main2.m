autoCenterPlot;
%% get transformation angles from 2 points on plane
point1 = pointOrthog(3,:); 
% point2 = pointOrthog(1,:);
% point2 = mean(pointOrthog([1,7],:),1);
% point2 = pointOrthog(1,:)+1/3*(pointOrthog(7,:)-pointOrthog(1,:));
% centerPoint = mean(pointOrthog,1);

% [DV,AP,ML]
bregma = [0,540/5,570/5];
%%
figure; 
ax1 = subplot(2,4,[1,5]);
plotInjectionVolume2(dataAll,atlas1,nameList1,nameList,cortexMask,dataFolder,ax1);

% rAngle(1) = 0;
% rAngle(2) = -pi/12;
% rAngle(3) = -pi/6;
coronalAngleR(1) = 0; APAngleR(1) = pi/2; spinAngleR(1) = pi/2;
coronalAngleR(2) = 0; APAngleR(2) = pi/3; spinAngleR(2) = pi/2;
coronalAngleR(3) = 0; APAngleR(3) = pi/4; spinAngleR(3) = pi/2;
for k = 1:3
    % rotate an angle from reference shank in the same plane.
%     xvector = xvector./norm(xvector);
%     axang = [xvector(1) xvector(2) xvector(3) rAngle(k)];
%     rotm = axang2rotm(axang);
%     zerocentered_point = point1-point2;
%     rotated_point=(rotm*zerocentered_point')';
%     rpoint1 = rotated_point+ point2; 
%     [coronalAngleR,APAngleR,spinAngleR] = getAngle(rpoint1, point2,xvector);
    %%
    [shankPlane,shankLine,shankSurface3d,shankLine2d] = rotateAndSliceProbePlane(coronalAngleR(k),APAngleR(k),spinAngleR(k),point1,template);
    orthogVector = cross(shankPlane(4:6),shankPlane(7:9));
    [T,x1,y1,z1] = obliqueslice(permute(template,[2,1,3]),shankPlane(1:3),orthogVector);
    coronalAngleDeg = rad2deg(coronalAngleR(k)); % angle from coronal plane
    APAngleDeg = rad2deg(APAngleR(k));
    spinDeg = rad2deg(spinAngleR(k));
    shank1Surface3d = shankSurface3d{1};
    APDist = (shank1Surface3d(2)-bregma(2))*50;
    MLDist = (shank1Surface3d(3)-bregma(3))*50;
    %%
    aax = subplot(3,4,4*(k-1)+2);
    angle1 = [-70,-90];
    angle2 = [-90,10];
    plotCenter3d(brainGridData,aax,pointOrthog,color1,angle1);
    surf(x1,y1,z1,T,'EdgeColor','None','HandleVisibility','off','FaceAlpha',0.6);
    colormap(aax,'gray')
    for i = 1:4
        if i == 1
                drawPoint3d(shankLine{1},'MarkerSize',1,'MarkerFaceColor','g','MarkerEdgeColor','none');
        else
            drawPoint3d(shankLine{i},'MarkerSize',1,'MarkerFaceColor','k','MarkerEdgeColor','none');
        % drawPoint3d(indexSurface3d,'MarkerSize',6,'MarkerFaceColor','r','MarkerEdgeColor','none');
        end
    end
    drawPoint3d(shank1Surface3d,'MarkerSize',3,'MarkerFaceColor','r','MarkerEdgeColor','none');
    aax1 = subplot(3,4,4*(k-1)+3);
    angle1 = [-70,-90];
    angle2 = [-90,10];
    plotCenter3d(brainGridData,aax1,pointOrthog,color1,angle2);
    surf(x1,y1,z1,T,'EdgeColor','None','HandleVisibility','off','FaceAlpha',0.6);
    colormap(aax1,'gray')

    for i = 1:4
        if i == 1
            drawPoint3d(shankLine{1},'MarkerSize',1,'MarkerFaceColor','g','MarkerEdgeColor','none');
        else
            drawPoint3d(shankLine{i},'MarkerSize',1,'MarkerFaceColor','k','MarkerEdgeColor','none');
        % drawPoint3d(indexSurface3d,'MarkerSize',6,'MarkerFaceColor','r','MarkerEdgeColor','none');
        end
    end
    drawPoint3d(shank1Surface3d,'MarkerSize',3,'MarkerFaceColor','r','MarkerEdgeColor','none');
    ax9 = subplot(3,4,4*(k-1)+4);
    hb1 = imshow(T',[]);
    for j = 1:numel(nameList)
        data1 = squeeze(dataAll(:,:,:,j));
        [TheColorImage,x1,y1,z1] = obliqueslice(permute(data1,[2,1,3]),shankPlane(1:3),orthogVector);
        TheColorImage = TheColorImage';
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
    for i = 1:4
        shankLine2dTemp = shankLine2d{i};
        if i == 1
            scatter(shankLine2dTemp(:,1),shankLine2dTemp(:,2),3,'g','filled');
        else
        scatter(shankLine2dTemp(:,1),shankLine2dTemp(:,2),3,'k','filled');
        end
        hold on;
    end
    text(10,50,{['From coronal plane: ' num2str(round(coronalAngleDeg*10)/10) ' degree'],...
        ['From midline: ' num2str(90-round(APAngleDeg*10)/10) ' degree'], ...
        ['Spin: ' num2str(round(spinDeg*10)/10) ' degree'],...
        ['AP: ' num2str(APDist) 'um'],...
        ['ML: ' num2str(MLDist) 'um']},'fontSize',8,'color','w');
end