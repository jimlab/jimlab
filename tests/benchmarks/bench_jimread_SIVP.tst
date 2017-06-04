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
path = root + "/tests/images/logoEnsim.png";
image = imread(path);

// <-- BENCH START -->
image = imread(path);
// <-- BENCH END -->

if loaded then
    atomsRemove("SIVP")
    if installed then
        atomsRemove("SIVP",, %T)
    end
end

