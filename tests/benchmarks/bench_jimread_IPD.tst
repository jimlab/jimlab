// =============================================================================
// //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// =============================================================================

//==============================================================================
// Benchmark for the jimread function
//==============================================================================
//
//  <-- BENCH NB RUN : 10 -->

try
    if ~atomsIsLoaded('IPD') then
            if ~atomsIsInstalled('IPD') then
            atomsInstall('IPD')
        end
        atomsLoad('IPD')
    end
catch
    msg = _("%s: This benchmark can not run with this OS.\n");
    error(msprintf(msg,"bench_jimread"));
end
path = jimlabPath + '/tests/images/logoEnsim.png';
image = ReadImage(path);

// <-- BENCH START -->
image = ReadImage(path);
// <-- BENCH END -->

if ~loaded then
    atomsQuit('IPD')
    if ~installed then
        atomsRemove('IPD')
    end
end
