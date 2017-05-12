// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

// Tests of mean(jimage) overload
// ------------------------------
path = jimlabPath("/") + "tests/images/";
Files = path + ["noError/gray.jpg" "lena_color.gif" "noError/rgba.png"];
v = getversion("scilab");
if v(1)==5 | v(2)>0 | v(3)>0  // mean() is actually overloadable
    for f = Files
        jimage = jimread(f);
        image = double(jimage.image);
        // Conditionning the reference
        if ndims(image)>2 & size(image,3)>3
            image = image(:,:,1:3);
        end
        if ndims(image)>2
            ref = mean(mean(image(:,:,1:3),1),2);
        else
            ref = mean(image)
        end
        assert_checkalmostequal(mean(jimage), ref);
        assert_checkalmostequal(mean(jimage,1), mean(image,1));
        assert_checkalmostequal(mean(jimage,2), mean(image,2));
        assert_checkalmostequal(mean(jimage,"r"), mean(image,1));
        assert_checkalmostequal(mean(jimage,"c"), mean(image,2));
        assert_checkalmostequal(mean(jimage,"m"), mean(image,1));
    end
end
