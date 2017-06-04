// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas AEGERTER
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function [S] = jimwrite(image,imagePath,Encoding,typeMIME)
	//This function writes an image as a file from a jimage object or a matrix/hypermatrix
	//image : an object reprensenting an image (jimage, matrix or hypermatrix)
	//imagePath : a string giving the directory where the image must be written
	//Encoding : word "gray", "rgb" or "rgba"
	//typeMIME : a word givin the type MIME : "jpg", "png", "gif" or "bmp"
	//S : a boolean 
 
    if(isdef(["image"],"l"))// Verify if image is a jimage object or a matrix
        if((typeof(image) == "hypermat")|(typeof(image) == "uint8"))
        Mat = image;
        arg_jimage = 0;
    elseif(typeof(image) == "jimage")
        arg_jimage = 1;
        Mat = image.image;
    else
        arg_jimage = -1;
        error("Not any jimage or matrix argument have been definded")
    end
    deftypeMIME = "jpg png gif bmp";
    
     
     if((size(Mat,3) ~= 4)&(size(Mat,3) ~= 3)&(size(Mat,3) ~= 1)) // Verify if Mat is a 2D or 3D matrix 
            error("Argument Mat is not a matrix")
     end
    
    
    if(~isdef(["imagePath"],"l") | type(imagePath) ~= 10) //Verify if imagePath is a string  
        warning("Invalid Path of file, current depository will be used");
        imagePath = pwd();
    end
    
        if(isdir(imagePath))// if imagePath refer to a directory, definition of the name and the TypeMIME
            imagePath = pathconvert(imagePath);
            if(arg_jimage)
                Name = image.title;
                warning("jimage''s name will be used :"+ Name);
                MIME = image.mime;
                MIME = strsubst(MIME, ".", "");
                
             else
                Name = "No_name";
                 warning("No_name will be used as file name");
                 warning("Undefineded type MIME, jpg will be used");
                 MIME = "jpg";
                 
             end
             
         else
             MIME = convstr(fileparts(imagePath,"extension"));
             MIME = strsubst(MIME, ".", "");
             if((MIME == "")&(arg_jimage == 0))
                 MIME = "jpg";
             elseif((MIME == "")&(arg_jimage == 1))
                 MIME = image.mime;
                 
             end
             
         end
     end
     
             
                     
    
    if(isdef(["typeMIME"],"l"))
         
         typeMIME = convstr(typeMIME),
         invalid_typeMIME = 0;
         comptypeMIME = strstr(deftypeMIME,typeMIME); // Verify if user's specified format is supported
           if((type(typeMIME) ~= 10)|(comptypeMIME == "")) // If typeMIME is not definded or wrong, 
                invalid_typeMIME = 1;
           end
      elseif(~(isdef(["typeMIME"],"l")))
          if(strstr(deftypeMIME,MIME) == "")
              invalid_typeMIME = 1;
          else 
              typeMIME = MIME;
              invalid_typeMIME = 0;
          end
          
      end

      if(arg_jimage & invalid_typeMIME) // Jimage typeMIME is used 
          typeMIME = image.mime
           warning("Invalid typeMIME detected, jimage typeMIME will be used :"..
          + typeMIME)
     elseif(invalid_typeMIME)
          typeMIME = "jpg";
          warning("Undefineded typeMIME, jpg will be used")
     end
     
   if(isdef(["Encoding"],"l"))
       if((type(Encoding) == 10))
         Encoding = convstr(Encoding);
         invalid_Encoding = 0;
         defEncoding = ["rgb","rgba","gray"];
         compEncoding = strstr(defEncoding,Encoding); // Verify if user's specified encoding is supported
         if((compEncoding == "")) // If Format is not definded or wrong, 
                invalid_Encoding = 1;
         end
        else
         invalid_Encoding = 1;
        end
         
    elseif(~(isdef(["Encoding"],"l")))
        invalid_Encoding = 1;
     end
    if(arg_jimage & invalid_Encoding)// Jimage's encoding is used 
        Encoding = image.encoding;
        warning("Invalid encoding detected, jimage encoding will be used : "..
         + image.encoding)
    elseif(invalid_Encoding & (size(image,3) >= 3))
          Encoding = "rgb";//the default value is "rgb"
        warning("Wrong definition of encoding. rgb will be used")
         warning("Transparency won''t be efficient")
     elseif(invalid_Encoding &( size(image,3) < 3))
          Encoding = "gray";//the default value is "rgb"
        warning("Wrong definition of encoding. gray will be used")
         warning("Transparency won''t be efficient")
     end
     
     if(Encoding == "rgba")
         if((typeMIME == "jpg")|(typeMIME == "bmp"))// RGBA is not aviable for jpg and bmp
             warning(Encoding +" is not aviable for "+ typeMIME ..
             + " type. png will be used")
             typeMIME = "png";
         end
     end
     
            
    jimport java.io.File;// Importe the java classes
    jimport javax.imageio.ImageIO; 
    jimport java.awt.image.BufferedImage;
    jimport java.awt.Color;   
 
    
    if (isdef(["Name"],"l"))
        imagePath = pathconvert(fileparts(imagePath,"path") +..
         Name + "." + typeMIME,%f);
 
    else
    
    imagePath = pathconvert(fileparts(imagePath,"path") +..
     fileparts(imagePath,"fname") + "." + typeMIME,%f);
end

// This code create the final path used by Java methode "write"

    S = 0;
    
    select Encoding,
        case "gray" then
            S =  jimwriteGRAY(Mat,imagePath,typeMIME);
        case "rgb" then
            S = jimwriteRGB(Mat,imagePath,typeMIME);
        case "rgba" then
            S =  jimwriteRGBA(Mat,imagePath,typeMIME);

    else 
        warning("Unexpected image type");
   end
    if  (~S)
        warning("The image haven''t been saved");
    end
    
endfunction

    function Sa = jimwriteGRAY(Mat,imagePath,typeMIME)
// This sub-function saved an image in gray scale definded by a 2D matrix using java methode "write", from BufferedImage class. 
// It is called by the function jimwrite.
// Mat : The wxh 2D matrix
// imagePath : A string giving the writting path
// typeMIME : A string giving the typeMIME for the new image 
// Sa : A boolean

         transposeValue = jautoTranspose();
        jautoTranspose(%t);
         width = size(Mat,2);  // Definition of image's size
         height = size(Mat,1);
         im = jnewInstance(BufferedImage,width,height, BufferedImage.TYPE_BYTE_GRAY );
         Mat = double(Mat(:,:))/255;
         try
             im = Ret.CstrImageGRAY(width,height,jwrapinfloat(Mat),..
             im);
        catch
       
            Ret = jcompile("SetImage",["import javax.imageio.ImageIO;"
            "import java.awt.image.BufferedImage;"
            "import java.awt.Color;"
            "import java.lang.Float;"
            "public class SetImage{"
            "public static BufferedImage CstrImageGRAY(int width, int height, float[][] Mat, BufferedImage image){"
            "int L = 0;"
            "int C = 0;"
            "float x = 1;"
            
            
            " for (L = 0; L < height; L++){"
                    "for(C = 0; C < width; C++){"
                        "Color A = new Color( Mat[L][C],Mat[L][C],Mat[L][C],x);"
              
                        "image.setRGB(C,L,A.getRGB());"
                    "}"
                "}"
            "return image;"
            "}}"]);

             im = Ret.CstrImageGRAY(width,height,jwrapinfloat(Mat),..
             im);
         end
        path = jnewInstance(File,imagePath);// Transfome Scilab object into Java object
    
        MIME = jnewInstance("java.lang.String", typeMIME);

        Sa = ImageIO.write(im, MIME, path);// image writting 
        jremove path MIME im Ret;
        jautoTranspose(transposeValue);
        
    endfunction

    function Sa = jimwriteRGB(Mat,imagePath,typeMIME)
// This sub-function saved an image definded by a 3D rgb matrix using java methode "write", from BufferedImage class. 
// It is called by the function jimwrite.
// Mat : The wxhx3 3D matrix
// imagePath : A string giving the writting path
// typeMIME : A string giving the typeMIME for the new image 
// Sa : A boolean

        transposeValue = jautoTranspose();
        jautoTranspose(%t);
        width = size(Mat,2);// Definition of image's size
        height = size(Mat,1);
        im = jnewInstance(BufferedImage,width,height, BufferedImage.TYPE_INT_RGB );
        Mat1 = double(Mat(:,:,1))/255;// Conversion into 0.0 to 1.0 range. 
        Mat2 = double(Mat(:,:,2))/255;
        Mat3 = double(Mat(:,:,3))/255;
        try
             im = Ret.CstrImageRGB(width,height,jwrapinfloat(Mat1),..
             jwrapinfloat(Mat2),jwrapinfloat(Mat3),im); // This java method set rgb value into the java BufferedImage object im.
        catch
       
            Ret = jcompile("SetImage",["import javax.imageio.ImageIO;"
            "import java.awt.image.BufferedImage;"
            "import java.awt.Color;"
            "import java.lang.Float;"
            "public class SetImage{"
            "public static BufferedImage CstrImageRGB(int width, int height, float[][] Mat1,float[][] Mat2, float[][] Mat3, BufferedImage image){"
            "int L = 0;"
            "int C = 0;"
            "float x = 1;"
            " for (L = 0; L < height; L++){"
                    "for(C = 0; C < width; C++){"
                        "Color A = new Color( Mat1[L][C],Mat2[L][C],Mat3[L][C],x);"
              
                        "image.setRGB(C,L,A.getRGB());"
                    "}"
                "}"
            "return image;"
            "}}"]);
              
             im = Ret.CstrImageRGB(width,height,jwrapinfloat(Mat1),..
             jwrapinfloat(Mat2),jwrapinfloat(Mat3),im);
         end
         path = jnewInstance(File,imagePath);// Transfome Scilab object into Java object
    
        MIME = jnewInstance("java.lang.String", typeMIME);

        Sa = ImageIO.write(im, MIME, path);// image writting 

       jremove path im MIME Ret ;
       jautoTranspose(transposeValue);

    endfunction

    function Sa = jimwriteRGBA(Mat,imagePath,typeMIME)
// This sub-function saved an image definded by a 3D rgba matrix using java methode "write", from BufferedImage class. 
// It is called by the function jimwrite.
// Mat : The wxhx4 3D matrix, 
// imagePath : A string giving the writting path
// typeMIME : A string giving the typeMIME for the new image 
// Sa : A boolean
        
        transposeValue = jautoTranspose();
       if(size(Mat,3) == 3)
           Sa =  jimwriteRGB(Mat,imagePath,typeMIME);
       elseif(size(Mat,3) == 1)
           Sa =  jimwriteGRAY(Mat,imagePath,typeMIME);
       else
        
        jautoTranspose(%t);
        width = size(Mat,2);  // Definition of image's size
        height = size(Mat,1);
        im = jnewInstance(BufferedImage,width,height, BufferedImage.TYPE_INT_ARGB );
        Mat1 = double(Mat(:,:,1))/255;
        Mat2 = double(Mat(:,:,2))/255;
        Mat3 = double(Mat(:,:,3))/255;
        Mat4 = double(Mat(:,:,4))/255;
        try
             im = Ret.CstrImageRGBA(width,height,jwrapinfloat(Mat1),..
             jwrapinfloat(Mat2),jwrapinfloat(Mat3),jwrapinfloat(Mat4)..
             ,im);
        catch
       
            Ret = jcompile("SetImage",["import javax.imageio.ImageIO;"
            "import java.awt.image.BufferedImage;"
            "import java.awt.Color;"
            "import java.lang.Float;"
            "public class SetImage{"
            "public static BufferedImage CstrImageRGBA(int width, int height, float[][] Mat1,float[][] Mat2, float[][] Mat3, float[][] Mat4, BufferedImage image){"
            "int L = 0;"
            "int C = 0;"
            
            " for (L = 0; L < height; L++){"
                    "for(C = 0; C < width; C++){"
                        "Color A = new Color( Mat1[L][C],Mat2[L][C],Mat3[L][C],Mat4[L][C]);"
              
                        "image.setRGB(C,L,A.getRGB());"
                    "}"
                "}"
            "return image;"
            "}}"]);
              
             im = Ret.CstrImageRGBA(width,height,jwrapinfloat(Mat1),..
             jwrapinfloat(Mat2),jwrapinfloat(Mat3),jwrapinfloat(Mat4)..
             ,im);
         end
        

        path = jnewInstance(File,imagePath);// Transfome Scilab object into Java object
    
        MIME = jnewInstance("java.lang.String", typeMIME);

        Sa = ImageIO.write(im, MIME, path);// image writting 
        end
        jremove path MIME im Ret; 
        jautoTranspose(transposeValue);
        
    endfunction
