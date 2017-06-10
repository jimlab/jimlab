// This file is part of Jimlab, 
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function jimageR = %jimage_e(i, varargin)
    // Extractions from a jimage:
    v = varargin;
    clear varargin
    jimageR = v($);
    imageR = jimageR.image;
    nL = size(imageR,3);
    tC = jimageR.transparencyColor
    jimageR.transparencyColor = -1;
    if length(v)>1 then
        j = v(1);
        if length(v)>2
            // Jimage(i,j,k): only given layers are processed
            k = round(v(2));
            // $ used in k range:
            if  type(k)==129 then
                tmp = [1:nL 4]
                if tmp(k)==[]
                    msg = _("jimage(:,:,k): The k range extracts nothing.");
                    error(msg)
                end
                k = tmp(k)         // K is now explicit
            end
            // GRAY image
            // ----------
            if nL==1   
                // k must be a single value in [-1 1 4]
                if length(k)~=1 & ~or(k==[-1 1 4])
                    msg = _("jimage(:,:,k): k must be unique and in [-1 1 4].");
                    error(msg)
                end
                if k==-1
                    if tC~=-1
                        imageR(imageR==tC) = 0
                    end
                elseif k==4     // we return the transparency mask
                    imageR = uint8(imageR~=tC)*255
                end
                
             // COLORED image
             // -------------
            else
                // To keep a jimage format, we must extract 1, 3 or 4 layers:
                if ~or(length(k)==[1 3 4])
                    msg = _("jimage(:,:,k): Wrong number of extracted layers. 1, 3, or 4 layers expected.");
                    error(msg);
                end
                // Indices must be valid:
                if or(abs(k) > 4)
                    msg = _("jimage(:,:,k): Wrong index of layer to extract. |k| values must be <= 4.");
                    error(msg)
                end
                // If the input image is in RGB, we create its alpha layer
                //  according to the .transparencyColor value:
                if nL==3
                    alpha = ones(imageR(:,:,1))*255;    // default layer
                    if tC~=-1
                        tmp = matrix(permute(imageR, [3 2 1]), 3, -1);
                        k_tP = vectorfind(tmp, tC(:), "c");
                        alpha(k_tP) = 0;
                    end
                    imageR(:,:,4) = alpha
                else
                    alpha = imageR(:,:,4);
                end
                alpha = double(alpha)/255;
                
                // Extraction of a single layer: => GRAY
                // .....................................
                if length(k)==1
                    if k>0 | k==-4
                        imageR = imageR(:,:,k);
                    elseif k<0
                        imageR = uint8(double(imageR(:,:,abs(k))) .* alpha);
                    else // k==0
                        imageR = uint8(alpha*0);
                    end
                    jimageR.encoding = "gray";
                    t = ["[Null]" "[Red]" "[Green]" "[Blue]" "[Alpha]"];
                    ti = jimageR.title;
                    if grep(ti, " ")~=[]
                        ti = "("+ti+")";
                    end
                    jimageR.title =  ti + " " + t(abs(k)+1);
                else
                    // Extraction of several layers: => RGB or RGBA
                    // ............................................
                    image = [];
                    for n = 1:length(k)
                        u = k(n);
                        if u>0
                            image(:,:,n) = imageR(:,:,u);
                        elseif u<0
                            image(:,:,n) = uint8(double(imageR(:,:,u)) .* alpha);
                        else
                            image(:,:,n) = uint8(alpha*0);
                        end
                    end
                    // The 4th layer is still supposed to be the alpha one
                    // If some negative indices have been used, the alpha layer
                    // has already be used in the corresponding layers.
                    // So we delete the alpha layer to prevent using it twice:
                    if or(k<0) & length(k)>3
                        image(:,:,4:$) =  [];
                    end
                    imageR = image;
                    clear image
                    if size(imageR,3)==3
                        jimageR.encoding = "rgb"
                    else
                        jimageR.encoding = "rgba"
                    end
                    // Updating the title
                    t = ["0" "R" "G" "B" "A"];
                    ti = jimageR.title;
                    if grep(ti, " ")~=[]
                        ti = "("+ti+")";
                    end
                    tmp = "[";
                    tmp = tmp + t(abs(k(1))+1);
                    if k(1)<0
                        tmp = tmp + "*A";
                    end
                    for n = 2:size(imageR,3)
                        tmp = tmp + " " + t(abs(k(n))+1);
                        if k(n)<0 & n<4
                            tmp = tmp + "*A";
                        end
                    end
                    jimageR.title =  ti + " " + tmp + "]";
                end  // if length(k)
            end // if nL==1
        else
            // Jimage(i,j): all layers are processed
            imageR = imageR(i,j,:);
        end
    else
        // Jimage(k): linearized indices over each layer. All layers are processed.
        // The result is a column x layers.
        nL = size(imageR,3)
        image = ones(length(i),1,nL);
        image = [];
        for k = 1:nL
            tmp = imageR(:,:,k);
            image = cat(3,image, tmp(i));
        end
        imageR = image
    end
    jimageR.image = imageR;
endfunction
