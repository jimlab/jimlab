//Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas AEGERTER
//This file must be used under the terms of the CeCILL.
//This source file is licensed as described in the file COPYING, which
//you should have received as part of this distribution.  The terms
//are also available at    
//http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

// <-- NO CHECK REF -->

// From an jimage file 
global jimlabPath
imagePath = jimlabPath +'\tests\images\noError\rgb.jpg';

jimage = jimread(imagePath);
imagePath = jimlabPath +'\tests\images\noError\';

// Simple call
jimwrite(jimage);

// With path
jimwrite(jimage,imagePath);

// With path and format
jimwrite(jimage,imagePath,'jpg');
jimwrite(jimage,imagePath,'png');
jimwrite(jimage,imagePath,'gif');
jimwrite(jimage,imagePath,'bmp');
jimwrite(jimage,imagePath,'wbmp');

// With format
jimwrite(jimage,,'jpg');
jimwrite(jimage,,'png');
jimwrite(jimage,,'gif');
jimwrite(jimage,,'bmp');
jimwrite(jimage,,'wbmp');

// With path, format and name
jimwrite(jimage,imagePath,'png','testname');
jimwrite(jimage,imagePath,'gif','testname');
jimwrite(jimage,imagePath,'bmp','testname');
jimwrite(jimage,imagePath,'wbmp','testname');

// With path and name
jimwrite(jimage,imagePath,,'testname');

// With format and name
jimwrite(jimage,,'png','testname');
jimwrite(jimage,,'gif','testname');
jimwrite(jimage,,'bmp','testname');
jimwrite(jimage,,'wbmp','testname');

