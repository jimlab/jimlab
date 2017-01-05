 //Copyright (C) 2017 - ENSIM, Université du Maine - Gael SENEE
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

//global properties

function jimdisp(varargin)

    //Checking whether the number of arguments is valid
    if argn(2) > 3 then
        error('Too many arguments');
    end

    if argn(2) == 0 then
        error('Enter a path, a URL or a matrix');
    end

    if argn(2) == 1 then
        jimdisp_reset();
        
        Mat_or_path = varargin(1);
        
        select type(Mat_or_path)
        case 8 then
            jimdisp_mat(Mat_or_path)
        case 17 then
            jimdisp_mat(Mat_or_path)
        case 10 then
            [Mat, properties] = jimread(Mat_or_path);
            jimdisp_mat(Mat)
        else
        error('Wrong type of argument : please enter a path, a url or a matrix')
        end
    end

    if argn(2) == 2 then
        
        jimdisp_reset()
        
        Mat_or_path = varargin(1);
               
        tmp = varargin(2);
        select type(varargin(2))
        case 16 then            
            properties = varargin(2);

            select type(Mat_or_path)
            case 8 then
                jimdisp_mat(Mat_or_path)
                jimdisp_prop(Mat_or_path,properties)
            case 17 then
                jimdisp_mat(Mat_or_path)
                jimdisp_prop(Mat_or_path,properties)
            case 10 then
                [Mat, properties] = jimread(Mat_or_path);
                jimdisp_mat(Mat)
                jimdisp_prop(Mat,properties)
            end
        case 10 then
            withbox = varargin(2)
            
            select type(Mat_or_path)
            case 8 then
                jimdisp_mat(Mat_or_path)
            case 17 then
                jimdisp_mat(Mat_or_path)
            case 10 then
                [Mat, properties] = jimread(Mat_or_path);
                jimdisp_mat(Mat)
            end
            jimdisp_box(withbox);
        end
    end

    if argn(2) == 3 then
        
        jimdisp_reset()
        
        Mat_or_path = varargin(1);
        withbox = varargin(2);
        properties = varargin(3);

        select type(Mat_or_path)
        case 8 then
            jimdisp_mat(Mat_or_path)
            jimdisp_prop(Mat_or_path,properties);
        case 17 then
            jimdisp_mat(Mat_or_path)
            jimdisp_prop(Mat_or_path,properties);
        case 10 then
            [Mat, properties] = jimread(Mat_or_path);
            jimdisp_mat(Mat)
            jimdisp_prop(Mat,properties);
        end
        jimdisp_box(withbox);
    end

endfunction

function jimdisp_mat(Mat)

    //Opening of the current parameters of the graphic environment
    ax = gca();
    fig = gcf();

    //Size of the matrix
    height = size(Mat,1);
    width = size(Mat,2);

    //Setting of the display
    Matplot(Mat)
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

function jimdisp_box(withbox)

    // Opening of the current parameters of the graphic environment
    ax = gca();
    fig = gcf();

    if withbox == 'withbox' then
        ax.box = "on";
    else
        ax.box = "off";
    end

endfunction

function jimdisp_prop(Mat,properties)

    // Opening of the current parameters of the graphic environment
    ax = gca();
    fig = gcf();

    // Size of the matrix
    height = size(Mat,1);
    width = size(Mat,2);
    ax.title.text = properties.Title+"  -  "+"Size : "+string(width)+" x " +string(height)+"  -  "+"Type : "+properties.Type;
    fig.figure_name = properties.Title;

endfunction

function jimdisp_reset()
    fig = gcf()
    clf(fig,'clear') // Reset of the paramaters of the graphic environment
endfunction
