
 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 //
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

 function [convertedJimage] = jimconvert(Jimage, encoding, transparencyColor)
	//This function converts an image encoding into RGB or gray levels.
	//Jimage : an object representing an image (jimage object, hypermatrix or matrix)
	//encoding : a word "gray" or "rgb" giving the output encoding
	//transparencyColor : the color shade allocated to every transparent pixel, a scalar or a vector/hypermatrix with 3 components in [0,255]
	//convertedJimage : the converted image encoded in uint8 in RGB or gray levels

     // test of the first argument
     if (typeof(Jimage) == "jimage") then
         //extraction of metadata from jimage object
         mime = Jimage.mime;
         name = Jimage.title;
         ext = '.' + mime;
         // Priority for a transparencyColor explicitely given
         if (~isdef("transparencyColor", "l") | type(transparencyColor) == 0.)
            transparencyColor = Jimage.transparencyColor;
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
         name = 'your ';
         ext = 'image';
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

     //test of transparencyColor argument
     //must be a scalar or a vector/hypermatrix with 3 components
     //must in the intervalle [0:255]
     if (isdef("transparencyColor","l") & type(transparencyColor) ~= 0) then
         l = length(transparencyColor);
         i = 1:l;
         if (l ~= 3. & l ~= 1.)
             msg = _("%s: Argument #%d: Scalar or hypermatrix with 3 components expected.\n");
             error(msprintf(msg, "jimconvert", 3));
         elseif (find(transparencyColor(i) > 255) ~= [] | find(transparencyColor(i) < -1) ~= [])
             msg = _("%s: Argument #%d: Components of transparencyColor must be in the intervalle [0,255].\n");
             error(msprintf(msg, "jimconvert", 3));
         end
     else
         transparencyColor = -1;
         l = 1;
     end

     if(~isdef("encoding", "l") | type(encoding) ==0)
         msg = _("%s: Argument #%d: The output encoding is not given.\n");
         error(msprintf(msg, "jimconvert", 2));
     elseif (type(encoding) == 10)

       select encoding
       case 'gray' then
           //transparencyColor must be a scalar in this case
           if l == 3.
               transparencyColor = [0.299 0.587 0.114] * transparencyColor(:);
           end

           if (size(Jimage,3) == 4)
               transparency = Jimage(:,:,4) == 0;
               //Coefficients given by Matplot() function
               Jimage = double(Jimage);
               convertedMat = 0.299 .* Jimage(:,:,1) + ..
                              0.587 .* Jimage(:,:,2) + ..
                              0.114 .* Jimage(:,:,3);
               if (transparencyColor == -1)
                   transparencyColor = 255;
               end
               transparencyMat = uint8(transparency) .* transparencyColor;
               convertedMat = convertedMat .* uint8(~transparency);
               convertedJimage = uint8(convertedMat) + uint8(transparencyMat);
               // If no pixel is transparent, the field transparencyColor of
               // the jimage object is -1
               if (find(transparency) == [])
                   transparencyColor = -1;
               end
           elseif (size(Jimage,3) == 3)
               Jimage = double(Jimage);
               // Coefficients are the same used by Matplot()
               convertedJimage = 0.299 .* Jimage(:,:,1) + ..
                                 0.587 .* Jimage(:,:,2) + ..
                                 0.114 .* Jimage(:,:,3);
               // convertedJimage = round(convertedJimage);
               convertedJimage = uint8(convertedJimage);
           elseif (size(Jimage,3) == 1.)
               convertedJimage = Jimage;
               warning("Your image has not been modified.")
           end
       case 'rgb' then
           if (size(Jimage, 3) == 4.)
               // By default transparencyColor is white
               if transparencyColor(1) == -1
                   transparencyColor = cat(3, 255, 255, 255);
               elseif size(transparencyColor, 3) ~= 3.
                   msg = _("%s: Argument #%d: hypermatrix with 3 components expected.\n");
                   error(msprintf(msg,"jimconvert", 3));
               end
			   //pixels with 0 on the alpha channel are filled with the transparencyColor
               transparency = Jimage(:,:,4) == 0;
               transparencyMat(:,:,1) = uint8(transparency) * transparencyColor(1);
               transparencyMat(:,:,2) = uint8(transparency) * transparencyColor(2);
               transparencyMat(:,:,3) = uint8(transparency) * transparencyColor(3);
               convertedMat(:,:,1) = Jimage(:,:,1) .* uint8(~transparency);
               convertedMat(:,:,2) = Jimage(:,:,2) .* uint8(~transparency);
               convertedMat(:,:,3) = Jimage(:,:,3) .* uint8(~transparency);
			   //addition of the transparent pixels and the non-transparent ones
               convertedJimage = uint8(transparencyMat) + convertedMat;
			   // If no pixel is transparent, the field transparencyColor of
               // the jimage object is -1
               if (find(transparency) == [])
                   transparencyColor = -1;
               end
           elseif (size(Jimage,3) == 3.)
               convertedJimage = Jimage;
               warning("Your image has not been modified.");
           else
               msg = _("%s: %s cannot be converted into rgb encoding.\n");
               error(msprintf(msg,"jimconvert", name + ext));
           end
       else
           msg = _("%s: Argument #%d: rgb or gray expected.\n");
           error(msprintf(msg,"jimconvert",2));
       end
       if jim
			//if a jimage object is given, the output object must be a jimage. 
           convertedJimage = mlist(['jimage','image','encoding',..
           'title','mime','transparencyColor'], convertedJimage, ..
                    encoding, name, mime, int16(transparencyColor));
       end
    else
       msg = _("%s: Argument #%d: Text(s) expected.\n");
       error(msprintf(msg,"jimconvert",2));
    end

endfunction
