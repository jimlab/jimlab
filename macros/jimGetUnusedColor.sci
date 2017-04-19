 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 //
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

 function [Color] = jimGetUnusedColor(image, targetColor)
     
     // test of the first argument and convertion in uint8 if necessary
     if (typeof(jimage) ~= "jimage") then
         [image, originalType] = jimstandard(image);
         if (image == %f) then
             msg = _("%s: Argument #%d: Wrong type of input argument.\n");
             error(msprintf(msg,"jimGetUnusedColor", 1));
         end
     else
         image = image.image;
     end
     
     targetColor = uint8(targetColor);
     
     if (size(image, 3) == 1) then
         //case of an image in gray levels
         
         //Checking targetColor input argument 
         //must be a scalar if the image is in gray levels
         if (length(targetColor) ~= 1) then
             msg = _("%s: Argument #%d: Scalar (1 element) expected.\n");
             error(msprintf(msg,"jimGetUnusedColor", 2));
         elseif (targetColor < 0 | targetColor > 255) then
             msg = _("%s: Argument #%d: Must be in the interval [%s, %s].\n");
             error(msprintf(msg,"jimGetUnusedColor", 2, 0, 255));
         end
         
         usedColors = unique(vectImage)
         if (intersect(usedColors, targetColor) == []) then
             Color = targetColor;
         else
             //If the target color is used, the nearest value is returned
             while (~exists('Color','l'))
                targetInf = targetColor - 1;
                targetSup = targetColor + 1;
                if (intersect(usedColors, targetInf) == []) then
                    Color = targetInf;
                elseif (intersect(usedColors, targetSup) == []) then
                    Color = targetSup;
                end
            end
            //Mettre un warning
         end
     end
    
endfunction
