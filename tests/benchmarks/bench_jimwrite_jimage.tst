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
jimage1 = jimread(path)
path = jimlabPath + '/tests/images/';

// <-- BENCH START -->

jimwrite(jimage1,,path,'png','BenchTest_jimage',);

// <-- BENCH END -->

path = jimlabPath + '/tests/images/BenchTest_jimage.png';
mdelete(path);
