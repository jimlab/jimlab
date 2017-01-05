// =============================================================================
// //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// =============================================================================

//==============================================================================
// Benchmark for the jimread function
//==============================================================================
//
//  <-- BENCH NB RUN : 10 -->

global jimlabPath;
path = jimlabPath + '/tests/images/logoEnsim.png';

// <-- BENCH START -->
[image, properties] = jimread(path);
// <-- BENCH END -->
