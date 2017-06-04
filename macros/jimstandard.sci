//Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas Aegerter
//Copyright (C) 2017 - ENSIM, Université du Maine - Camille Chaillous
 
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function [convertedMat, originalType] = jimstandard(imageMat,opt)
    
    //Detection of the optionnal input argument
    if (isdef("opt", "l") & type(opt) ~= 0) then
        if type(opt) == 4
            argb? = opt;
        elseif type(opt) == 10
            stdr_colorsBits = strstr(["444","555","4444","5551","332"], opt);
            if(stdr_colorsBits ~= [])
                colorsBits = opt;
            else
                warning("Wrong second input argument, default values will be used");
            end
        elseif opt == 1.
            argb? = %t;
        elseif opt == 0.
            argb? = %f;
        elseif size(opt, 2) == 3.
            if(max(opt) > 1. | min(opt) < 0)
                msg = _("%s: Argument #%d: coefficients of the colormap must be in the intervalle[0,1].\n");
                error(msprintf(msg,"jimstandard", 2));
            else
                colormap = opt;
            end
        elseif opt == gcf()
            // opt can be a graphic handle , the current colormap will be used
            f = gcf();
            colormap = f.color_map;
        else
            msg = _("%s: Argument #%d: Wrong type of input argument.\n");
            error(msprintf(msg,"jimstandard", 2));
        end
    end
    
    
    //If the type is not supported by jimstandard(), the function returns false
    convertedMat = %f;
    originalType = 0;
    layers = size(imageMat, 3);
    
    if (isdef("colormap", "l"))
        //If a colormap is given, the image is considered as indexed
        dim = size(imageMat)
        imageDouble = colormap(imageMat,:)
        convertedMat = matrix(imageDouble, dim(1), dim(2), -1)
        convertedMat = uint8(255*convertedMat);
        originalType = "ind";
    else
        //If the image is not indexed, the conversion depends on the type of the input matrix/hypermatrix
        if (type(imageMat(1,1,1)) == 1.)     
            // real matrix or hypermatrix can be an equivalent matrix of integers
            if((max(imageMat) <= 1.) & (min(imageMat) >= 0.)) then
                convertedMat = uint8(255*imageMat);
                originalType = ["double"];
            elseif ((max(imageMat) <= 255.) & (min(imageMat) >= 0.))
                imageMat = uint8(imageMat);
            elseif ((max(imageMat) <= 127.) & (min(imageMat) >= -128.))
                imageMat = int8(imageMat);
            elseif ((max(imageMat) <= 2^16-1) & (min(imageMat) >= 0.))
                imageMat = uint16(imageMat);
            elseif ((max(imageMat) <= 2^15-1) & (min(imageMat) >= -(2^15)))
                imageMat = int16(imageMat);
            elseif ((max(imageMat) <= 2^32-1) & (min(imageMat) >= 0.))
                imageMat = uint32(imageMat);
            elseif ((max(imageMat) <= 2^31-1) & (min(imageMat) >= -(2^31)))
                imageMat = int32(imageMat);
            end
        end
        
        t = type(imageMat(1,1,1));
        select(t)
        case 4. then     //boolean matrix
            convertedMat = uint8(255*imageMat);
            originalType = "bool";
        case 8. then     //matrix of integer
            tmp = inttype(imageMat(:,:,1));
            if (tmp == 1.) then
                convertedMat = uint8(imageMat)                                    
                originalType = "int8";
                if isdef("colorsBits", "l") & colorsBits == "332"
                    image = uint16(convertedMat);
                    r = modulo(image,uint16(2^8));
                    convertedMat(:,:,1) = floor(r./uint16(2^5));
                    g = modulo(image,uint16(2^5));
                    convertedMat(:,:,2) = floor(g./uint16(2^2));
                    convertedMat(:,:,3) = modulo(image,uint16(2^2));
                    convertedMat(:,:,1:2) = double(convertedMat(:,:,1:2)) * 255/7;
                    convertedMat(:,:,3) = double(convertedMat(:,:,3)) * 255/3;
                    convertedMat = uint8(convertedMat);
                    originalType = [originalType, "332"];
                end
            elseif(tmp == 11.)
                convertedMat = imageMat;
                originalType = "uint8";
                if isdef("colorsBits", "l") & colorsBits == "332"
                    image = uint16(convertedMat);
                    r = modulo(image,uint16(2^8));
                    convertedMat(:,:,1) = floor(r./uint16(2^5));
                    g = modulo(image,uint16(2^5));
                    convertedMat(:,:,2) = floor(g./uint16(2^2));
                    convertedMat(:,:,3) = modulo(image,uint16(2^2));
                    convertedMat(:,:,1:2) = double(convertedMat(:,:,1:2)) * 255/7;
                    convertedMat(:,:,3) = double(convertedMat(:,:,3)) * 255/3;
                    convertedMat = uint8(convertedMat);
                    originalType = [originalType, "332"];
                end
            elseif(tmp == 12.) then
                // matrix of uint16
                if (~isdef('colorsBits', "l") | type(colorsBits) == 0) then
                    colorsBits = '4444';
                    warning('The type of encoding is not given. By default, the type rgba4444 is used');
                elseif (colorsBits == "332") then
                    warning('Wrong binary encoding. By default, the type rgba4444 is used');
                end
                convertedMat = jimstandard_uint16(imageMat,colorsBits);
                originalType = ["uint16", colorsBits];
            elseif(tmp == 2.) then
                // matrix of int16
                if (~isdef('colorsBits', "l") | type(colorsBits) == 0) then
                    colorsBits = '4444';
                    warning('The type of enconing is not given. By default, the type rgba4444 is used');
                elseif (colorsBits == "332") then
                    warning('Wrong binary encoding. By default, the type rgba4444 is used');
                end
                tmp = uint16(imageMat);
                convertedMat = jimstandard_uint16(tmp,colorsBits);
                originalType = ["int16", colorsBits];
            elseif (tmp == 14.) then
                 convertedMat = jimstandard_uint32(imageMat);
                 originalType = "uint32";
           elseif(tmp == 4.) then
                 tmp = uint32(imageMat); 
                 convertedMat = jimstandard_uint32(tmp);
                 originalType = "int32";
            end
        end
    end
    
    // If the hypermatrix has more than four layers, it cannot represent an image. 
    if (layers > 4 | layers == 2) then
        convertedMat = %f;
        originalType = 0;
    end
    
    if(isdef("argb?","l") & argb? & layers == 4) then // If argb standard is used, convertion in rgba standard
        test = ["int16","uint16"];
        if(strstr(test,originalType(1)) == "")
           tmp = convertedMat(:,:,1);
           convertedMat(:,:,1:3) = convertedMat(:,:,2:4);
           convertedMat(:,:,4) = tmp;
       end
       originalType = [originalType;"argb"];
   end
   
endfunction


 function [convertedMat] = jimstandard_uint32(image)
     //This subfunction is called by jimstandard(). 
     //It converts a matrix of uint32 into a hypermatrix of uint8 with 4 layers. 
     //image : a matrix of uint32 
     //convertedMat : a hypermatrix of uint8 with 4 layers. The value of each layer corresponds to one byte of the uint32. 
     

     convertedMat(:,:,4) = floor(image./uint32(16^6));
     r = modulo(image,uint32(16^6));
     convertedMat(:,:,1) = floor(r./uint32(16^4));
     g = modulo(image,uint32(16^4));
     convertedMat(:,:,2) = floor(g./uint32(16^2));
     convertedMat(:,:,3) = modulo(image,uint32(16^2))
     
     convertedMat = uint8(convertedMat);
    
 endfunction
 
 function [convertedMat] = jimstandard_uint16(image, colorsBits)
     //This subfunction is called by jimstandard(). 
     //It converts a matrix of uint16 into a hypermatrix of uint8 with 3 or 4 layers. 

     //image : a matrix of uint16 
     //colorsBits : a string. '444', '555', '4444' or '5551'. This arguments enable to know the number of bits used by each components.
     //convertedMat : a hypermatrix of uint8 with 3 or 4 layers. The value of each layer corresponds to one components of the uint16 value. 
     
     select(colorsBits)
     case '444' then
         //This case corresponds to image_type "rgb444" in Matplot_properties
        r = modulo(image,uint16(16^3));
        convertedMat(:,:,1) = floor(r./uint16(16^2));
        g = modulo(image,uint16(16^2));
        convertedMat(:,:,2) = floor(g./uint16(16));
        convertedMat(:,:,3) = modulo(image,uint16(16));
        convertedMat = double(convertedMat) * 255/15;
        convertedMat = uint8(convertedMat);
     case '555' then
         //This case corresponds to image_type "rgb555" in Matplot_properties
         r = modulo(image,uint16(2^15));
         convertedMat(:,:,1) = floor(r./uint16(2^10));
         g = modulo(image,uint16(2^10));
         convertedMat(:,:,2) = floor(g./uint16(2^5));
         convertedMat(:,:,3) = modulo(image,uint16(2^5))
         convertedMat = double(convertedMat) * 255/31;
         convertedMat = uint8(convertedMat);
     case '4444' then
        //This case corresponds to image_type "rgb4444" in Matplot_properties
        convertedMat(:,:,1) = floor(image./uint16(16^3));
        g = modulo(image,uint16(16^3));
        convertedMat(:,:,2) = floor(g./uint16(16^2));
        b = modulo(image,uint16(16^2));
        convertedMat(:,:,3) = floor(b./uint16(16));
        convertedMat(:,:,4) = modulo(image,uint16(16));
        convertedMat = double(convertedMat) * 255/15;
        convertedMat = uint8(convertedMat);
     case '5551' then
         //This case corresponds to image_type "rgba5551" in Matplot_properties
         convertedMat(:,:,1) = floor(image./uint32(2^11));
         g = modulo(image,uint32(2^11));
         convertedMat(:,:,2) = floor(g./uint16(2^6));
         b = modulo(image,uint16(2^6));
         convertedMat(:,:,3) = floor(b./uint16(2));
         convertedMat(:,:,4) = modulo(image,uint16(2)) * 255;
         convertedMat(:,:,1:3) = double(convertedMat(:,:,1:3)) * 255/31;
         convertedMat = uint8(convertedMat);
     end
    
endfunction
