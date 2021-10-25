autoCenterPlot;
%% get transformation angles from 2 points on plane
% [DV,AP,ML]
bregma = [0,540/5,570/5];
%%
point = [18,156,178];
% AP angle shift
point1 = repmat(point,5,1);
coronalAngleR = repmat(-1.8481,5,1);
APAngleR(1) = 0.8903;
APAngleR(2) = 0.8903+pi/12;
APAngleR(3) = 0.8903+pi/6;
APAngleR(4) = 0.8903-pi/12;
APAngleR(5) = 0.8903-pi/6;

% coronal angle shift
% point1 = repmat(point,5,1);
% APAngleR = repmat(0.8903,5,1);
% coronalAngleR(1) = -1.8481;
% coronalAngleR(2) = -1.8481+pi/12;
% coronalAngleR(3) = -1.8481+pi/6;
% coronalAngleR(4) = -1.8481-pi/12;
% coronalAngleR(5) = -1.8481-pi/6;
% 
% trasnlation
% point1(1,:) = shank1Surface3d; % set point as entry point of ref shank
% point1(2,:) = shank1Surface3d; point1(2,3) = shank1Surface3d(3)-10;
% point1(3,:) = shank1Surface3d; point1(3,3) = shank1Surface3d(3)-20;
% point1(4,:) = shank1Surface3d; point1(4,3) = shank1Surface3d(3)+10;
% point1(5,:) = shank1Surface3d; point1(5,3) = shank1Surface3d(3)+20;
%%
figure; 
ax1 = subplot(6,6,[1,7]);
plotInjectionVolume2(dataAll,atlas1,nameList1,nameList,cortexMask,dataFolder,ax1);
% coronalAngleR(1) = 0; APAngleR(1) = pi/2; spinAngleR(1) = pi/2;
for k = 1:5
    % rotate an angle from reference shank in the same plane.
%     xvector = xvector./norm(xvector);
%     axang = [xvector(1) xvector(2) xvector(3) rAngle(k)];
%     rotm = axang2rotm(axang);
%     zerocentered_point = point1-point2;
%     rotated_point=(rotm*zerocentered_point')';
%     rpoint1 = rotated_point+ point2; 
%     [coronalAngleR,APAngleR,spinAngleR] = getAngle(rpoint1, point2,xvector);
    %%
    [shankPlane,shankLine,shankSurface3d,shankLine2d] = rotateAndSliceProbePlane(coronalAngleR(k),APAngleR(k),spinAngleR,point1(k,:),template);
    orthogVector = cross(shankPlane(4:6),shankPlane(7:9));
    [T,x1,y1,z1] = obliqueslice(permute(template,[2,1,3]),shankPlane(1:3),orthogVector);
    coronalAngleDeg = rad2deg(coronalAngleR(k)); % angle from coronal plane
    APAngleDeg = rad2deg(APAngleR(k));
    spinDeg = rad2deg(spinAngleR);
    shank1Surface3d = shankSurface3d{1};
    APDist = (shank1Surface3d(2)-bregma(2))*50;
    MLDist = (shank1Surface3d(3)-bregma(3))*50;
    %%
    aax = subplot(6,6,6*(k-1)+2);
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
    aax1 = subplot(6,6,6*(k-1)+3);
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
    ax9 = subplot(6,6,6*(k-1)+4);
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
    
    ax10 = subplot(6,6,6*(k-1)+5);
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
            scatter(shankLine2dTemp(:,1),shankLine2dTemp(:,2),1,'g','filled');
        else
        scatter(shankLine2dTemp(:,1),shankLine2dTemp(:,2),1,'k','filled');
        end
        hold on;
    end
    text(20,50,{['From coronal plane: ' num2str(round(coronalAngleDeg*10)/10) ' degree'],...
        ['From midline: ' num2str(90-round(APAngleDeg*10)/10) ' degree'], ...
        ['Spin: ' num2str(round(spinDeg*10)/10) ' degree'],...
        ['AP: ' num2str(APDist) 'um'],...
        ['ML: ' num2str(MLDist) 'um']},'fontSize',6,'color','w');
    
%     ax11 = subplot(6,6,6*(k-1)+6);
%     [atlasPlane,x2,y2,z2] = obliqueslice(permute(atlas,[2,1,3]),shankPlane(1:3),orthogVector);
%     structure = readtable('E:\smoothed25MicronAtlas\structure_tree_safe_2017.csv');
%     atlasPlane2 = double(atlasPlane(:));
%     atlasPlane(atlasPlane(:)==0) = 1;
%     name1 = strings(numel(atlasPlane2),3);
%     for ii = 1:numel(atlasPlane2)
%         indx = find(structure.id == atlasPlane2(ii));
%         if ~isempty(indx)
%             name1(ii,1) = string(structure.name(indx));
%             name1(ii,2) = string(structure.acronym(indx));
%             name1(ii,3) = string(structure.color_hex_triplet(indx));
%         end
%     end            
%     [C, ia, ic] = unique(name1(:,1));
end
 