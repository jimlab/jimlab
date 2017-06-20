// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Gaël SENÉE
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function jim = jimage(image, varargin)
    // This function creates a jimage object from a matrix or hypermatrix.
    // image : a single-layered matrix, or a three- or four-layered hypermatrix.
    // This matrix is converted in jimage standard format (uint8).
    // Options (varargin) :
    // • jimstandard() optional arguments are available : "colormap", "colorBits"
    // and "argb?"
    // • Several fields of the jimage object can be set :
    //   - "title" : the title of the image ;
    //   - "mime" : the mime type of the image ("jpg", "png", "bmp" or "gif") ;
    //   - "transparency" : the transparency color of the image (a scalar for grayscale
    //     images or a hypermatrix with three components for rgba and rgba images).
    // These fields are to be set in pairs ("field 1","value 1","field 2,"value 2"...).



    // % Standard errors & warnings for this function %

    msg_string = _("%s: Argument #%d : Wrong type. A string is expected.")
    msg_mime = _("%s: Argument #%d : Wrong argument. ""png"", ""jpg"", ""bmp"", or ""gif"" expected.")
    msg_transp = _("%s: Argument #%d : Scalar or hypermatrix with 3 components expected.")
    msg_matdims = _("%s: Argument #%d : An image can be represented only by a 1, 3 or 4 layered matrix or hypermatrix. ")

    // % Checking the input arguments %

    [outputs,inputs] = argn(0);

    // Checking the jimstandard() options
    if inputs > 1 & (varargin(1) == "colormap" | varargin(1) == "colorBits" | varargin(1) == "argb?") then
        disp("oui")
        standard_options = varargin(1)
        standard_opt_check = 1
    else
        standard_opt_check = 0
    end
    
    // Conversion in Jimlab standard format : uint8
    if (isdef("standard_options", "l") & type(standard_options) ~= 0) then
        mat_image = jimstandard(image, standard_options);
    else
        mat_image = jimstandard(image)
    end


    // % Retrieving the values of the fields of jimage %

    // Setting default MIME type
     mime = ""

    // Setting the default file name
    title = ""
        
    // Setting the default transparency color
    transColor = -1

    // Only if optional arguments are given
    if inputs > 1 then
        
        // If jimstandard() arguments are given, they shouldn't be counted as
        // part of the jimage fields.
        // There's no need to check the last argument, and the first is the matrix
        // so varargin has to be decreased twice.
        for i = 1 + standard_opt_check : inputs-2
            select varargin(i)

                case "mime" then
                    if varargin(i+1) == "png" | varargin(i+1) == "jpg" |..
                       varargin(i+1) == "gif" | varargin(i+1) == "bmp" then
                        mime = varargin(i+1)
                    else
                        warning(msprintf(msg_mime, "jimage", i+2))
                        warning("Default value will be used.")
                    end
                    
                case "title"
                    if type(varargin(i+1)) == 10 then
                        title = varargin(i+1)
                    else
                        warning(msprintf(msg_string, "jimage", i+2))
                        warning("Default value will be used.")
                    end
                    
                case "transparency"
                    if type(varargin(i+1)) ~= 10 ..
                        & (length(varargin(i+1)) == 3 | length(varargin(i+1)) == 1) ..
                        & (find(varargin(i+1) > 255) == [] & find(varargin(i+1) < -1) == []) then
                            transColor = varargin(i+1)
                    else
                        warning(msprintf(msg_transp, "jimage", i+2))
                        warning("Default value will be used.")
                    end

            end
        end

    end

    // Checking the encoding of the image
        
    select size(mat_image,3)
        case 1 then
            encoding = "gray"
        case 3 then
            encoding = "rgb"
        case 4 then
            encoding = "rgba"
        else
          error(msprintf(msg_matdims,"jimage",1));
    end
        
    // Creating the jimage object
    fields = ["jimage","image","encoding","title","mime","transparencyColor"];
    jim = mlist(fields, mat_image, encoding, title, mime, transColor);
    
endfunction
