 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 //
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

 function [convertedJimage] = jimconvert(jimage, encoding, ..
                                        transparencyColor, varargin)
                                        
     //test of transparencyColor argument
     //must be a hypermatrix with three components in the intervalle [0:255]
     if (isdef('transparencyColor',"l") & type(transparencyColor) ~= 0) then
         if (size(transparencyColor, 3) == 3.) 
             for i = 1:3
                 if (transparencyColor(i) > 255 | transparencyColor(i) < 0)
                     msg = _("%s: Argument #%d: Components of transparencyColor must be in the intervalle [0:255].\n");
                     error(msprintf(msg,"jimconvert", 3));
                 end
             end
             transparencyColor = uint8(transparencyColor);
         else
             msg = _("%s: Argument #%d: hypermatrix with 3 components expected.\n");
             error(msprintf(msg,"jimconvert", 3));
         end
     end
     
     // test of the first argument and convertion in uint8 if necessary
     if (typeof(jimage) == "jimage") then
         mime = jimage.mime;
         name = jimage.title;
         //Priority for the intput argument 
         if (~isdef('transparencyColor', 'l') | type(transparencyColor) == 0)
            transparencyColor = jimage.transparencyColor;
            //If there is no transparencyColor, white is choosen by default
            if (transparencyColor(1) == -1 & jimage.encoding == 'rgba')
                transparencyColor = cat(3, uint8(255), uint8(255), uint8(255));
            end
         end
         ext = '.' + mime;
         jimage = jimage.image;
         jim = %t;
         bw = %f;
     elseif (type(jimage) == 4) 
         jim = %f;
         bw = %t; 
         name = 'your ';
         ext = 'image';
     else 
         if (~isdef('varargin', 'l') | type(varargin) == 0)
             [jimage, originalType] = jimstandard(jimage);
         else
            [jimage, originalType] = jimstandard(jimage, varargin(:));
         end
         name = 'your ';
         ext = 'image';
         if (~isdef('transparencyColor', 'l') | type(transparencyColor) == 0)
             //If there is no transparencyColor, white is choosen by default
            transparencyColor = cat(3, uint8(255), uint8(255), uint8(255));
         end
         jim = %f;
         bw = %f;
         //jimstandard() return %f if the (hyper)matrix encoding is not supported by jimlab
         if (type(jimage) == 4) then
             if (jimage == %f) then
                msg = _("%s: Argument #%d: Wrong type of input argument.\n");
                error(msprintf(msg,"jimconvert", 1));
            end
         end
     end
     
     if (type(encoding) == 10)

       select encoding
       case 'gray' then
           if (size(jimage,3) == 4)
               if (~isdef('varargin', 'l') | type(varargin) == 0)
                   jimage = jimconvert(jimage, 'rgb', transparencyColor)
                   transparencyColor = 0.299 .* transparencyColor(:,:,1) + ..
        0.587 .* transparencyColor(:,:,2) + 0.114 .* transparencyColor(:,:,3);
               else
                   jimage = jimconvert(jimage,'rgb', transparencyColor, ..
                                                            varargin(:));
                   transparencyColor = 0.299 .* transparencyColor(:,:,1) + ..
        0.587 .* transparencyColor(:,:,2) + 0.114 .* transparencyColor(:,:,3);
               end
           end
           if (size(jimage,3) == 3)
               jimage = double(jimage);
               //Coefficients are the same used by Matplot() 
               convertedJimage = 0.299 .* jimage(:,:,1) + 0.587 .* ..
                                        jimage(:,:,2) + 0.114 .* jimage(:,:,3);
               convertedJimage = round(convertedJimage);
               convertedJimage = uint8(convertedJimage);
               if (length(transparencyColor) == 3)
                   transparencyColor = 0.299 .* transparencyColor(:,:,1) + ..
        0.587 .* transparencyColor(:,:,2) + 0.114 .* transparencyColor(:,:,3);
                end
           elseif bw == %t
               convertedJimage = uint8(jimage) * 255;
           else
               msg = _("%s: %s cannot be converted into gray encoding.\n");
               error(msprintf(msg,"jimconvert", name + ext));
           end
       case 'rgb' then
           if (size(jimage, 3) == 4)
               transparency = jimage(:,:,4) == 0;
               transparencyMat(:,:,1) = uint8(transparency) .* ..
                                        transparencyColor(:,:,1);
               transparencyMat(:,:,2) = uint8(transparency) .* ..
                                         transparencyColor(:,:,2);
               transparencyMat(:,:,3) = uint8(transparency) .* ..
                                          transparencyColor(:,:,3);
               convertedMat(:,:,1) = jimage(:,:,1) .* uint8(~transparency);
               convertedMat(:,:,2) = jimage(:,:,2) .* uint8(~transparency);
               convertedMat(:,:,3) = jimage(:,:,3) .* uint8(~transparency);
               convertedJimage = transparencyMat + convertedMat;
           else
               msg = _("%s: %s cannot be converted into rgb encoding.\n");
               error(msprintf(msg,"jimconvert", name + ext));
           end
       else
           msg = _("%s: Argument #%d: rgb or gray expected.\n");
           error(msprintf(msg,"jimconvert",2));
       end
       if jim
           convertedJimage = mlist(['jimage','image','encoding',..
           'title','mime','transparencyColor'], convertedJimage, ..
                    encoding, name, mime, transparencyColor);
       end
    else 
       msg = _("%s: Argument #%d: Text(s) expected.\n");
       error(msprintf(msg,"jimconvert",2));
    end
    
endfunction
