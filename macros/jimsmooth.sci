// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
//Copyright (C) 2017 - ENSIM, Université du Maine - Alix Melaine Mnoubue
//
//This file must be used under the terms of the CeCILL.
//This source file is licensed as described in the file COPYING, which
//you should have received as part of this distribution. The terms
//are also available at
//http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function [IMB] =jimsmooth(Image, varargin)
    //test arguments
    if( argn(2) ==1) then
        fogType="gaussian";
        fogWidth=3;
        mat_filter = jimsmooth_mask(fogType,fogWidth) ;
    end
    //number of arguments is two and the width of the filter is 3
    if( argn(2) <3 & (length(varargin) ==1) & (type(varargin(1))==10)) then
        fogType=varargin(1);
        fogWidth=3;
        mat_filter = jimsmooth_mask(fogType,fogWidth) ;
    end

    if(argn(2) >=3) then
        if(length(varargin) ==2) then
            fogType=varargin(1);
            fogWidth=varargin(2) ;
            mat_filter = jimsmooth_mask(fogType,fogWidth) ;
        end
        if(length(varargin) ==3) then
            if(~( isequal(fogType, 'customize' ))) then
                warning('The filter type should be customize' ) ;
            end
            fogWidth=varargin(1) ;
            //test for parity of matrix customize
            if(~ modulo(length(varargin(2)) , 2) )
                mat_filter=varargin(2);
            else 
                error('the length of the matrix must be odd and bigger than 1' ) ;

            end

        end
    end
    // Testing arguments's typetype_filter
    if(typeof(Image) == 'hypermat' ) then
        mat_image = Image;
    elseif(typeof(Image) == 'jimage' ) then
        mat_image = Image. image;
    else
        error('Not any jimage or matrix argument have been defined' );
    end

//test Encoding Image
    if((ndims(mat_image) == 4) ) // Verify if Mat is a 2D
        type_image = "rgba"; // Alpha channel isn't modified 
       mat_im= jimsmooth_padRGBa(mat_image,fogWidth);
    elseif(ndims(mat_image) == 3) // For 3D matrix
        type_image = "rgb";
        mat_im= jimsmooth_padRGB(mat_image,fogWidth);
    elseif(ndims(mat_image) == 2) // For 2D matrix
        type_image = "gray";
        mat_im= jimsmooth_padGRAY(mat_image,fogWidth);
    else
        error("Argument Mat is not a matrix");
    end
    
//select Encoding Image
    select type_image,
    case "gray" then
        IMB= uint8(conv2( double( mat_im),mat_filter,'same')) ;
    case "rgb" then
        // Convolve the three separate color .
        mat_im(:,:,1)=conv2(double(mat_im(:,:,1)),mat_filter,'same');
        mat_im(:,:,2)=conv2(double(mat_im(:,:,2)),mat_filter,'same');
        mat_im(:,:,3)=conv2(double(mat_im(:,:,3)),mat_filter,'same');
         IMB=uint8( mat_im);
    case "rgba" then
        // Convolve the three separate color .
        mat_im(:,:,1)=conv2(double(mat_im(:,:,1)),mat_filter,'same');
        mat_im(:,:,2)=conv2(double(mat_im(:,:,2)),mat_filter,'same');
        mat_im(:,:,3)=conv2(double(mat_im(:,:,3)),mat_filter,'same');
        mat_im(:,:,4)=conv2(double(mat_im(:,:,4)),mat_filter,'same');
        //Recombine separate color channels into a single

        IMB=uint8( mat_im);

    end



endfunction

//Function returning the specified input mask
function [matMask] =jimsmooth_mask(fogType, fogwidth)

    order=2;
    //testing the parity of fogwidth mask
    if((modulo(fogwidth, 2)) ==0 | fogwidth<3 ) then error('the fogwidth must be  odd' ) ; end;
    // mat =mask(fogwidth);//the mask of filter
    select fogType


    case "gaussian" then
        ic = int(fogwidth/2) +1; // index of the center
        sigma = (fogwidth/2) /order;
        // Matrix of distances to the mask's center:
        [X,Y] = meshgrid(1: fogwidth) ;

        // Creation of the 2D gaussian profile/weights
        matMask = exp(-((X-ic) .^2 + (Y-ic) .^2) /2/sigma^2) ;
        // Normalization:
        matMask = matMask/sum(matMask) ;
    case "uniform" then
        matMask = (1/fogwidth^2) *ones(fogwidth,fogwidth) ;
    case "triangular" then

        if(fogwidth > 3) then
            mat=(1/fogwidth^2) *ones(fogwidth,fogwidth) ;
            matMask = conv2(mat,mat) ;
        else
            error('the size of this filter musb be bigger than 3' ) ;
        end

    else
        error('this filter does not exits' ) ;
    end

endfunction

//Gray Image
function [matImage] =jimsmooth_padGRAY(matrice,width)
    [L,C]=size(matrice);

    indiceL=L;
    indiceC=C;
    endc=L;

    //add row in the low

    for i= 1 : width
        matrice=[matrice(1:endc,:) ;matrice(indiceL,:)];
        endc=endc+1;
        indiceL=L-i;

    end
    L=L+width;

    //add roww in the hight
    indiceLh=L;
    matrice=[matrice(1:1,:); matrice(1,:) ;matrice(2:indiceLh,:)];
    indiceLh=indiceLh+1;
    for i= 1 : width 
        matrice=[matrice(1:1,:); matrice(i*2,:) ;matrice(2:indiceLh,:)];
        indiceLh=indiceLh+1;

    end
    matrice(1:1,:)=[];

    //add colunn in the right

    for i= 1 : width   
        matrice=[matrice ,matrice(:,indiceC)];
        indiceC=C-i;
    end

    //add colunn in the left
    indiceCl=1
    for i= 1 : width   
        matrice=[matrice(:,indiceCl) , matrice];
        indiceCl=indiceCl+2;
    end

    matImage=matrice;


endfunction   

//RGB Image
function [matImage] =jimsmooth_padRGB(matrice,width)
    [L,C]=size(matrice);

    indiceL=L;
    indiceC=C;
    endc=L;

    //add row in the low

    mat1=matrice(:,:,1);   mat2=matrice(:,:,2);   mat3=matrice(:,:,3);
    
    for i= 1 : width
        mat1=[mat1(1:endc,:) ;mat1(indiceL,:)];
         mat2=[mat2(1:endc,:) ;mat2(indiceL,:)];
          mat3=[mat3(1:endc,:) ;mat3(indiceL,:)];
        endc=endc+1;
        indiceL=L-i;

    end
    L=L+width;

    //add roww in the hight
    indiceLh=L;
   
    mat1=[mat1(1:1,:); mat1(1,:) ;mat1(2:indiceLh,:)];
     mat2=[mat2(1:1,:); mat2(1,:) ;mat2(2:indiceLh,:)];
      mat3=[mat3(1:1,:); mat3(1,:) ;mat3(2:indiceLh,:)];
    indiceLh=indiceLh+1;
    for i= 1 : width 
        mat1=[mat1(1:1,:); mat1(i*2,:) ;mat1(2:indiceLh,:)];
        mat2=[mat2(1:1,:); mat2(i*2,:) ;mat2(2:indiceLh,:)];
        mat3=[mat3(1:1,:); mat3(i*2,:) ;mat3(2:indiceLh,:)];
        indiceLh=indiceLh+1;

end
 L=L+width;
    mat1(1:1,:)=[];
    mat2(1:1,:)=[];
    mat3(1:1,:)=[];

    //add colunn in the right

    for i= 1 : width   
        mat1=[mat1 ,mat1(:,indiceC)];
         mat2=[mat2 ,mat2(:,indiceC)];
          mat3=[mat3 ,mat3(:,indiceC)];
        indiceC=C-i;
    end

    //add colunn in the left
    indiceCl=1
    for i= 1 : width   
        mat1=[mat1(:,indiceCl) , mat1];
         mat2=[mat2(:,indiceCl) , mat2];
          mat3=[mat3(:,indiceCl) , mat3];
        indiceCl=indiceCl+2;
    end
    C=C + (2*width);
matImage = resize_matrix(matrice, L, C);
    matImage(:,:,1)=mat1;
    matImage(:,:,2)=mat2;
    matImage(:,:,3)=mat3;


endfunction


//RGB Image
function [matImage] =jimsmooth_padRGBa(matrice,width)
    [L,C]=size(matrice);

    indiceL=L;
    indiceC=C;
    endc=L;

    //add row in the low

    mat1=matrice(:,:,1);   mat2=matrice(:,:,2);   mat3=matrice(:,:,3);mat4=matrice(:,:,4);
    
    for i= 1 : width
        mat1=[mat1(1:endc,:) ;mat1(indiceL,:)];
         mat2=[mat2(1:endc,:) ;mat2(indiceL,:)];
          mat3=[mat3(1:endc,:) ;mat3(indiceL,:)];
           mat4=[mat4(1:endc,:) ;mat4(indiceL,:)];
        endc=endc+1;
        indiceL=L-i;

    end
    L=L+width;

    //add roww in the hight
    indiceLh=L;
   
    mat1=[mat1(1:1,:); mat1(1,:) ;mat1(2:indiceLh,:)];
     mat2=[mat2(1:1,:); mat2(1,:) ;mat2(2:indiceLh,:)];
      mat3=[mat3(1:1,:); mat3(1,:) ;mat3(2:indiceLh,:)];
      mat4=[mat4(1:1,:); mat4(1,:) ;mat4(2:indiceLh,:)];
    indiceLh=indiceLh+1;
    for i= 1 : width 
        mat1=[mat1(1:1,:); mat1(i*2,:) ;mat1(2:indiceLh,:)];
        mat2=[mat2(1:1,:); mat2(i*2,:) ;mat2(2:indiceLh,:)];
        mat3=[mat3(1:1,:); mat3(i*2,:) ;mat3(2:indiceLh,:)];
        mat4=[mat4(1:1,:); mat4(i*2,:) ;mat4(2:indiceLh,:)];
        indiceLh=indiceLh+1;

end
 L=L+width;
    mat1(1:1,:)=[];
    mat2(1:1,:)=[];
    mat3(1:1,:)=[];

    //add colunn in the right

    for i= 1 : width   
        mat1=[mat1 ,mat1(:,indiceC)];
         mat2=[mat2 ,mat2(:,indiceC)];
          mat3=[mat3 ,mat3(:,indiceC)];
          mat4=[mat4 ,mat4(:,indiceC)];
        indiceC=C-i;
    end

    //add colunn in the left
    indiceCl=1
    for i= 1 : width   
        mat1=[mat1(:,indiceCl) , mat1];
         mat2=[mat2(:,indiceCl) , mat2];
          mat3=[mat3(:,indiceCl) , mat3];
           mat4=[mat4(:,indiceCl) , mat4];
        indiceCl=indiceCl+2;
    end
    C=C + (2*width);
matImage = resize_matrix(matrice, L, C);
    matImage(:,:,1)=mat1;
    matImage(:,:,2)=mat2;
    matImage(:,:,3)=mat3;
     matImage(:,:,4)=mat4;


endfunction

