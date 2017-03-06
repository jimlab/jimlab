//Copyright (C) 2017 - ENSIM, Université du Maine - Gael SENEE
//This file must be used under the terms of the CeCILL.
//This source file is licensed as described in the file COPYING, which
//you should have received as part of this distribution.  The terms
//are also available at    
//http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function jimdisp(image,box,info)

    // Initializing default parameters
    if exists('info') == 0 then
    info='no';
    end

    if exists('box') == 0 then
    box='no';
    end

    // Case where an image path or URL is given : the image is first
    // loaded with jimread.
    if type(image) == 10 then
        jimage1=jimread(image);
        jimreset(jimage1);
        jimdisp_mat(jimage1)
        
        if info == 'info' then
            withinfo(jimage1)
        end

    // Case where a 2D or 3D matrix is given
    else
        jimreset(image);
        jimdisp_mat(image)
        
        if info == 'info' then
            withinfo(image)
        end
    end

    if box == 'box' then
        withbox()
    end

endfunction

function jimdisp_mat(image)
    // This subfonction changes some parameters of the graphic
    // environment in order to display the image properly.

    //Opening of the current parameters of the graphic environment
    ax = gca();
    fig = gcf();

    //Size of the matrix
    dim = size(image);
    width = dim(1);
    height = dim(2);

    //Setting of the display
    if typeof(image) == 'jimage' then
    Matplot(image.image)
    fig.figure_name = image.title+image.format;
    else
    Matplot(image)
    end
    ax.box="off";
    ax.axes_visible = ["off","off","off"];
    ax.isoview = "on"; // Squared pixels
    ax.auto_scale = "on";
    ax.tight_limits = "on"; 

    
    // Centering of the displayed image (depends on the size)
    if height > 100 then
        ax.data_bounds = [-10,width+11,-10,height+11];
    else
        ax.data_bounds = [-3,width+4,-3,height+4];
    end

endfunction

function withbox()
    // This subfonction changes a parameter of the graphic
    // environment in order to display a box around the image.

    ax = gca();
    ax.box = "on";

endfunction

function withinfo(image)
    // This subfonction changes some parameters of the graphic
    // environment in order to display some properties included in
    // the jimage object fields.
    
    // Opening of the current parameters of the graphic environment
    ax = gca();

    // Size of the matrix
    dim = size(image);
    width = dim(1);
    height = dim(2);
    
    ax.title.text = image.title+image.format+"  -  "+"Type : "..
    +image.encoding+"  -  "+"Size : "+string(height)+" x "+string(width);

endfunction

function jimreset(image)
    // This subfonction clears the figure by resetting some
    // parameters of the graphic environment and plotting a white
    // box the size of the image.
    
    dim = size(image);
    width = dim(1);
    height = dim(2);
    Matplot(8*ones(height+10,width+10));

    // Opening of the current parameters of the graphic environment
    ax = gca();
    
    ax.title.text = ''
endfunction
