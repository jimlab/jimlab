// =============================================================================
// //Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas Aegerter
// =============================================================================

//==============================================================================
// Benchmark for the jiminvert function
//==============================================================================
//
//  <-- BENCH NB RUN : 10 -->

global jimlabPath

path = jimlabPath + '/tests/images/logoEnsim.png';
jimage1 = jimread(path);

// <-- BENCH START -->

jimage2 = jiminvert(jimage1);

// <-- BENCH END -->
