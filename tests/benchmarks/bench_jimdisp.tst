// This file is part of the Jimlab module,
// an external module coded for Scilab and dedicated to image processing.
//
// Copyright (C) 2017 - ENSIM, Université du Maine - Gaël SENÉE
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which you
// should have received as part of this distribution.  The terms are also
// available at http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt
//
//==============================================================================
// Benchmark for the jimdisp function
//==============================================================================

//  <-- BENCH NB RUN : 10 -->

global jimlabPath

path = jimlabPath + '/tests/images/logoEnsim.png';
jimage1 = jimread(path);

// <-- BENCH START -->

jimdisp(jimage1,'box','info');

// <-- BENCH END -->
