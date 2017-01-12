// =============================================================================
// //Copyright (C) 2017 - ENSIM, Université du Maine - Gael SENEE
// =============================================================================

//==============================================================================
// Benchmark for the jimread function
//==============================================================================
//
//  <-- BENCH NB RUN : 10 -->

global jimlabPath

path = jimlabPath + '/tests/images/logoEnsim.png';
jimage1 = jimread(path);

// <-- BENCH START -->

jimdisp(jimage1,'box','info');
// <-- BENCH END -->
