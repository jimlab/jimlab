// =============================================================================
// //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// =============================================================================

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

if ~atomsIsLoaded("IPD") then
    loaded=1;
    if ~atomsIsInstalled("IPD") then
        installed=1;
        atomsInstall("IPD")
    end
    atomsLoad("IPD")
end

root = jimlabPath();
path = root + "/tests/images/logoEnsim.png";
image = ReadImage(path);

// <-- BENCH START -->
image = ReadImage(path);
// <-- BENCH END -->

if loaded then
    atomsRemove("IPD")
    if installed then
        atomsRemove("IPD",, %T)
    end
end
