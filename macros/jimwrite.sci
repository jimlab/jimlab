//Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas Aegerter
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function jimwrite(jimage,imageMat,imagePath,Format,Name,Encoding)
 
    if(isdef(["imageMat"],"l"))
        Mat = imageMat;
        arg_jimage = 0;
    elseif(isdef(["jimage"],"l"))
        arg_jimage = 1;
        Mat = jimage.image;
    else
        arg_jimage = 0;
        error('Not any jimage or matrix argument have been definded')
    end
    disp(arg_jimage);
    
     
     if((size(Mat,3) ~= 4)&(size(Mat,3) ~= 3)&(size(Mat,3) ~= 1)) // Verify if Mat is a 2D or 3D matrix 
            error('Argument Mat is not a matrix')
     end
    
    
    if(~isdef(["imagePath"],"l") | type(imagePath) ~= 10) //Verify if imagePath is a string  
        warning('Invalid Path of file, current depository will be used');
        imagePath = pwd;
    end
    
    if(isdef(["Format"],"l"))
         invalid_Format = 0;
         defFormat = ['jpg','png','gif','bmp','wbmp'];
         compFormat = strstr(defFormat,Format); // Verify if user's specified format is supported
           if((type(Format) ~= 10)|(compFormat == '')) // If Format is not definded or wrong, 
                invalid_Format = 1;
           end
      elseif(~(isdef(["Format"],"l"))) 
          
          invalid_Format = 1;
      end
      
      if(arg_jimage & invalid_Format) // Jimage format is used 
          Format = part(jimage.format,[2:length(jimage.format)])
           warning('Invalid format detected, jimage format will be used :'..
          + Format)
     elseif(invalid_Format)
          Format = 'jpg';
          warning('Undefineded format, jpg will be used')
     end
     
     if(isdef(["Name"],"l"))
         
         if((type(Name) ~= 10)|(Name == ''))// If Name isn't definded or wrong, the default value is 'No Name'
            warning('Name is not a string, the image will be called No_name');
            Name = 'No_name';
        end
     elseif(arg_jimage) 
         
         Name = jimage.title;
         warning('Invalid Name detected, jimage''s name will be used :'..
          + Name)
     else
         Name = 'No_name';
         warning('Undefineded name, No_name will be used')     
    end
    
   if(isdef(["Encoding"],"l"))
         invalid_Encoding = 0;
         defEncoding = ['rgb','rgba','gray'];
         compFormat = strstr(defEncoding,Encoding); // Verify if user's specified encoding is supported
         if((type(Encoding) ~= 10)|(compFormat == '')) // If Format is not definded or wrong, 
                invalid_Encoding = 1;
         end
    elseif(~(isdef(["Encoding"],"l")))
        invalid_Encoding = 1;
     end
    if(arg_jimage & invalid_Encoding)// Jimage format is used 
        Encoding = jimage.encoding;
        warning('Invalid encoding detected, jimage encoding will be used : '..
         + jimage.encoding)
    elseif(invalid_Encoding)
          Encoding = 'rgb';//the default value is 'rgb'
        warning('Not any encoding have been definded. rgb will be used')
         warning('Transparency wont be efficient')
     end
     
     if(Encoding == 'rgba')
         if((Format == 'jpg')|(Format == 'bmp'))
             warning(Encoding +' is not aviable for '+ Format ..
             + ' type. png will be used')
             Format = 'png';
         end
     end
     
            
    jimport java.io.File;// Importe the java classes
    jimport javax.imageio.ImageIO; 
    jimport java.awt.image.BufferedImage;
    jimport java.awt.Color;   
 
    
     
    imagePath = imagePath + "/" + Name + "." + Format; // This code create the final path used by Java methode 'write'

    S = 0;
    
    select Encoding,
        case 'gray' then
            S =  jimwriteGRAY(Mat,imagePath,Format);
        case 'rgb' then
            S = jimwriteRGB(Mat,imagePath,Format);
        case 'rgba' then
            S =  jimwriteRGBA(Mat,imagePath,Format);

    else 
        error('Unexpected image type');
   end
    if  (~S)
        error('The image haven''t been saved');
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
            "float z = 0;"
            "float mid =new Float(0.5019608);"
            " for (L = 0; L < height; L++){"
                    "for(C = 0; C < width; C++){"
                        "Color A = new Color( Mat[L][C],x,x,x);"
              
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
        
       if(size(Mat,3) == 3)
           Sa =  jimwriteRGB(Mat,imagePath,typeMIME);
           
       else
        transposeValue = jautoTranspose();
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


    
