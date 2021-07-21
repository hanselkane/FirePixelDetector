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
h = (Ihsv(:,:,1) >= 0.31) & (Ihsv(:,:,1) <= 0.36);
s = (Ihsv(:,:,2) >= 0.4) & (Ihsv(:,:,2) <= 1);
v = (Ihsv(:,:,3) >= 0.0) & (Ihsv(:,:,3) <= 1);
mask = uint8(h & s & v);
mask  = imclose(mask, strel('disk',20));
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
imshow(Irgb); hold on;
%----------beri tampilan user---------------
for x = 1 : length(stat)
    bb = stat(x).BoundingBox;
    xc = round(stat(x).Centroid(1));
    yc = round(stat(x).Centroid(2));
    hue = Ihsv(yc,xc,1);
    saturation = Ihsv(yc,xc,2);
    value = Ihsv(yc,xc,3);
    aga = (stat(x).Area)/100;
    txt = sprintf('area : %.4f\nsaturation : %.4f\nvalue : %.4f',aga,saturation,value);
    rectangle('position',bb,'edgecolor','b','linewidth',2);    
    plot(xc,yc,'bo');
    text(xc,yc+30,txt,'color','y','fontweight','normal');
end
%------------beri tampilan keterangan------------------

