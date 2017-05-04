 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 //
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

 function [Color] = jimGetUnusedColor(image, targetColor, varargin)
     
     // test of the first argument and convertion in uint8 if necessary
     if (typeof(jimage) ~= "jimage") then
         [image, originalType] = jimstandard(image, varargin(:));
         if (type(image) == 4)
            if (image == %f) then
                msg = _("%s: Argument #%d: Wrong type of input argument.\n");
                error(msprintf(msg,"jimGetUnusedColor", 1));
            end
        end
     else
         image = image.image;
     end
     
     
     if (size(image, 3) == 1) then
         //case of an image in gray levels

         //Checking targetColor input argument 
         //must be a scalar if the image is in gray levels
         if (length(targetColor) ~= 1) then
             msg = _("%s: Argument #%d: Scalar (1 element) expected.\n");
             error(msprintf(msg,"jimGetUnusedColor", 2));
         elseif (targetColor < 0 | targetColor > 255) then
             msg = _("%s: Argument #%d: Must be in the interval [%d, %d].\n");
             error(msprintf(msg,"jimGetUnusedColor", 2, 0, 255));
         end
         
         targetColor = uint8(targetColor);
         usedColors = unique(image)
         if (intersect(usedColors, targetColor) == []) then
             Color = targetColor;
         else
             //If the target color is used, the nearest value is returned
             while (~isdef('Color','l') | type(Color) == 0)
                if targetInf > 0
                    targetInf = targetColor - 1;
                end
                if targetSup < 255
                    targetSup = targetColor + 1;
                end
                if (intersect(usedColors, targetInf) == []) then
                    Color = targetInf;
                    warning('targetColor is used, the nearest unused color in the image is returned.\n');
                elseif (intersect(usedColors, targetSup) == []) then
                    Color = targetSup;
                    warning('targetColor is used, the nearest unused color in the image is returned.\n');
                end
                if (targetInf == 0 & targetSup == 255) then
                    //case where all colors are used
                    [ibins, counts] = dsearch(image, [0:255], "d");
                    counts = flipdim(counts, 2)
                    [oc, Color] = min(counts);
                    Color = uint8(256-Color);
                    warning("All colors are used. Color is the least used color in the image.\n")
                end
            end
         end
         
     elseif (size(image, 3) == 3)
         //case of a RGB encoded image
         
         //Checking targetColor input argument
         if (size(targetColor) ~= [1. 1. 3.]) then
             msg = _("%s: Argument #%d: Hypermatrix with 3 elements expected.\n");
             error(msprintf(msg,"jimGetUnusedColor"));
         else
             for i = 1:3
                if (targetColor(i) < 0 | targetColor(i) > 255) then
                    msg = _("%s: Argument #%d: Components must be in the interval [%d, %d].\n");
                    error(msprintf(msg,"jimGetUnusedColor", 2, 0, 255));
                end
            end
         end
         
         // Getting the colors used in the image
         pixelList = matrix(image, -1, 3);
         
         
         // usedColors = unique(pixelList, 'r');
         
     end
    
endfunction
