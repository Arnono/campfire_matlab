
% GEW-RCM03 Data Analysis and Statistics 
% Arnold Wasike
% Effect of the "Camp fire" California - November 2018
% 
% 
% In 2018, The state of Californiaexperienced some of the worst wild fire disasters in its recrded history. 
% Here we look at the "Camp fire" 
% Here we look at the "Camp fire again" 

%% 1.Show area of interest on world map

clear, close, clc

map = webmap('Open Street Map');

aoi = shaperead('shp/fire_extent/area_of_interest.shp','UseGeoCoords',true);
aoi = geoshape(aoi);
wmpolygon(aoi,'FaceColor',[0.2 0 0],'FaceAlpha',.3, 'EdgeColor', 'red','linewidth',.9, ...
      'OverlayName','Area of interest')
  
CaLon = -121.6040445;
CaLat = 39.7569806;
name = 'Paradise Ca';
description = 'Area of Study, The Camp fire';
iconFilename =('location.png');
wmmarker(CaLat, CaLon, 'Description', description, ...
                   'FeatureName', name,... 
                   'Icon', iconFilename,... 
                   'OverlayName', name);
wmzoom(10);    
clear
%% 3.Show fire extent over rgb exaggerated image on november 8th

[B22018,R2018] = geotiffread('2018_fire_corrected/RT_LC08_L1TP_044032_20181108_20181116_01_T1_B2.TIF');
B32018 = geotiffread('2018_fire_corrected/RT_LC08_L1TP_044032_20181108_20181116_01_T1_B3.TIF');
B42018 = geotiffread('2018_fire_corrected/RT_LC08_L1TP_044032_20181108_20181116_01_T1_B4.TIF');
B102018 = geotiffread('2018_fire_corrected/RT_LC08_L1TP_044032_20181108_20181116_01_T1_B10.TIF');

B22018fill = B22018;
B32018fill = B32018;
B42018fill = B42018;

B22018fill(isnan(B22018fill))=0;
B32018fill(isnan(B32018fill))=0;
B42018fill(isnan(B42018fill))=0;

B22018s = adapthisteq(B22018fill,'ClipLimit',0.1,'Distribution','Rayleigh');
B32018s = adapthisteq(B32018fill,'ClipLimit',0.1,'Distribution','Rayleigh');
B42018s = adapthisteq(B42018fill,'ClipLimit',0.1,'Distribution','Rayleigh');
rgb2018 = cat(3,B22018s,B32018s,B42018s);

figure
imshow(rgb2018,'InitialMagnification',30)
title('Camp fire Paradise Ca.')

vars2018 = {'B22018','B32018','B42018',...
    'B22018fill','B32018fill','B42018fill',...
    'B22018s','B32018s','B42018s','vars2018'};
clear(vars2018{:})

%% 4. Show the 3d surface temperature plot, which highlights the fire

figure
B102018Deg = (B102018-272);
mapshow(B102018Deg, R2018, 'DisplayType', 'surface');
colormap(parula);
view(3);
axis normal
xlabel('Longitude in Meters');
ylabel('Latitide in Meters');
zlabel('Temperature in Degrees Celcius');
title('Plot of Surface temperature  - November 8th 2018')

vars2018b = {'B102018','B102018Deg','vars2018b'};
clear(vars2018b{:})

%% 5. Change detection, Show RGB of Dec 2017, NDVI and NDVI scatter plot

[B22017,R2017] = geotiffread('2017_dec_corrected/RT_LC08_L1TP_044032_20171207_20171223_01_T1_B2.TIF');
B32017 = geotiffread('2017_dec_corrected/RT_LC08_L1TP_044032_20171207_20171223_01_T1_B3.TIF');
B42017 = geotiffread('2017_dec_corrected/RT_LC08_L1TP_044032_20171207_20171223_01_T1_B4.TIF');
B52017 = geotiffread('2017_dec_corrected/RT_LC08_L1TP_044032_20171207_20171223_01_T1_B5.TIF');
B102017 = geotiffread('2017_dec_corrected/RT_LC08_L1TP_044032_20171207_20171223_01_T1_B10.TIF');

%unrefined plot
NIR2017 = B52017;
Red2017 = B42017;
ndvi17 = (NIR2017 - Red2017) ./ (NIR2017 + Red2017);
ndvi17 = double(ndvi17);
figure
mapshow(ndvi17,R2017, 'DisplayType', 'surface');
colormap(winter);
axis normal
xlabel('Longitude in Meters');
ylabel('Latitide in Meters');
title('December 2017 NDVI')

% Define a threshhold value for vegetation
threshold = 0.4;
q2017 = (ndvi17 > threshold);
qd2017 = double(q2017);
figure
mapshow(qd2017 ,R2017, 'DisplayType', 'surface');
colormap(winter);
axis normal
xlabel('Longitude in Meters');
ylabel('Latitide in Meters');
title('December 2017 filtered NDVI')

%Showing the NDVI Scatter plot
figure
plot(Red2017,NIR2017,'+b')
hold on
plot(Red2017(q2017(:)),NIR2017(q2017(:)),'g+')
axis square
xlabel('Red level')
ylabel('NIR level')
title('NIR vs. Red Scatter Plot - 2017')

percentcover2017 = 100 * numel(NIR2017(q2017(:))) / numel(NIR2017)

vars2017 = {'B22017','B32017','B42017','B52017',...
    'B102017','NIR2017','Red2017','ndvi17',...
    'q2017','qd2017','vars2017'};
clear(vars2017{:})


%% 6. Show RGB of Jan 2019, NDVI and NDVI scatter plot

[B22019,R2019] = geotiffread('2019_jan_corrected/RT_LC08_L1TP_044032_20190127_20190206_01_T1_B2.TIF');
B32019 = geotiffread('2019_jan_corrected/RT_LC08_L1TP_044032_20190127_20190206_01_T1_B3.TIF');
B42019 = geotiffread('2019_jan_corrected/RT_LC08_L1TP_044032_20190127_20190206_01_T1_B4.TIF');
B52019 = geotiffread('2019_jan_corrected/RT_LC08_L1TP_044032_20190127_20190206_01_T1_B5.TIF');
B102019 = geotiffread('2019_jan_corrected/RT_LC08_L1TP_044032_20190127_20190206_01_T1_B10.TIF');

%unrefined plot
NIR2019 = B52019;
Red2019 = B42019;
ndvi19 = (NIR2019 - Red2019) ./ (NIR2019 + Red2019);
ndvi19 = double(ndvi19);

figure
mapshow(ndvi19,R2019, 'DisplayType', 'surface');
colormap(winter);
axis normal
xlabel('Longitude in Meters');
ylabel('Latitide in Meters');
title('December 2019 NDVI')

q2019 = (ndvi19 > threshold);
qd2019 = double(q2019);
figure
mapshow(qd2019 ,R2019, 'DisplayType', 'surface');
colormap(winter);
axis normal
xlabel('Longitude in Meters');
ylabel('Latitide in Meters');
title('December 2019 filtered NDVI')


%Showing the NDVI Scatter plot
figure
plot(Red2019,NIR2019,'+b')
hold on
plot(Red2019(q2019(:)),NIR2019(q2019(:)),'g+')
axis square
xlabel('Red level')
ylabel('NIR level')
title('NIR vs. Red Scatter Plot -2019')

percentcover2019 = 100 * numel(NIR2019(q2019(:))) / numel(NIR2019)

vars2019 = {'B22019','B32019','B42019','B52019',...
    'B102019','NIR2019','Red2019','ndvi19',...
    'q2019','qd2019','vars2019'};
clear(vars2019{:})

%% 7. Repeat 5 and 6 for extracted area of fire extent
%Fire extent
rgbd2018 = double(rgb2018);
cmp_fire = shaperead('shp/fire_extent/campfire_falifornia_32610.shp');
figure
mapshow(rgbd2018,R2018)
mapshow(cmp_fire,'FaceColor','none', 'EdgeColor', 'red','linewidth',.7);
axis normal
xlabel('Longitude in Meters');
ylabel('Latitide in Meters');
title('Final Camp fire extent - November 2018')

vars2018fire = {'rgb2018','rgbd2018','R2018','cmp_fire','vars2018fire'};
clear(vars2018fire{:})
    
%% Focused area Before 

[B42017F,R2017F] = geotiffread('2017_dec_firearea_corrected/RT_LC08_L1TP_044032_20171207_20171223_01_T1_B4.TIF');
B52017F = geotiffread('2017_dec_firearea_corrected/RT_LC08_L1TP_044032_20171207_20171223_01_T1_B5.TIF');
B62017F = geotiffread('2017_dec_firearea_corrected/RT_LC08_L1TP_044032_20171207_20171223_01_T1_B6.TIF');

%unrefined plot
NIR2017F = B52017F;
Red2017F = B42017F;
SWIR2017F = B62017F;
ndvi17F = (NIR2017F - Red2017F) ./ (NIR2017F + Red2017F);
nbr17F = (NIR2017F - SWIR2017F) ./ (NIR2017F + SWIR2017F);
ndvi17F = double(ndvi17F);
nbr17F = double(nbr17F);
figure
mapshow(ndvi17F,R2017F, 'DisplayType', 'surface');
colormap(winter);
axis normal
xlabel('Longitude in Meters');
ylabel('Latitide in Meters');
title('NDVI of burnt area extent')

figure
mapshow(nbr17F,R2017F, 'DisplayType', 'surface');
c = hot;
c = flipud(c);
colormap(c);
view(3);
axis normal
xlabel('Longitude in Meters');
ylabel('Latitide in Meters');
zlabel('Delta NBR');
title('NBR - December 2017')

q2017F = (ndvi17F > threshold);
qd2017F = double(q2017F);
figure
mapshow(qd2017F ,R2017F, 'DisplayType', 'surface');
colormap(winter);
axis normal
xlabel('Longitude in Meters');
ylabel('Latitide in Meters');
title('2017 NVDI positive of greater than 0.4')

%Showing the NDVI Scatter plot
figure
plot(Red2017F,NIR2017F,'+b')
hold on
plot(Red2017F(q2017F(:)),NIR2017F(q2017F(:)),'g+')
axis square
xlabel('Red level')
ylabel('NIR level')
title('NIR vs. Red Scatter Plot 2017 - Focused')

percentcover2017F = 100 * numel(NIR2017F(q2017F(:))) / numel(NIR2017F)

vars2017F = {'B42017F','B52017F','B62017F','c',...
    'nbr17F','NIR2017F','Red2017F','SWIR2017F',...
    'q2017F','qd2017F','vars2017F'};
clear(vars2017F{:})


%% Focused area aftermath

[B42019F,R2019F] = geotiffread('2019_jan_firearea_corrected/RT_LC08_L1TP_044032_20190127_20190206_01_T1_B4.TIF');
B52019F = geotiffread('2019_jan_firearea_corrected/RT_LC08_L1TP_044032_20190127_20190206_01_T1_B5.TIF');
B62019F = geotiffread('2019_jan_firearea_corrected/RT_LC08_L1TP_044032_20190127_20190206_01_T1_B6.TIF');

%unrefined plot
NIR2019F = B52019F;
Red2019F = B42019F;
SWIR2019F = B62019F;
ndvi19F = (NIR2019F - Red2019F) ./ (NIR2019F + Red2019F);
nbr19F = (NIR2019F - SWIR2019F) ./ (NIR2019F + SWIR2019F);
ndvi19F = double(ndvi19F);
nbr19F = double(nbr19F);

figure
mapshow(ndvi19F,R2019F, 'DisplayType', 'surface');
colormap(winter);
axis normal
xlabel('Longitude in Meters');
ylabel('Latitide in Meters');
title('NDVI of burnt area extent')

figure
mapshow(nbr19F,R2019F, 'DisplayType', 'surface');
c = hot;
c = flipud(c);
colormap(c);
view(3);
axis normal
xlabel('Longitude in Meters');
ylabel('Latitide in Meters');
zlabel('NBR Value');
title('NBR - January 2019')

q2019F = (ndvi19F > threshold);
qd2019F = double(q2019F);
figure
mapshow(qd2019F ,R2019F, 'DisplayType', 'surface');
colormap(winter);
axis normal
xlabel('Longitude in Meters');
ylabel('Latitide in Meters');
title('2019 NVDI positive of greater than 0.4')

%Showing the NDVI Scatter plot
figure
plot(Red2019F,NIR2019F,'+b')
hold on
plot(Red2019F(q2019F(:)),NIR2019F(q2019F(:)),'g+')
axis square
xlabel('Red level')
ylabel('NIR level')
title('NIR vs. Red Scatter Plot')

percentcover2019F = 100 * numel(NIR2019F(q2019F(:))) / numel(NIR2019F)

vars2019F = {'B42019F','B52019F','B62019F','c',...
    'nbr19F','NIR2019F','Red2019F','SWIR2019F',...
    'q2019F','qd2019F','vars2019F'};
clear(vars2019F{:})

%% 8. Plot histograms of NDVI value distribution, pre and post
figure
hist(ndvi17F(:),100);
xlabel('Classes');
ylabel('Frequency');
title('Histogram distribution of NDVI Values 2017')

figure
hist(ndvi19F(:),100);
xlabel('Classes');
ylabel('Frequency');
title('Histogram distribution of NDVI Values 2019')

%% 10. Estimate percentage decrease in biomass. 
%Get computational sums of only areas with inferred vegetation
bio17 = (ndvi17F > 0.4);
bio19 = (ndvi19F > 0.4);


biox2017 = ndvi17F .* bio17;
biox2017 = double(biox2017);
figure
mapshow(biox2017, R2017, 'DisplayType', 'surface');
colormap(parula);
axis normal
xlabel('Longitude in Meters');
ylabel('Latitide in Meters');
title('Areas with plants only - 2017')


biox2019 = ndvi19F .* bio19;
biox2019 = double(biox2019);
figure
mapshow(biox2019, R2017, 'DisplayType', 'surface');
colormap(parula);
axis normal
xlabel('Longitude in Meters');
ylabel('Latitide in Meters');
title('Areas with plants only - 2019')

rwsum17 = sum(bio17(:));
rwsum19 = sum(bio19(:));

%Assumung that 2017 is at 100%
percentage_change_2017_2019 = ((rwsum19 - rwsum17) / rwsum17)*100;

%%
%Displaying net change per area
change =((ndvi19F - ndvi17F)./2) .* 100;

changeup = (change > 0);
changeup = double(changeup);
figure
mapshow(changeup, R2017, 'DisplayType', 'surface');
colormap(parula);
axis normal
xlabel('Longitude in Meters');
ylabel('Latitide in Meters');
title('Increase in biomass')

changedown = (change <= 0);
changedown = double(changedown);
figure
mapshow(changedown, R2017, 'DisplayType', 'surface');
colormap(parula);
axis normal
xlabel('Longitude in Meters');
ylabel('Latitide in Meters');
title('Decrease in biomass')

percentage_change_2017_2019

clear

%% References
% References:
% 1. MATLAB? Recipes for Earth Sciences, Fourth Edition - Martin H. Trauth
% 2. MATLAB Documentation - Mathworks.
% 3. usgs.gov
% 4. California State Government - https://www.ca.gov/








