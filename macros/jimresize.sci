// This file is part of Jimlab, an external module coded for Scilab 
// and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Gaël SENÉE
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at    
// http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt


function resizedImage = jimresize (originalImage, out_height, out_width, interp_type, spline_type)
// • originalImage : a single layered matrix (grayscale image), or a 3- or 4-
// layered hypermatrix (RGB or RGBA image).
// • out_height : height of the output image.
// • out_width : width of the output image.
// • inter_type : string of characters giving the choice of the interpolation
// algorithm. By default, 'natural'.
// • spline_type : string of characters giving the choice of the spline calculation
// algorithm. By default, 'not_a_knot'.
// • resizedImage : the output image, in standard Jimlab format.

// WIP.
// Side effects (outlines around the contrasted pixels): are they correctible ?


    // Checking the type of the image

    msg = "%s: Argument #%d : A (hyper)matrix of 1, 3 or 4 layers, or a jimage object must be given";

    if (isdef("originalImage","l") & type(originalImage) ~= 0)
        if typeof(originalImage) == 'jimage' then
            mat_image = originalImage.image;
        else
            mat_image = jimstandard(originalImage);
        end
    else
        error(msprintf(msg, 'jimresize', 1));
    end

    // Checking the number of layers
    
    if (size(mat_image,3) == 4) then
        interpolatedMatrix = jimresizeRGBA (mat_image, out_height, out_width, interp_type, spline_type)
    elseif (size(mat_image,3) == 3) then
        interpolatedMatrix = jimresizeRGB (mat_image, out_height, out_width, interp_type, spline_type)
    elseif(ndims(mat_image) == 2) then
        interpolatedMatrix = jimresizeGray (mat_image, out_height, out_width, interp_type, spline_type)
    else    
        error(msprintf(msg,'jiminvert',1));
    end

    if typeof(originalImage) == jimage then
        resizedImage = mlist(['jimage','image','encoding','title','mime','transparencyColor'],..
        interpolatedMatrix, image.encoding, image.title, image.mime, image.transparencyColor);
    
    else
        resizedImage = interpolatedMatrix
    
    end
    
    

endfunction

function out_image = jimresizeCorrection (mat_image, layers)
    
    // Correction the pixel values
    
    for i = 1:layers
        mat_image(:,:,i) = floor(mat_image(:,:,i));
        
        mask(:,:,i) = mat_image(:,:,i) >= 255;
        
        out_image(:,:,i) = 255*mask + mat_image(:,:,i) .* ~mask;
    end

    out_image = jimstandard(out_image);
    
endfunction



function interpolatedImage = jimresizeGray (mat_image, out_height, out_width, interp_type, spline_type)
// This subfonction uses an interpolation algorithm to resize a single-layered matrix.
// • originalImage : a single layered hypermatrix (grayscale image)
// • out_height : height of the output image.
// • out_width : width of the output image.
// • inter_type : string of characters giving the choice of the interpolation
// algorithm. By default, 'natural'.
// • interpolatedImage : the output image, in standard Jimlab format.

    [h,w] = size(mat_image);
    
    // Setting the interpolation parameters
    x = linspace(0,1,h) ;
    y = linspace(0,1,w) ;

    layer = double(mat_image);

    spl = splin2d(x, y, layer, spline_type) ;

    xx = linspace(0,1,out_height) ;
    yy = linspace(0,1,out_width) ;

    [XX,YY] = ndgrid(xx,yy);
    interpol = floor(interp2d(XX,YY, x, y, spl, interp_type));

    // Correcting the wrong values of pixels
    
    mask255 = (interpol(:,:,1) >= 255);
    mask0 = (interpol(:,:,1) < 0);

    out1 = 255*mask255 + interpol .* ~mask255;
    out2 = out1 .* ~mask0;

    // Returning the interpolated image in uint8 format
    interpolatedImage = uint8(out2);
    
endfunction

function interpolatedImage = jimresizeRGB (mat_image, out_height, out_width, interp_type, spline_type)
// This subfonction uses an interpolation algorithm to resize a 3-layered hypermatrix.
// • originalImage : a 3 layered hypermatrix (RGB image)
// • out_height : height of the output image.
// • out_width : width of the output image.
// • inter_type : string of characters giving the choice of the interpolation
// algorithm. By default, 'natural'.
// • spline_type : string of characters giving the choice of the spline calculation
// algorithm. By default, 'not_a_knot'.
// • interpolatedImage : the output image, in standard Jimlab format.

    [h,w] = size(mat_image);
    
    // Setting the interpolation parameters
    x = linspace(0,1,h) ;
    y = linspace(0,1,w) ;

    layer1 = double(mat_image(:,:,1));
    layer2 = double(mat_image(:,:,2));
    layer3 = double(mat_image(:,:,3));
    
    spl1 = splin2d(x, y, layer1, spline_type) ;
    spl2 = splin2d(x, y, layer2, spline_type) ;
    spl3 = splin2d(x, y, layer3, spline_type) ;
    
    xx = linspace(0,1,out_height) ;
    yy = linspace(0,1,out_width) ;

    [XX,YY] = ndgrid(xx,yy);
    interpol(:,:,1) = floor(interp2d(XX,YY, x, y, spl1, interp_type));
    interpol(:,:,2) = floor(interp2d(XX,YY, x, y, spl2, interp_type));
    interpol(:,:,3) = floor(interp2d(XX,YY, x, y, spl3, interp_type));
    
    
    // Correcting the wrong values of pixels
    mask255(:,:,1) = (interpol(:,:,1) >= 255);
    mask255(:,:,2) = (interpol(:,:,2) >= 255);
    mask255(:,:,3) = (interpol(:,:,3) >= 255);

    mask0(:,:,1) = (interpol(:,:,1) < 0);
    mask0(:,:,2) = (interpol(:,:,2) < 0);
    mask0(:,:,3) = (interpol(:,:,3) < 0);

    out1(:,:,1) = 255*mask255(:,:,1) + interpol(:,:,1) .* ~mask255(:,:,1);
    out1(:,:,2) = 255*mask255(:,:,2) + interpol(:,:,2) .* ~mask255(:,:,2);
    out1(:,:,3) = 255*mask255(:,:,3) + interpol(:,:,3) .* ~mask255(:,:,3);
    
    out2(:,:,1) = out1(:,:,1) .* ~mask0(:,:,1);
    out2(:,:,2) = out1(:,:,2) .* ~mask0(:,:,2);
    out2(:,:,3) = out1(:,:,3) .* ~mask0(:,:,3);
    
    interpolatedImage = uint8(out2) ;

endfunction

function interpolatedImage = jimresizeRGBA (mat_image, out_height, out_width, interp_type, spline_type)
// This subfonction uses an interpolation algorithm to resize a 4-layered hypermatrix.
// • originalImage : a 4 layered hypermatrix (RGBA image)
// • out_height : height of the output image.
// • out_width : width of the output image.
// • inter_type : string of characters giving the choice of the interpolation
// algorithm. By default, 'natural'.
// • spline_type : string of characters giving the choice of the spline calculation
// algorithm. By default, 'not_a_knot'.
// • interpolatedImage : the output image, in standard Jimlab format.

    [h,w] = size(mat_image);
    
    // Setting the interpolation parameters
    x = linspace(0,1,h) ;
    y = linspace(0,1,w) ;

    layer1 = double(mat_image(:,:,1));
    layer2 = double(mat_image(:,:,2));
    layer3 = double(mat_image(:,:,3));
    layer4 = double(mat_image(:,:,4));
    
    spl1 = splin2d(x, y, layer1, spline_type) ;
    spl2 = splin2d(x, y, layer2, spline_type) ;
    spl3 = splin2d(x, y, layer3, spline_type) ;
    spl4 = splin2d(x, y, layer4, spline_type) ;
    
    xx = linspace(0,1,out_height) ;
    yy = linspace(0,1,out_width) ;

    [XX,YY] = ndgrid(xx,yy);
    interpol(:,:,1) = floor(interp2d(XX,YY, x, y, spl1, interp_type));
    interpol(:,:,2) = floor(interp2d(XX,YY, x, y, spl2, interp_type));
    interpol(:,:,3) = floor(interp2d(XX,YY, x, y, spl3, interp_type));
    interpol(:,:,4) = floor(interp2d(XX,YY, x, y, spl4, interp_type));
    
    mask255(:,:,1) = (interpol(:,:,1) >= 255);
    mask255(:,:,2) = (interpol(:,:,2) >= 255);
    mask255(:,:,3) = (interpol(:,:,3) >= 255);
    mask255(:,:,4) = (interpol(:,:,4) >= 255);

    mask0(:,:,1) = (interpol(:,:,1) < 0);
    mask0(:,:,2) = (interpol(:,:,2) < 0);
    mask0(:,:,3) = (interpol(:,:,3) < 0);
    mask0(:,:,4) = (interpol(:,:,4) < 0);

    out1(:,:,1) = 255*mask255(:,:,1) + interpol(:,:,1) .* ~mask255(:,:,1);
    out1(:,:,2) = 255*mask255(:,:,2) + interpol(:,:,2) .* ~mask255(:,:,2);
    out1(:,:,3) = 255*mask255(:,:,3) + interpol(:,:,3) .* ~mask255(:,:,3);
    out1(:,:,4) = 255*mask255(:,:,4) + interpol(:,:,4) .* ~mask255(:,:,4);
    
    out2(:,:,1) = out1(:,:,1) .* ~mask0(:,:,1);
    out2(:,:,2) = out1(:,:,2) .* ~mask0(:,:,2);
    out2(:,:,3) = out1(:,:,3) .* ~mask0(:,:,3);
    out2(:,:,4) = out1(:,:,4) .* ~mask0(:,:,4);
    
    interpolatedImage = uint8(out2) ;
    
    
endfunction
