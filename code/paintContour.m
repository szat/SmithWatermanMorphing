function [ canvas ] = paintContour(contour, dims)
% Usage: [ canvas ] = paintContour(contour, dims)
%
% Arguments:
%          contour  - Contour that is m x 2, the coordinates have to lie within dims
%             dims  - The size of the binary into which contour will be painted.
%
% Returns:
%            canvas - A binary image of dimension given by dims, where contour falls is painted 1.

% Example:
% I = imread('..\data\bw_fish1.png');
% BW = imbinarize(I);
% C = bwboundaries(BW,4); %IT IS IMPORTANT FOR THIS TO BE 4 CONNECTED AND ***not*** 8 CONNECTED
% C = C{1};
% C = buildContour(BW,C); %NEED TO USE SPACING HERE
% canvas = paintContour(C,size(BW));
% imshow(canvas);

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

temp = zeros(dims);
[rl, cl] = size(contour);
for i = 1:rl
    pt = contour(i,:);
    row = floor(pt(1));
    col = floor(pt(2));
    row_low = max(1,row-1);
    col_low = max(1,col-1);
    row_high = min(dims(1), row+1);
    col_high = min(dims(2), col+1);
    temp(row_low:row_high, col_low:col_high) = 1;
end
canvas = temp;
end
