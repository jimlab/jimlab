function [MG]=gsm2d(M,sigma,rayon)
    // déclaration des variables
    Kf=0;
    g=0;
    
    select argn(2)
        case 1
           sigma = 5;
        case 0
           error('Invalid number of arguments.');
       end
       
       if(sigma==1) then   error('erreur');end
       if(rayon<1) then   error('erreur');end
       
    for i = -rayon:rayon
        for j = -rayon:rayon
             e= exp( -(i^2+j^2) /(2*sigma*sigma));
             kf=kf+e;
             Kernel(i+rayon, j+rayon) =e;
         end 
     end
     
       for i = -rayon:rayon
        for j = -rayon:rayon
              Kernel(i+rayon, j+rayon)  =   Kernel(i+rayon, j+rayon) /kf;
        end
       end
       
       MG= conv2(Kernel,M); 
 end      
