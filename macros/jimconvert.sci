 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 //
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

 function [convertedJimage] = jimconvert(jimage, encoding)
     
     // test of the first argument and convertion in uint8 if necessary
     if (typeof(jimage) ~= "jimage") then
         [jimage, originalType] = jimstandard(jimage);
         if (jimage == %f) then
             msg = _("%s: Argument #%d: Wrong type of input argument.\n");
             error(msprintf(msg,"jimconvert", 1));
         end
     else
         image = image.image;
         jim = %t;
     end
     
     if (type(encoding) == 10)
       jim = typeof(jimage) == "jimage"
       if jim
           mime = jimage.mime;
           name = jimage.title;
           ext = '.' + mime;
           jimage = jimage.image;
       else
           name = 'your ';
           ext = 'image';
       end
            
       select encoding
       case 'gray' then
           if (typeof(jimage) == "hypermat")
               jimage = double(jimage);
               //Coefficients are the same used by Matplot() 
               convertedJimage = (0.299 .* jimage(:,:,1) + 0.587 .* jimage(:,:,2) + ..
                                                    0.114 .* jimage(:,:,3))/3;
               convertedJimage = round(convertedJimage);
               convertedJimage = uint8(convertedJimage);
           else
               msg = _("%s: %s cannot be converted into gray encoding.\n");
               error(msprintf(msg,"jimconvert", name + ext));
           end
       case 'rgb' then
           if (size(jimage, 3) == 4)
               convertedJimage = jimage(:,:,[1:3]);
           else
               msg = _("%s: %s cannot be converted into rgb encoding.\n");
               error(msprintf(msg,"jimconvert", name + ext));
           end
       else
           msg = _("%s: Argument #%d: rgb or gray expected.\n");
           error(msprintf(msg,"jimconvert",2));
       end
       if jim
           convertedJimage = mlist(['jimage','image','encoding',..
           'title','mime'], convertedJimage, encoding, name, ..
                                                       mime);
       end
    else 
       msg = _("%s: Argument #%d: Text(s) expected.\n");
       error(msprintf(msg,"jimconvert",2));
    end
    
endfunction
