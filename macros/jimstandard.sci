//Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas Aegerter
//Copyright (C) 2017 - ENSIM, Université du Maine - Camille Chaillous
 
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function [convertedMat, originalType] = jimstandard(imageMat,colormap)
    
    //If the type is not supported by jimstandard(), the function returns false
    convertedMat = %f;
    
    if (isdef(["Colormap",'l'])) then
        //If a colormap is given, the image is indexed
        convertedMat = jimstandard_ind(imageMat, colormap);
        originalType = "ind";
    else 
        t = type(imageMat);
        select(t)
        case 1 then     // Converts a real matrix of real arguments
            if((max(imageMat) == 1.) & (min(imageMat) == 0.)) then
                convertedMat = jimstandard_d(imageMat);
                originalType = 1;
            else
                //If the coefficients are not normalized
                m = min(imageMat);
                M = max(imageMat);
                tmp = (imageMat - m)/(M - m);
                convertedMat = jimstandard_d(imageMat);
                originalType = 1;
            end
        case 4 then     //boolean matrix
            convertedMat = uint8(imageMat * 255);
            originalType = 4;
        case 8 then     //matrix of integer
            if (inttype(imageMat) == 1 & min(imageMat) < 0) then
                convertedMat = imageMat + 128;
                originalType = "int8";
            elseif (inttype(imageMat) == 4 & size(imageMat,3) == 1) then
                if (min(imageMat) > 0) then
                    convertedMat = jimstandard_uint32(imageMat);
                    originalType = "uint32";
                else
                    tmp = imageMat + 2147483648;
                    convertedMat = jimstandard_uint32(tmp);
                    originalType = "int32";
                end
            end
        end
    end
endfunction


                 //Converted_Mat = uint8(255*imageMat);
                //else
                 //Converted_Mat = uint8(255*(imageMat/max(imageMat)));
                //en

