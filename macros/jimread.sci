 //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

 

 function [jimage] = jimread(imPath)
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
        catch
        msg = _("%s: Cannot open file.\n");
        error(msprintf(msg,"jimread"));
        end
    
        try
        imType = jgetfield(bufferedIm,"type");
        catch
        msg = _("%s: Unexpected image type.\n");
        error(msprintf(msg,"jimread"));
        end
        
        jremove File ImageIO f;
        
        //The image JAVA type conditions the choice of the extracting method 
        select double(imType)
        case 1 then
            [jimage] = jimread_intrgb(bufferedIm, imPath);
        case 2 then
            [jimage] = jimread_intargb(bufferedIm, imPath);
        case 3 then
            [jimage] = jimread_intargbpre(bufferedIm, imPath);
        case 4 then
            [jimage] = jimread_intbgr(bufferedIm, imPath);
        case 5 then
            [jimage] = jimread_3bytebgr(bufferedIm, imPath);
        case 6 then
            [jimage] = jimread_4byteabgr(bufferedIm, imPath);
        case 7 then
            [jimage] = jimread_4byteabgrpre(bufferedIm, imPath);
        case 8 then
            [jimage] = jimread_ushort565rgb(bufferedIm, imPath);
        case 9 then 
            [jimage] = jimread_ushort555rgb(bufferedIm, imPath);
        case 10 then 
            [jimage] = jimread_byteGray(bufferedIm, imPath);
        case 11 then
            [jimage] = jimread_ushortGray(bufferedIm, imPath);
        case 13 then
            [jimage] = jimread_byteIndexed(bufferedIm, imPath);
        else
            msg = _("%s: Unexpected image type.\n");
            error(msprintf(msg,"jimread"));
        end
        
    else
        msg = _("%s: Argument #%d: Text(s) expected.\n");
        error(msprintf(msg,"jimread",1));
    end
endfunction

function [jimage] = jimread_intrgb(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_INT_RGB BufferedImage. It is called by the function jimread().
//jimage : a mlist. The fist field 'im' is a WxHx3 matrix, the second field 'encoding' is a string, the third field 'title' is a string. 
//bufferedIm : a Java object from BufferedImage class with type TYPE_INT_RGB, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the data from the BufferedImage
    bufferedImData = jgetfield(bufferedIm,"data");
    dataBuffer = jgetfield(bufferedImData, "dataBuffer");
    unprocessedData = uint32(jinvoke(dataBuffer, "getData"));
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    jremove bufferedIm bufferedImData dataBuffer 
    
    //decomposes the integer value of the color into the three 8-bits color components for each pixels
    im(:,:,1) = floor(unprocessedData./uint32(16^4));
    g = modulo(unprocessedData,uint32(16^4));
    im(:,:,2) = floor(g./uint32(16^2));
    im(:,:,3) = modulo(unprocessedData,uint32(16^2))
    
    jremove unprocessedData
    
    
    dim = [double(width) double(height) 3];
    try
    im = matrix(im,dim);                      //transpose matrix of the image
    im = permute(im,[2 1 3]);                 //formatting the image data 
    im = uint8(im);                           //convertion into 8-bits unsigned intergers usable by jimdisp()
    catch
    msg = _("%s: No more memory.\n");
    error(msprintf(msg,"jimread"));
    end
    
    //creates a mlist with the image data and some properties
    mime = strsubst(fileext(imPath), ".", "");
    jimage = mlist(['jimage','image','encoding','title','mime','transparencyColor'], im,..
    'rgb', basename(imPath), mime, -1);
    
endfunction

function [jimage] = jimread_intargb(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_INT_ARGB BufferedImage. It is called by the function jimread().
//jimage : a mlist. The fist field 'im' is a WxHx4 matrix, the second field 'encoding' is a string, the third field 'title' is a string.
//bufferedIm : a Java object from BufferedImage class with type TYPE_INT_ARGB, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the data from the BufferedImage
    bufferedImData = jgetfield(bufferedIm,"data");
    dataBuffer = jgetfield(bufferedImData, "dataBuffer");
    unprocessedData = uint32(jinvoke(dataBuffer, "getData"));
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    jremove bufferedIm bufferedImData dataBuffer 
    
    //decomposes the integer value of the color into the three 8-bits color components and an 8-bits alpha component for each pixels
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
    msg = _("%s: No more memory.\n");
    error(msprintf(msg,"jimread"));
    end
    
    //creates a mlist with the image data and some properties
    mime = strsubst(fileext(imPath), ".", "");
    jimage = mlist(['jimage','image','encoding','title','mime','transparencyColor'], im,..
    'rgba', basename(imPath), mime, -1);
    
endfunction

function [jimage] = jimread_intargbpre(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_INT_ARGB_PRE BufferedImage. It is called by the function jimread().
//jimage : a mlist. The fist field 'im' is a WxHx4 matrix, the second field 'encoding' is a string, the third field 'title' is a string.
//bufferedIm : a Java object from BufferedImage class with type TYPE_INT_ARGB_PRE, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the image dimensions 
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    //gets the integer value of the color in the RGB color space for each pixels
    m = zeros(1,height*width);
    unprocessedData = jinvoke(bufferedIm,"getRGB",0,0,int(width),..
                                int(height),m,0,int(width));
    
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
    msg = _("%s: No more memory.\n");
    error(msprintf(msg,"jimread"));
    end
    
    //creates a mlist with the image data and some properties
    mime = strsubst(fileext(imPath), ".", "");
    jimage = mlist(['jimage','image','encoding','title','mime','transparencyColor'], im,..
    'rgba', basename(imPath), mime, -1);
    
endfunction

function [jimage] = jimread_intbgr(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_INT_BGR BufferedImage. It is called by the function jimread().
//jimage : a mlist. The fist field 'im' is a WxHx3 matrix, the second field 'encoding' is a string, the third field 'title' is a string.
//bufferedIm : a Java object from BufferedImage class with type TYPE_INT_BGR, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the data from the BufferedImage
    bufferedImData = jgetfield(bufferedIm,"data");
    dataBuffer = jgetfield(bufferedImData, "dataBuffer");
    unprocessedData = uint8(jinvoke(dataBuffer, "getData"));
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    jremove bufferedIm bufferedImData dataBuffer 
    
    //decomposes the integer value of the color into the three 8-bits color components for each pixels
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
    msg = _("%s: No more memory.\n");
    error(msprintf(msg,"jimread"));
    end
    
    //creates a mlist with the image data and some properties
    mime = strsubst(fileext(imPath), ".", "");
    jimage = mlist(['jimage','image','encoding','title','mime','transparencyColor'], im,..
    'rgb', basename(imPath), mime, -1);
    
endfunction

function [jimage] = jimread_3bytebgr(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_3BYTE_BGR BufferedImage. It is called by the function jimread().
//jimage : a mlist. The fist field 'im' is a WxHx3 matrix, the second field 'encoding' is a string, the third field 'title' is a string.
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
    msg = _("%s: No more memory.\n");
    error(msprintf(msg,"jimread"));
    end
    
    jremove unprocessedData
    
    //creates a mlist with the image data and some properties
    mime = strsubst(fileext(imPath), ".", "");
    jimage = mlist(['jimage','image','encoding','title','mime','transparencyColor'], im,..
    'rgb', basename(imPath), mime, -1);
    
endfunction

function [jimage] = jimread_4byteabgr(bufferedIm, imPath)             
//This sub-function reads an image from a TYPE_4BYTE_ABGR BufferedImage. It is called by the function jimread().
//jimage : a mlist. The fist field 'im' is a WxHx4 matrix, the second field 'encoding' is a string, the third field 'title' is a string.
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
    msg = _("%s: No more memory.\n");
    error(msprintf(msg,"jimread"));
    end
    
    jremove unprocessedData
    
    //creates a mlist with the image data and some properties
    mime = strsubst(fileext(imPath), ".", "");
    jimage = mlist(['jimage','image','encoding','title','mime','transparencyColor'], im,..
    'rgba', basename(imPath), mime, -1);
    
endfunction

function [jimage] = jimread_4byteabgrpre(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_4BYTE_ABGR_PRE BufferedImage. It is called by the function jimread().
//jimage : a mlist. The fist field 'im' is a WxHx4 matrix, the second field 'encoding' is a string, the third field 'title' is a string.
//bufferedIm : a Java object from BufferedImage class with type TYPE_4BYTE_ABGR_PRE, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the image dimensions 
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    //gets the integer value of the color in the RGB color space for each pixels
    m = zeros(1,height*width);
    unprocessedData = jinvoke(bufferedIm,"getRGB",0,0,int(width),..
                                int(height),m,0,int(width));
    
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
    msg = _("%s: No more memory.\n");
    error(msprintf(msg,"jimread"));
    end
    
    //creates a mlist with the image data and some properties
    mime = strsubst(fileext(imPath), ".", "");
    jimage = mlist(['jimage','image','encoding','title','mime','transparencyColor'], im,..
    'rgba', basename(imPath), mime, -1);
    
endfunction

function [jimage] = jimread_ushort565rgb(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_USHORT_565_RGB BufferedImage. It is called by the function jimread().
//jimage : a mlist. The fist field 'im' is a WxHx3 matrix, the second field 'encoding' is a string, the third field 'title' is a string.
//bufferedIm : a Java object from BufferedImage class with type TYPE_USHORT_565_RGB, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the image dimensions 
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    //gets the integer value of the color in the RGB color space for each pixels
    m = zeros(1,height*width);
    unprocessedData = jinvoke(bufferedIm,"getRGB",0,0,int(width),..
                                int(height),m,0,int(width));
    
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
    msg = _("%s: No more memory.\n");
    error(msprintf(msg,"jimread"));
    end
    
    //creates a mlist with the image data and some properties
    mime = strsubst(fileext(imPath), ".", "");
    jimage = mlist(['jimage','image','encoding','title','mime','transparencyColor'], im,..
    'rgb', basename(imPath), mime, -1);
    
endfunction

function [jimage] = jimread_ushort555rgb(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_USHORT_555_RGB BufferedImage. It is called by the function jimread().
//jimage : a mlist. The fist field 'im' is a WxHx3 matrix, the second field 'encoding' is a string, the third field 'title' is a string.
//bufferedIm : a Java object from BufferedImage class with type TYPE_USHORT_555_RGB, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the image dimensions 
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    //gets the integer value of the color in the RGB color space for each pixels
    m = zeros(1,height*width);
    unprocessedData = jinvoke(bufferedIm,"getRGB",0,0,int(width),..
                                int(height),m,0,int(width));
    
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
    msg = _("%s: No more memory.\n");
    error(msprintf(msg,"jimread"));
    end
    
    //creates a mlist with the image data and some properties
    mime = strsubst(fileext(imPath), ".", "");
    jimage = mlist(['jimage','image','encoding','title','mime','transparencyColor'], im,..
    'rgb', basename(imPath), mime, -1);
    
endfunction

function [jimage] = jimread_byteGray(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_BYTE_GRAY BufferedImage. It is called by the function jimread().
//jimage : a mlist. The fist field 'im' is a WxH matrix, the second field 'encoding' is a string, the third field 'title' is a string.
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
    msg = _("%s: No more memory.\n");
    error(msprintf(msg,"jimread"));
    end
    
    jremove unprocessedData
    
    //creates a mlist with the image data and some properties
    mime = strsubst(fileext(imPath), ".", "");
    jimage = mlist(['jimage','image','encoding','title','mime','transparencyColor'], im,..
    'gray', basename(imPath), mime, -1);
    
endfunction

function [jimage] = jimread_ushortGray(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_USHORT_GRAY BufferedImage. It is called by the function jimread().
//jimage : a mlist. The fist field 'im' is a WxHx3 matrix, the second field 'encoding' is a string, the third field 'title' is a string.
//bufferedIm : a Java object from BufferedImage class with type TYPE_USHORT_GRAY, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the image dimensions 
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    //gets the integer value of the color in the RGB color space for each pixels
    m = zeros(1,height*width);
    unprocessedData = jinvoke(bufferedIm,"getRGB",0,0,int(width),..
                                int(height),m,0,int(width));
    
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
    msg = _("%s: No more memory.\n");
    error(msprintf(msg,"jimread"));
    end
    
    //creates a mlist with the image data and some properties
    mime = strsubst(fileext(imPath), ".", "");
    jimage = mlist(['jimage','image','encoding','title','mime','transparencyColor'], im,..
    'rgb', basename(imPath), mime, -1);
    
endfunction

function [jimage] = jimread_byteIndexed(bufferedIm, imPath)
//This sub-function reads an image from a TYPE_BYTE_INDEXED BufferedImage. It is called by the function jimread().
//jimage : a mlist. The fist field 'im' is a WxHx4 matrix, the second field 'encoding' is a string, the third field 'title' is a string.
//bufferedIm : a Java object from BufferedImage class with type TYPE_BYTE_INDEXED, imPath : the complete image file's path.
//More informations about the BufferedImage Class : "https://docs.oracle.com/javase/7/docs/api/java/awt/image/BufferedImage.html"
    
    //Extracts the image dimensions 
    width = jgetfield(bufferedIm,"width");
    height = jgetfield(bufferedIm, "height");
    
    //gets the integer value of the color in the RGB color space for each pixels
    m = zeros(1,height*width);
    unprocessedData = jinvoke(bufferedIm,"getRGB",0,0,int(width),..
                            int(height),m,0,int(width));
    
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
    msg = _("%s: No more memory.\n");
    error(msprintf(msg,"jimread"));
    end
    
    //creates a mlist with the image data and some properties
    mime = strsubst(fileext(imPath), ".", "");
    jimage = mlist(['jimage','image','encoding','title','mime','transparencyColor'], im,..
    'rgba', basename(imPath), mime, -1);
    
endfunction
