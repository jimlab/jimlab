//Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas Aegerter
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function  jimwrite(imageMat,imagePath,imageProperties,Format,Name,Type)
 
if(type(imagePath) == 10)   
jimport java.io.File;
jimport javax.imageio.ImageIO; 
jimport java.awt.image.BufferedImage;
jimport java.awt.Color

else
    error('Invalid Path of file');
end


if((type(imageMat) ~= 17)&(type(imageMat) ~= 1))
    error('Argument imageMat is not a matrix')
end

if(type(imageProperties) == 16)
    width = imageProperties(3);
    height = imageProperties(4);
    Type = imageProperties(5);
    Name = imageProperties(2);
    
else
    width = size(imageMat,1);
    height = size(imageMat,2);
    
end

if((type(Format) ~= 10)|(Format == '')) 
    Format = 'jpg';
end

if((type(Type) ~= 10)|(Type == ''))
    Type = 'RGB';
end

if((type(Name) ~= 10)|(Name == ''))
Name = 'No name';
end
//imageMat = permute(imageMat,[2 1 3]);
imagePath = strcat([imagePath,"/",Name,".",Format]);

f = jnewInstance(File,imagePath);

S = 0;

select Type,
case 'GRAY' then
   S =  jimwrite_gray(imageMat,f,width,height);
case 'RGB' then
    S =  jimwrite_RGB(imageMat,f,width,height);
case 'RGBA' then
   S =  jimwrite_RGBA(imageMat,f,width,height);

else 
   error('Unexpected image type');
   end
if  (~S)
    error('The image haven''t been saved');
end

endfunction

function Sa =  jimwrite_RGB(imageMat,f,width,height)

im = jnewInstance(BufferedImage,width,height, BufferedImage.TYPE_INT_RGB );
for (x = 1:width)
    for(y =1:height) 

A = jnewInstance(Color, double(imageMat(x,y,1)), double(imageMat(x,y,2)),double(imageMat(x,y,3)),1);
R = jinvoke(A,"getRGB");
jinvoke(im,"setRGB", int(x-1), int(y-1), int(R));
end
end

Form = jnewInstance("java.lang.String", Format)
Sa = ImageIO.write(im, Form, f);



jremove f im A Form;

endfunction

function Sa = jimwrite_RGBA(imageMat,f,width,height)
    
    im = jnewInstance(BufferedImage,width,height, BufferedImage.TYPE_INT_ARGB );
    for (x = 1:width)
        for(y =1:height) 
    
            A = jnewInstance(Color, double(imageMat(x,y,1)), double(imageMat(x,y,2)), ..
                                double(imageMat(x,y,3)),double(imageMat(x,y,4)));
            R = jinvoke(A,"getRGB");
            jinvoke(im,"setRGB", int(x-1), int(y-1), int(R));
    
       end
    end

Form = jnewInstance("java.lang.String", Format)
Sa = ImageIO.write(im, Form, f);



jremove f im A Form; 
    
endfunction

function Sa =  jimwrite_gray(imageMat,f,width,height)
 
     im = jnewInstance(BufferedImage,width,height, BufferedImage.TYPE_BYTE_GRAY );
for (x = 1:width)
    for(y =1:height) 

A = jnewInstance(Color, double(imageMat(x,y)),1);
R = jinvoke(A,"getRGB");
jinvoke(im,"setRGB", int(x-1), int(y-1), int(R));
   end
end

Form = jnewInstance("java.lang.String", Format)
Sa = ImageIO.write(im, Form, f);


    
endfunction
