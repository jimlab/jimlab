jim = jimread(jimlabPath()+'/tests/images/logoEnsim_gray.png');

resizedImage = jimresize (jim, 1000,1024, 'natural', 'natural');


subplot(1,2,1)
jimdisp(jim)
subplot(1,2,2)
jimdisp(resizedImage)

clear mask
clear out_mat
clear out

originalImage = jim(10:19,10:19);
originalImage = originalImage.image;
interp_type = 'natural' ;

    [h,w] = size(originalImage);
    
    // Setting the interpolation parameters
    x = linspace(0,1,w) ;
    y = linspace(0,1,h) ;

    layer1 = double(originalImage(:,:,1));
    layer2 = double(originalImage(:,:,2));
    layer3 = double(originalImage(:,:,3));
    layer4 = double(originalImage(:,:,4));
    
    
    spl1 = splin2d(x, y, layer1, interp_type) ;
    spl2 = splin2d(x, y, layer2, interp_type) ;
    spl3 = splin2d(x, y, layer3, interp_type) ;
    spl4 = splin2d(x, y, layer4, interp_type) ;
    
    xx = linspace(0,1,2*w) ;
    yy = linspace(0,1,2*h) ;

    [XX,YY] = ndgrid(xx,yy);
    out_mat(:,:,1) = floor(interp2d(XX,YY, x, y, spl1, interp_type));
    out_mat(:,:,2) = floor(interp2d(XX,YY, x, y, spl2, interp_type));
    out_mat(:,:,3) = floor(interp2d(XX,YY, x, y, spl3, interp_type));
    out_mat(:,:,4) = floor(interp2d(XX,YY, x, y, spl4, interp_type));
    
    mask255(:,:,1) = (out_mat(:,:,1) >= 255);
    mask255(:,:,2) = (out_mat(:,:,2) >= 255);
    mask255(:,:,3) = (out_mat(:,:,3) >= 255);
    mask255(:,:,4) = (out_mat(:,:,4) >= 255);

    mask0(:,:,1) = (out_mat(:,:,1) < 0);
    mask0(:,:,2) = (out_mat(:,:,2) < 0);
    mask0(:,:,3) = (out_mat(:,:,3) < 0);
    mask0(:,:,4) = (out_mat(:,:,4) < 0);

    out1(:,:,1) = 255*mask255(:,:,1) + out_mat(:,:,1) .* ~mask255(:,:,1);
    out1(:,:,2) = 255*mask255(:,:,2) + out_mat(:,:,2) .* ~mask255(:,:,2);
    out1(:,:,3) = 255*mask255(:,:,3) + out_mat(:,:,3) .* ~mask255(:,:,3);
    out1(:,:,4) = 255*mask255(:,:,4) + out_mat(:,:,4) .* ~mask255(:,:,4);
    
    out2(:,:,1) = out1(:,:,1) .* ~mask0(:,:,1);
    out2(:,:,2) = out1(:,:,2) .* ~mask0(:,:,2);
    out2(:,:,3) = out1(:,:,3) .* ~mask0(:,:,3);
    out2(:,:,4) = out1(:,:,4) .* ~mask0(:,:,4);
    
    interpolatedImage = out2 ;
    
    
    im = uint8(interpolatedImage);
    
    mat_image = jim.image;
    
    [h,w] = size(mat_image);
    
    // Setting the interpolation parameters
    x = linspace(0,1,h) ;
    y = linspace(0,1,w) ;

    layer = double(mat_image);

    spl = splin2d(x, y, layer, interp_type) ;

    xx = linspace(0,1,2*h) ;
    yy = linspace(0,1,2*w) ;

    [XX,YY] = ndgrid(xx,yy);
    out = floor(interp2d(XX,YY, x, y, spl, interp_type));

    mask = out(:,:,1) >= 255;
    
    interpolatedImage = 255*mask + out.* ~mask;
    
    im = uint8(interpolatedImage);

