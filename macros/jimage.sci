// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Gaël SENÉE
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function jim = jimage(image, standard_options)
    // This function creates a jimage object from a matrix or hypermatrix.
    // image : a single-layered matrix, or a three- or four-layered hypermatrix.
    // This matrix is converted in jimage standard format (uint8).
    // The following fields get a default value :
    // • filename : "user"
    // • mime : "unknown"
    // • transparencyColor : -1


    // Creating the new jimage object : values have to be set on all the fields.
    
    // Conversion in Jimlab standard format : uint8
    if (isdef("standard_options", "l") & type(standard_options) ~= 0) then
        
        mat_image = jimstandard(image, standard_options);
        
    else
        
        mat_image = jimstandard(image)
    
    end

     // Setting default MIME type
     mime = "unknown"

    // Setting the default file name
    title = "user"
        
    // Setting the default transparency color
    transColor = -1
        
    // Checking the encoding of the image
        
    select size(mat_image,3)
        case 1 then
            encoding = "gray"
        case 3 then
            encoding = "rgb"
        case 4 then
            encoding = "rgba"
        else
          msg = _("%s: An image can be represented only by a 1, 3 or 4 layers matrix or hypermatrix. \n");
          error(msprintf(msg,"jimage"));
    end
        
    // Creating the jimage object
    fields = ["jimage","image","encoding","title","mime","transparencyColor"];
    jim = mlist(fields, mat_image, encoding, title, mime, transColor);
    
endfunction
