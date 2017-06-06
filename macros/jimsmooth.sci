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
    if((ndims(mat_image) == 4) ) then // Verify if Mat is a 2D
        type_image = "rgba"; // Alpha channel isn't modified 
        mat_im= jimsmooth_padRGBa(mat_image,fogWidth);
    elseif(ndims(mat_image) == 3) then // For 3D matrix
        type_image = "rgb";
        mat_im= jimsmooth_padRGB(mat_image,fogWidth);
    elseif(ndims(mat_image) == 2) then // For 2D matrix
        type_image = "gray";
        mat_im= jimsmooth_padGRAY(mat_image,fogWidth);
    else
        error("Argument Mat is not a matrix");
    end

    //select Encoding Image
    select type_image,
    case "gray" then
        result= uint8(conv2( double( mat_im),mat_filter,'same')) ;
        IMB=jimsmooth_DelPadGRAY(result,fogWidth);

    case "rgb" then
        // Convolve the three separate color .
        mat_im(:,:,1)=conv2(double(mat_im(:,:,1)),mat_filter,'same');
        mat_im(:,:,2)=conv2(double(mat_im(:,:,2)),mat_filter,'same');
        mat_im(:,:,3)=conv2(double(mat_im(:,:,3)),mat_filter,'same');
        result=uint8( mat_im);
        IMB=jimsmooth_DelPadRGB(result,fogWidth);

    case "rgba" then
        // Convolve the three separate color .
        mat_im(:,:,1)=conv2(double(mat_im(:,:,1)),mat_filter,'same');
        mat_im(:,:,2)=conv2(double(mat_im(:,:,2)),mat_filter,'same');
        mat_im(:,:,3)=conv2(double(mat_im(:,:,3)),mat_filter,'same');
        mat_im(:,:,4)=conv2(double(mat_im(:,:,4)),mat_filter,'same');
        //Recombine separate color channels into a single

        result=uint8( mat_im);
        IMB=jimsmooth_DelPadRGBa(result,fogWidth);

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

    //add row in the low

    matrice=[matrice ;matrice(L:-1:L-width+1,:,:)];


    //add row in the hight

    matrice=[ matrice(width:-1:1,:,:);matrice];

    //add colunn in the right

    matrice=[ matrice , matrice(:,C:-1:C-width+1)];

    //add colunn in the left

    matrice=[  matrice(:,width:-1:1),matrice];

    matImage=matrice;


endfunction   

//RGB Image
function [matImage] =jimsmooth_padRGB(matrice,width)
    [L,C]=size(matrice);

    mat1=matrice(:,:,1);   mat2=matrice(:,:,2);   mat3=matrice(:,:,3);
    //add row in the low
    mat1=[mat1 ;mat1(L:-1:L-width+1,:,:)];
    mat2=[mat2 ;mat2(L:-1:L-width+1,:,:)];
    mat3=[mat3 ;mat3(L:-1:L-width+1,:,:)];

    //add roww in the hight

    mat1=[ mat1(width:-1:1,:,:);mat1];
    mat2=[ mat2(width:-1:1,:,:);mat2];
    mat3=[ mat3(width:-1:1,:,:);mat3];
    //add colunn in the right

    mat1=[ mat1 , mat1(:,C:-1:C-width+1)];
    mat2=[ mat2 , mat2(:,C:-1:C-width+1)];
    mat3=[ mat3 , mat3(:,C:-1:C-width+1)];

    //add colunn in the left   
    mat1=[  mat1(:,width:-1:1),mat1];
    mat2=[  mat2(:,width:-1:1),mat2];
    mat3=[  mat3(:,width:-1:1),mat3]

    //new size of row and column 
    L=L+(2*width);  
    C=C + (2*width);

    matImage = resize_matrix(matrice, L, C);
    matImage(:,:,1)=mat1;
    matImage(:,:,2)=mat2;
    matImage(:,:,3)=mat3;


endfunction


//RGB Image
function [matImage] =jimsmooth_padRGBa(matrice,width)
    [L,C]=size(matrice);

    //add row in the low

    mat1=matrice(:,:,1);   mat2=matrice(:,:,2);   mat3=matrice(:,:,3);mat4=matrice(:,:,4);

    //add row in the low
    mat1=[mat1 ;mat1(L:-1:L-width+1,:,:)];
    mat2=[mat2 ;mat2(L:-1:L-width+1,:,:)];
    mat3=[mat3 ;mat3(L:-1:L-width+1,:,:)];
    mat4=[mat4 ;mat4(L:-1:L-width+1,:,:)];

    //add roww in the hight


    mat1=[ mat1(width:-1:1,:,:);mat1];
    mat2=[ mat2(width:-1:1,:,:);mat2];
    mat3=[ mat3(width:-1:1,:,:);mat3];
    mat4=[ mat4(width:-1:1,:,:);mat4];
    //add colunn in the right

    mat1=[ mat1 , mat1(:,C:-1:C-width+1)];
    mat2=[ mat2 , mat2(:,C:-1:C-width+1)];
    mat3=[ mat3 , mat3(:,C:-1:C-width+1)];
    mat4=[ mat4 , mat4(:,C:-1:C-width+1)];

    //add colunn in the left   
    mat1=[  mat1(:,width:-1:1),mat1];
    mat2=[  mat2(:,width:-1:1),mat2];
    mat3=[  mat3(:,width:-1:1),mat3];
    mat4=[  mat4(:,width:-1:1),mat4];

    //new size of row and column 
    L=L+(2*width);  
    C=C + (2*width);

    matImage = resize_matrix(matrice, L, C);
    matImage(:,:,1)=mat1;
    matImage(:,:,2)=mat2;
    matImage(:,:,3)=mat3;
    matImage(:,:,4)=mat4;


endfunction


function [matImage] =jimsmooth_DelPadGRAY(matrice,width)
    [L,C]=size(matrice);

    //delete row in the low

    matrice(L:-1:L-width+1,:)=[];


    //delete row in the hight

    matrice(width:-1:1,:)=[];

    //delete colunn in the right
    matrice(:,C:-1:C-width+1)=[];

    //delete colunn in the left
    matrice(:,width:-1:1)=[];

    //new size of row and column 
    L=L-(2*width);  
    C=C-(2*width);
    matImage=matrice; 
endfunction   


//RGBa Image
function [matImage] =jimsmooth_DelPadRGBa(matrice,width)
    [L,C]=size(matrice);

    //delete row in the low

    mat1=matrice(:,:,1);   mat2=matrice(:,:,2);   mat3=matrice(:,:,3);mat4=matrice(:,:,4);

    //delete row in the low
    mat1(L:-1:L-width+1,:)=[];
    mat2(L:-1:L-width+1,:)=[];
    mat3(L:-1:L-width+1,:)=[];
    mat4(L:-1:L-width+1,:)=[];

    //delete roww in the hight


    mat1(width:-1:1,:,:)=[];
    mat2(width:-1:1,:,:)=[];
    mat3(width:-1:1,:,:)=[];
    mat4(width:-1:1,:,:)=[];
    //delete colunn in the right

    mat1(:,C:-1:C-width+1)=[];
    mat2(:,C:-1:C-width+1)=[];
    mat3(:,C:-1:C-width+1)=[];
    mat4(:,C:-1:C-width+1)=[];

    //delete colunn in the left   
    mat1(:,width:-1:1)=[];
    mat2(:,width:-1:1)=[];
    mat3(:,width:-1:1)=[];
    mat4(:,width:-1:1)=[];

    //new size of row and column 
    L=L-(2*width);  
    C=C-(2*width);

    matImage = resize_matrix(matrice, L, C);
    matImage(:,:,1)=mat1;
    matImage(:,:,2)=mat2;
    matImage(:,:,3)=mat3;
    matImage(:,:,4)=mat4;


endfunction


//RGB Image
function [matImage] =jimsmooth_DelPadRGB(matrice,width)
    [L,C]=size(matrice);

    //delete row in the low

    mat1=matrice(:,:,1);   mat2=matrice(:,:,2);   mat3=matrice(:,:,3);

    //delete row in the low
    mat1(L:-1:L-width+1,:)=[];
    mat2(L:-1:L-width+1,:)=[];
    mat3(L:-1:L-width+1,:)=[];

    //delete roww in the hight


    mat1(width:-1:1,:)=[];
    mat2(width:-1:1,:)=[];
    mat3(width:-1:1,:)=[];

    //delete colunn in the right

    mat1(:,C:-1:C-width+1)=[];
    mat2(:,C:-1:C-width+1)=[];
    mat3(:,C:-1:C-width+1)=[];


    //delete colunn in the left   
    mat1(:,width:-1:1)=[];
    mat2(:,width:-1:1)=[];
    mat3(:,width:-1:1)=[];


    //new size of row and column 
    L=L-(2*width);  
    C=C-(2*width);

    matImage = resize_matrix(matrice, L, C);

    matImage(:,:,1)=mat1;
    matImage(:,:,2)=mat2;
    matImage(:,:,3)=mat3;



endfunction

