//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function subdemolist = demo_gateway()
    demopath = get_absolute_file_path("jimlab.dem.gateway.sce");
	// List here The titles (that will appear in the demo menu) and related demo file names
    subdemolist = ["Example #1"  ,"example_1.dem.sce"; ..
				   "Example #2"  ,"example_2.dem.sce"; ..
				  ];

    subdemolist(:,2) = demopath + subdemolist(:,2);

endfunction

subdemolist = demo_gateway();
clear demo_gateway  // remove demo_gateway on stack
colorbar()