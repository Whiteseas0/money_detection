img= input('Resim dosyasýnýn adýný uzantýsýyla beraber giriniz :','s'); 

img=imread(img);                                            % Girilen dosyadaki fotoðraf okunuyor.
imga = imresize(img, [480 NaN]);
subplot(231),imshow(imga,'InitialMagnification','fit');
title('Orjinal');

img=rgb2gray(imga);                                         % %Fotoðrafý gri tona çevriliyor.
th=graythresh(img);
h=fspecial('unsharp');
img=imfilter(img,h,'replicate');
subplot(232),imshow(img,'InitialMagnification','fit');
title('Gri ve Keskinleþtirilmiþ');

bw=im2bw(img,th);                                           %Fotoðrafa negatiflik ekleniyor.
subplot(233),imshow(bw,'InitialMagnification','fit');
title('Negatif');

bw= imcomplement(bw);
bw2 = bwmorph(bw,'remove');                                 % Fotoðraftaki paralarýn sýnýrlarý belirleniyor.
subplot(234),imshow(bw2,'InitialMagnification','fit');
title('Sýnýrlar');

bw2 = bwareaopen(bw2,30);                                   %30px den daha az sayýda olan nesneler kaldýrýlýyor.
bw2=imfill(bw2,'holes');                                    % Fotoðraftaki çukur diye nitelendirilen yerleri dolduruyoruz..
subplot(235),imshow(bw2,'InitialMagnification','fit'); 
title('Sýnýrlarýn Ýçi Dolu');

SE =strel('disk',7);                                        % Birlesik madeni paralarin ayrilmasi saglaniyor.
bw2 = imerode(bw2,SE);
subplot(236),imshow(bw2,'InitialMagnification','fit');
title('Ayrýlma');


[B,L] = bwboundaries(bw2);                                  % length(B) ile para adetini ogrendik ve etiket atadik
stats = regionprops(bw2, 'Area','Centroid');
figure(2),imshow(imga,'InitialMagnification','fit');

    toplam = 0;
    for n=1:length(B)
        a=stats(n).Area;                                    % Her paranýn alanýný öðrendik. Boyutlara göre hesaplama yaptýk. 
        centroid=stats(n).Centroid;
            if   a >1200 &&  a < 2000
                 toplam = toplam + 1;
                 text(centroid(1),centroid(2),'1TL');
            elseif a  > 800 &&  a < 1200
                toplam = toplam + 0.5;
                text(centroid(1),centroid(2),'50Krþ');
            elseif a > 550 &&  a < 800
                toplam = toplam + 0.25;
                text(centroid(1),centroid(2),'25Krþ');
            elseif a > 435 &&  a < 550
                toplam = toplam + 0.10;
                text(centroid(1),centroid(2),'10Krþ');
            elseif a > 200 &&  a < 435
                 toplam = toplam + 0.05;
                 text(centroid(1),centroid(2),'5Krþ');
        end
    end
    
     title(['Toplam para miktari = ',num2str(toplam),' TL'])