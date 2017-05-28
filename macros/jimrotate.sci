// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function jim = jimrotate(jim, Angle, frameMode)
    // jim: a jimage
    // Angle: in °, anti-clockwise
    // Final dithering: TO BE IMPLEMENTED
    // frameMode: boolean or [r g b] vector : TO BE IMPLEMENTED

    Angle = -Angle;
    [h, w, nL] = size(jim.image);
    // Corners
    //  A--B
    //  |  |
    //  |  |
    //  D--C
    xc = [1 w w 1 ];
    yc = [1 1 h h ];
    // Rotation matrix: [C -S ; S C]
    M = [cosd(Angle) -sind(Angle) ; sind(Angle) cosd(Angle)];
    // Rotated corners:
    tmp = M*[xc ; yc];
    xcr = tmp(1,:);
    ycr = tmp(2,:);
    // Rotated ranges:
    minXr = floor(min(xcr));
    maxXr = ceil(max(xcr));
    nXr = maxXr - minXr + 1;
    minYr = floor(min(ycr));
    maxYr = ceil(max(ycr));
    nYr = maxYr - minYr +1;
    // Rotated indices:
    [X, Y] = meshgrid(minXr:maxXr, minYr:maxYr);
    // Initializing the result
    R = uint8(zeros(nYr,nXr,size(jim,3)));
    // Reversed indices in the original image:
    Mr =  [cosd(Angle) sind(Angle) ; -sind(Angle) cosd(Angle)];
    tmp = round(Mr * [X(:)' ; Y(:)']);
    X = tmp(1,:);
    Y = tmp(2,:);
    clear tmp
    K = find(X>0 & X<=w & Y>0 & Y<=h);
    I = sub2ind([h w], [Y(K)' X(K)']);
    clear X Y
    for i = 1:nL
        tmp = uint8(zeros(1,nXr*nYr));
        tmp2 = jim.image(:,:,i);
        tmp(K) = tmp2(I);
        R(:,:,i) = matrix(tmp, nXr, nYr);
    end
    jim.image = R;
endfunction
