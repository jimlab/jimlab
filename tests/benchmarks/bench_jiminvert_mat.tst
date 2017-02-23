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

// <-- BENCH START -->

Mat = jiminvert(mat);
// <-- BENCH END -->
