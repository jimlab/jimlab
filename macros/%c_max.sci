// This file overcomes the bug http://bugzilla.scilab.org/15157
// occuring with Scilab 6.0. It is unused with Scilab 5.5.
//
// TO BE REMOVED after the bug 15157 will be FIXED
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt
 
function [m, k] = %c_max(obj,varargin)
    v = getversion("scilab");
    if v(1)==6 then
        if size(varargin)>0
            execstr("[m, k] = %"+typeof(obj,"overload")+"_max(obj,varargin)");
        else
            execstr("[m, k] = %"+typeof(obj,"overload")+"_max(obj)");
        end
    end
endfunction
