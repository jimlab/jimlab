// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas AEGERTER
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
 
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at    
// http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function path = jimlabPath(sep)
    //This function returns the path of Jimlab library in a string with or without a final separator.
    //sep : a character, "/" or "\". If sep exists, a final separator is added to jimlabPath.
    
    //Jimlab must be loaded 
    if (isdef(['jimlablib'],'a')) then 
        v = getversion("scilab");
        [m, mp] = libraryinfo("jimlablib");// Get the path from libraryinfo.
        //remove '/marcos' from path
        path = pathconvert(fullpath(mp), %t, %t);
        tmp= filesep() + 'macros' + filesep()
        path = strsubst(path, tmp, '')
    else 
        msg = _("%s: Jimlab library is not loaded.\n");
        error(msprintf(msg,"jimlabPath"));
    end
    
    if(isdef(["sep"],"l"))
        if ((sep ~= "/" )& (sep ~= "\")) then
            msg = _("%s: Argument #%d: / or \ expected.\n");
            warning(msprintf(msg,"jimlabPath", 1));
        else
            path = path + filesep() //adding a final separator.
        end
    end
    
endfunction
    
