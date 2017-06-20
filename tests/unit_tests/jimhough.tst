// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
// <-- INTERACTIVE TEST -->  // PROVISOIRE. TESTS AUTOMATIQUES À VENIR

// Tests for jimhough()
// --------------------
jim = jimread(jimlabPath()+"/tests/images/hough.png");
[H, rho, a] = jimhough(jim,-80:0.5:70);
clf
drawlater
Matplot(log10(H)/max(log10(H))*255)
f = gcf(); f.color_map = hotcolormap(256);
ax = gca();
e = gce();
nr = size(e.data,1);
b = ceil(nr/2);
ax.data_bounds([1 2]) = [min(a) ; max(a)+1];
ax.data_bounds([3 4]) = [-b ; b-1];
r = ax.children(1).rect;
ax.children(1).rect([1 3]) = [min(a) max(a)+1];
ax.children(1).rect([2 4]) = [-b b-1];
xlabel("$angle\ \theta\ [°]$", "fontsize",3)
ylabel("$Distance\ \rho\ to \ the\ origin\ [px]$", "fontsize",3)
title("HOUGH Tranform: Detection of straight lines", "fontsize",3);
ax.axes_reverse(1) = "on";
ax.grid_position = "foreground";
ax.grid = color("grey60")*[1 1];
ax.grid_style = [8 8];

//colorbar(0,3,[1 255],"$10^%d$")
//e = gce();
//cb = e.parent;
//cb.auto_ticks(2)="off";
//cb.sub_ticks = [3 9];
//t0 = cb.y_ticks;
//t0.locations = (0:3)';
//t0.labels = msprintf("$10^%d}$\n",(0:3)');
//cb.y_ticks = t0;

xsetech([0.15 0.48 0.35 0.4])
jimdisp(~jim,"box")
title("Image")
axi = gca();
axi.title.position=[335 5];
drawnow
