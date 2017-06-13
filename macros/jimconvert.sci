// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function [convertedJimage] = jimconvert(Jimage, encoding, transparency)
    //This function converts an image encoding into RGB or gray levels.
    //Jimage : an object representing an image (jimage object, hypermatrix or matrix)
    //encoding : a word "gray", "rgb" et "rgba" giving the output encoding
    //transparency : the color shade allocated to every transparent pixel, a scalar or a vector/hypermatrix with 3 components in [0,255] 
    //convertedJimage : the converted image encoded in uint8 in RGBA, RGB or gray levels

    // test of the second argument : "gray", "rgb" or "rgba"
    if(~isdef("encoding", "l") | type(encoding) == 0)
        msg = _("%s: Argument #%d: The output encoding is not given.\n");
        error(msprintf(msg, "jimconvert", 2));
    else
        if (type(encoding) ~= 10)
            msg = _("%s: Argument #%d: Text(s) expected.\n");
            error(msprintf(msg,"jimconvert",2));
        else
            stdr_encoding = strstr(["rgba","rgb","gray"], encoding);
            if (stdr_encoding == [""])
                msg = _("%s: Argument #%d: rgba, rgb or gray expected.\n");
                error(msprintf(msg,"jimconvert",2));
            end
        end
    end

    // test of the first argument
    if (typeof(Jimage) == "jimage") then
        //extraction of metadata from jimage object
        mime = Jimage.mime;
        name = Jimage.title;
        ext = "." + mime;
        jimTC = Jimage.transparencyColor;
        // Priority for a transparency explicitely given
        if (~isdef("transparency", "l") | type(transparency) == 0.)
            if (jimTC(1) ~= -1)
                if (length(jimTC) == 3. & encoding == "gray")
                    transparency = [0.299 0.587 0.114] * jimTC(:);
                else
                    transparency = jimTC;
                end
            end
        end
        Jimage = Jimage.image;
        jim = %t;
        bw = %f;
    elseif (type(Jimage) == 4)
        // boolean image : %t = white, %f = black
        jim = %f;
        bw = %t;
        convertedJimage = uint8(Jimage) * 255;
        if (encoding ~= "gray")
            warning("Your image has been converted into gray encoding")
        end
    else
        //conversion in uint8 if necessary, jimstandard() default values are used
        [Jimage, originalType] = jimstandard(Jimage);
        name = "your ";
        ext = "image";
        jim = %f;
        bw = %f;
        if (type(Jimage) == 4) then
            if (Jimage == %f) then
                //jimstandard() returns %f if the image is not handled
                msg = _("%s: Argument #%d: Wrong type of input argument.\n");
                error(msprintf(msg,"jimconvert", 1));
            end
        end
    end

    //test of transparency argument
    //must be a scalar or a vector/hypermatrix with 3 components
    //must in the intervalle [0:255]
    if (isdef("transparency","l") & type(transparency) ~= 0) then
        if (min(transparency) > 0. & max(transparency) < 1.)
            transparency = uint8(255 * transparency);
        elseif (min(transparency) < -1 | max(transparency) > 255.)
            msg = _("%s: Argument #%d: Components of transparency must be in the intervalle [0,255] or [0,1].\n");
            error(msprintf(msg, "jimconvert", 3));
        end
        dimTC = size(transparency);
        l = max(dimTC);
        if (encoding == "gray" & l ~= 1.)
            msg = _("%s: Argument #%d: Scalar expected.\n");
            error(msprintf(msg, "jimconvert", 3));
        elseif (encoding == "rgb" & l ~= 3.)
            msg = _("%s: Argument #%d: hypermatrix with 3 components expected.\n");
            error(msprintf(msg, "jimconvert", 3));
        elseif encoding == "rgba"
            if dimTC == size(Jimage)
                alpha = %t;
            elseif (l == size(Jimage, 3))
                alpha = %f
            elseif (l ~= size(Jimage, 3))
                msg = _("%s: Argument #%d and #%d: Dimensions must agree.\n");
                error(msprintf(msg, "jimconvert", 1, 3));
            else
                msg = _("%s: Argument #%d: Scalar, alpha channel matrix or hypermatrix with 3 components expected.\n");
                error(msprintf(msg, "jimconvert", 3));
            end
        end
    else
        transparency = -1;
        l = 1;
    end



    select encoding

    case "gray" then

        //RGBA=>Gray
        if (size(Jimage,3) == 4)
            transparencyMask = Jimage(:,:,4) == 0;
            //Coefficients given by Matplot() function
            Jimage = double(Jimage);
            convertedMat = 0.299 .* Jimage(:,:,1) + ..
                           0.587 .* Jimage(:,:,2) + ..
                           0.114 .* Jimage(:,:,3);
            // If no pixel is transparent and Jimage.transparencyColor = -1,
            //this value is kept
            //A modifier éventuellement apres réponse de S. Gougeon
            if (transparency == -1 & find(transparencyMask) ~= [])
                transparency = 255;
            end
            transparencyMat = uint8(transparencyMask) .* transparency;
            convertedMat = convertedMat .* uint8(~transparencyMask);
            convertedJimage = uint8(convertedMat) + uint8(transparencyMat);

        //RGB=>Gray
        elseif (size(Jimage,3) == 3)
            Jimage = double(Jimage);
            // Coefficients are the same used by Matplot()
            convertedJimage = 0.299 .* Jimage(:,:,1) + ..
                              0.587 .* Jimage(:,:,2) + ..
                              0.114 .* Jimage(:,:,3);
            convertedJimage = uint8(convertedJimage);
        
        //Gray=>Gray
        elseif (size(Jimage,3) == 1.)
            convertedJimage = Jimage;
            warning("Your image has not been modified.")
        end
           
    case "rgb" then
        
        //RGBA=>RGB
        if (size(Jimage, 3) == 4.)
            transparencyMask = Jimage(:,:,4) == 0;
            // By default transparency is white
            if (transparency(1) == -1)
                transparency = cat(3, 255, 255, 255);
            end
            //All pixel with transparency are filled with transparencyColor
            transparencyMat(:,:,1) = uint8(transparencyMask) * transparency(1);
            transparencyMat(:,:,2) = uint8(transparencyMask) * transparency(2);
            transparencyMat(:,:,3) = uint8(transparencyMask) * transparency(3);
            convertedMat(:,:,1) = Jimage(:,:,1) .* uint8(~transparencyMask);
            convertedMat(:,:,2) = Jimage(:,:,2) .* uint8(~transparencyMask);
            convertedMat(:,:,3) = Jimage(:,:,3) .* uint8(~transparencyMask);
            //addition of the transparent pixels and the non-transparent ones
            convertedJimage = uint8(transparencyMat) + convertedMat;
            //A modifier éventuellement apres réponse de S. Gougeon
            if (find(transparencyMask) == [] & isdef("jimTC", "l") & jimTC(1) == -1)
                transparency = -1;
            end
            
        //RGB=>RGB
        elseif (size(Jimage,3) == 3.)
            convertedJimage = Jimage;
            warning("Your image has not been modified.");
               
        //Gray=>RGB
        elseif (size(Jimage,3) == 1.)
            dim = size(Jimage);
            tmp = [Jimage, Jimage, Jimage];
            convertedJimage = matrix(tmp, [dim(1), dim(2), 3]);
        end

    case "rgba" then
            
        //RGBA=>RGBA
        if (size(Jimage, 3) == 4.)
            convertedJimage = Jimage;
            warning("Your image has not been modified.");
            
        //RGB=>RGBA
        elseif (size(Jimage, 3) == 3.)
            convertedJimage = Jimage;
            if (isdef("alpha", "l"))
                if alpha
                    convertedJimage(:,:,4) = transparency;
                else
                    transparency = uint32(transparency(1)).*16^4 + uint32(transparency(2)).*16^2 + uint32(transparency(3));
                    tmp = uint32(Jimage(:,:,1)).*16^4 + uint32(Jimage(:,:,2)).*16^2 + uint32(Jimage(:,:,3));
                    convertedJimage(:,:,4) = 255 * uint8(tmp ~= transparency)
                end
            else
                convertedJimage(:,:,4) = 255 * ones(size(Jimage, 1:2));
            end
            convertedJimage = uint8(convertedJimage)
        
        elseif (size(Jimage, 3) == 1.)
            dim = size(Jimage);
            tmp = [Jimage, Jimage, Jimage];
            convertedJimage = matrix(tmp, [dim(1), dim(2), 3]);
            if (isdef("alpha", "l"))
                if alpha
                    convertedJimage(:,:,4) = uint8(transparency);
                else
                    convertedJimage(:,:,4) = 255 * uint8(Jimage ~= transparency)
                end
            else
                convertedJimage(:,:,4) = 255 * ones(size(Jimage, 1), size(Jimage, 2));
            end
            convertedJimage = uint8(convertedJimage)
        end
    end
    if jim
        //if a jimage object is given, the output object must be a jimage. 
        convertedJimage = mlist(["jimage","image","encoding",..
        "title","mime","transparencyColor"], convertedJimage, ..
        encoding, name, mime, int16(transparency));
    end


endfunction
