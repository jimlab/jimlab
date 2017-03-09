 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 //
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

 function [convertedJimage] = jimconvert(jimage, encoding)
     if (typeof(jimage) == "jimage" | typeof(jimage) == "hypermat") 
        if (type(encoding) == 10)
            jim = typeof(jimage) == "jimage"
            if jim
                name = jimage.title;
                ext = jimage.format;
                jimage = jimage.image;
            else
                name = 'your ';
                ext = 'image';
            end
            
            select encoding
            case 'gray' then
                if (typeof(jimage) == "hypermat")
                    jimage = double(jimage);
                    convertedJimage = (jimage(:,:,1) + jimage(:,:,2) + ..
                                                         jimage(:,:,3))/3;
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
                'title','format'], convertedJimage, encoding, name, ..
                                                            ext);
            end
        else
            msg = _("%s: Argument #%d: Text(s) expected.\n");
            error(msprintf(msg,"jimconvert",2));
        end
     else
        msg = _("%s: Argument #%d: M-list or %s expected.\n");
        error(msprintf(msg,"jimconvert",1,"hypermat"));
     end
    
endfunction
