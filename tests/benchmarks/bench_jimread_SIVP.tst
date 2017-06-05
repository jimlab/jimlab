// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

//==============================================================================
// Benchmark for the jimread function
//==============================================================================
//
//  <-- BENCH NB RUN : 10 -->

v = getversion("scilab");

if v(1) ~= 5 then
    msg = _("%s: This benchmark cannot run with this version of Scilab.\n");
    error(msprintf(msg,"bench_jimread"));
end

loaded = 0;
installed = 0;

if (getos() == "Windows" | getos() == "Linux")
    if ~atomsIsLoaded("SIVP") then
        loaded = 1;
        if ~atomsIsInstalled("SIVP") then
            installed = 1;
            atomsInstall("SIVP")
        end
        atomsLoad("SIVP")
    end
else
    msg = _("%s: This benchmark cannot run with this OS.\n");
    error(msprintf(msg,"bench_jimread"));
end

root = jimlabPath();
path = root + "/tests/images/logoEnsim_rgba.png";
image = imread(path);

// <-- BENCH START -->
image = imread(path);
// <-- BENCH END -->

if loaded then
    atomsRemove("SIVP")
    if installed then
        atomsRemove("SIVP", %T)
    end
end

