// This file is part of Jimlab, an external module coded for Scilab 
// and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Gaël SENÉE
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at    
// http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function [mask, polygon, ijTopLeft] = jimroi(image, input_polygon, crop2polygon)

// INPUT ARGUMENTS
// • image : jimage object, single layered matrix, 3- or
// 4-layered hypermatrix.
// • polygon : summits of the polygon the user wants to select.
// It consists of a [N ; 2] matrix containing the summits of the
// polygon (correctly sorted for the polygone to avoid any
// intersection).
// • crop2polygon : boolean used in order to crop the mask to the minimal
// rectangle around the polygon.
// By default

// OUTPUT ARGUMENTS
// • mask : the function returns a boolean matrix or hypermatrix :
// %T inside the polygon and %F outside the polygon.
// ~mask can be used to return the opposite mask.
// • polygon : returns the same matrix as the input argument.
// • ijTopLeft : coordinates of the top left corner of the rectangle
// containing the whole polygon.

// WIP.
// Lacks the interactive edition of the polygon by edit_curv().
// Returning the right polygon if it's edited by edit_curv().
// Replace the point_in_polygon() function by a vectorized function.


    // Checking the type of the input image
    if (isdef("image","l") & type(image) ~= 0)
        if typeof(image) == 'jimage' then
            Matrix = image.image;
        elseif type(image) == 1 | type(image) == 8 then
            Matrix = jimstandard(image);
        else
            msg_1 = "%s: Argument #%d : A (hyper)matrix of 1, 3 or 4 layers, or a jimage object must be given";
            error(msprintf(msg_1, 'jimroi', 1))
        end
    else
        error(msprintf(msg_1, 'jimroi', 1))
    end

    // Checking the type of the matrix of the summits
    msg_2 = "%s: Argument #%d : Must be a [N ; 2] matrix of integers describing the N summits of (x,y) coordinates";
    if ~(type(input_polygon) == 1) | ~(size(input_polygon, 2) == 2) then
        error(msprintf(msg_2, 'jimroi', 2))
    end

    // Checking the crop argument
    if ~isdef('crop2polygon','l') | type(crop2polygon) == 0 then
        crop2polygon = %f ;
    end
    
    if crop2polygon == 0 then
        crop2polygon = %f
    end
    
    if crop2polygon == 1 then
        crop2polygon = %t
    end
    
    if ~(type(crop2polygon) == 4) then
        warning("Wrong input argument #3 : default value %f will be used.")
    end

    // Creation of the mask
    mask = jimcreateMask(input_polygon, Matrix);

    // Cropping the mask

    if crop2polygon then
        mask = jimcropMask(input_polygon, Matrix, mask)
    end
    
    // Returning ijTopleft
    
    poly_top = max(input_polygon(:,2));
    poly_bot = min(input_polygon(:,2));
    poly_left = min(input_polygon(:,1));
    poly_right = max(input_polygon(:,1));

    ijTopLeft = [poly_top-1,poly_left-1];

    // Returning the polygon WIP
    polygon = input_polygon;

endfunction

function output_mask = jimcreateMask(input_polygon, mat_image)
// This subfonction creates the boolean mask which describes the zone being
// selected.
// • input_polygon : a [N ; 2] matrix containing the summits of the
// polygon (correctly sorted for the polygone to avoid any
// intersection)
// • mat_image : a single, 3- or 4-layered matrix or hypermatrix.
// • output_mask : a (hyper)matrix of boolean of the same size of mat_image.

    x_poly = input_polygon(:,1);
    y_poly = input_polygon(:,2);

    [h,w] = size(mat_image);

    // Adapting the polygon in the orientation of the image
    // The origin of a Matplot figure is at the bottom left but the matrix
    // has its origin in the top left corner.

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
    output_mask = in(:,:) == 1;

endfunction

function out_mask = jimcropMask (input_polygon, mat_image, input_mask)
// This subfunction is used to crop the mask to the minimal rectangle
// within which the polygon is contained.
// input_polygon : a [N ; 2] matrix containing the summits of the
// polygon (correctly sorted for the polygone to avoid any
// intersection)
// mat_image : a single, 3- or 4-layered matrix or hypermatrix.
// input_mask : a (hyper)matrix of boolean of the same size of mat_image.
// out_mask : a (hyper)matrix of boolean.
    
    [h,w] = size(mat_image);
    
    poly_top = max(input_polygon(:,2));
    poly_bot = min(input_polygon(:,2));
    poly_left = min(input_polygon(:,1));
    poly_right = max(input_polygon(:,1));

    out_mask = input_mask(h-poly_top:h-poly_bot,poly_left:poly_right)
        
    // Border corrections : suppressing the extreme lines filled with %F
    h_mask = size(out_mask,1)
    w_mask = size(out_mask,2)
    
    left = %f ; right = %f ; bot = %f ; top = %f ;

    for i = 1:h_mask
        // First column of the mask
        if out_mask(i,1) then
            left = %t
            break
        end
     end

    for i = 1:h_mask
        // Last column of the mask
        if out_mask(i,w_mask) then
            right = %t
            break
        end
    end

    for j = 1:w_mask
        // First line of the mask
        if out_mask(1,j) then
            top = %t
            break
        end
    end
        
    for j = 1:w_mask
        // Last line of the mask
        if out_mask(h_mask,j) then
            bot = %t
            break
        end
    end


    // Exclusion of the lines filled with %F
    n_left = 1 ; n_right = w_mask ;
    n_bot = 1 ; n_top = h_mask ;
    
    if ~left then
        n_left = 2
    end
    
    if ~right then
        n_right = w_mask - 1
    end
    
    if ~bot then
        n_top = h_mask - 1
    end
    
    if ~top then
        n_bot = 2
    end
    
        out_mask = out_mask(n_bot:n_top,n_left:n_right)
    
endfunction
