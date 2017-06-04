// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Mnoubue ALIX MELAINE
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function [IMB] =jimpixelized(Image,varagin)
   
    //test arguments
    if( argn(2) ==1) then
	picHeigth=10;
	picWidth=10;
    end
    
     if( argn(2)>= 3 & length(varagin)== 2) then
        picHeigth=varagin(1);
        picWidth=varagin(2);
    end
  
    
    // Testing arguments's typetype_filter
    if(typeof(Image) == "hypermat" ) then
        mat_image = Image;
    elseif(typeof(Image) == "jimage" ) then
        mat_image = Image. image;
    else
        error("Not any jimage or matrix argument have been defined" );
    end
      //row and colum of image
    [L,C]=size(mat_image);
       
    //pixelization of image
    for rrow = 1:picHeigth:L
        for rcol = 1:picWidth:C
            
            sumR=0; 
            sumG=0;
            sumB=0;
            sumT=0;
          
            for row=rrow: min(rrow+picHeigth, L)
                for col=rcol: min(rcol+picWidth, C)
                    row_mat=row + rrow;
                    col_mat=col+rcol;
                   
                    if(row_mat < L & col_mat < C) then
                    sumR=sumR + mat_image(row_mat,col_mat,1);
                   sumG=sumG + mat_image(row_mat,col_mat,2);
                   sumB=sumB + mat_image(row_mat,col_mat,3);
               end
             
               sumT=sumT + 1;
                end
            end
            
          sumT=sumT -1;
       
            //Avrage value for this compoment
            averageR= ((( sumR /sumT)));
            averageG=  ((( sumG /sumT)));
            averageB= ((( sumB /sumT)));
            
            //boucle for assign the average to the pixel  
            for row=rrow: min(rrow + picHeigth, L)
                for col=rcol: min(rcol + picWidth, C) 
                     row_mat=row + rrow;
                    col_mat=col+rcol;
                    mat_image(row_mat,col_mat,1)=averageR;
                    mat_image(row_mat,col_mat,2)=averageG;
                    mat_image(row_mat,col_mat,3)=averageB;   
                end
            end
            
            
        end 
    end
        IMB=mat_image;
endfunction

