// =============================================================================
// //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// =============================================================================

//==============================================================================
// Benchmark for the jimread function
//==============================================================================
//
//  <-- BENCH NB RUN : 10 -->

try
    if ~atomsIsLoaded('SIVP') then
            if ~atomsIsInstalled('SIVP') then
            atomsInstall('SIVP')
        end
        atomsLoad('SIVP')
    end
catch
    msg = _("%s: This benchmark can not run with this OS.\n");
    error(msprintf(msg,"bench_jimread"));
global jimlabPath;
path = jimlabPath + '/tests/images/logoEnsim.png';
image = imread(path);

// <-- BENCH START -->
image = imread(path);
// <-- BENCH END -->
