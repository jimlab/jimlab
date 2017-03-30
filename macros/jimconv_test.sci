//Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas Aegerter
 
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function [Converted_Mat, Original_Type] = jimconv(imageMat)
    
    Original_Type = type(imageMat);
    select(Original_Type)
    case 1 then
        
    case 4 then // Convert a boolean matrix
        Converted_Mat = 255*uint8(imageMat);
        
    case 8 then
        if((max(imageMat) == 1)&(min(imageMat) == 0));
            Converted_Mat = 255*uint8(imageMat);
         end
    case 17 then
        
