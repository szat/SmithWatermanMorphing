function [ D ] = editMatrix(contour_src,contour_dst,delta)
% Implementation of Wagner and Fischer's String to String Correction Problem 
% Also known as the Levenshtein matrix

% Usage:   [ D ] = editMatrix(contour_src,contour_dst,delta)
%
% Arguments:  
%      contour_src  - Source contour, should be m x 2
%      contour_dst  - Destination contour, should be n x 2
%            delta  - Distance between successsive contour points
%
% Returns: 
%                 D - The Levenshtein distance matrix between contour_src and contour_dst 

% Example:
% smoothing = 10;
% delta = 5;
% 
% I1 = imread('..\data\bw_fish1.png');
% BW1 = imbinarize(I1);
% C1 = bwboundaries(BW1,4); %IT IS IMPORTANT FOR THIS TO BE 4 CONNECTED AND ***not*** 8 CONNECTED
% C1 = C1{1};
% C1 = buildContour(BW1,C1,smoothing,'Spacing',delta); %NEED TO USE SPACING HERE
% 
% I2 = imread('..\data\bw_fish2.png');
% BW2 = imbinarize(I2);
% C2 = bwboundaries(BW2,4); %IT IS IMPORTANT FOR THIS TO BE 4 CONNECTED AND ***not*** 8 CONNECTED
% C2 = C2{1};
% C2 = buildContour(BW2,C2,smoothing,'Spacing',delta); %NEED TO USE SPACING HERE
% 
% % Edit Matrix
% D = editMatrix(C1, C2, delta); 

% Reference: Wagner, Robert A., and Michael J. Fischer. 
% The string-to-string correction problem. 
% Journal of the ACM (JACM) 21.1 (1974): 168-173.

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

string_src = diff(contour_src);
string_dst = diff(contour_dst);

n = size(string_dst,1);
m = size(string_src,1);

temp = zeros(n+1, m+1);
temp(1,1) = 0;

for j = 2:m+1
    temp(1,j) = temp(1,j-1) + delta;
end
for i = 2:n+1
    temp(i,1) = temp(i-1,1) + delta;
end
for i = 2:n+1
    for j = 2:m+1
       temp(i,j) = min([temp(i-1,j-1)+norm(string_dst(i-1,:) - string_src(j-1,:)), temp(i-1,j)+delta, temp(i,j-1)+delta]);
    end
end

D = temp;
end