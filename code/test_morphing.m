% Copyright (c) Adrian Szatmari
% Author: Adrian Szatmari
% Date: 2017-11-30
% License: MIT, patent permitting
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.

% To Vizualize, download imshow3D from 
% https://www.mathworks.com/matlabcentral/fileexchange/41334-imshow3d--3d-imshow-

smoothing = 10;
delta = 5;

I1 = imread('..\data\bw_fish1.png');
BW1 = imbinarize(I1);
C1 = bwboundaries(BW1,4); %IT IS IMPORTANT FOR THIS TO BE 4 CONNECTED AND ***not*** 8 CONNECTED
C1 = C1{1};
C1 = buildContour(BW1,C1,smoothing,'Spacing',delta); %NEED TO USE SPACING HERE

I2 = imread('..\data\bw_fish2.png');
BW2 = imbinarize(I2);
C2 = bwboundaries(BW2,4); %IT IS IMPORTANT FOR THIS TO BE 4 CONNECTED AND ***not*** 8 CONNECTED
C2 = C2{1};
C2 = buildContour(BW2,C2,smoothing,'Spacing',delta); %NEED TO USE SPACING HERE

% Edit Matrix
D = editMatrix(C1, C2, delta); 

% Edit Sequence
alpha = linspace(0,1,100);
slice3d = zeros([size(BW1), 100]);

for i = 1:length(alpha)
    C = alphaMorph(D, alpha(i), C1, C2); %t might be bigger than 200!!!
    C = resampleContour(C, 'Sampling', 280);
    slice3d(:,:,i) = paintContour(C,size(BW1)) + paintContour(C(1:10:end,:),size(BW1));
end

% Simple Visualization
figure
imshow(slice3d(:,:,50),[]);

% To Vizualize, download imshow3D from 
% https://www.mathworks.com/matlabcentral/fileexchange/41334-imshow3d--3d-imshow-
% figure;
% imshow3D(slice3d,[]);

% DISCLAIMER: it seems that in some odd cases, this method returns garbage.
% Try to check whether both contours are clockwise. buildContour naturally sets this.
% To fix first try building both contours with the supplied buildContour fct. 
% This seems to happen when src and dst are very far from one another. 
