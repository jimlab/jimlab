function new_image = jimblur(image)
hw = jcompile("Float", ["public class Float {"
                             "public static float [] getArray() {"
                             "float[] matrix = new float[600];"
                              "for (int i = 0; i < 400; i++) matrix[i] = 1.0f/500.0f;"
                             "return matrix;"
                             "}"
                             "}"]);

m = hw.getArray();

jremove hello hw
sourceImage = jcast(image, "java.awt.image.BufferedImage");
destImage =jnull ;
noyau= Kernel.new (20, 30, m);
op = ConvolveOp.new (ker, ConvolveOp.EDGE_NO_OP, jnull );
blurredImage = op.filter(sourceImage, destImage);
endfunction 
