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
//  <-- BENCH NB RUN : 50 -->

v = getversion("scilab");

if v(1) ~= 5 then
    msg = _("%s: This benchmark cannot run with this version of Scilab.\n");
    error(msprintf(msg,"bench_jimread"));
end

if ~atomsIsLoaded("IPD") then
    if ~atomsIsInstalled("IPD") then
        atomsInstall("IPD")
        atomsAutoloadDel("IPD");
    end
    atomsLoad("IPD")
end

path = getshortpathname(jimlabPath() + "/tests/images/logoEnsim_rgba.png");
image = ReadImage(path);

// <-- BENCH START -->
image = ReadImage(path);
// <-- BENCH END -->
