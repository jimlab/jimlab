 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 //
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

 function [Color] = jimGetUnusedColor(image, targetColor)
     
     // test of the first argument and convertion in uint8 if necessary
     if (typeof(image) ~= "jimage") then
         [image, originalType] = jimstandard(image);
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
         if (isdef(targetColor, 'l') & type(targetColor) ~= 0)
            if (length(targetColor) ~= 1) then
                msg = _("%s: Argument #%d: Scalar (1 element) expected.\n");
                error(msprintf(msg,"jimGetUnusedColor", 2));
            elseif (targetColor < 0 | targetColor > 255) then
                msg = _("%s: Argument #%d: Must be in the interval [%d, %d].\n");
                error(msprintf(msg,"jimGetUnusedColor", 2, 0, 255));
            end
        else
            targetColor = 255;
        end
         
         targetColor = uint8(targetColor);
         usedColors = unique(image);
         if (intersect(usedColors, targetColor) == []) then
             Color = targetColor;
         else
             //If the target color is used, the nearest value is returned
             targetInf = targetColor;
             targetSup = targetColor;
             while (~isdef('Color','l'))
                if targetInf > 0
                    targetInf = targetInf - 1;
                end
                if targetSup < 255
                    targetSup = targetSup + 1;
                end
                if (intersect(usedColors, targetInf) == []) then
                    Color = targetInf;
                    warning('targetColor is used, the nearest unused color in the image is returned.');
                elseif (intersect(usedColors, targetSup) == []) then
                    Color = targetSup;
                    warning('targetColor is used, the nearest unused color in the image is returned.');
                end
                if (targetInf == 0 & targetSup == 255) then
                    //case where all colors are used
                    [ibins, counts] = dsearch(image, [0:255], "d");
                    counts = flipdim(counts, 2)
                    [oc, Color] = min(counts);
                    Color = uint8(256-Color);
                    warning("All colors are used. Color is the least used color in the image.")
                end
            end
         end
         
     elseif (size(image, 3) == 3 | size(image, 3) == 4)
         //case of a RGB encoded image
         
         //Checking targetColor input argument
         if (isdef('targetColor', 'l') & type(targetColor) ~= 0)
            if (size(targetColor) ~= [1. 1. 3.]) then
                msg = _("%s: Argument #%d: Hypermatrix with 3 elements expected.\n");
                error(msprintf(msg,"jimGetUnusedColor", 2));
            else
                for i = 1:3
                    if (targetColor(i) < 0 | targetColor(i) > 255) then
                        msg = _("%s: Argument #%d: Components must be in the interval [%d, %d].\n");
                        error(msprintf(msg,"jimGetUnusedColor", 2, 0, 255));
                    end
                end
            end
        else
            targetColor = cat(3, 255, 255, 255)
        end
         
         targetColor = uint32(targetColor(1)).*16^4 + uint32(targetColor(2)).*16^2 + uint32(targetColor(3));
         // Getting the colors used in the image
         pixelList = matrix(image(:,:,1:3), -1, 3);
         //Conversion in uint32 in the aim to be able to use dseach()
         colorList = uint32(pixelList(:,1)).*16^4 + uint32(pixelList(:,2)).*16^2 + uint32(pixelList(:,3));
         [ibins, counts] = dsearch(colorList, [0:16777215], "d");
         if (counts(targetColor + 1) == 0)
             Color32 = targetColor;
         else
             targetInf = targetColor;
             targetSup = targetColor;
             while (~isdef('Color32','l'))
                if targetInf > 0
                    targetInf = targetInf - 1;
                end
                if targetSup < 16777215
                    targetSup = targetSup + 1;
                end
                if (counts(targetInf + 1) == 0) then
                    Color32 = targetInf;
                    warning('targetColor is used, the nearest unused color in the image is returned.');
                elseif (counts(targetSup + 1) == 0) then
                    Color32 = targetSup;
                    warning('targetColor is used, the nearest unused color in the image is returned.');
                end
                if (targetInf == 0 & targetSup == 16777215) then
                    //case where all colors are used
                    counts = flipdim(counts, 2)
                    [oc, Color32] = min(counts);
                    Color32 = 16777216-Color32;
                    warning("All colors are used. Color is the least used color in the image.")
                end
            end
         end
         // The output argument is formatted as an hypermatrix of uint8
         Color(1,1,1) = floor(Color32./uint32(16^4));
         tmp = modulo(Color32,uint32(16^4));
         Color(1,1,2) = floor(tmp./uint32(16^2)); 
         Color(1,1,3) = modulo(Color32, uint32(16^2));
         Color = uint8(Color);    
     end
    
endfunction
