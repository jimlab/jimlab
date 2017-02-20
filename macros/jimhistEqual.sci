 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 //
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

 function [equalizedJimage] = jimhistEqual(jimage)
     if (typeof(jimage) == "jimage" | typeof(jimage) == "hypermat" | ..
                                        typeof(jimage) == "uint8") 
        jim = typeof(jimage) == "jimage"
        dim = size(jimage)
        gray = length(dim) == 2
        
        if gray & ~jim
            x = [0:1:256]
            data = double(jimage)
            [cf, ind] = histc(x, data, normalization = %t)
            tmp = 0
            data = string(data)
            for i = 1:length(cf)
                tmp = tmp + cf(i)
                cf(i) = 255*tmp
                tmp2 = string(ind(i))
                tmp3 = string(cf(i))
                equalizedJimage = strsubst(data, tmp2, tmp3)
            end
            equalizedJimage = strtod(equalizedJimage)
            equalizedJimage = uint8(equalizedJimage)
        end
     else
        msg = _("%s: Argument #%d: M-list or encoded integer(s) of type (%s) ..
        or %s expected.\n");
        error(msprintf(msg,"jimhistEqual",1,"uint8","hypermet"));
     end
     endfunction
