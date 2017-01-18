//Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas Aegerter
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function jimwrite(jimage,imagePath,Format,Name)
 
    
     imageMat = jimage.image;
    
     
     if((ndims(imageMat) ~= 4)&(ndims(imageMat) ~= 3)&(ndims(imageMat) ~= 2)) // Verify if imageMat is a 2D,3D or 4D matrix 
            error('Argument image exctracted from jimage argument is not a matrix')
     end
    
    
    if(type(imagePath) ~= 10) //Verify if imagePath is a string  
        warning('Invalid Path of file, current depository will be used');
        imagePath = pwd;
    end
    if(isdef(["Format"]))
        a = 0;
         defFormat = ['jpg','png','gif','bmp','wbmp'];
         compFormat = strstr(defFormat,Format); // Verify if user's specified format is supported
           if((type(Format) ~= 10)|(compFormat == '')) // If Format is not definded or wrong, 
                warning('Invalid format detected, jpg will be used')  //the default value is 'jpg'
                  Format = 'jpg';
              end
     else 
         a = 1;
         Format = jimage.format;
     end
     
     if(isdef(["Name"]))
         if((type(Name) ~= 10)|(Name == ''))// If Name isn't definded or wrong, the default value is 'No Name'
            warning('Name is not a string, the image will be called No_name');
            Name = 'No_name';
        end
     else
         Name = jimage.title;    
    end
   
    jimport java.io.File;// Importe the java classes
    jimport javax.imageio.ImageIO; 
    jimport java.awt.image.BufferedImage;
    jimport java.awt.Color;   
    
    if(a)
    imagePath = strcat([imagePath,"/",Name,Format]);// This code create the final path used by Java methode 'write'
    else
    imagePath = strcat([imagePath,"/",Name,".",Format]);
    end

    f = jnewInstance(File,imagePath);// Transfome Scilab object into Java object
    Form = jnewInstance("java.lang.String", Format);

    S = 0;
    
    select jimage.encoding,
        case 'gray' then
            S =  jimwritegray(imageMat,f,Form);
        case 'rgb' then
            S = jimwriteRGB(imageMat,f,Form);
        case 'rgba' then
            S =  jimwriteRGBA(imageMat,f,Form);

    else 
        error('Unexpected image type');
   end
    if  (~S)
        error('The image haven''t been saved');
    end
endfunction

    function Sa = jimwriteRGB(imageMat,f,Form)
// This sub-function saved an image definded by a 3D rgb matrix using java methode "write", from BufferedImage class. 
// It is called by the function jimwrite.
// imageMat : The wxhx3 3D matrix, f : a java object corresponding to imagePath,
// width : the width of the matrix, height : the height of the matrix.
           
         width = size(imageMat,2);// Definition of image's size
        height = size(imageMat,1);
        im = jnewInstance(BufferedImage,width,height, BufferedImage.TYPE_INT_RGB );
        for (l = 1:height)
            for(c =1:width) 
                A = jnewInstance(Color, double(imageMat(l,c,1)),..
                 double(imageMat(l,c,2)),double(imageMat(l,c,3)),1);
                R = jinvoke(A,"getRGB");
                jinvoke(im,"setRGB", int(c-1), int(l-1), int(R));
            end
        end

        Sa = ImageIO.write(im, Form, f);



        jremove f im A Form R;

    endfunction

    function Sa = jimwriteRGBA(imageMat,f,Form)
// This sub-function saved an image definded by a 4D rgba matrix using java methode "write", from BufferedImage class. 
// It is called by the function jimwrite.
// imageMat : The wxhx4 4D matrix, f : a java object corresponding to imagePath,
// width : the width of the matrix, height : the height of the matrix.

       
         width = size(imageMat,2);  // Definition of image's size
        height = size(imageMat,1);
        im = jnewInstance(BufferedImage,width,height, BufferedImage.TYPE_INT_ARGB );
        for (x = 1:height)
            for(y =1:width) 
    
                A = jnewInstance(Color, double(imageMat(x,y,1)),.. 
                double(imageMat(x,y,2)), double(imageMat(x,y,3)),..
                double(imageMat(x,y,4)));
                R = jinvoke(A,"getRGB");
                jinvoke(im,"setRGB", int(y-1), int(x-1), int(R));
    
           end
        end

        Sa = ImageIO.write(im, Form, f);

        jremove f im A Form R; 
    
    endfunction

    function Sa = jimwritegray(imageMat,f,Form)
// This sub-function saved an image in gray scale definded by a 2D matrix using java methode "write", from BufferedImage class. 
// It is called by the function jimwrite.
// imageMat : The wxh 2D matrix, f : a java object corresponding to imagePath,
// width : the width of the matrix, height : the height of the matrix.

      
         width = size(imageMat,2);  // Definition of image's size
         height = size(imageMat,1);
         im = jnewInstance(BufferedImage,width,height, BufferedImage.TYPE_BYTE_GRAY );
        for (x = 1:width)
            for(y =1:height) 

            A = jnewInstance(Color, double(imageMat(x,y)),1,1,1);
            R = jinvoke(A,"getRGB");
            jinvoke(im,"setRGB", int(y-1), int(x-1), int(R));
           end
        end

        Sa = ImageIO.write(im, Form, f);

         jremove f im A Form R;
    
    endfunction
