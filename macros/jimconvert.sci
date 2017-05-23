 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 //
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

 function [convertedJimage] = jimconvert(jimage, encoding, transparencyColor)
                                        
     // test of the first argument
     if (typeof(jimage) == "jimage") then
         //extraction of metadata from jimage object
         mime = jimage.mime;
         name = jimage.title;
         ext = '.' + mime;
         // Priority for a transparencyColor explicitely given
         if (~isdef("transparencyColor", "l") | type(transparencyColor) == 0.)
            transparencyColor = jimage.transparencyColor;
         end
         jimage = jimage.image;
         jim = %t;
         bw = %f;
     elseif (type(jimage) == 4) 
         jim = %f;
         bw = %t; 
         convertedJimage = uint8(jimage) * 255;
         if (encoding ~= "gray")
             warning("Your image has been converted into gray encoding")
         end
     else 
         //conversion in uint8 if necessary, jimstandard() default values are used
         [jimage, originalType] = jimstandard(jimage);
         name = 'your ';
         ext = 'image';
         jim = %f;
         bw = %f;
         if (type(jimage) == 4) then
             if (jimage == %f) then
                msg = _("%s: Argument #%d: Wrong type of input argument.\n");
                error(msprintf(msg,"jimconvert", 1));
            end
         end
     end
     
     //test of transparencyColor argument
     //must be a scalar or a vector/hypermatrix with 3 components
     //must in the intervalle [0:255]
     if (isdef("transparencyColor","l") & type(transparencyColor) ~= 0) then
         l = length(transparencyColor);
         i = 1:l;
         if (l ~= 3. & l ~= 1.)
             msg1 = _("%s: Argument #%d: Scalar or hypermatrix with 3 components expected.\n");
             error(msprintf(msg1,"jimconvert", 3));
         elseif (find(transparencyColor(i) > 255) ~= [] | find(transparencyColor(i) < -1) ~= [])
             msg2 = _("%s: Argument #%d: Components of transparencyColor must be in the intervalle [0,255].\n");
             error(msprintf(msg2,"jimconvert", 3));
         end
     else
         transparencyColor = -1;
         l = 1;
     end
     
     //        transparencyColor = cat(3, transparencyColor(1), transparencyColor(2)..
     //      , transparencyColor(3));
     
     if (type(encoding) == 10)

       select encoding
       case 'gray' then
           //transparencyColor must be a scalar in this case
           if l == 3.
               transparencyColor = 0.299 .* transparencyColor(1) + ..
        0.587 .* transparencyColor(2) + 0.114 .* transparencyColor(3);
           end
           
           if (size(jimage,3) == 4)
               transparency = jimage(:,:,4) == 0;
               //Coefficients given by Matplot() function
               jimage = double(jimage);
               convertedMat = 0.299 .* jimage(:,:,1) + 0.587 .* ..
                                        jimage(:,:,2) + 0.114 .* jimage(:,:,3);
               if (transparencyColor == -1)
                   transparencyColor = 255;
               end
               transparencyMat = uint8(transparency) .* transparencyColor;
               convertedMat = convertedMat .* uint8(~transparency);
               convertedJimage = uint8(convertedMat) + uint8(transparencyMat);
               //If no pixel is transparent, the field transparencyColor of the jimage object is -1
               if (find(transparency) == [])
                   transparencyColor = -1;
               end
           elseif (size(jimage,3) == 3)
               jimage = double(jimage);
               //Coefficients are the same used by Matplot() 
               convertedJimage = 0.299 .* jimage(:,:,1) + 0.587 .* ..
                                        jimage(:,:,2) + 0.114 .* jimage(:,:,3);
               //convertedJimage = round(convertedJimage);
               convertedJimage = uint8(convertedJimage);
           elseif bw ~= %t
               msg = _("%s: %s cannot be converted into gray encoding.\n");
               error(msprintf(msg,"jimconvert", name + ext));
           end
       case 'rgb' then
           if (size(jimage, 3) == 4)
               //By default transparencyColor is white
               if transparencyColor(1) == -1
                   transparencyColor = cat(3, 255, 255, 255);
               elseif size(transparencyColor, 3) ~= 3.
                   msg = _("%s: Argument #%d: hypermatrix with 3 components expected.\n");
                   error(msprintf(msg,"jimconvert", 3));
               end
               transparency = jimage(:,:,4) == 0;
               transparencyMat(:,:,1) = uint8(transparency) .* ..
                                        transparencyColor(1);
               transparencyMat(:,:,2) = uint8(transparency) .* ..
                                         transparencyColor(2);
               transparencyMat(:,:,3) = uint8(transparency) .* ..
                                          transparencyColor(3);
               convertedMat(:,:,1) = jimage(:,:,1) .* uint8(~transparency);
               convertedMat(:,:,2) = jimage(:,:,2) .* uint8(~transparency);
               convertedMat(:,:,3) = jimage(:,:,3) .* uint8(~transparency);
               convertedJimage = uint8(transparencyMat) + convertedMat;
               if (find(transparency) == [])
                   transparencyColor = -1;
               end
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
                    encoding, name, mime, int16(transparencyColor));
       end
    else 
       msg = _("%s: Argument #%d: Text(s) expected.\n");
       error(msprintf(msg,"jimconvert",2));
    end
    
endfunction
