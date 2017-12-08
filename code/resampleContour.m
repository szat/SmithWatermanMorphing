function [contour] = resampleContour(contour, option, value)

% Resamples a contour, with either average distance specified or number of points specified.

% Usage:   [contour] = resampleContour(contour, option, value)
%
% Arguments:
%          contour  - Contour, should be m x 2
%           option  - Either 'Spacing' or 'Sampling'
%            value  - Distance between successsive contour points
%
% Returns:
%           contour - Contour, will be as specified by the option and value, will be n x 2

% Example 1 (Sampling):
% smoothing = 10;
% delta = 5;
% 
% I = imread('..\data\bw_fish1.png');
% BW = imbinarize(I);
% C = bwboundaries(BW,4); %IT IS IMPORTANT FOR THIS TO BE 4 CONNECTED AND ***not*** 8 CONNECTED
% C = C{1};
% C = buildContour(BW,C);
% C = resampleContour(C,'Sampling',300);
%
% Example 2 (Spacing):
% smoothing = 10;
% delta = 5;
% 
% I = imread('..\data\fish\bw_fish1.png');
% BW = imbinarize(I);
% C = bwboundaries(BW,4); %IT IS IMPORTANT FOR THIS TO BE 4 CONNECTED AND ***not*** 8 CONNECTED
% C = C{1};
% C = buildContour(BW,C);
% C = resampleContour(C,'Spacing',3);
% dist = sqrt((C(:,1) - circshift(C(:,1),1)).^2 + (C(:,2) - circshift(C(:,2),1)).^2);
% mean(dist)

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

if(strcmp(option,'Spacing'))
    %Sampling
    Rc = [contour(:,1); contour(1,1)];
    Cc = [contour(:,2); contour(1,2)];
    dR = diff(Rc);
    dC = diff(Cc);
    dS = sqrt(dR.^2+dC.^2);
    contour(dS == 0,:) = [];
    
    Rc = [contour(:,1); contour(1,1)];
    Cc = [contour(:,2); contour(1,2)];
    dR = diff(Rc);
    dC = diff(Cc);
    dS = sqrt(dR.^2+dC.^2);
    dS = [0; dS];
    d = cumsum(dS);  % Here is the independent variable
    perim = d(end);
    
    refinement = ceil(perim / value);
    delta = value;
    
    dSi = delta*(0:refinement)';
    dSi(end) = dSi(end)-.005; % Make interp1 happy
    Ri = interp1(d,Rc,dSi);
    Ci = interp1(d,Cc,dSi,'linear');
    Ri(end)=[]; Ci(end)=[];
    contour = [Ri, Ci];
elseif(strcmp(option,'Sampling'))
    %Spacing
    Rc = [contour(:,1); contour(1,1)];
    Cc = [contour(:,2); contour(1,2)];
    dR = diff(Rc);
    dC = diff(Cc);
    dS = sqrt(dR.^2+dC.^2);
    contour(dS == 0,:) = [];
    
    Rc = [contour(:,1); contour(1,1)];
    Cc = [contour(:,2); contour(1,2)];
    dR = diff(Rc);
    dC = diff(Cc);
    dS = sqrt(dR.^2+dC.^2);
    dS = [0; dS];
    
    d = cumsum(dS);  % independent variable
    perim = d(end);
    
    refinement = value;
    delta = perim / value;
    
    dSi = delta*(0:refinement)';
    dSi(end) = dSi(end)-.005; % appease interp1
    Ri = interp1(d,Rc,dSi);
    Ci = interp1(d,Cc,dSi,'linear');
    Ri(end)=[]; Ci(end)=[];
    contour = [Ri, Ci];
end
end

