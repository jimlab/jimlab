// This file is part of Jimlab, an external module coded for Scilab 
//  and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Gaël SENÉE
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function jim = jimage(image, varargin)
    // This function creates a jimage object from a matrix or hypermatrix and
    // specific fields.
    // It can also set new values to the fields of an already existing jimage object.
    // image : a single-layered matrix, or a three- or four-layered hypermatrix.
    // This matrix is converted in uint8.
    // The following fields are configurable (varargin entries) :
    // MIME type : A specific string of characters ('png', 'jpg', 'bmp' or 'gif').
    // Encoding : A specific string of characters ('rgb', 'rgba' or 'gray').
    // TransparencyColor : A value or vector.
    // All of these three fields are required in order to create a new jimage oject.
    // Only one entry can be filled in order to replace an existing field.
    // The field filename has a default value 'user' when a new jimage object is created.
    
    // WIP.
    // • Transparency Color types are to be checked.
    // • Missing : Checking whether the encoding corresponds to the dimensions of the
    // matrix or hypermatrix.

    if argn(2) > 5 then
        error('Too many input arguments : five fields describe jimage objects, four of them being configurable by users')
    end
    

    for i = 1:length(varargin)

        select varargin(i)

            // MIME type field
            case 'png' then
                mime = 'png'
            case 'jpg' then
                mime = 'jpg'
            case 'gif' then
                mime = 'gif'
            case 'bmp' then
                mime = 'bmp'
                
            // Encoding field
            case 'gray' then
                encoding = 'gray'
            case 'rgb' then
                encoding = 'rgb'
            case 'rgba' then
                encoding = 'rgba'
                
        end
        
        // Transparency Color field
        if type(varargin(i)) == 8 | type(varargin(i)) == 1 then
            transparencyColor = varargin(i);
        end
       
    end
    
    // Case of a jimage object : fields have to be replaced by the new values.
    
    if typeof(image) == 'jimage' then
        
        if isdef('encoding','l') then
            image.encoding = encoding ;
        end
        
        if isdef('mime','l') then
            image.mime = mime ;
        end
    
        if isdef('transparencyColor','l') then
            image.transparencyColor = transparencyColor ;
        end

        jim = image ;
        
        
    // Case of a new jimage object : values have to be set on all the fields.
    
    else
        
        // Conversion in Jimlab standard format : uint8
        // mat_image = jimstandard(image)
        mat_image = image;
        
        // Setting the default file name
        filename = 'user';
        
        // Creating the jimage object
        fields = ['jimage','image','encoding','filename','mime','transparencyColor'];
        jim = mlist(fields, mat_image, encoding, filename, mime, transparencyColor);
    end
    
endfunction
