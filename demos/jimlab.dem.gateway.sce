//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function subdemolist = demo_gateway()
    demopath = get_absolute_file_path("jimlab.dem.gateway.sce");
    // List here The titles (that will appear in the demo menu) and related demo file names
    subdemolist = [ "Flipping up-down/left-right", "flipping.dem.sce"; ..
                    "Negative"                   , "jimnegative.dem.sce"; ..
                    "Balancing colors with mean()","balancing_colors.dem.sce"; ..
                    "Managing color layers"     ,"jimColorsLayers.dem.sce"; ..
                    "Detecting straight lines"   , "jimhough.dem.sce"; ..
                  ];
    subdemolist(:,2) = demopath + subdemolist(:,2);
endfunction

subdemolist = demo_gateway();
clear demo_gateway
