// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
 
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at    
// http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function jimlabPath = jimpath(sep)
    //This function returns the path of Jimlab library in a string with or without a final separator.
    //sep : a character, "/" or "\". If sep exists, a final separator is added to jimlabPath.
    
    if isdef('jimlablib') then
        [m, mp] = libraryinfo('jimlablib');
        //remove '/marcos' from jimlabPath in Scilab 6.0.0
        if v(1) == 6 then
            jimlabPath = pathconvert(fullpath(mp), %t, %t);
            tmp= filesep() + 'macros'
            jimlabPath = strsubst(jimlabPath, tmp, '')
        else
            jimlabPath = pathconvert(fullpath(mp + "../"), %t, %t);
        end
    else 
        msg = _("%s: Jimlab library is not loaded.\n");
        error(msprintf(msg,"jimpath"));
    end
endfunction
