function [ contour ] = alphaMorph( mat, alpha, contour_src, contour_dst )
% Implementation of Jiang, Bunke, Abegglen and Kandel's Curve Morphing by Weighted Mean of Strings

% alphaMorph(mat, 0, contour_src, contour_dst) ~ contour_src, same shape 
% alphaMorph(mat, 1, contour_src, contour_dst) ~ contour_dst, same shape

% Usage:   [ contour ] = alphaMorph( mat, alpha, contour_src, contour_dst )
%
% Arguments:  
%              mat  - Levenshtein distance matrix
%            alpha  - In [0,1], as alpha*contour_src + (1-alpha)*contour_dst (kinda)
%      contour_src  - Source contour, should be m x 2
%      contour_dst  - Destination contour, should be n x 2
%
% Returns: 
%           contour - The morphed contour at position alpha. May have more points than both src and dst. 

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
%
% C = alphaMorph(D, 0.5, C1, C2);

% Reference: Jiang, Xiaoyi, et al. 
% Curve morphing by weighted mean of strings.
% Pattern Recognition, 2002. Proceedings. 16th International Conference on. Vol. 4. IEEE, 2002.

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

src = diff(contour_src);
dst = diff(contour_dst);

i = size(dst,1)+1; %size(source)
j = size(src,1)+1; %size(target)

while(i ~= 1 && j ~= 1)
    temp = min(min(mat(i-1,j-1), mat(i,j-1)), mat(i-1,j));
    if (mat(i-1,j) == temp) %insertion
        i = i - 1;
        src = [src(1:j-1,:); (alpha)*dst(i,:); src(j:end,:)];
        if(i == 1 || j == 1)
            break; 
        end
    end
       if (mat(i-1,j-1) == temp)
        if (mat(i-1,j-1)~= mat(i,j))  %substitution
            i = i - 1;
            j = j - 1;
            src(j,:) = (1-alpha)*src(j,:) + alpha*dst(i,:);
            if(i == 1 || j == 1)
                break; 
            end
        else
            i = i - 1;
            j = j - 1;
            if(i == 1 || j == 1)
                break; 
            end
        end
    end    
    
    if (mat(i,j-1) == temp) %deletion
        j = j - 1;
        src(j,:) = (1-alpha)*src(j,:);
        if(i == 1 || j == 1)
            break; 
        end
    end
end

% Pick a root of the end contour
root = (1-alpha)*contour_src(1,:)+alpha*contour_dst(1,:);

pt = root;
% Morph contour_src into towards contour_dst
c = zeros(length(src),2);
for k = 1:length(src)
    c(k,1) = pt(1);
    c(k,2) = pt(2);
    pt = [pt(1),pt(2)] + src(k,:);
end
contour = c;

% DISCLAIMER: it seems that in some odd cases, this method returns garbage.
% Try to check whether both contours are clockwise. buildContour naturally sets this.
% To fix first try building both contours with the supplied buildContour fct. 
% This seems to happen when src and dst are very far from one another. 
end