//Copyright (C) 2017 - ENSIM, Université du Maine - Alix Melaine Mnoubue
//This file must be used under the terms of the CeCILL.
//This source file is licensed as described in the file COPYING, which
//you should have received as part of this distribution. The terms
//are also available at
//http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function [IMB] =jimpixelize(Image,varargin)


    //test arguments
    if( argn(2) ==1) then
        picHeigth=10;
        picWidth=10;
    end

    if( argn(2) ==2) then
        picHeigth=varargin(1);
        picWidth=varargin(1);
    end

    if( argn(2)>= 3 & length(varargin)== 2) then
        picHeigth=varargin(1);
        picWidth=varargin(2);
    end

    // Testing arguments's typetype_filter
    if(typeof(Image) == 'hypermat' ) then
        mat_image = Image;
    elseif(typeof(Image) == 'jimage' ) then
        mat_image = Image. image;
    else
        error('Not any jimage or matrix argument have been defined' );
    end


    [c,d]=size(mat_image);
    nb=picHeigth*picWidth
    m=(c*d) / (nb);
    if(ndims(Image) == 4 & modulo((c*d),nb))// Verify if Mat is a 2D or 3D matrix 
        Encoding = "rgba"; // Alpha channel isn't modified*
        mat_image=jimpixelize_padRGBa(mat_image,picHeigth,picWidth);
    elseif(ndims(Image) == 3 & modulo((c*d),nb)) // For 2D matrix
        Encoding = "rgb";
        mat_image=jimpixelize_padRGB(mat_image,picHeigth,picWidth);
    elseif(ndims(Image) == 2 & modulo((c*d),nb))
        Encoding = "gray";
        mat_image=jimpixelize_padGRAY(mat_image,picHeigth,picWidth);
    else    
        error("Argument Mat is not a matrix")
    end

    [L,C]=size(mat_image);
    cont1=[];
    cont2=[];
    cont3=[];
    limit_row= (L / picHeigth);
    limit_col=(C / picWidth);

    k=1;
    for rrow=1 : limit_row
        pas_row=picHeigth + k-1;
        j=1; 
        disp(pas_row)
        for rrol=1 : limit_col
            pas_col=picWidth + j-1;
            B1= mat_image(k:pas_row , j:pas_col,1);
            B2= mat_image(k:pas_row , j:pas_col,2);
            B3= mat_image(k:pas_row , j:pas_col,3);
            [line,colne]=size(B1);
            p=line*colne;
            mat1=(matrix(B1,p,1));
            mat2=(matrix(B2,p,1));
            mat3=(matrix(B3,p,1));
            cont1=[cont1,mat1];
            cont2=[cont2,mat2];
            cont3=[cont3,mat3];
            j=pas_col+1;
        end
        k=pas_row+1;

    end


    moy1= mean(double(cont1),'r');
    moy2= mean(double(cont2),'r');
    moy3= mean(double(cont3),'r');



    pas_moy=1;
    k=1;
    j=1;
    for rrow=1 : limit_row
        pas_row=picHeigth + k-1;
        j=1;
        for rrol=1 : limit_col
            pas_col=picWidth + j-1;
            mat_image(k:pas_row , j:pas_col,1)=uint8(moy1(1,pas_moy));
            mat_image(k:pas_row , j:pas_col,2)=uint8(moy2(1,pas_moy));
            mat_image(k:pas_row , j:pas_col,3)=uint8(moy3(1,pas_moy));
            pas_moy=pas_moy+1;
            j=pas_col+1;
        end
        k=pas_row+1;

    end
    IMB=mat_image;

endfunction

//Image RGB
function [IML] =jimpixelize_padRGB(matrice,height,width)

    [L,C]=size(matrice);
    n=floor(L /height);
    m=floor(C / width);
    indiceL=L;
    indiceC=C;
    endc=L;
    mat1=matrice(:,:,1);   mat2=matrice(:,:,2);   mat3=matrice(:,:,3);

    if (( modulo(l, height) ) ) then
        rest_blockl=modulo(L,n*height);
        add_blockl=height-rest_blockl;
        for i= 1 : add_blockl

            mat1=[mat1(1:endc,:) ;mat1(indiceL,:)];
            mat2=[mat2(1:endc,:) ;mat2(indiceL,:)];
            mat3=[mat3(1:endc,:) ;mat3(indiceL,:)];
            endc=endc+1;
            indiceL=L-i;

        end

    end

    if (( modulo(C, width) ) ) then
        rest_blockc=modulo(C,m*width);
        add_blockc=width - rest_blockc;
        for i= 1 : add_blockc   
            mat1=[mat1 ,mat1(:,indiceC)];
            mat2=[mat2 ,mat2(:,indiceC)];
            mat3=[mat3 ,mat3(:,indiceC)];
            indiceC=C-i;
        end
    end
    IML=cat(3,mat1,mat2,mat3);
endfunction

//Image RGBa
function [IML] =jimpixelize_padRGBa(matrice,height,width)

    [L,C]=size(matrice);
    n=floor(L /height);
    m=floor(C / width);
    indiceL=L;
    indiceC=C;
    endc=L;
    mat1=matrice(:,:,1);   mat2=matrice(:,:,2);   mat3=matrice(:,:,3);  mat4=matrice(:,:,4);

    if (( modulo(l, height) ) ) then
        rest_blockl=modulo(L,n*height);
        add_blockl=height-rest_blockl;
        for i= 1 : add_blockl

            mat1=[mat1(1:endc,:) ;mat1(indiceL,:)];
            mat2=[mat2(1:endc,:) ;mat2(indiceL,:)];
            mat3=[mat3(1:endc,:) ;mat3(indiceL,:)];
             mat4=[mat4(1:endc,:) ;mat4(indiceL,:)];
            endc=endc+1;
            indiceL=L-i;

        end

    end

    if (( modulo(C, width) ) ) then
        rest_blockc=modulo(C,m*width);
        add_blockc=width - rest_blockc;
        for i= 1 : add_blockc   
            mat1=[mat1 ,mat1(:,indiceC)];
            mat2=[mat2 ,mat2(:,indiceC)];
            mat3=[mat3 ,mat3(:,indiceC)];
            mat4=[mat4 ,mat4(:,indiceC)];
            indiceC=C-i;
        end
    end
    IML=cat(4,mat1,mat2,mat3,mat4);


endfunction

//Image Gray
function [IML] =jimpixelize_padGRAY(matrice,height,width)

    [L,C]=size(matrice);
    n=floor(L /height);
    m=floor(C / width);
    indiceL=L;
    indiceC=C;
    endc=L;
 

    if (( modulo(l, height) ) ) then
        rest_blockl=modulo(L,n*height);
        add_blockl=height-rest_blockl;
        for i= 1 : add_blockl

            matrice=[matrice(1:endc,:) ;matrice(indiceL,:)];
            matrice=[matrice(1:endc,:) ;matrice(indiceL,:)];
            matrice=[matrice(1:endc,:) ;matrice(indiceL,:)];
            endc=endc+1;
            indiceL=L-i;

        end

    end

    if (( modulo(C, width) ) ) then
        rest_blockc=modulo(C,m*width);
        add_blockc=width - rest_blockc;
        for i= 1 : add_blockc   
            matrice=[matrice ,matrice(:,indiceC)];
            matrice=[matrice ,matrice(:,indiceC)];
            matrice=[matrice ,matrice(:,indiceC)];
            indiceC=C-i;
        end
    end
    IML=matrice;


endfunction
