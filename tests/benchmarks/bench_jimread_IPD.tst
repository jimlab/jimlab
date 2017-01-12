// =============================================================================
// //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// =============================================================================

//==============================================================================
// Benchmark for the jimread function
//==============================================================================
//
//  <-- BENCH NB RUN : 10 -->

if ~atomsIsLoaded(IPD) then
    if ~atomsIsInstalled(IPD) then
        atomsInstall(IPD)
    end
    atomsLoad(IPD)
end
global jimlabPath;
path = jimlabPath + '/tests/images/logoEnsim.png';
[image, properties] = ReadImage(path);

// <-- BENCH START -->
[image, properties] = ReadImage(path);
// <-- BENCH END -->
