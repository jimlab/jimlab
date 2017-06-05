// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas AEGERTER
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt

//==============================================================================
// Benchmark for the jimwrite function
//==============================================================================
//
//  <-- BENCH NB RUN : 10 -->


path = jimlabPath() + '/tests/images/mat.data';
load(path);
path = jimlabPath() + '/tests/images/';

// <-- BENCH START -->
jimwrite(mat,path + 'BenchTest_mat','rgb','png');
// <-- BENCH END -->

path = jimlabPath() + '/tests/images/BenchTest_mat.png';
mdelete(path);
