// This file is part of Jimlab, an external module coded for Scilab 
// and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Gaël SENÉE
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at    
// http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function [mask, polygon, ijTopLeft] = jimroi(image, input_polygon, editpoly, crop2polygon)

// INPUT ARGUMENTS
// • image : jimage object, single layered matrix, 3- or
// 4-layered hypermatrix.
// • polygon : summits of the polygon the user wants to select.
// It consists of a [N ; 2] matrix containing the summits of the
// polygon (correctly sorted for the polygone to avoid any
// intersection).
// • crop2polygon : boolean used in order to crop the mask to the minimal
// rectangle around the polygon. By default, it's set to %f.
// • editpoly : boolean used in order to edit the polygon via edit_curv(). By
// default it's set to %f.
// 0 and 1 work for both of these arguments.

// OUTPUT ARGUMENTS
// • mask : the function returns a boolean matrix or hypermatrix :
// %T inside the polygon and %F outside the polygon.
// • polygon : returns the output polygon, changed by the interactive edition
// or not. 
// • ijTopLeft : coordinates of the top left corner of the rectangle
// containing the whole polygon.


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

    // Setting default values if not given by the user
    if ~isdef('input_polygon','l') | type(input_polygon) == 0 then
        input_polygon = [];
    end
    
        if ~isdef('editpoly','l') | type(editpoly) == 0 then
        editpoly = %f;
    end

    // Checking the type of the matrix of the summits
    msg_2 = "%s: Argument #%d : Must be a [N ; 2] matrix of integers describing the N summits of (x,y) coordinates";
    
    if ~(type(input_polygon) == 1) then
        if ~(size(input_polygon, 2) == 2) |  ~(size(input_polygon, 2) == 0)  then
            error(msprintf(msg_2, 'jimroi', 2))
        end
    end

    // Allowing the polygon to be empty if the user wants to edit it interactively
    if  input_polygon == [] & editpoly == %f then
        msg_4 = "%s: Argument #%d : Must be a [N ; 2] matrix of integers describing the N summits of (x,y) coordinates. \n It can be an empty matrix only if edit is True."
         error(msprintf(msg_4, 'jimroi', 2))
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
    
    // Interactive edition of the polygon
    if input_polygon ~=[] then
        xd = input_polygon(:,1)
        yd = input_polygon(:,2)
    else
        xd = [] ; yd = []
    end
    
    if editpoly then
        jimdisp(image);
        [x,y] = edit_curv(xd,yd)
        polygon = floor([x,y]),
    else
        polygon = input_polygon
    end
        
        
    // Creating the mask
    mask = jimcreateMask(polygon, Matrix);
    
    
    // Cropping the mask
    if crop2polygon then
        mask = jimcropMask(polygon, Matrix, mask)
    end
    
    // Returning ijTopleft
    poly_top = max(polygon(:,2));
    poly_bot = min(polygon(:,2));
    poly_left = min(polygon(:,1));
    poly_right = max(polygon(:,1));

    ijTopLeft = [size(Matrix,1)-poly_top+1 ,poly_left];


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

    x_poly = input_polygon(:,1);
    y_poly = input_polygon(:,2);

    x2 = x_poly ;
    y2 = h - y_poly +1 ;

    // The polygon now displays the same shape than the summits describe.
    
    // Creating the boolean mask
    xa = [1:1:h];
    ya = [1:1:w];
    [x,y] = meshgrid (xa, ya);
    [in,on] = moc_inpolygon (x, y, x2, y2);
    output_mask = in | on;
 

endfunction

function out_mask = jimcropMask (input_polygon, mat_image, input_mask)
// This subfunction is used to crop the mask to the minimal rectangle
// within which the polygon is contained.
// • input_polygon : a [N ; 2] matrix containing the summits of the
// polygon (correctly sorted for the polygone to avoid any
// intersection)
// • mat_image : a single, 3- or 4-layered matrix or hypermatrix.
// • input_mask : a (hyper)matrix of boolean of the same size of mat_image.
// • out_mask : a (hyper)matrix of boolean.
    
    [h,w] = size(mat_image);
    
    poly_top = max(input_polygon(:,2));
    poly_bot = min(input_polygon(:,2));
    poly_left = min(input_polygon(:,1));
    poly_right = max(input_polygon(:,1));

    out_mask = input_mask(h-poly_top:h-poly_bot+1,poly_left:poly_right)
        
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
    
    // Returning the final cropped mask
    out_mask = out_mask(n_bot:n_top,n_left:n_right)
    
endfunction
