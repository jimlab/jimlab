// This file is part of Jimlab, an external module coded for Scilab
//  and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
// Copyright (C) 2017 - ENSIM, Université du Maine - Gaël SENÉE
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

function jimdisp(image, varargin)
    // Displays of a gray or colored RGB or RGBA or indexed image.
    // image: matrix or RGB or RGBA hypermatrix or jimage object
    // Options (in any order, case insensitive):
    // "box", "on"|"off": displays a frame around the image
    // "box", idColor|colorName          : specifies the box color
    // "box", [idColor thickness]        : Specifies the box color and thickness (in [1 7])
    // "box", list(colorName, thickness) : same thing
    // "box", {colorName, thickness}     : same thing (Scilab 6)
    //
    // "grid"                            : displays a grid over the image
    // "grid", idColor|colorName         : specifies the grid color
    // "grid", [idColor idStyle]         : Specifies the grid color and style (in [0 12])
    // "grid", list(colorName, idStyle)  : same thing
    // "grid", {colorName, idStyle}      : same thing (Scilab 6)
    //
    // "axes"  : displays graduated axes. (1,1) is opn top-left corner
    // "info"  : displays infos in the main title.
    // "colormap"|"cm": uses the current colormap to display the image as a
    //                  matrix of color indices.

    // Initializing default parameters
    fname = "jimdisp";
    f = gcf();
    info = %f;
    boxC = -1;      // color index (default = -1 = black. -2 = disabled)
    boxT =  1;    // Thickness of the framing box. %inf means Default
    gridC = -1;     // color index (default = -1 = disabled)
    gridS = 7;      // Line style of the grid.
    axes = %f;      // Graduated axes
    grid = 0;
    accordingColormap = %f;

    if ~isdef("varargin", "l") then
        varargin = list();
    end
    noa = length(varargin);      // Number of optional arguments
    for i = 1:noa
        opt = varargin(i);
        if type(opt)==10
            opt = convstr(opt(1));
            if opt=="info"
                info = %t;
                // no value expected. Could later be the vector of fields to
                // be displayed.
            elseif or(opt==["colormap" "cm"])
                accordingColormap = %t;
            elseif opt=="box"
                // We expect the specifications [color thickness]
                if i<noa
                    i = i+1;
                    opt = varargin(i);
                    [BoxC, BoxT] = jimdisp_getParams("box", opt, i+1);
                    if BoxC~=%inf, boxC = BoxC, end
                    if BoxT~=%inf, boxT = BoxT, end
                else
                    boxC = "on";
                end
            elseif opt=="axes"
                axes = %t;
                // No following value expected
            elseif opt=="grid"
                if i<noa
                    i = i+1;
                    opt = varargin(i);
                    [GridC, GridS] = jimdisp_getParams("grid", opt, i+1);
                    if GridC~=%inf, gridC = GridC, end
                    if GridS~=%inf, gridS = GridS, end
                else
                    gridC = "on";
                end  // i < noa
                axes = %t;
                // No following value expected
            end
        end
    end

    if type(image) == 10 then
        // Case where an image path or URL is given : the image is first
        // loaded with jimread.
        image = jimread(image);
    elseif typeof(image)~="jimage" & ~accordingColormap
        image = jimstandard(image);
    end

    drawlaterIN = f.immediate_drawing;
    f.immediate_drawing = "off";
    jimdisp_mat(image);

    ax = gca();
    // Graduations according to indices
    if axes then
        ax.axes_visible([1 2]) = "on";
    end
    // Framing box
    if type(boxC)==10 then
        ax.box = boxC;
    else    // box color
        ax.box = "on";
        ax.foreground = boxC;
    end
    ax.thickness = boxT;
    // Grid
    if type(gridC)==10 then
        ax.grid = [1 1];
        ax.grid_position = "foreground";
    else    // grid color
        ax.grid = [gridC gridC];
        ax.grid_position = "foreground";
    end
    ax.grid_style = [gridS gridS];

    // Infos
    if info then
        [height, width] = size(image);
        ax.title.text = image.title + "." + image.mime + " - " + ..
        jimtype(image) + " - "  + string(height) + " x " + string(width);
    end
    f.immediate_drawing = drawlaterIN;
endfunction

// ---------------------------------------------------------------------------

function jimdisp_mat(image)
// This subfonction changes some parameters of the graphic
// environment in order to display the image properly.

    // Opening of the current parameters of the graphic environment
    fig = gcf();
    ax = gca();

    // Size of the matrix
    [height, width] = size(image);

    // Setting of the display
    if typeof(image) == "jimage" then
        Matplot(image.image($:-1:1,:,:));
        if ax.parent.type=="Figure" & and(ax.axes_bounds == [0 0 1 1])
            fig.figure_name = image.title + "." + image.mime;
        end
    else
        Matplot(image($:-1:1,:,:));
    end
    ax.box = "on";
    ax.axes_reverse(2) = "on";   // to follow components indices
    ax.axes_visible = ["off","off","off"];

    ax.isoview = "on";
    ax.auto_scale = "on";
    ax.tight_limits = "on";
    ax.title.text = "";
    ax.margins = [0.05 0.05 0.125 0.08];
    ax.background = -2; // Forcing the background to remain white
    fig.background = -2; // Forcing the background to remain white
endfunction

// ---------------------------------------------------------------------------

function [boxC, boxT] = jimdisp_getParams(optType, opt, arginN)
    // optType: "box" | "grid"
    // opt: the value of the optional argin
    // arginN: the index of the optional argin in the argin list

    fname = "jimdisp";
    boxC = %inf;    // Color index. %inf means Default
    boxT = %inf;    // Thickness of the framing box. %inf means Default
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
                bocT = opt.entries(2);
            end
        end
    elseif type(opt(1))==10
        boxC = opt(1);
        if size(opt,2)>1
            boxT = opt(2);
        end
    elseif opt~=[] & type(opt(1))==1
        boxC = opt(1)
        if length(opt(:))>1
            boxT = opt(2);
        end
    else
        msg = _("%s: Argument #%d: Wrong %s parameters. [color thickness] expected.\n");
        error(msprintf(msg, fname, arginN, optType))
    end
    // Box color:
    if type(boxC)==10
        boxC = convstr(boxC);
        if ~or(boxC==["on" "off"])
            try
                boxC = color(boxC);
            catch
                msg = _("%s: Argument #%d: Wrong color name.\n");
                error(msprintf(msg, fname, arginN))
            end
        end
    elseif type(boxC)==1
        boxC = real(round(boxC));
        if boxC<-2 | boxC>size(f.color_map,1)
            msg = _("%s: Argument #%d: Wrong color index. Must be in [-2, %d].\n");
            error(msprintf(msg, fname, arginN, size(f.color_map,1)))
        end
    else
        msg = _("%s: Argument #%d: Wrong %s color specification. A valid name or index expected.\n");
        error(msprintf(msg, fname, arginN, optType))
    end
    // Box thickness:
    if type(boxT)==10
        try
            boxT = evstr(boxT);
        catch
            msg = _("%s: Argument #%d: Wrong thickness specification.\n");
            error(msprintf(msg, fname, arginN))
        end
    end
    if type(boxT)==1
        boxT = max(0, real(round(boxT)));
    else
        msg = _("%s: Argument #%d: Wrong %s thickness specification. Integer expected.\n");
        error(msprintf(msg, fname, arginN, optType))
    end

endfunction
