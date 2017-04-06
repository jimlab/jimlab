//Copyright (C) 2017 - ENSIM, Université du Maine - Nicolas Aegerter
 
 //This file must be used under the terms of the CeCILL.
 //This source file is licensed as described in the file COPYING, which
 //you should have received as part of this distribution.  The terms
 //are also available at    
 //http://www.cecill.info/licences/Licence_CeCILL_V2.1-fr.txt

function [Converted_Mat, Original_Type] = jimstandard(imageMat,Colormap)
    
    if(~isdef(["Colormap",'l'])|(type(Colormap) == 0))// selection of the matrix type
        Original_Type = type(imageMat);
   
        Converted_Mat = %nan;
    
            select(Original_Type)
            case 1 then// Converted a real matrix of real arguments
                if((max(imageMat) == 1.)&(min(imageMat) == 0.))
                 Converted_Mat = uint8(255*imageMat);
                else
                 Converted_Mat = uint8(255*(imageMat/max(imageMat)));
                end
            case 4 then // Convert a boolean matrix
                imageMat = bool2s(imageMat)
                Converted_Mat = 255*uint8(imageMat)
            case 8 then // Matrix of int
                if((max(imageMat) == 1)&(min(imageMat) == 0))
                    Converted_Mat = uint8(255*imageMat);
                else
                    select(inttype(imageMat))
                    case 1
                        Converted_Mat = (imageMat + 127);
                        Original_Type = 81;
                    case 4
                        if(size(imageMat,3) ~= 1)
                        Converted_Mat = %nan;
                    else
                       
                    end
                end
                
                end
                
                    
                        
                        
                        
                        
                        
                end
   
      elseif(isdef(['Colormap','l']))
          return 1;
      end
      
      
      
      if((Converted_Mat(:,:,:) == %nan)|(size(Converted_Mat,3) >4))
          Converted_Mat = %f;
      end
      
    
endfunction
