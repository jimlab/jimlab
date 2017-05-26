// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function jimageR = %jimage_e(i, varargin)
    // Extractions from a jimage:
    v = varargin;
    clear varargin
    jimageR = v($);
    imageR = jimageR.image;
    if length(v)>1 then
        // Jimage(i,j): all layers are processed
        j = v(1);
        imageR = imageR(i,j,:);
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
