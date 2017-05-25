// =============================================================================
// //Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// =============================================================================

//==============================================================================
// Benchmark for the jimread function
//==============================================================================
//
//  <-- BENCH NB RUN : 10 -->

root = jimlabPath();
path = root + '/tests/images/logoEnsim.png';
Jimage = jimread(path);

// <-- BENCH START -->
Jimage = jimread(path);
// <-- BENCH END -->
