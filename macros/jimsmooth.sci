//Copyright (C) 2017 - ENSIM, Université du Maine - Alix Melaine Mnoubue
//This file must be used under the terms of the CeCILL.
//This source file is licensed as described in the file COPYING, which
//you should have received as part of this distribution. The terms
//are also available at
//http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function [IMB] =jimsmooth(Image, varargin)
    //test arguments
    if( argn(2) <2) then
	fogType="gaussian";
	fogWidth=3;
      mat_filter = jimsmooth_mask(fogType,fogWidth) ;
    end
    //number of arguments is two and the width of the filter is 3
    if( argn(2) <3 & (length(varargin) ==1) & (type(varargin(1))==10)) then
        fogType=varargin(1);
        fogWidth=3;
        mat_filter = jimsmooth_mask(fogType,fogWidth) ;
    end

    if(argn(2) >=3) then
        if(length(varargin) ==2) then
            fogType=varargin(2);
            fogWidth=varargin(1) ;
            mat_filter = jimsmooth_mask(fogType,fogWidth) ;
        end
        if(length(varargin) ==3) then
            if(~( isequal(fogType, 'customize' ))) then
                warning('The filter type should be customize' ) ;
            end
            fogWidth=varargin(1) ;
            //test for parity of matrix customize
            if(~ modulo(length(varargin(2)) , 2) )
                mat_filter=varargin(2);
            else 
                error('the length of the matrix must be odd and bigger than 1' ) ;

            end

        end
    end




    // Testing arguments's typetype_filter
    if(typeof(Image) == 'hypermat' ) then
        mat_image = Image;
    elseif(typeof(Image) == 'jimage' ) then
        jimage=1;
        mat_image = Image. image;
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
        result= uint8(conv2(mat_filter, double( mat_image))) ;
    case "rgb" then
        // Convolve the three separate color .
        mat_image(:,:,1)=conv2(double(mat_image(:,:,1)),mat_filter,'same');
        mat_image(:,:,2)=conv2(double(mat_image(:,:,2)),mat_filter,'same');
        mat_image(:,:,3)=conv2(double(mat_image(:,:,3)),mat_filter,'same');

        //Recombine separate color channels into a single
        result = cat(3, uint8( mat_image(:,:,1)), uint8( mat_image(:,:,2)), uint8( mat_image(:,:,3)));


    end
    
        IMB =  result;
  
endfunction

//Function returning the specified input mask
function [matMask] =jimsmooth_mask(fogType, fogwidth)

    order=2;
    //testing the parity of fogwidth mask

    if(modulo(fogwidth, 3) <>0 | fogwidth<3 ) error('the fogwidth must be odd' ) ; end;
    // mat =mask(fogwidth);//the mask of filter
    select fogType


    case "gaussian" then
        ic = int(fogwidth/2) +1; // index of the center
        sigma = (fogwidth/2) /order;
        // Matrix of distances to the mask's center:
        [X,Y] = meshgrid(1: fogwidth) ;
        // Creation of the 2D gaussian profile/weights
        matMask = exp(-((X-ic) .^2 + (Y-ic) .^2) /2/sigma^2) ;
        // Normalization:
        matMask = matMask/sum(matMask) ;
    case "rectangular" then
        matMask = (1/fogwidth^2) *ones(fogwidth,fogwidth) ;
        // case "uniform" then matMask = (1/fogwidth^2) *ones(fogwidth,fogwidth) ;
    case "triangular" then

        if(fogwidth > 3) then
            mat=(1/fogwidth^2) *ones(fogwidth,fogwidth) ;
            matMask = conv2(mat,mat) ;
        else
            error('the size of this filter musb be bigger than 3' ) ;
        end

    else
        error('this filter does not exits' ) ;
    end

endfunction


