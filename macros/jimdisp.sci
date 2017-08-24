// This file is part of Jimlab, an external module coded for Scilab
//  and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Gaël SENÉE
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function jimdisp(image, varargin)
    // Displays of a gray or colored RGB or RGBA or indexed image.
    // image: matrix or RGB or RGBA hypermatrix or jimage object
    // Options (in any order, case insensitive):
    // "colormap"|"cm": uses the current colormap to display the image as a
    //                  matrix of color indices.
    // "axes"  : displays graduated axes. (1,1) is opn top-left corner
    // "info"  : displays infos in the main title.
    // "info", "bottom" | "left"
    //
    // "box", "off"                  : removes the frame around the image
    // "box", color                  : specifies the box color (name or rgb)
    // "box", thickness              : Specifies the box color and thickness (in [1 7])
    // "box", list(color, thickness) : same thing
    // "box", {color, thickness}     : same thing (Scilab 6)
    //
    // "grid", "on"                  : displays a default grid over the image
    // "grid", color                 : specifies the grid color (name or rgb)
    // "grid", idStyle               : Specifies the grid color and style (in [0 12])
    //
    // "grid", list(color, idStyle)  : same thing
    // "grid", {color, idStyle}      : same thing (Scilab 6)
    //
    // Notes:
    //  * color = colorname = "red" or [r g b]= [1 0 0] or [255 0 0] 
    //  * The box thickness sets also the grid's one.

    // Initializing default parameters
    // -------------------------------
    fname = "jimdisp";
    f = gcf();
    info = "";
    boxC = color("black"); // Default box color. -2 = disabled
    boxT =  1;        // Thickness of the framing box. %inf means Default
    gridC = -2;       // Default grid color. -2 = disabled
    gridS = 7;        // Line style of the grid.
    axes = %f;        // Graduated axes
    accordingColormap = %f;

    if ~isdef("varargin", "l") then
        varargin = list();
    end
    // Analyzing input arguments
    // -------------------------
    noa = length(varargin);      // Number of optional arguments
    j = 0;
    for i = 1:noa
        if i<=j, continue, end
        opt = varargin(i);
        if type(opt)~=10
            msg = _("%s: Argument #%d: word expected.\n");
            error(msprintf(msg, fname, i+1))
        end
        if size(opt,"*")~=1
            msg = _("%s: Argument #%d: Scalar (1 component) expected.\n");
            error(msprintf(msg, fname, i+1))
        end
        opt = convstr(opt);
        expected = ["info" "box" "axes" "grid" "colormap"];
        if ~or(opt==expected)
            disp(opt)
            msg = _("%s: Argument #%d: value among {%s} expected.\n");
            error(msprintf(msg, fname, i, strcat(""""+expected+"""",",")))
        end
        // The option is a known one
        if opt=="info"
            info = "top";
            if i<noa
                tmp = varargin(i+1)
                if type(tmp)==10 & size(tmp,"*")==1 & or(convstr(tmp)==["left" "bottom"])
                    info = convstr(tmp);
                    j = i+1;
                end
             end

        elseif opt=="colormap"
            accordingColormap = %t;

        elseif opt=="box"
            if i<noa
                j = i+1;
                opt = varargin(j);
                if type(opt)==10 & size(opt,"*")==1 & convstr(opt)=="off"
                    boxC = -2;
                    continue
                end
                // We expect the specifications: color|thickness|both
                [BoxC, BoxT] = jimdisp_getParams("box", opt, j);
                if BoxC~=%inf, boxC = BoxC, end
                if BoxT~=%inf, boxT = BoxT, end
            end

        elseif opt=="axes"
            axes = %t;
            // No following value expected

        elseif opt=="grid"
            axes = %t;
            if i<noa
                j = i+1;
                opt = varargin(j);
                if type(opt)==10 & size(opt,"*")==1 & convstr(opt)=="on"
                    gridC = color("black");
                    continue
                end
                // We expect the specifications: color|thickness|both
                [GridC, GridS] = jimdisp_getParams("grid", opt, j);
                if GridC~=%inf, gridC = GridC, end
                if GridS~=%inf, gridS = GridS, end
            else
                gridC = color("black");
            end  // i < noa
        end
    end

    if type(image) == 10 then
        // Case where an image path or URL is given : the image is first
        // loaded with jimread.
        image = jimread(image);
    elseif typeof(image)~="jimage" & ~accordingColormap
        image = jimstandard(image);
    end

    // DISPLAY
    // =======
    drawlaterIN = f.immediate_drawing;
    f.immediate_drawing = "off";

    ax = gca();
    [height, width] = size(image);

    // Image and General settings
    if typeof(image) == "jimage" then
        Matplot(image.image($:-1:1,:,:));
        if ax.parent.type=="Figure" & and(ax.axes_bounds == [0 0 1 1])
            f.figure_name = image.title + "." + image.mime;
        end
    else
        Matplot(image($:-1:1,:,:));
    end
    ax.isoview = "on";
    ax.auto_scale = "on";
    ax.tight_limits = "on";
    ax.margins = [0.10 0.05 0.125 0.10];
    ax.background = -2; // Forcing the background to remain white
    f.background = -2;  // Forcing the background to remain white

    // Axes
        // Graduations according to indices
    ax.axes_reverse(2) = "on";   // to follow components indices
    
    ax.axes_visible = ["off","off","off"];
    if axes then
        ax.axes_visible([1 2]) = "on";
    end
    // Framing box
    if boxC~=-2 then
        ax.box = "on";
        ax.foreground = boxC;
    else
        ax.box = "off";
    end
    ax.thickness = boxT;
    // Grid
    if gridC~=-2 then
        ax.grid = [gridC gridC];
        ax.grid_position = "foreground";
        ax.grid_style = [gridS gridS];
    end
    // Infos
    if info~="" then
        [height, width] = size(image);
        txt = image.title + "." + image.mime + " - " + ..
        jimtype(image) + " - "  + string(height) + " x " + string(width);
        if info=="top"
            ax.title.text = txt;
        elseif info=="bottom"
            ax.x_label.text = txt;
        else
            ax.y_label.text = txt;
        end
    end
    f.immediate_drawing = drawlaterIN;
endfunction

// ---------------------------------------------------------------------------

function jimdisp_mat(image)
// This subfonction changes some parameters of the graphic
// environment in order to display the image properly.

endfunction

// ---------------------------------------------------------------------------

function [boxC, boxT] = jimdisp_getParams(optType, opt, arginN)
    // optType: "box" | "grid"
    // opt: the value of the optional argin
    // arginN: the index of the optional argin in the argin list

    fname = "jimdisp";
    boxC = [0 0 0]; // Default Color
    boxT = %inf;    // Thickness of the framing box or styleIndex of the grid lines.
                    //  %inf means Default
    sv = getversion("scilab");

    if type(opt)==15 // list
        boxC = opt(1);
        if length(opt)>1
            boxT = opt(2);
        end
    elseif typeof(opt)=="ce"
        if sv(1)==6
            execstr("boxC = opt{1}");
            if length(opt)>1
                execstr("boxT = opt{2}");
            end
        else
            boxC = opt.entries(1);
            if length(opt)>1
                boxT = opt.entries(2);
            end
        end
    elseif type(opt(1))==10
        boxC = opt(1);
    elseif opt~=[] & type(opt(1))==1
        if length(opt(:))==3
            boxC = opt;
        else
            boxT = opt(1)
        end
    else
        msg = _("%s: Argument #%d: Wrong %s parameters. word, number, list or cell expected.\n");
        error(msprintf(msg, fname, arginN, optType))
    end
    // Box/Grid color:
    if type(boxC)==10
        boxC = convstr(boxC);
        try
            boxC = color(boxC);
        catch
            msg = _("%s: Argument #%d: Wrong color name.\n");
            error(msprintf(msg, fname, arginN))
        end
    elseif type(boxC)==1
        boxC = real(round(boxC));
        if length(boxC)~=3
            msg = _("%s: Argument #%d: Wrong size for color: [r g b] expected.\n");
            error(msprintf(msg, fname, arginN))
        end
        if min(boxC)<0 | max(boxC)>255
            msg = _("%s: Argument #%d: [r g b] intensities expected in [0 1] or [0 255].\n");
            error(msprintf(msg, fname, arginN))
        end
        if max(boxC)<=1
            boxC = boxC*255;
        end
        boxC = color(boxC(1), boxC(2), boxC(3));
    else
        msg = _("%s: Argument #%d: Wrong %s color specification: Name or [r g b] expected.\n");
        error(msprintf(msg, fname, arginN, optType))
    end
    // Box thickness / Grid style:
    if optType=="box"
        tmp = "box thickness";
    else
        tmp = "grid style";
    end
    if type(boxT)==10
        try
            boxT = evstr(boxT);
        catch
            msg = _("%s: Argument #%d: Wrong %s specification.\n");
            error(msprintf(msg, fname, arginN, tmp))
        end
    end
    if type(boxT)==1
        boxT = max(0, real(round(boxT)));
    else
        msg = _("%s: Argument #%d: Wrong %s specification. Integer expected.\n");
        error(msprintf(msg, fname, arginN, optType))
    end

endfunction
