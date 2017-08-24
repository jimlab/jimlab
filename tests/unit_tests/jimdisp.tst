// This file is part of Jimlab, an external module coded for Scilab and
// dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

// Unit test for jimdisp()

Scivers = getversion("scilab");
Scivers = Scivers(1);
jim = jimread(jimlabPath() +"\tests\images\noError\rgb.jpg");

options = [
    """info"""
    """info"",""bottom"""
    """info"",""left"""
    """axes"""
    """box"", ""off"""
    """box"", ""red"""
    """box"", [0 1 0]"
    """box"", 3"
    """box"", list(""red"",3)"
    """box"", list([1 0 1],4)"
    ];
if Scivers==6  then
    options = [options ; """box"", {""blue"", 2}" ; """box"", {[0 0 1], 3}"];
end
options = [options ; ..
    """grid"", ""on"""
    """grid"", ""red"""
    """grid"", [0 0 1]"
    """grid"", 3"
    """grid"", list(""red"",3)"
    """grid"", list([1 0 1],3)"
    ];
if Scivers==6  then
    options = [options ; """grid"", {""blue"", 2}" ; """grid"", {[0 0 1], 3}"];
end

// Plotting:
n = size(options,"*")+1;
nC = ceil(sqrt(n*5/3));
nL = ceil(n/nC);

scf(0);
clf
subplot(nL, nC,1), jimdisp(jim);
for i = 1:n-1
    o = options(i);
    subplot(nL,nC,i);
    execstr("jimdisp(jim, "+o+")");
    if grep(o,"info")==[] | grep(o,["left" "bottom"])~=[]
        xtitle("Options: "+o)
    else
        xlabel("Options: "+o);
    end
end

// Untested:
// "colormap"|"cm": uses the current colormap to display the image as a
//                  matrix of color indices.

// TESTS SWITH MIXED OPTIONS
// =========================
options = [
    """info"", ""axes"""
    """axes"",""info"",""bottom"""
    """info"",""left"",""box"",""off"""
    """info"",""box"", ""red"""
    """box"", [0 1 0],""axes"",""info"",""left"""
    """axes"",""box"", 3,""info"",""bottom"""
    """box"", 3,""info"",""left"",""grid"",""red"""
    """box"", 2,""grid"",""red"",""box"",""off"""
    """box"", ""off"",""grid"",""red"""
    ];
if Scivers==6  then
//    options = [options ; """box"", {""blue"", 2}" ; """box"", {[0 0 1], 3}"];
end
//options = [options ; ..
//    """grid"", ""on"""
//    """grid"", ""red"""
//    """grid"", [0 0 1]"
//    """grid"", 3"
//    """grid"", list(""red"",3)"
//    """grid"", list([1 0 1],3)"
//    ];
if Scivers==6  then
//    options = [options ; """grid"", {""blue"", 2}" ; """grid"", {[0 0 1], 3}"];
end

// Plotting:
n = size(options,"*")+1;
nC = ceil(sqrt(n*5/3));
nL = ceil(n/nC);

scf(1);
clf
subplot(nL, nC,1), jimdisp(jim);
for i = 1:n-1
    o = options(i);
    subplot(nL,nC,i);
    execstr("jimdisp(jim, "+o+")");
    if grep(o,"info")==[] | grep(o,["left" "bottom"])~=[]
        xtitle("Options: "+o)
    else
        xlabel("Options: "+o);
    end
end
