//Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas Aegerter
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function image = jiminvert(image)
// If a jimage argument is used, input and output arguments must be the same.
 

    if(type(image) == 1)
        arg_jimage =0;
        width = size(image,2);  // Definition of image's size
        height = size(image,1);
        im = image;
    elseif(type(image) == 17)
        arg_jimage =1;
        width = size(image.image,2);  // Definition of image's size
        height = size(image.image,1);
        im = image.image;
    else
        error('Not any jimage or matrix argument have been definded')     
    end
    
    
     if((ndims(im) == 4)|(ndims(im) == 3))// Verify if Mat is a 2D,3D or 4D matrix 
        Encoding = 'rgb'; // Alpha channel isn't modified
     elseif(ndims(im) == 2)
        Encoding = 'gray';
      else    
        error('Argument Mat is not a matrix')
     end
  
   
    convMat = int(255 * ones(height,width));
    
    select Encoding,
        case 'gray' then
            convertedImage =  jiminvertGray(im,convMat);
        case 'rgb' then
            convertedImage = jiminvertRgb(im,convMat);
    end
   
   if(arg_jimage)
       image.image = convertedImage;
   else
       image =  convertedImage;
   end
   
endfunction

    function convertedImage = jiminvertRgb(im,convMat)
// This sub-function invert an image definded by a 3D or 4D rgb matrix.
// It is called by the function jiminvert.
// im : The wxhx3 3D matrix, convMat : the matrix used for convertion 

      im(:,:,1) = abs(convMat - im(:,:,1)); // Convertion algorithm  
      im(:,:,2) = abs(convMat - im(:,:,2));
      im(:,:,3) = abs(convMat - im(:,:,3));  
      convertedImage = im;

    endfunction



    function convertedImage = jiminvertGray(im,convMat)
// This sub-function invert an image definded by a 2D rgb matrix.
// It is called by the function jiminvert.
// im : The wxh 2D matrix, convMat : the matrix used for convertion 
      
      convertedImage = convMat - im;
         
    endfunction
