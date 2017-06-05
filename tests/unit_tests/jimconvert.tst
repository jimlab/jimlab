// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

// <-- NO CHECK REF -->
// <-- TEST WITH GRAPHICS --> //required by JIMS

    //Conversion of a RGBA encoded image 
	
path = jimlabPath("/") + "tests/images/logoEnsim_rgba.png";
Jimage = jimread(path);
image = Jimage.image;

//in rgb without transparencyColor 
jrgb = jimconvert(Jimage, "rgb");
assert_checkequal(jrgb.transparencyColor, int16(cat(3, 255, 255, 255)))
rgb = jimconvert(image, "rgb");
Jimage.transparencyColor = cat(3, 200, 200, 200);
jrgb = jimconvert(Jimage, "rgb");
assert_checkequal(jrgb.transparencyColor, int16(Jimage.transparencyColor))

//in rgb with a transparencyColor
tColor = cat(3, 200, 200, 200);
jrgb = jimconvert(Jimage, "rgb", tColor);
assert_checkequal(jrgb.transparencyColor, int16(tColor))
rgb = jimconvert(image, "rgb", tColor);

//in gray without transparencyColor
Jimage.transparencyColor = -1;
jgray = jimconvert(Jimage, "gray");
assert_checkequal(jgray.transparencyColor, int16(255))
gray = jimconvert(image, "gray");
Jimage.transparencyColor = cat(3, 200, 200, 200);
jgray = jimconvert(Jimage, "gray");
assert_checkequal(jgray.transparencyColor, int16(200))

//in gray with a transparencyColor
tColor = 200;
jgray = jimconvert(Jimage, "gray", tColor);
gray = jimconvert(image, "gray", tColor);
assert_checkequal(jgray.transparencyColor, int16(200))

//RGBA image with no 0 on the alpha channel
path = jimlabPath("/") + "tests/images/noError/rgba.png";
Jimage = jimread(path);
image = Jimage.image;

//in rgb without transparencyColor 
jrgb = jimconvert(Jimage, "rgb");
assert_checkequal(jrgb.transparencyColor, int16(-1))
rgb = jimconvert(image, "rgb");
Jimage.transparencyColor = cat(3, 200, 200, 200);
jrgb = jimconvert(Jimage, "rgb");
assert_checkequal(jrgb.transparencyColor, int16(-1))

//in rgb with a transparencyColor
tColor = cat(3, 200, 200, 200);
jrgb = jimconvert(Jimage, "rgb", tColor);
assert_checkequal(jrgb.transparencyColor, int16(-1))
rgb = jimconvert(image, "rgb", tColor);

//in gray without transparencyColor
Jimage.transparencyColor = -1;
jgray = jimconvert(Jimage, "gray");
assert_checkequal(jgray.transparencyColor, int16(-1))
gray = jimconvert(image, "gray");
Jimage.transparencyColor = 200;
jgray = jimconvert(Jimage, "gray");
assert_checkequal(jgray.transparencyColor, int16(-1))

//in gray with a transparencyColor
tColor = 200;
jgray = jimconvert(Jimage, "gray", tColor);
gray = jimconvert(image, "gray", tColor);
assert_checkequal(jgray.transparencyColor, int16(-1))


    //Conversion of a RGB encoded image
    
path = jimlabPath("/") + "tests/images/noError/rgb.png";
Jimage = jimread(path);
image = Jimage.image;

//in gray without transparencyColor
jgray = jimconvert(Jimage, "gray");
gray = jimconvert(image, "gray");
Jimage.transparencyColor = cat(3, 200, 200, 200);
jgray = jimconvert(Jimage, "gray");

//in gray with a transparencyColor
tColor = cat(3, 200, 200, 200);
jgray = jimconvert(Jimage, "gray", tColor);
gray = jimconvert(image, "gray", tColor);

//in rgb 
jrgb = jimconvert(Jimage, "rgb");
rgb = jimconvert(image, "rgb");
jrgb2 = jimconvert(Jimage, "rgb", 255);
rgb2 = jimconvert(image, "rgb", [255,255,255]);
assert_checkequal(Jimage.image, jrgb.image);
assert_checkequal(Jimage.image, rgb);
assert_checkequal(Jimage.image, jrgb2.image);
assert_checkequal(Jimage.image, rgb2);

    //Conversion of a boolean image

image = (rand(20, 20) > 0.5);
gray = jimconvert(image, "gray");
Jimage = jimread(path);
image = Jimage.image;
jgray = jimconvert(Jimage, "gray");


    //Converion of a gray image
path = jimlabPath("/") + "tests/images/noError/gray.jpg";
Jimage = jimread(path);
image = Jimage.image;
jgray = jimconvert(Jimage, "gray");
gray = jimconvert(image, "gray");
jgray2 = jimconvert(Jimage, "gray", 255);
gray2 = jimconvert(image, "gray", [255,255,255]);
assert_checkequal(Jimage.image, jgray.image);
assert_checkequal(Jimage.image, gray);
assert_checkequal(Jimage.image, jgray2.image);
assert_checkequal(Jimage.image, gray2);

    //Errors

//Wrong first argument
msg = "%s: Argument #%d: Wrong type of input argument.\n";
msg = msprintf(msg, "jimconvert", 1);
assert_checkerror("gray = jimconvert(""wrong"" , ""gray"")", msg)

//Wrong second argument
msg = "%s: Argument #%d: rgb or gray expected.\n";
msg = msprintf(msg, "jimconvert", 2);
assert_checkerror("rgba = jimconvert(Jimage.image , ""rgba"")", msg)

msg = "%s: Argument #%d: The output encoding is not given.\n";
msg = msprintf(msg, "jimconvert", 2);
assert_checkerror("rgba = jimconvert(Jimage.image)", msg)

//Wrong third argument
path = jimlabPath("/") + "tests/images/noError/rgba.png";
Jimage = jimread(path);
msg = "%s: Argument #%d: hypermatrix with 3 components expected.\n";
msg = msprintf(msg, "jimconvert", 3);
assert_checkerror("rgba = jimconvert(Jimage.image , ""rgb"", 38)", msg)

msg = "%s: Argument #%d: Components of transparencyColor must be in the intervalle [0,255].\n";
msg = msprintf(msg, "jimconvert", 3);
tColor = cat(3, 400, 3, 3);
assert_checkerror("rgba = jimconvert(Jimage.image , ""gray"", tColor)", msg)


//Converting a gray  image into rgb encoding
path = jimlabPath("/") + "tests/images/noError/gray.jpg";
Jimage = jimread(path);
msg = "%s: %s cannot be converted into rgb encoding.\n";
name = Jimage.title + "." + Jimage.mime;
msg = msprintf(msg, "jimconvert", name);
assert_checkerror("gray = jimconvert(Jimage , ""rgb"")", msg)
msg = "%s: %s cannot be converted into rgb encoding.\n";
name = "your image";
msg = msprintf(msg, "jimconvert", name);
assert_checkerror("gray = jimconvert(Jimage.image , ""rgb"")", msg)

