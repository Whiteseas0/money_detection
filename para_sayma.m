img= input('Resim dosyas�n�n ad�n� uzant�s�yla beraber giriniz :','s'); 

img=imread(img);                                            % Girilen dosyadaki foto�raf okunuyor.
imga = imresize(img, [480 NaN]);
subplot(231),imshow(imga,'InitialMagnification','fit');
title('Orjinal');

img=rgb2gray(imga);                                         % %Foto�raf� gri tona �evriliyor.
th=graythresh(img);
h=fspecial('unsharp');
img=imfilter(img,h,'replicate');
subplot(232),imshow(img,'InitialMagnification','fit');
title('Gri ve Keskinle�tirilmi�');

bw=im2bw(img,th);                                           %Foto�rafa negatiflik ekleniyor.
subplot(233),imshow(bw,'InitialMagnification','fit');
title('Negatif');

bw= imcomplement(bw);
bw2 = bwmorph(bw,'remove');                                 % Foto�raftaki paralar�n s�n�rlar� belirleniyor.
subplot(234),imshow(bw2,'InitialMagnification','fit');
title('S�n�rlar');

bw2 = bwareaopen(bw2,30);                                   %30px den daha az say�da olan nesneler kald�r�l�yor.
bw2=imfill(bw2,'holes');                                    % Foto�raftaki �ukur diye nitelendirilen yerleri dolduruyoruz..
subplot(235),imshow(bw2,'InitialMagnification','fit'); 
title('S�n�rlar�n ��i Dolu');

SE =strel('disk',7);                                        % Birlesik madeni paralarin ayrilmasi saglaniyor.
bw2 = imerode(bw2,SE);
subplot(236),imshow(bw2,'InitialMagnification','fit');
title('Ayr�lma');


[B,L] = bwboundaries(bw2);                                  % length(B) ile para adetini ogrendik ve etiket atadik
stats = regionprops(bw2, 'Area','Centroid');
figure(2),imshow(imga,'InitialMagnification','fit');

    toplam = 0;
    for n=1:length(B)
        a=stats(n).Area;                                    % Her paran�n alan�n� ��rendik. Boyutlara g�re hesaplama yapt�k. 
        centroid=stats(n).Centroid;
            if   a >1200 &&  a < 2000
                 toplam = toplam + 1;
                 text(centroid(1),centroid(2),'1TL');
            elseif a  > 800 &&  a < 1200
                toplam = toplam + 0.5;
                text(centroid(1),centroid(2),'50Kr�');
            elseif a > 550 &&  a < 800
                toplam = toplam + 0.25;
                text(centroid(1),centroid(2),'25Kr�');
            elseif a > 435 &&  a < 550
                toplam = toplam + 0.10;
                text(centroid(1),centroid(2),'10Kr�');
            elseif a > 200 &&  a < 435
                 toplam = toplam + 0.05;
                 text(centroid(1),centroid(2),'5Kr�');
        end
    end
    
     title(['Toplam para miktari = ',num2str(toplam),' TL'])