// =============================================================================
// //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// =============================================================================

//==============================================================================
// Benchmark for the jimread function
//==============================================================================
//
//  <-- BENCH NB RUN : 10 -->

v = getversion("scilab");

if v(1) == 5 then
    module = "SIP";
elseif v(1) == 6 then
    module ="IPCV"
else
    msg = _("%s: This benchmark cannot run with this version of Scilab.\n");
    error(msprintf(msg,"bench_jimread"));
end

loaded = 0;
installed = 0;

if (getos() == "Linux" | (getos() == "Windows" & module == "IPCV")) then
    if ~atomsIsLoaded(module) then
            loaded=1;
            if ~atomsIsInstalled(module) then
            installed=1;
            atomsInstall(module)
        end
        atomsLoad(module)
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
    atomsRemove(module)
    if installed then
        atomsRemove(module,,%T)
    end
end

