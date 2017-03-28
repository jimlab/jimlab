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


if ~atomsIsLoaded('IPD') then
    if ~atomsIsInstalled('IPD') then
        atomsInstall('IPD')
    end
    atomsLoad('IPD')
end

root = jimpath();
path = root + '/tests/images/logoEnsim.png';
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
