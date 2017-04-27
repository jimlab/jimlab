//Copyright (C) 2017 - ENSIM, Université du Maine - Alix Melaine Mnoubue
//This file must be used under the terms of the CeCILL.
//This source file is licensed as described in the file COPYING, which
//you should have received as part of this distribution. The terms
//are also available at
//http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function [IMB] =jimsmooth(im, type_filter, varargin)
    //test arguments
    if( argn(2) <2) then
        error('Invalid number of arguments.' ) ;
    end

    if( argn(2) <3) then
        width=3;
         mat_filter = jimsmooth_mask(type_filter,width) ;
    end

    if(argn(2) >=3 ) then
        if(length(varargin) ==1) then
            width=varargin(1) ;
             mat_filter = jimsmooth_mask(type_filter,width) ;
        end
        if(length(varargin) ==2) then
            if(~( isequal(type_filter, 'customize' ))) then
                warning('The filter type should be customize' ) ;
            end
            width=varargin(1) ;
            if(~ modulo(length(varargin(2)) , 3) )
                mat_filter=varargin(2);
            else 
                error('the length of the matrix must be odd and bigger than 1' ) ;

            end

        end
    end
   
   
  

    // Testing arguments's typetype_filter
    if(typeof(im) == 'hypermat' ) then
        mat_image = im;
    elseif(typeof(im) == 'jimage' ) then
        mat_image = im. image;
    else
        error('Not any jimage or matrix argument have been defined' );
    end

    if((ndims(mat_image) == 4) | (ndims(mat_image) == 3)) // Verify if Mat is a 2D
        type_image = "rgb"; // Alpha channel isn't modified
    elseif(ndims(mat_image) == 2) // For 2D matrix
        type_image = "gray";
    else
        error("Argument Mat is not a matrix");
    end

    select type_image,
    case "gray" then
        IMB= uint8(conv2(mat_filter, double( mat_image))) ;
    case "rgb" then
        // Convolve the three separate color .
        mat_image(:,:,1)=conv2(double(mat_image(:,:,1)),mat_filter,'same');
        mat_image(:,:,2)=conv2(double(mat_image(:,:,2)),mat_filter,'same');
        mat_image(:,:,3)=conv2(double(mat_image(:,:,3)),mat_filter),'same');
        
        //Recombine separate color channels into a single
        RGB = cat(3, uint8( mat_image(:,:,1)), uint8( mat_image(:,:,2)), uint8( mat_image(:,:,3)));
        IMB=RGB;

    end

endfunction

//Function returning the specified input mask
function [matMask] =jimsmooth_mask(type_filter, width)

    order=2;
    //testing the parity of Width mask

    if(modulo(width, 3) <>0 | width<3 ) error('the width must be odd' ) ; end;
    // mat =mask(width);//the mask of filter
    select type_filter


    case "gaussien" then
        ic = int(width/2) +1; // index of the center
        sigma = (width/2) /order;
        // Matrix of distances to the mask's center:
        [X,Y] = meshgrid(1: width) ;
        // Creation of the 2D gaussian profile/weights
        matMask = exp(-((X-ic) .^2 + (Y-ic) .^2) /2/sigma^2) ;
        // Normalization:
        matMask = matMask/sum(matMask) ;
    case "rectangular" then
        matMask = (1/width^2) *ones(width,width) ;
        // case "uniform" then matMask = (1/width^2) *ones(width,width) ;
    case "triangular" then

        if(width > 3) then
            mat=(1/width^2) *ones(width,width) ;
            matMask = conv2(mat,mat) ;
        else
            error('the size of this filter musb be bigger than 3' ) ;
        end

    else
        error('this filter does not exits' ) ;
    end

endfunction
