// =============================================================================
// //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// =============================================================================

//==============================================================================
// Benchmark for the jimread function
//==============================================================================
//
//  <-- BENCH NB RUN : 10 -->

try
    if ~atomsIsLoaded('SIP') then
            loaded=1;
            if ~atomsIsInstalled('SIP') then
            installed=1;
            atomsInstall('SIP')
        end
        atomsLoad('SIP')
    end
catch
    msg = _("%s: This benchmark can not run with this OS.\n");
    error(msprintf(msg,"bench_jimread"));
end

path = jimlabPath + '/tests/images/logoEnsim.png';
image = imread(path);

// <-- BENCH START -->
image = imread(path);
// <-- BENCH END -->

if ~loaded then
    atomsQuit('SIP')
    if ~installed then
        atomsRemove('SIP')
    end
end

