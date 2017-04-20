//Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas Aegerter
//Copyright (C) 2017 - ENSIM, Université du Maine - Camille Chaillous
 
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function [convertedMat, originalType] = jimstandard(imageMat,colormap,argb,Type)
    
    //If the type is not supported by jimstandard(), the function returns false
    convertedMat = %f;
    originalType = 0;
    if(isdef(["argb"],"l")&(argb ~= "")) then
        // If an hypermatrix is define as ARGB or RGBA
       
        if((argb == 1)|(argb == %t)) then
            argb = %t;
        elseif((argb == 0)|(argb == %f)) then
            argb = %f;
        else 
            warning("Bad argument type for argb, rgba standard"..
            +" will be used.");
            argb = %f;
        end
    else
        argb = %f;
    end
    
    if(isdef(["Type"],"l")&(Type ~= ""))
         argb = %f;
         stdr_Type = strstr(["444","555","4444","5551"],Type);
         if(stdr_Type == "")
             Type = -1;
         end
     else
         Type = %f;
     end
     

    if (isdef(["colormap"],'l')&(colormap ~= "")) then
        //If a colormap is given, the image is indexed
        convertedMat = jimstandard_ind(imageMat, colormap,);
        originalType = "ind";
        
    else 
        t = type(imageMat(:,:,1));
        select(t)
        case 1 then     // Converts a real matrix of real arguments
            if((max(imageMat) == 1.) & (min(imageMat) == 0.)) then
                convertedMat = uint8(255*imageMat);
                originalType = ["double";"0";"1"];
            else
                //If the coefficients are not normalized
                m = min(imageMat);
                M = max(imageMat);
                if(M == 255)
                    m = 0;
                end
                tmp = (imageMat - m)/(M - m);
                convertedMat = uint8(255*imageMat);
                originalType = ["double";string(m);string(M)];
            end
        case 4 then     //boolean matrix
            convertedMat = uint8(255*imageMat);
            originalType = "bool";
        case 8 then     //matrix of integer
            tmp = inttype(imageMat(:,:,1));
            if (tmp == 1) then
                convertedMat = imageMat + 127;
                originalType = "int8";
            elseif(tmp == 11)
                convertedMat = imageMat;
                originalType = "uint8";
            elseif(tmp == 12) then
                convertedMat = jimstandard_uint16(imageMat,Type);
                originalType = "uint16";
            elseif(tmp == 2) then
                tmp = imageMat + 32768;
                convertedMat = jimstandard_uint16(imageMat,Type);
                originalType = "int16";
            elseif (tmp == 14) then
                 convertedMat = jimstandard_uint32(imageMat,argb);
                 originalType = "uint32";
           elseif(tmp == 4) then
                 tmp = imageMat + 2147483648; 
                 convertedMat = jimstandard_uint32(tmp,argb);
                 originalType = "int32";
            end
        end
    end
    
    if(argb) then // If argb standard is used, convertion in rgba standard
        test = ["int16","uint16","int32","uint32"];
        if(strstr(test,originalType) == "")
           tmp = convertedMat(:,:,1);
           convertedMat(:,:,1) = convertedMat(:,:,4);
           convertedMat(:,:,4) = tmp;
       end
       originalType = [originalType;"argb"];
   end
   
endfunction


 function [convertedMat] = jimstandard_uint32(image, argb)
     //This subfunction is called by jimstandard(). 
     //It converts a matrix of uint32 into a hypermatrix of uint8 with 4 layers. 
     //image : a matrix of uint32 
     //argb : a boolean. True if the image is encoded in ARGB and false if the image is encoded in RGBA
     //convertedMat : a hypermatrix of uint8 with 4 layers. The value of each layer corresponds to one byte of the uint32. 
     
     if (~isdef(argb) | type(argb) == 0) then
         argb = %f;
     elseif (type(argb) ~= 4) then
         msg = _("%s: Argument #%d: Boolean expected.\n");
         error(msprintf(msg,"jimstandard_uint32", 2));
     end
     
     if (argb == %t) then
         convertedMat(:,:,4) = floor(image./uint32(16^6));
         r = modulo(image,uint32(16^6));
         convertedMat(:,:,1) = floor(r./uint32(16^4));
         g = modulo(image,uint32(16^4));
         convertedMat(:,:,2) = floor(g./uint32(16^2));
         convertedMat(:,:,3) = modulo(image,uint32(16^2))
     elseif (argb == %f) then
         convertedMat(:,:,1) = floor(image./uint32(16^6));
         g = modulo(image,uint32(16^6));
         convertedMat(:,:,2) = floor(r./uint32(16^4));
         b = modulo(image,uint32(16^4));
         convertedMat(:,:,3) = floor(g./uint32(16^2));
         convertedMat(:,:,4) = modulo(image,uint32(16^2))
     end

    
 endfunction
 
 function [convertedMat] = jimstandard_uint16(image, Type)
     //This subfunction is called by jimstandard(). 
     //It converts a matrix of uint16 into a hypermatrix of uint8 with 3 or 4 layers. 
     //image : a matrix of uint16 
     //Type : a string. '444', '555', '4444' or '5551'. This arguments enable to know the number of bits used by each components.
     //convertedMat : a hypermatrix of uint8 with 3 or 4 layers. The value of each layer corresponds to one components of the uint16 value. 
     
     if (~isdef(Type) | type(Type) == 0) then
         Type = '444';
         warning('The type of enconing is not given. By default, the type rgb444 is used');
     elseif (type(argb) ~= 10) then
         msg = _("%s: Argument #%d: String expected.\n");
         error(msprintf(msg,"jimstandard_uint16", 2));
     end
     
     if (Type == '444') then
         //This case correspond to image_type "rgb444" in Matplot_properties
         convertedMat(:,:,1) = floor(image./uint16(2^12));
         g = modulo(image,uint16(2^12));
         convertedMat(:,:,2) = floor(g./uint16(2^8));
         convertedMat(:,:,3) = modulo(image,uint16(2^4))
     elseif (Type == '555') then
         convertedMat(:,:,1) = floor(image./uint16(2^15));
         g = modulo(image,uint16(2^15));
         convertedMat(:,:,2) = floor(g./uint16(2^10));
         convertedMat(:,:,3) = modulo(image,uint16(2^5))
     elseif (Type == '4444') then
         convertedMat(:,:,1) = floor(image./uint16(2^16));
         g = modulo(image,uint16(2^16));
         convertedMat(:,:,2) = floor(g./uint16(2^12));
         b = modulo(image,uint16(2^12));
         convertedMat(:,:,3) = floor(b./uint16(2^8));
         convertedMat(:,:,4) = modulo(image,uint16(2^4))
     elseif (Type == '5551') then
         convertedMat(:,:,1) = floor(image./uint16(2^16));
         g = modulo(image,uint16(2^16));
         convertedMat(:,:,2) = floor(g./uint16(2^11));
         b = modulo(image,uint16(2^11));
         convertedMat(:,:,3) = floor(b./uint16(2^6));
         convertedMat(:,:,4) = modulo(image,uint16(2))
     else
         msg = _("%s: Argument #%d: Wrong type of encoding.\n");
         error(msprintf(msg,"jimstandard_uint16", 2));
     end

    
 endfunction

