// This file is part of Jimlab, an external module coded for Scilab 
// and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function [HM, rho, anglesD] = jimhough(image, anglesD)
    // THIS VERSION:
    //  * anglesD on [-90, 90[, direct, wrt (Oy)
    //  * rho: Distance wrt bottom left corner of the image
    //  * HM: Hough Matrix. Same size as image, forced to 2D.

    if typeof(image)=="jimage"
        image = image.image;
    else
        image = jimstandard(image);
    end
    if size(image,3)>1 then
        image = jimconvert(image,"gray");
    end
    image = image($:-1:1,:);    // origine image en bas à gauche
    [Ny, Nx] = size(image);
    pix = find(double(image));
    clear image
    Npix = length(pix);
    if ~Npix
        return
    end
    if ~isdef("anglesD","l") | type(anglesD)==0 then
        anglesD = -90:89;
    else
        anglesD = unique(modulo(anglesD+90, 180));
        tmp = anglesD>180;
        anglesD(tmp) = [];
        anglesD = anglesD - 90;
    end
    angles = anglesD /180*%pi;
    Nangles = length(angles);
    rhoMax = round(sqrt(Nx^2 + Ny^2));
    rho = -rhoMax:rhoMax;
    HM = zeros(length(rho), Nangles);
    [x,y] = meshgrid(1:Nx, 1:Ny);
    x = matrix(x(pix),1,-1);    // Row
    y = matrix(y(pix),1,-1);    // Row
    t1 = ones(x);               // Row
    c = cos(angles(:));         // column
    s = sin(angles(:));         // column
    sHM = size(HM);
    angleStep = max(1, floor(1e4/Npix));  // Blocks of 1e4 eligible pixels max
    for iStep = 1:ceil(Nangles / angleStep)
        t = 1+(iStep-1)*angleStep;
        t = t:min(t + angleStep -1, Nangles);
        r = round(c(t)*x + s(t)*y) + rhoMax;
        t = t(:)*t1;
       ind = sub2ind(sHM, r(:), t(:));
       tmp = tabul(ind,"i");
       ind = tmp(:,1);
       HM(ind) = HM(ind) + tmp(:,2);
    end
    HM = HM($:-1:1,:);
endfunction
