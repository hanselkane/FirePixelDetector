Irgb  = imread('D:\Hansel\kiara1a.tif');
Ihsv  = rgb2hsv(Irgb);
low = 0.001;      
high = 0.158;
%------------Sesuaikan titik di GPS dan gambar secara manual---------------
point1lat = -6.92279
point1long = 107.6489
x1 = 400
y1 = 200
point2lat = -6.92288
point2long = 107.6492
x2 = 1000
y2 = 400
%------------Sesuaikan titik di GPS dan gambar secara manual---------------

%------------hitung perbedaan skala gambar vs gps--------------
dx = abs((point2long-point1long)/(x1-x2))
dy = abs((point2lat-point1lat)/(y1-y2))
%------------hitung perbedaan skala gambar vs gps--------------

%------------tutupi semua bagian gambar kecuali daerah2 dengan warna
%tertentu (bergantung hsv(hue, saturation, value), 
%saringan 1, warna yg dicari sangat spesifik, 
%rentang hsv sangat ketat-------------
h = (Ihsv(:,:,1) >= 0.001) & (Ihsv(:,:,1) <= 0.158);
s = (Ihsv(:,:,2) >= 0.41) & (Ihsv(:,:,2) <= 0.415);
v = (Ihsv(:,:,3) >= 0.91) & (Ihsv(:,:,3) <= 1);
mask = uint8(h & s & v);
mask  = imclose(mask, strel('rectangle',[1 1]));
mR = mask .* Irgb(:,:,1);
mG = mask .* Irgb(:,:,2);
mB = mask .* Irgb(:,:,3);
%------------tutupi semua bagian gambar kecuali daerah2 dengan warna
%tertentu (bergantung hsv(hue, saturation, value), 
%saringan 1, warna yg dicari sangat spesifik, 
%rentang hsv sangat ketat-------------

%------------daerah yg lolos saringan diatas, 
%pixelnya diubah jadi binari, bernilai satu----------
Icolor = cat(3, mR, mG, mB);
Igray = rgb2gray(Icolor);
Ibw = im2bw(Igray,graythresh(Igray));
Ilabel = bwlabel(Ibw);
%------------daerah yg lolos saringan diatas, 
%pixelnya diubah jadi binari, bernilai satu----------

%------------beri tampilan keterangan------------------
stat = regionprops(Ilabel,'boundingbox','centroid');
subplot(1,2,1);
imshow(Irgb); hold on;
for x = 1 : length(stat)
    bb = stat(x).BoundingBox;
    xc = round(stat(x).Centroid(1));
    yc = round(stat(x).Centroid(2));
    hue = Ihsv(yc,xc,1);
    saturation = Ihsv(yc,xc,2);
    value = Ihsv(yc,xc,3);
    txt = sprintf('hue : %.4f\nsaturation : %.4f\nvalue : %.4f',hue,saturation,value);
    rectangle('position',bb,'edgecolor','b','linewidth',2);    
    plot(xc,yc,'bo');
    text(xc,yc+30,txt,'color','y','fontweight','normal');
end
%------------beri tampilan keterangan------------------

%------saringan ke 2 proses serupa, 
%rentang hsv lebih longgar untuk mencari luas dari 
%titik api,tetapi areanya yg sempit, 
%hanya di 'scan' di sekitar titik api-----
holeregion1 = (Ihsv(:,:,1)<0)
holeregion1((yc-60):(yc+60), (xc-60):(xc+60), 1) = 1
h = (Ihsv(:,:,1) >= 0) & (Ihsv(:,:,1) <= 0.2);
s = (Ihsv(:,:,2) >= 0.36) & (Ihsv(:,:,2) <= 0.415);
v = (Ihsv(:,:,3) >= 0.65) & (Ihsv(:,:,3) <= 1);
mask = uint8(h & s & v & holeregion1);
mask  = imclose(mask, strel('disk',12));
mR = mask .* Irgb(:,:,1);
mG = mask .* Irgb(:,:,2);
mB = mask .* Irgb(:,:,3);
Icolor = cat(3, mR, mG, mB);
Igray = rgb2gray(Icolor);
Ibw = im2bw(Igray,graythresh(Igray));
Ilabel = bwlabel(Ibw);
stat = regionprops(Ilabel);
subplot(1,2,2);
imshow(Irgb); hold on;
%------saringan ke 2 proses serupa, 
%rentang hsv lebih longgar untuk mencari luas dari 
%titik api,tetapi areanya yg sempit, 
%hanya di 'scan' di sekitar titik api-----

%----------beri tampilan user---------------
for x = 1 : length(stat)
    bb = stat(x).BoundingBox;
    xc = stat(x).Centroid(1);
    yc = stat(x).Centroid(2);
    areas = (stat(x).Area)/100;
    pointlat = point1lat+((y1-yc)*dy)
    pointlong = point1long+((xc-x1)*dx)
    txt = sprintf('longitude : %.6f\nlatitude : %.6f\narea : %.3f m^2',pointlong,pointlat,areas);
    rectangle('position',bb,'edgecolor','b','linewidth',2);    
    plot(xc,yc,'bo');
    text(xc,yc+30,txt,'color','y','fontweight','normal');
end
%----------beri tampilan user---------------
