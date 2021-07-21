Irgb  = imread('D:\Hansel\kiara2a.tif');
Ihsv  = rgb2hsv(Irgb);
low = 0;      
high = 0.03572;
h = (Ihsv(:,:,1) >= low) & (Ihsv(:,:,1) <= high);
s = (Ihsv(:,:,2) >= 0.4) & (Ihsv(:,:,2) <= 0.4);
v = (Ihsv(:,:,3) >= 0.68) & (Ihsv(:,:,3) <= 0.689);
mask = uint8(h & s & v);
mask  = imclose(mask, strel('disk', 5));
mR = mask .* Irgb(:,:,1);
mG = mask .* Irgb(:,:,2);
mB = mask .* Irgb(:,:,3);
Icolor = cat(3, mR, mG, mB);
Igray = rgb2gray(Icolor);
Ibw = im2bw(Igray,graythresh(Igray));
Ilabel = bwlabel(Ibw);
stat = regionprops(Ilabel,'boundingbox','centroid');
imshow(Irgb); hold on;
for x = 1 : length(stat)
    bb = stat(x).BoundingBox;
    xc = stat(x).Centroid(1);
    yc = stat(x).Centroid(2);
    txt = sprintf('x : %.2f\ny : %.2f',xc,yc);
    rectangle('position',bb,'edgecolor','b','linewidth',2);    
    plot(xc,yc,'bo');
    text(xc,yc+30,txt,'color','y','fontweight','normal');
end