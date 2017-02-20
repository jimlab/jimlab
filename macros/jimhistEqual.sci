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
        N = dim(1)*dim(2)
        gray = length(dim) == 2
        
        //Case of a matrix with gray levels
        if gray & ~jim
            //Calcul of the cumulated histogram
            x = [0:1:256]
            data = double(jimage)
            [cf, ind] = histc(x, data, normalization = %t)
            //cf2(1)=cf(1);
            //colorMap(1) = 255*cf2(1)
            tmp = 0
            for i = 1:length(cf)
                tmp = tmp + cf(i)
                newLevel(i) = tmp*255
            end
            for i = 1:dim(1)
                for j = 1:dim(2)
                    equalizedJimage(i,j) = newLevel(ind(i,j))
                end
            end
            equalizedJimage = uint8(equalizedJimage)
        end
     else
        msg = _("%s: Argument #%d: M-list or encoded integer(s) of type (%s) ..
        or %s expected.\n");
        error(msprintf(msg,"jimhistEqual",1,"uint8","hypermet"));
     end
 endfunction
