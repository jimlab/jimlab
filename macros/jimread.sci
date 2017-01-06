 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

 

 function [im, imProperties] = jimread(imPath)
    if(type(imPath) == 10)
        jimport java.io.File;
        jimport javax.imageio.ImageIO;
        
        //Tests the type of the input argument
        if(strstr(convstr(imPath),'http') == convstr(imPath))
            imPath = getURL(imPath,TMPDIR);
        end
        
        //Reads the image file using Java
        f = jnewInstance(File, imPath);
        try
        bufferedIm = jinvoke(ImageIO, "read", f);
        imType = jgetfield(bufferedIm,"type");
        catch
        msg = _("%s: Unexpected image type.\n");
        error(msprintf(msg,"jimread"));
        end
        
        jremove File ImageIO f;
        
        //The image JAVA type conditions the choice of the extracting method 
        select imType,
        case 1 then
            [im, imProperties] = jimread_intrgb(bufferedIm, imPath);
        case 2 then
            [im, imProperties] = jimread_intargb(bufferedIm, imPath);
        case 3 then
            [im, imProperties] = jimread_intargbpre(bufferedIm, imPath);
        case 4 then
            [im, imProperties] = jimread_intbgr(bufferedIm, imPath);
        case 5 then
            [im, imProperties] = jimread_3bytebgr(bufferedIm, imPath);
        case 6 then
            [im, imProperties] = jimread_4byteabgr(bufferedIm, imPath);
        case 7 then
            [im, imProperties] = jimread_4byteabgrpre(bufferedIm, imPath);
        case 8 then
            [im, imProperties] = jimread_ushort565rgb(bufferedIm, imPath);
        case 9 then 
            [im, imProperties] = jimread_ushort555rgb(bufferedIm, imPath);
        case 10 then 
            [im, imProperties] = jimread_byteGray(bufferedIm, imPath);
        case 11 then
            [im, imProperties] = jimread_ushortGray(bufferedIm, imPath);
        case 13 then
            [im, imProperties] = jimread_byteIndexed(bufferedIm, imPath);
        else
            msg = _("%s: Unexpected image type.\n");
            error(msprintf(msg,"jimread"));
        end
        
    else
        msg = _("%s: Argument #%d: Text(s) expected.\n");
        error(msprintf(msg,"jimread",1));
    end
endfunction

function [im, imProperties] = jimread_intrgb(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_INT_RGB BufferedImage. It is called by the function jimread().
//im : a WxHx3 matrix, imProperties : a tlist.
//bufferedIm : a Java object from BufferedImage class with type TYPE_INT_RGB, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the data from the BufferedImage
    bufferedImData = jgetfield(bufferedIm,"data");
    dataBuffer = jgetfield(bufferedImData, "dataBuffer");
    unprocessedData = uint32(jinvoke(dataBuffer, "getData"));
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    jremove bufferedIm bufferedImData dataBuffer 
    
    //decomposes the hexadecimal value of the color into the three 8-bits color components for each pixels
    im(:,:,1) = floor(unprocessedData./uint32(16^4));
    g = modulo(unprocessedData,uint32(16^4));
    im(:,:,2) = floor(g./uint32(16^2));
    im(:,:,3) = modulo(unprocessedData,uint32(16^2))
    
    jremove unprocessedData
    
    
    dim = [double(width) double(height) 4];
    try
    im = matrix(im,dim);                      //transpose matrix of the image
    im = permute(im,[2 1 3]);                 //formatting the image data 
    im = uint8(im);                           //convertion into 8-bits unsigned intergers usable by jimdisp()
    catch
    msg = _("%s: stack size exceeded (Use stacksize function to ..
                                                increase it).\n");
    error(msprintf(msg,"jimread"));
    end
    
    //defines the image properties
    imProperties = tlist(['ImageProperties','Title','Width','Height',..
    'Type'], basename(imPath), double(height), double(width), 'RGB');
    
endfunction

function [im, imProperties] = jimread_intargb(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_INT_ARGB BufferedImage. It is called by the function jimread().
//im : a WxHx4 matrix, imProperties : a tlist.
//bufferedIm : a Java object from BufferedImage class with type TYPE_INT_ARGB, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the data from the BufferedImage
    bufferedImData = jgetfield(bufferedIm,"data");
    dataBuffer = jgetfield(bufferedImData, "dataBuffer");
    unprocessedData = uint32(jinvoke(dataBuffer, "getData"));
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    jremove bufferedIm bufferedImData dataBuffer 
    
    //decomposes the hexadecimal value of the color into the three 8-bits color components and an 8-bits alpha component for each pixels
    im(:,:,4) = floor(unprocessedData./uint32(16^6));
    r = modulo(unprocessedData,uint32(16^6));
    im(:,:,1) = floor(r./uint32(16^4));
    g = modulo(unprocessedData,uint32(16^4));
    im(:,:,2) = floor(g./uint32(16^2));
    im(:,:,3) = modulo(unprocessedData,uint32(16^2))
    
    jremove unprocessedData
    
    dim = [double(width) double(height) 4];
    try
    im = matrix(im,dim);                      //transpose matrix of the image
    im = permute(im,[2 1 3]);                 //formatting the image data 
    im = uint8(im);                           //convertion into 8-bits unsigned intergers usable by jimdisp()
    catch
    msg = _("%s: stack size exceeded (Use stacksize function to ..
                                                increase it).\n");
    error(msprintf(msg,"jimread"));
    end
    
    //defines the image properties
    imProperties = tlist(['ImageProperties','Title','Width','Height',..
    'Type'], basename(imPath), double(height), double(width), 'RGBA');
    
endfunction

function [im, imProperties] = jimread_intargbpre(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_INT_ARGB_PRE BufferedImage. It is called by the function jimread().
//im : a WxHx4 matrix, imProperties : a tlist.
//bufferedIm : a Java object from BufferedImage class with type TYPE_INT_ARGB_PRE, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the image dimensions 
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    //gets the integer value of the color in the RGB color space for each pixels
    m = zeros(1,height*width);
    unprocessedData = jinvoke(bufferedIm,"getRGB",0,0,int(width-1),..
                                int(height-1),m,0,int(width));
    
    //decomposes the integer value of the color into the three 8-bits color components and an 8-bits alpha component for each pixels
    im(:,:,4) = floor(unprocessedData./uint32(16^6));
    r = modulo(unprocessedData,uint32(16^6));
    im(:,:,1) = floor(r./uint32(16^4));
    g = modulo(unprocessedData,uint32(16^4));
    im(:,:,2) = floor(g./uint32(16^2));
    im(:,:,3) = modulo(unprocessedData,uint32(16^2))
    jremove bufferedIm unprocessedData
    
    dim = [double(width) double(height) 4];
    im = matrix(im,dim);             //transpose matrix of the image
    try
    im = permute(im,[2 1 3]);        //formatting the image data 
    im = uint8(im);                  //convertion into 8-bits unsigned intergers usable by jimdisp()
    catch
    msg = _("%s: stack size exceeded (Use stacksize function to ..
                                                increase it).\n");
    error(msprintf(msg,"jimread"));
    end
    
    //defines the image properties
    imProperties = tlist(['ImageProperties','Title','Width','Height',..
    'Type'], basename(imPath), double(height), double(width), 'RGBA');
    
endfunction

function [im, imProperties] = jimread_intbgr(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_INT_BGR BufferedImage. It is called by the function jimread().
//im : a WxHx3 matrix, imProperties : a tlist.
//bufferedIm : a Java object from BufferedImage class with type TYPE_INT_BGR, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the data from the BufferedImage
    bufferedImData = jgetfield(bufferedIm,"data");
    dataBuffer = jgetfield(bufferedImData, "dataBuffer");
    unprocessedData = uint8(jinvoke(dataBuffer, "getData"));
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    jremove bufferedIm bufferedImData dataBuffer 
    
    //decomposes the hexadecimal value of the color into the three 8-bits color components for each pixels
    im(:,:,3) = floor(r./uint32(16^4));
    g = modulo(unprocessedData,uint32(16^4));
    im(:,:,2) = floor(g./uint32(16^2));
    im(:,:,1) = modulo(unprocessedData,uint32(16^2))
    
    jremove unprocessedData
    
    dim = [double(width) double(height) 3];
    try
    im = matrix(im,dim);                      //transpose matrix of the image
    im = permute(im,[2 1 3]);                 //formatting the image data 
    im = uint8(im);                           //convertion into 8-bits unsigned intergers usable by jimdisp()
    catch
    msg = _("%s: stack size exceeded (Use stacksize function to ..
                                                increase it).\n");
    error(msprintf(msg,"jimread"));
    end
    
    //defines the image properties
    imProperties = tlist(['ImageProperties','Title','Width','Height',..
    'Type'], basename(imPath), double(height), double(width), 'RGB');
    
endfunction

function [im, imProperties] = jimread_3bytebgr(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_3BYTE_BGR BufferedImage. It is called by the function jimread().
//im : a WxHx3 matrix, imProperties : a tlist.
//bufferedIm : a Java object from BufferedImage class with type TYPE_3BYTE_BGR, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the data from the BufferedImage
    bufferedImData = jgetfield(bufferedIm,"data");
    dataBuffer = jgetfield(bufferedImData, "dataBuffer");
    unprocessedData = uint8(jinvoke(dataBuffer, "getData"));
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    jremove bufferedIm bufferedImData dataBuffer 
    
    
    dim = [double(width) double(height) 3];
    im = matrix(unprocessedData,3,-1);
    try
    im = flipdim(im,1);               //storage of the 3 layers in RGB order
    im = matrix(im',dim);             //transpose matrix of the image
    im = permute(im,[2 1 3]);         //formatting the image data 
    catch
    msg = _("%s: stack size exceeded (Use stacksize function to ..
                                                increase it).\n");
    error(msprintf(msg,"jimread"));
    end
    
    jremove unprocessedData
    
    //defines the image properties
    imProperties = tlist(['ImageProperties','Title','Width','Height',..
    'Type'], basename(imPath), double(height), double(width), 'RGB');
    
endfunction

function [im, imProperties] = jimread_4byteabgr(bufferedIm, imPath)             
//This sub-function reads an image from a TYPE_4BYTE_ABGR BufferedImage. It is called by the function jimread().
//im : a WxHx4 matrix, imProperties : a tlist.
//bufferedIm : a Java object from BufferedImage class with type TYPE_4BYTE_ABGR, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"

    //Extracts the data from the BufferedImage
    bufferedImData = jgetfield(bufferedIm,"data");
    dataBuffer = jgetfield(bufferedImData, "dataBuffer");
    unprocessedData = uint8(jinvoke(dataBuffer, "getData"));
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    jremove bufferedIm bufferedImData dataBuffer 
    
    dim = [double(width) double(height) 4];
    im = matrix(unprocessedData,4,-1);
    try
    im = flipdim(im,1);               //storage of the 4 layers in RGBA order
    im = matrix(im',dim);             //transpose matrix of the image
    im = permute(im,[2 1 3]);         //formatting the image data 
    catch
    msg = _("%s: stack size exceeded (Use stacksize function to ..
                                                increase it).\n");
    error(msprintf(msg,"jimread"));
    end
    
    jremove unprocessedData
    
    //defines the image properties
    imProperties = tlist(['ImageProperties','Title','Width','Height',..
    'Type'], basename(imPath), double(height), double(width), 'RGBA');
    
endfunction

function [im, imProperties] = jimread_4byteabgrpre(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_4BYTE_ABGR_PRE BufferedImage. It is called by the function jimread().
//im : a WxHx4 matrix, imProperties : a tlist.
//bufferedIm : a Java object from BufferedImage class with type TYPE_4BYTE_ABGR_PRE, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the image dimensions 
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    //gets the integer value of the color in the RGB color space for each pixels
    m = zeros(1,height*width);
    unprocessedData = jinvoke(bufferedIm,"getRGB",0,0,int(width-1),..
                                int(height-1),m,0,int(width));
    
    //decomposes the integer value of the color into the three 8-bits color components and an 8-bits alpha component for each pixels
    im(:,:,4) = floor(unprocessedData./uint32(16^6));
    r = modulo(unprocessedData,uint32(16^6));
    im(:,:,1) = floor(r./uint32(16^4));
    g = modulo(unprocessedData,uint32(16^4));
    im(:,:,2) = floor(g./uint32(16^2));
    im(:,:,3) = modulo(unprocessedData,uint32(16^2))
    jremove bufferedIm unprocessedData
    
    dim = [double(width) double(height) 4];
    im = matrix(im,dim);             //transpose matrix of the image
    try
    im = permute(im,[2 1 3]);        //formatting the image data 
    im = uint8(im);                  //convertion into 8-bits unsigned intergers usable by jimdisp()
    catch
    msg = _("%s: stack size exceeded (Use stacksize function to ..
                                                increase it).\n");
    error(msprintf(msg,"jimread"));
    end
    
    //defines the image properties
    imProperties = tlist(['ImageProperties','Title','Width','Height',..
    'Type'], basename(imPath), double(height), double(width), 'RGBA');
    
endfunction

function [im, imProperties] = jimread_ushort565rgb(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_USHORT_565_RGB BufferedImage. It is called by the function jimread().
//im : a WxHx3 matrix, imProperties : a tlist.
//bufferedIm : a Java object from BufferedImage class with type TYPE_USHORT_565_RGB, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the image dimensions 
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    //gets the integer value of the color in the RGB color space for each pixels
    m = zeros(1,height*width);
    unprocessedData = jinvoke(bufferedIm,"getRGB",0,0,int(width-1),..
                                int(height-1),m,0,int(width));
    
    //decomposes the integer value of the color into the three 8-bits color components and an 8-bits alpha component for each pixels
    im(:,:,1) = floor(unprocessedData./uint32(16^4));
    g = modulo(unprocessedData,uint32(16^4));
    im(:,:,2) = floor(g./uint32(16^2));
    im(:,:,3) = modulo(unprocessedData,uint32(16^2))
    jremove bufferedIm unprocessedData
    
    dim = [double(width) double(height) 3];
    im = matrix(im,dim);             //transpose matrix of the image
    try
    im = permute(im,[2 1 3]);        //formatting the image data 
    im = uint8(im);                  //convertion into 8-bits unsigned intergers usable by jimdisp()
    catch
    msg = _("%s: stack size exceeded (Use stacksize function to ..
                                                increase it).\n");
    error(msprintf(msg,"jimread"));
    end
    
    //defines the image properties
    imProperties = tlist(['ImageProperties','Title','Width','Height',..
    'Type'], basename(imPath), double(height), double(width), 'RGB');
    
endfunction

function [im, imProperties] = jimread_ushort555rgb(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_USHORT_555_RGB BufferedImage. It is called by the function jimread().
//im : a WxHx3 matrix, imProperties : a tlist.
//bufferedIm : a Java object from BufferedImage class with type TYPE_USHORT_555_RGB, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the image dimensions 
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    //gets the integer value of the color in the RGB color space for each pixels
    m = zeros(1,height*width);
    unprocessedData = jinvoke(bufferedIm,"getRGB",0,0,int(width-1),..
                                int(height-1),m,0,int(width));
    
    //decomposes the integer value of the color into the three 8-bits color components and an 8-bits alpha component for each pixels
    im(:,:,1) = floor(unprocessedData./uint32(16^4));
    g = modulo(unprocessedData,uint32(16^4));
    im(:,:,2) = floor(g./uint32(16^2));
    im(:,:,3) = modulo(unprocessedData,uint32(16^2))
    jremove bufferedIm unprocessedData
    
    dim = [double(width) double(height) 3];
    im = matrix(im,dim);             //transpose matrix of the image
    try
    im = permute(im,[2 1 3]);        //formatting the image data 
    im = uint8(im);                  //convertion into 8-bits unsigned intergers usable by jimdisp()
    catch
    msg = _("%s: stack size exceeded (Use stacksize function to ..
                                                increase it).\n");
    error(msprintf(msg,"jimread"));
    end
    
    //defines the image properties
    imProperties = tlist(['ImageProperties','Title','Width','Height',
    'Type'], basename(imPath), double(height), double(width), 'RGB');
    
endfunction

function [im, imProperties] = jimread_byteGray(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_BYTE_GRAY BufferedImage. It is called by the function jimread().
//im : a WxH matrix, imProperties : a tlist.
//bufferedIm : a Java object from BufferedImage class with type TYPE_BYTE_GRAY, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"

    //Extracts the data from the BufferedImage
    bufferedImData = jgetfield(bufferedIm,"data");
    dataBuffer = jgetfield(bufferedImData, "dataBuffer");
    unprocessedData = jinvoke(dataBuffer, "getData");
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    jremove bufferedIm bufferedImData dataBuffer 
    
    dim = [double(width) double(height) 1];
    im = matrix(unprocessedData, dim);
    try
    im = permute(im,[2 1 3]);         //formatting the image data 
    im = uint8(im);                   //convertion into 8-bits unsigned intergers usable by jimdisp()
    catch
    msg = _("%s: stack size exceeded (Use stacksize function to ..
                                                increase it).\n");
    error(msprintf(msg,"jimread"));
    end
    
    jremove unprocessedData
    
    //defines the image properties
    imProperties = tlist(['ImageProperties','Title','Width','Height',..
    'Type'], basename(imPath), double(height), double(width), 'Gray');
    
endfunction

function [im, imProperties] = jimread_ushortGray(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_USHORT_GRAY BufferedImage. It is called by the function jimread().
//im : a WxHx3 matrix, imProperties : a tlist.
//bufferedIm : a Java object from BufferedImage class with type TYPE_USHORT_GRAY, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the image dimensions 
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    //gets the integer value of the color in the RGB color space for each pixels
    m = zeros(1,height*width);
    unprocessedData = jinvoke(bufferedIm,"getRGB",0,0,int(width-1),..
                                int(height-1),m,0,int(width));
    
    //decomposes the integer value of the color into the three 8-bits color components and an 8-bits alpha component for each pixels
    im(:,:,1) = floor(unprocessedData./uint32(16^4));
    g = modulo(unprocessedData,uint32(16^4));
    im(:,:,2) = floor(g./uint32(16^2));
    im(:,:,3) = modulo(unprocessedData,uint32(16^2))
    jremove bufferedIm unprocessedData
    
    dim = [double(width) double(height) 3];
    im = matrix(im,dim);             //transpose matrix of the image
    try
    im = permute(im,[2 1 3]);        //formatting the image data 
    im = uint8(im);                  //convertion into 8-bits unsigned intergers usable by jimdisp()
    catch
    msg = _("%s: stack size exceeded (Use stacksize function to ..
                                                increase it).\n");
    error(msprintf(msg,"jimread"));
    end
    
    //defines the image properties
    imProperties = tlist(['ImageProperties','Title','Width','Height',..
    'Type'], basename(imPath), double(height), double(width), 'RGB');
    
endfunction

function [im, imProperties] = jimread_byteIndexed(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_BYTE_INDEXED BufferedImage. It is called by the function jimread().
//im : a WxHx4 matrix, imProperties : a tlist.
//bufferedIm : a Java object from BufferedImage class with type TYPE_BYTE_INDEXED, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the image dimensions 
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    //gets the integer value of the color in the RGB color space for each pixels
    m = zeros(1,height*width);
    unprocessedData = jinvoke(bufferedIm,"getRGB",0,0,int(width-1),..
                            int(height-1),m,0,int(width));
    
    //decomposes the integer value of the color into the three 8-bits color components and an 8-bits alpha component for each pixels
    im(:,:,4) = floor(unprocessedData./uint32(16^6));
    r = modulo(unprocessedData,uint32(16^6));
    im(:,:,1) = floor(r./uint32(16^4));
    g = modulo(unprocessedData,uint32(16^4));
    im(:,:,2) = floor(g./uint32(16^2));
    im(:,:,3) = modulo(unprocessedData,uint32(16^2))
    jremove bufferedIm unprocessedData
    
    dim = [double(width) double(height) 4];
    im = matrix(im,dim);             //transpose matrix of the image
    try
    im = permute(im,[2 1 3]);        //formatting the image data 
    im = uint8(im);                  //convertion into 8-bits unsigned intergers usable by jimdisp()
    catch
    msg = _("%s: stack size exceeded (Use stacksize function to ..
                                                increase it).\n");
    error(msprintf(msg,"jimread"));
    end
    
    //defines the image properties
    imProperties = tlist(['ImageProperties','Title','Width','Height',..
    'Type'], basename(imPath), double(height), double(width), 'RGBA');
    
endfunction


