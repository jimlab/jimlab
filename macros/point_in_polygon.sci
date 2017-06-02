//Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS

//Copyright (c) 2011, David Adams
//All rights reserved.
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:

//* Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//* The name of David Adams 
//  may not be used to endorse or promote products
//  derived from this software without specific prior written permission.

//THIS FUNCTION IS PROVIDED BY DAVID ADAMS ``AS IS'' AND ANY
//EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//DISCLAIMED. IN NO EVENT SHALL DAVID ADAMS BE LIABLE FOR ANY
//DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN //ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function [inside] = point_in_polygon(xpol, ypol, xpoint, ypoint)
//*****************************************************************************
// function: inside_poly - this function returns a Yes (1), No(0)
// depending on if a point is inside a  polygon or not
//
// Inputs:
//    xpol, ypol are the coordinates of a simple closed polygon 
//    xpoint, ypoint are the coordinates of the point
//
// Outputs: 1 (inside polygon), 0 (not inside polygon)
//
//*****************************************************************************

// make them row vectors instead of column... consistency
if(size(xpol,2)==1) 
    xpol=xpol';
end
if(size(ypol,2)==1) 
    ypol=ypol';
end

//********************************************
// show the polygon
do_the_plot = 0

if(do_the_plot)
    scf(9999);
    // it is assumed that this is a closed polygon
    plot2d(xtemp,ytemp)
end
//********************************************

npol = size(xpol,'*')

out = [%inf 1]

inside = 0
j = npol; // j is the previous vertice 
i = 1
while  i <= npol

    if ((((ypol(i) <= ypoint) & (ypoint < ypol(j)))|((ypol(j) <= ypoint) & (ypoint < ypol(i)))) & ..
       (xpoint < ((xpol(j) - xpol(i))/(ypol(j) - ypol(i))) * (ypoint - ypol(i)) + xpol(i)))

          inside = ~inside;
    end
    i = i + 1;
    j = i - 1;
end

inside = out(inside + 1)
endfunction
