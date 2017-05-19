 //Copyright (C) 2017 - ENSIM, Université du Maine - Gaël SENÉE
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt


function jim = jimage2(image, varargin)

// Known errors :
// filename is set by default on 'user'.

    if argn(2) > 5 then
        error('Too many input arguments : five fields describe jimage objects, four of them being configurable by users')
    end
    
    if typeof(image) == 'jimage' then
        jim = jimageSet(image, varargin)
    
    else
        jim = jimageCreate (image, varargin)
        
    end
    
endfunction

function jim = jimageSet (image, varargin)
// This subfunction allows the user to replace any field of a jimage object.
// varargin takes specific strings of characters to set the MIME type and the
// encoding fields, any string of character to set the filename field and
// a value or vector to set the transparency color field.


    for i = 1:length(varargin(1))

        select varargin(1)(i)

            // MIME type
            case 'png' then
                image.mime = 'png'
            case 'jpg' then
                image.mime = 'jpg'
            case 'gif' then
                image.mime = 'gif'
            case 'bmp' then
                image.mime = 'bmp'
                
            // Encoding
            case 'gray' then
                image.encoding = 'gray'
            case 'rgb' then
                image.encoding = 'rgb'
            case 'rgba' then
                image.encoding = 'rgba'
        end

        // Transparency Color
        if type(varargin(1)(i)) == 8 | type(varargin(1)(i)) == 1 then
            image.transparencyColor = varargin(1)(i);
        end

    end

    jim = image;

endfunction
    
    
function jim = jimageCreate (image, varargin)
// This subfunction creates a jimage object from a matrix and specified fields.
// The input arguments are affected to the fields depending on their type.
// Some specific strings of characters are dedicated to particular fields.

    for i = 1:length(varargin(1))
        
        // Matrix
        mat_image = image;
        

        select varargin(1)(i)

            // MIME type
            case 'png' then
                mime = 'png'
            case 'jpg' then
                mime = 'jpg'
            case 'gif' then
                mime = 'gif'
            case 'bmp' then
                mime = 'bmp'
                
            // Encoding
            case 'gray' then
                encoding = 'gray'
            case 'rgb' then
                encoding = 'rgb'
            case 'rgba' then
                encoding = 'rgba'
                
        end
        
        // Transparency Color
        if type(varargin(1)(i)) == 8 | type(varargin(1)(i)) == 1 then
            transparencyColor = varargin(1)(i);
        end
       
    end
    
    filename = 'user';
    fields = ['jimage','image','encoding','filename','mime','transparencyColor'];
    jim = mlist(fields, mat_image, encoding, filename, mime, transparencyColor);

endfunction
