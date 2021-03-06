// This file is part of Jimlab, an external module coded for Scilab
//  and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

// Tests of mean(jimage) overload
// ------------------------------
path = jimlabPath("/") + "tests/images/noError/";
Files = path + ["gray.jpg" "rgb.png" "rgba.png"];
v = getversion("scilab");
if v(1)==5 | v(2)>0 | v(3)>0  // mean() is actually overloadable
    for f = Files
        Jimage = jimread(f);
        image = double(Jimage.image);
        // Conditionning the reference
        if ndims(image)>2 & size(image,3)>3
            image = image(:,:,1:3);     // alpha layer ignored
        end
        if ndims(image)>2
            ref = mean(mean(image(:,:,1:3),1),2); // size = [1 1 3]
        else
            ref = mean(image)  // size = [1 1]
        end
        assert_checkalmostequal(mean(Jimage), ref);
        assert_checkalmostequal(mean(Jimage,1), mean(image,1));
        assert_checkalmostequal(mean(Jimage,2), mean(image,2));
        assert_checkalmostequal(mean(Jimage,"r"), mean(image,1));
        assert_checkalmostequal(mean(Jimage,"c"), mean(image,2));
        assert_checkalmostequal(mean(Jimage,"m"), mean(image,1));
    end
end
