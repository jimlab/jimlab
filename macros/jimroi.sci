// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Gaël SENÉE
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function [mask, polygon, ijTopLeft] = jimroi(image, input_polygon, varargin)

// INPUT ARGUMENTS
// • image : jimage object, single layered matrix, 3- or 4-layered hypermatrix.
// • input_polygon : summits of the polygon the user wants to select.
// It consists of an N lines and 2 columns array containing the (x,y) coordinates
// of the N summits of the polygon.
// If empty or wrong, an interactive edition of the polygon is forced.
// • options (varargin) :
// "edit" allows the user to select summits of the polygon interactively,
// "crop" returns the mask cropped to the size of the minimal rectangle containing
// the polygon.

// OUTPUT ARGUMENTS
// • mask : the function returns a boolean matrix or hypermatrix :
// %T inside the polygon and on its sides, and %F outside the polygon.
// • polygon : returns the output polygon, changed by the interactive edition
// or not.
// • ijTopLeft : coordinates of the top left corner of the rectangle
// containing the whole polygon.

    // % Standard errors for this function %
    msg_points = _("%s: Three points must be selected at least in order to select a polygon.")
    msg_options = _("%s: Argument %s : The optional arguments available are ""crop"" or ""edit"".")
    msg_summits = _("%s: Argument #%s : Must be an array of integers describing the N summits of (x,y) coordinates")
    msg_emptypoly = _("%s: Argument #%d : A wrong or empty polygon has been given. Forcing the interactive edit.")
    msg_nbarg = _("%s: Too many input arguments (must be < 5).")
    msg_matrix = _("%s: Argument #%d : A (hyper)matrix of 1, 3 or 4 layers, or a jimage object must be given")
    
    
    // % The algorithm will depend on the number of input parameters %

    [outputs,inputs]=argn(0);

    if inputs > 4 then
    warning(msprintf(msg_nbarg, "jimroi"))
    warning("Arguments up to #4 will be considered, the others will be ignored.")
    end

    // % Argument # 1 : Checking the type of the input image %
    if (isdef("image","l") & type(image) ~= 0)
        if typeof(image) == "jimage" then
            Matrix = image.image;
        else
            Matrix = jimstandard(image);
        end
    else
        error(msprintf(msg_matrix, "jimroi", 1));
    end

    // % Argument # 2 : Setting default polygon if not given by the user %
    if ~isdef("input_polygon","l") | type(input_polygon) == 0 then
        input_polygon = [];
    end
    
    // Checking the type of the matrix of the summits
    
    if ~(type(input_polygon) == 1) then
        if ~(size(input_polygon, 2) == 2) |  ~(size(input_polygon, 2) == 0)  then
            error(msprintf(msg_summits, "jimroi", 2))
        end
    end

    // Arguments #3 & #4 : Setting default values
    if inputs == 4 & type(varargin(2)) == 0 then
        varargin(2) = "";
        inputs = inputs-1 ;
        warning(msprintf(msg_options, "jimroi", "#4"))
        warning("Default value will be used.")
    end
    
    if inputs == 4 & type(varargin(1)) == 0 then
        varargin(1) = "";
        varargin(1) = varargin(2);
        varargin(2) = "";
        inputs = inputs-1 ;
        warning(msprintf(msg_options, "jimroi", "#3"))
        warning("Default value will be used.")
    end

    if inputs == 3 & type(varargin(1)) == 0 then
        varargin(1) = "";
        inputs = inputs-1 ;
        warning(msprintf(msg_options, "jimroi", "#3"))
        warning("Default value will be used.")
    end


    // % Setting default values for the interactive edition %

    if input_polygon == [] then
        xd = [] ; yd = [] ;
    else
        xd = input_polygon(:,1) ;
        yd = input_polygon(:,2) ;
    end

select inputs
    
    // A matrix or jimage is the only input argument
    // The mask is uncropped and the interactive edit is forced
    case 1 then

        jimdisp(image)
        [x,y] = edit_curv(xd,yd) ;
        
        if size(x) < 3 then
            error(msprintf(msg_points, "jimroi"))
        end
        
        polygon = floor([x,y]);
        mask = jimcreateMask(polygon, Matrix);
        
    // A predefined polygon is given
    case 2 then
    
    // If the polygon is empty, the interactive edit is forced
    if input_polygon == [] then
        warning(msprintf(msg_emptypoly, "jimroi", 2))
        jimdisp(image)
        [x,y] = edit_curv(xd,yd) ;
        
        if size(x) < 3 then
            error(msprintf(msg_points, "jimroi"))
        end
        
        polygon = floor([x,y]);
    
    else
        polygon = input_polygon
    end
        mask = jimcreateMask(polygon, Matrix) ;

    // An optional argument is given : "crop" or "edit"
    case 3 then
    
         select varargin(1)
            case "crop" then
                if input_polygon == [] then
                    warning(msprintf(msg_emptypoly, "jimroi", 2))
                    jimdisp(image)
                    [x,y] = edit_curv(xd,yd) ;
    
                    if size(x) < 3 then
                        error(msprintf(msg_points, "jimroi"))
                    end
    
                    polygon = floor([x,y]);
    
                else
                    polygon = input_polygon
                end
                mask = jimcreateMask(polygon, Matrix) ;
                mask = jimcropMask(polygon, Matrix, mask) ;

            case "edit" then
                jimdisp(image)
                [x,y] = edit_curv(xd,yd)
                
                if size(x) < 3 then
                    error(msprintf(msg_points, "jimroi"))
                end
                
                polygon = floor([x,y]);
                mask = jimcreateMask(polygon, Matrix);
            
            else 
                error(msprintf(msg_options, "jimroi","#3"))
        end

    // The user wants to edit the polygon and crop the mask
    case 4 then
        
        if varargin(1) == "edit" | varargin(2) == "edit" then
            jimdisp(image)
            [x,y] = edit_curv(xd,yd)
            
            if size(x) < 3 then
                error(msprintf(msg_points, "jimroi"))
            end
            
            polygon = floor([x,y]);
            mask = jimcreateMask(polygon, Matrix);
        else
                error(msprintf(msg_options, "jimroi","#3 & #4"))
        end
        
        if varargin(1) == "crop" | varargin(2) == "crop" then
            mask = jimcropMask(polygon, Matrix, mask)
        else
                error(msprintf(msg_options, "jimroi","#3 & #4"))
        end
        
    end


    // % Returning ijTopleft
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
    xa = [1:1:w];
    ya = [1:1:h];
    [x,y] = meshgrid (xa, ya);
    [in,on] = moc_inpolygon (x, y, x2, y2);
    output_mask = (in | on);

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

    out_mask = input_mask(h-poly_top:h-poly_bot+1,poly_left:poly_right) ;

    // Border corrections : suppressing the extreme lines filled with %F
    [h_mask, w_mask] = size(out_mask) ;

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
