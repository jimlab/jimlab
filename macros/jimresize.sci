//Copyright (C) 2017 - ENSIM, Université du Maine - Gael SENEE

//This file must be used under the terms of the CeCILL.
//This source file is licensed as described in the file COPYING, which
//you should have received as part of this distribution.  The terms
//are also available at    
//http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function resized_image = jimresize (original_image,height,width)

    // Case where a jimage object is given
    if typeof(original_image) == 'jimage' then

        // Extracting the matrix of the image
        im = original_image.image;
    
    // Case where a 2D or 3D matrix is given
    else
    
        im = original_image ;
        
    end

    // Input and output sizes
    in_rows = size(im,1);
    in_cols = size(im,2);
    out_rows = height;
    out_cols = width;

    S_R = in_rows / out_rows;
    S_C = in_cols / out_cols;


    // Interpolation grid
    [cf, rf] = meshgrid(1 : out_cols, 1 : out_rows);

    rf = rf * S_R;
    cf = cf * S_C;

    r = floor(rf);
    c = floor(cf);
    
    r(r < 1) = 1;
    c(c < 1) = 1;
    r(r > in_rows - 1) = in_rows - 1;
    c(c > in_cols - 1) = in_cols - 1;
    
    delta_R = rf - r;
    delta_C = cf - c;
    
    in1_ind = sub2ind([in_rows, in_cols], r, c);
    in2_ind = sub2ind([in_rows, in_cols], r+1,c);
    in3_ind = sub2ind([in_rows, in_cols], r, c+1);
    in4_ind = sub2ind([in_rows, in_cols], r+1, c+1);
    
    out = zeros(out_rows, out_cols, size(im, 3));
    
    for idx = 1:size(im,3)
        chan = double(im(:,:,idx))
        d1=matrix(chan(in1_ind),out_rows,out_cols);
        d2=matrix(chan(in2_ind),out_rows,out_cols);
        d3=matrix(chan(in3_ind),out_rows,out_cols);
        d4=matrix(chan(in4_ind),out_rows,out_cols);
        DD1=d1.*(1-delta_R).*(1-delta_C);
        DD2=d2.*(delta_R).*(1 - delta_C);
        DD3=d3.*(1 - delta_R).*(delta_C);
        DD4=d4.*(delta_R).*(delta_C);
        tmp = DD1+DD2+DD3+DD4;
        out(:,:,idx) = uint8(tmp);
    end;
    // Case where a jimage object is given
    if typeof(original_image) == 'jimage' then

        // Extracting the matrix of the image
            resized_image = mlist(['jimage','image','encoding','title','mime'], uint8(out),..
    original_image.encoding, original_image.title, original_image.mime);
    
    // Case where a 2D or 3D matrix is given
    else
        
        resized_image = uint8(out);
        
    end

endfunction
