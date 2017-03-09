 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 //
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

 function [convertedJimage] = jimconvert(jimage, encoding)
     if (typeof(jimage) == "jimage" | typeof(jimage) == "hypermat" | ..
                                type(jimage) == 1 | type(jimage) == 8) 
        if (type(encoding) == 10)
            jim = typeof(jimage) == "jimage"
            if jim
                jimage = jimage.image;
            end
            dim = size(jimage)
            N = dim(1)*dim(2)
            
            select encoding
            case 'gray' then
                jimage = double(jimage);
                convertedJimage = (jimage(:,:,1) + jimage(:,:,2) + ..
                                                      jimage(:,:,3))/3;
            else
                msg = _("%s: Argument #%d: rgb, rgba or gray expected.\n");
                error(msprintf(msg,"jimconvert",2));
            end
            convertedJimage = round(convertedJimage);
            convertedJimage = uint8(convertedJimage);
        else
            msg = _("%s: Argument #%d: Text(s) expected.\n");
            error(msprintf(msg,"jimconvert",2));
        end
     else
        msg = _("%s: Argument #%d: M-list or %s or %s expected.\n");
        error(msprintf(msg,"jimconvert",1,"matrix","hypermat"));
     end
    
endfunction
