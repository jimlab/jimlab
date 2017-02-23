// =============================================================================
// //Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas Aegerter
// =============================================================================

//==============================================================================
// Benchmark for the jiminvert function
//==============================================================================
//
//  <-- BENCH NB RUN : 10 -->

global jimlabPath

path = jimlabPath + '/tests/images/mat.data';
load(path);
path = jimlabPath + '/tests/images/';

// <-- BENCH START -->
jimwrite(,mat,path,'png','BenchTest_mat','rgb');
// <-- BENCH END -->
path = jimlabPath + '/tests/images/BenchTest_mat.png';
mdelete(path);
