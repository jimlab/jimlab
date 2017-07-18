//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function subdemolist = demo_gateway()
    demopath = get_absolute_file_path("jimlab.dem.gateway.sce");
    // List here The titles (that will appear in the demo menu) and related demo file names
    subdemolist = ["Negative"  ,"jimnegative.dem.sce"; ..
                  ];

    subdemolist(:,2) = demopath + subdemolist(:,2);

endfunction

subdemolist = demo_gateway();
clear demo_gateway
