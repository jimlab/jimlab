// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
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

if v(1) == 6 then
    module ="scicv";
else
    msg = _("%s: This benchmark cannot run with this version of Scilab.\n");
    error(msprintf(msg,"bench_jimread"));
end

if ~atomsIsLoaded(module) then
    if ~atomsIsInstalled(module) then
        atomsInstall(module);
        atomsAutoloadDel(module);
    end
    atomsLoad(module);
end

root = jimlabPath("/");
path = root + mgetl(root + "tests/benchmarks/read_filename.txt",1);
path = getshortpathname(path);
image = imread(path);

// <-- BENCH START -->
image = imread(path);
// <-- BENCH END -->
