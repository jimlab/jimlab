 //Copyright (C) 2017 - ENSIM, Université du Maine - Gaël SENÉE
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function [mask, polygon, ijTopLeft] = jimroi(image, input_polygon, crop2polygon)

// INPUT ARGUMENTS
// image : jimage object, single layered matrix, 3-layered or
// 4-layered hypermatrix.
// polygon : summits of the polygon the user wants to select.
// It consists of a [N ; 2] matrix containing the summits of the
// polygon (correctly sorted for the polygone to avoid any
// intersection).
// crop2polygon (optional): gives the information whether the
// rectangular output image has been cropped to the minimal size
// containing the selected zone or not (it is not, by default).

// OUTPUT ARGUMENTS
// mask : the function returns a boolean matrix or hypermatrix :
// %T inside the polygon and %F outside the polygon.
// ~mask can be used to return the opposite mask.
// polygon : returns the same matrix as the input argument.
// ijTopLeft : number of lines and columns deleted if the output image is
// cropped.

// WIP.
// Works for squared matrix.
// Lacks the interactive edition of the polygon (edit_curves)



    // Testing input arguments
    
    // Checking the type of the input image
    if isdef("image","l")
       if typeof(image) == 'jimage' then
            Matrix = image.image;
        elseif type(image) == 8 then // Matrix of integers
            Matrix = image;
        end
    else
        error('A (hyper)matrix of 1, 3 or 4 layers, or a jimage object must be given as an entry')
    end

    // Checking the type of the matrix of the summits
    if ~type(input_polygon) == 1 then
        error('This argument must be a [N ; 2] matrix of integers.')
    end
    
    if ~size(input_polygon,2) == 2 then
        error('This argument must be a [N ; 2] matrix of integers describing the N summits of (x,y) coordinates')
    end

    // Checking the optional argument
    if ~isdef('crop2polygon','l') | type(crop2polygon) == 0 then
        crop2polygon = 'no';
    end
    if ~type(crop2polygon) == 10 then
        error('This argument must be a string of characters.')
    end

    // Creation of the mask
    [mask,poly_out] = jimcreateMask(input_polygon,Matrix);

    // Returning the number of lines and columns suppressed in case of cropping.
    poly_top = max(input_polygon(:,2));
    poly_bot = min(input_polygon(:,1));
    poly_left = min(input_polygon(:,1));
    poly_right = max(input_polygon(:,2));

    polygon = input_polygon;
    
    ijTopLeft = [poly_top-1,poly_left-1];



endfunction

function [mask,out_polygon] = jimcreateMask(input_polygon,mat_image)
// This subfonction creates the boolean mask which describes the zone being
// selected.
// polygon : a [N ; 2] matrix containing the summits of the
// polygon (correctly sorted for the polygone to avoid any
// intersection)

    x_poly = input_polygon(:,1);
    y_poly = input_polygon(:,2);

    // Displaying the polygon
    // (0.5 offsets are here to align with Matplot figures)
    // xpoly(x_poly-0.5, y_poly+0.5,'lines',1);

    [h,w] = size(mat_image);

    // Adapting the polygon in the orientation of the image
    // The origin of a Matplot figure is at the bottom left but the
    // function point_in_polygon seems to have the origin on the top left.
    // This function needs to be reworked

    poly_out = input_polygon;
    poly_out(:,1) = h;
    poly_out(:,2) = w;
    y_poly_out = x_poly;
    x_poly_out = poly_out(:,1)-y_poly;

    // The polygon now displays the same shape than the summits describe.

    // Gray and RGB matrix (subfunction)
    for i = 1:h
        for j = 1:w
            in(i,j) = point_in_polygon(x_poly_out, y_poly_out, i,j);
        end
    end

    // Creating the boolean mask
    mask = in(:,:) == 1;
    out_polygon=[x_poly_out,y_poly_out];
    
endfunction
