// Copyright (C) 2008 - INRIA
// Copyright (C) 2009-2011 - DIGITEO
// Copyright (C) 2017 - ENSIM, Université du Maine - Camille CHAILLOUS
// Copyright (C) 2017 - ENSIM, Université du Maine - Samuel GOUGEON
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function main_builder()

    TOOLBOX_NAME  = "jimlab";
    TOOLBOX_TITLE = "jimlab";
    toolbox_dir = pwd();        // for working out

    // Check Scilab's version
    // ======================
    v = getversion("scilab");
    if strcmp(msprintf("%d.%d",v(1),v(2)), "5.5") < 0 then
        error(gettext("Scilab 5.5 or more is required."));
    end

    // Actions
    // =======
    toolbox_dir   = get_absolute_file_path("builder.sce");
    // Macros
    mprintf("Building macros...\n-- Creation of [%s] --\n", TOOLBOX_NAME+"lib");
    genlib(TOOLBOX_NAME+"lib", toolbox_dir+"macros", %t);   // to force rebuilding
    genlib("jimagelib", toolbox_dir+"macros/overload", %t); // to force rebuilding
    //tbx_builder_macros(toolbox_dir);

    // loader and cleaner
    if v(1)==5 then
        tbx_build_loader(TOOLBOX_NAME, toolbox_dir);
        tbx_build_cleaner(TOOLBOX_NAME, toolbox_dir);
    else
        tbx_build_loader(toolbox_dir);
        tbx_build_cleaner(toolbox_dir);
    end

    // Help pages
    tbx_builder_help(toolbox_dir);
endfunction
// =============================================================================
main_builder();
clear main_builder; // remove main_builder on stack
// =============================================================================
