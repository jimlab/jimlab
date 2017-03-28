// =============================================================================
// //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// =============================================================================

//==============================================================================
// Benchmark for the jimread function
//==============================================================================
//
//  <-- BENCH NB RUN : 10 -->

v = getversion('scilab');

if v(1) ~= 5 then
    msg = _("%s: This benchmark cannot run with this version of Scilab.\n");
    error(msprintf(msg,"bench_jimread"));
end

if (getos() == "Windows" | getos() == "Linux")
    if ~atomsIsLoaded('SIVP') then
            if ~atomsIsInstalled('SIVP') then
            atomsInstall('SIVP')
        end
        atomsLoad('SIVP')
    end
else
    msg = _("%s: This benchmark cannot run with this OS.\n");
    error(msprintf(msg,"bench_jimread"));
end

root = jimpath();
path = root + '/tests/images/logoEnsim.png';
image = imread(path);

// <-- BENCH START -->
image = imread(path);
// <-- BENCH END -->

if ~loaded then
    atomsQuit('SIVP')
    if ~installed then
        atomsRemove('SIVP')
    end
end
