// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function Mod_image = jimnegative(image)
	//This function returns the negative of an image 
	//image : an object reprensenting an image (jimage, matrix or hypermatrix)
	//Mod_image : the negative of image
	
	// If a jimage argument is used, will be a jimage object with the same properties than input jimage.
    if(typeof(image) == "jimage")
        arg_Jimage = 1;
        dim = size(image);  // Definition of image's size
        height = dim(1);
        width = dim(2);
        im = image.image;
    elseif((typeof(image) == "hypermat")|(ndims(image) >= 2)) // Testing aruments's type
        arg_Jimage = 0;
        width = size(image,2);  // Definition of image's size
        height = size(image,1);
        im = image;
    else
        error("Not any jimage or matrix argument have been definded")     
    end
    
    [im, originalType] = jimstandard(im);
    
     if((size(im,3) == 4)|(size(im,3) == 3))// Verify if Mat is a 2D or 3D matrix 
         Encoding = "rgb"; // Alpha channel isn't modified
     elseif(size(im,3) == 1) // For 2D matrix
         Encoding = "gray";
      else    
        error("Argument Mat is not a matrix")
     end
  
   
    convMat = 255 * ones(height,width); // Creating the conversion matrix
    
    select Encoding,
        case "gray" then
        
            convertedImage =  convMat - im;// Convertion algorithm  
            
        case "rgb" then
        
            im(:,:,1) = convMat - im(:,:,1); 
            im(:,:,2) = convMat - im(:,:,2);
            im(:,:,3) = convMat - im(:,:,3);  
            convertedImage = im;

    end
   
   if(arg_Jimage)
       
    Mod_image = mlist(["jimage","image","encoding","title","mime","transparencyColor"],..
     convertedImage, image.encoding, image.title, image.mime, image.transparencyColor);

   else
       Mod_image =  convertedImage;
   end
   
endfunction

