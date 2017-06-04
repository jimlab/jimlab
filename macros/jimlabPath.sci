// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas AEGERTER
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt


function path = jimlabPath(sep)
    // This function returns the path of Jimlab library in a string
    // with or without a final separator.
    // sep : a character, "/" or "\". If sep exists, the OS file
    //      separator is appended to the returned path

    if isdef("jimlablib","a") then 
        // Jimlab is loaded => we use libraryinfo()
        v = getversion("scilab");
        [m, mp] = libraryinfo("jimlablib");
        //remove "/macros" from path
        path = pathconvert(mp, %f, %t);
        tmp = filesep() + "macros";
        path = strsubst(path, "|\"+tmp+"$|", "", "r");
    else
        // Is Jimlab an installed ATOMS?
        tmp = atomsGetInstalled();
        path = tmp(find(tmp(:,1)=="jimlab"),4);
        path = path($);
        if path==[]
            msg = _("%s: Jimlab is neither installed nor loaded.\n");
            error(msprintf(msg,"jimlabPath"));
        end
        path = strsubst(path, "|^SCI|", SCI, "r");
    end
    
    if getos()=="Windows"
        path = getlongpathname(path);
    end
    if isdef("sep", "l") & type(sep)~=0
        if and(sep~=["/" "\"]) then
            // If a wrong argument is given, no separator is appended
            //  and the user is warned:
            msg = _("%s: Argument #%d: / or \ expected.\n");
            warning(msprintf(msg,"jimlabPath", 1));
        else
            path = path + filesep()
        end
    end
endfunction
