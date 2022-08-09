para= input('Tespit edilecek paranýn fotoðraf adýný giriniz :','s'); 
para = imread(para);
para=rgb2gray(para);
subplot(221);imshow(para);
title('Tespit Edilecek Para');
 
toplu= input('Tespit edilecek fotoðrafýn adýný giriniz :','s'); 
toplu = imread(toplu);
toplu=rgb2gray(toplu);
subplot(222);imshow(toplu);
title('Toplu Para');

paraPoints = detectSURFFeatures(para);
topluPoints = detectSURFFeatures(toplu);

subplot(223);imshow(para);
title('Tespit Edilecek Para Eþlenecek Noktalar');
hold on;
plot(selectStrongest(paraPoints, 10000));

subplot(224);imshow(toplu);
title('Tespit Edilen Fotoðraf Eþlenecek Noktalar');
hold on;
plot(selectStrongest(topluPoints, 10000));

[paraFeatures, paraPoints] = extractFeatures(para, paraPoints);
[topluFeatures, topluPoints] = extractFeatures(toplu, topluPoints);

paraPairs = matchFeatures(paraFeatures, topluFeatures);

matchedParaPoints = paraPoints(paraPairs(:, 1), :);
matchedTopluPoints = topluPoints(paraPairs(:, 2), :);
figure(2),subplot(211);
showMatchedFeatures(para, toplu, matchedParaPoints, ...
    matchedTopluPoints, 'montage');
title('Bütün Eþleþen Noktalar');

[tform, inlierParaPoints, inlierTopluPoints] = ... = ...
    estimateGeometricTransform(matchedParaPoints, matchedTopluPoints, 'affine');


figure(2),subplot(212);
showMatchedFeatures(para, toplu, inlierParaPoints, ...
    inlierTopluPoints, 'montage');
title('Sadece Gereken Noktalar');

paraPolygon = [0.5, 0.5;...                           % top-left
        size(para, 1), 0.5;...                 % top-right
        size(para, 1), size(para, 1);... % bottom-right
        1, size(para, 1);...                 % bottom-left
        0.5, 0.5];                   % top-left again to close the polygon

newParaPolygon = transformPointsForward(tform, paraPolygon);

figure(3);imshow(toplu);
hold on;
line(newParaPolygon(:, 1), newParaPolygon(:, 2), 'Color', 'y');
title('Tespit edilen para');


