// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 1993 - INRIA - Serge Steer
// Copyright (C) 1993 - INRIA - Habib Jreij
// Copyright (C) 2012 - 2016 - Scilab Enterprises
// Copyright (C) 2017 - Samuel GOUGEON : À PROPOSER ET COMMITER DANS SCILAB
//  - utilise le repère courant s'il existe et si gc n'est pas indiqué : FAIT
//    alors :
//    - conserve la fenêtre graphique en sortant: FAIT
//    - fixe gce() à la courbe dessinée : FAIT
//  - ajouter la possibilité de supprimer un point : FAIT
//  - fusionner les 2 polylines produites : FAIT
//  - on conserve la toolbar : FAIT
//  - It is no longer possible to set points out of the axes : DONE
//  TODO 
//  - possibilité de fournir le handle d'un polyline au lieu de x et y
//  - possibilité d'indiquer le style du trait (possible sur le handle AVANT l'appel).
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function [x,y,ok,gc] = edit_curv(x,y,job,tit,gc)
    //   mod_curv  - Edition  de courbe interactive
    //%Syntaxe
    //  [x,y,ok]=mod_curv(xd,yd,job,tit)
    //%Parametres
    //  xd    :  vecteur des abscisses donnees (eventuellement [])
    //  yd    :  vecteur des ordonnees donnees (eventuellement [])
    //  job   :  chaine de 3 caracteres  specifiant les operations
    //           permises:
    //            - Si la chaine contient le caractere 'a', il est
    //              possible d'ajouter des points aux donnees, sinon
    //              il est seulement possible de les deplacer
    //            - Si la chaine contient le caractere 'x', il est
    //              possible de deplacer les points horizontalement
    //            - Si la chaine contient le caractere 'y', il est
    //              possible de deplacer les points verticalement
    //  tit   : liste de trois chaines de caracteres
    //          tit(1) : titre de la courbe (peut etre un vecteur colonne)
    //          tit(2) : label de l'axe des abscisses
    //          tit(3) : label de l'axe des ordonnees
    //  x     : vecteur des abscisses resultat
    //  y     : vecteur des ordonnees resultat
    //  ok    : vaut %t si la sortie as ete demandee par le menu Ok
    //           et  %f si la sortie as ete demandee par le menu Abort
    //%menus
    //  Ok    : sortie de l'editeur et retour de la courbe editee
    //  Abort : sortie de l'editeur et retour au donnes initiales
    //  Undo  : annulation de la derniere modification
    //  Size  : changement des bornes du graphique
    //  Grids : changement des graduations du graphique
    //  Clear : effacement de la courbe (x=[] et y=[]) (sans quitter l'editeur)
    //  Read  : lecture de la courbe a partir d'un fichier d'extension .xy
    //  Save  : sauvegarde binaire (sur un fichier d'extension .xy) de
    //          la courbe
    //!
    [lhs,rhs]=argn(0)

    ok = %t;
    if rhs==0 then x=[]; y=[],end;
    if rhs==1 then y=x;x=(1:size(y,"*"))',end
    if rhs<3  then job="axy",end
    if rhs<4 then tit=[" "," "," "],end
    if size(tit,"*")<3 then tit(3)=" ",end
    //

    [mx,nx] = size(x); x=x(:)
    [my,ny] = size(y); y=y(:)
    n = min(mx*nx,my*ny)
    x= x(1:n);y=y(1:n);
    xsav=x; ysav=y; xs=x; ys=y;
    //
    lj = length(job)
    add=0;modx=0;mody=0
    for k=1:lj
        jk = part(job,k)
        select jk
        case "a" then add = 1,
        case "x" then modx= 1
        case "y" then mody= 1
        else error(msprintf(gettext("%s: Wrong value for input argument #%d: Must be in the set {%s}.\n"), "edit_curv", 3, "a, x, y"));
        end
    end
    eps = 0.01
    symbsiz = 0.2
    // bornes initiales du graphique
    if findobj("type","Axes")~=[] then
        db = gca();
        db = db.data_bounds;
    else
        db = [];
    end
    if rhs<5 then
        if mx<>0 then
            if db==[]
                [xmn xmx ymn ymx]= (min(x), max(x), min(y), max(y));
            else
                [xmn xmx] = (min([x(:); db(1)]), max([x(:); db(2)]));
                [ymn ymx] = (min([y(:); db(3)]), max([y(:); db(4)]));
            end
            dx = xmx - xmn;
            dy = ymx - ymn;
            if dx==0 then dx = max(xmx/2,1), end
            if db==[]
                xmn = xmn - dx/10;
                xmx = xmx + dx/10;
            end
            if dy==0 then dy = max(ymx/2,1), end
            if db==[]
                ymn = ymn - dy/10;
                ymx = ymx + dy/10;
            end
        else
            if db==[]
                xmn=0; ymn=0; xmx=1; ymx=1; dx=1; dy=1
            else
                [xmn xmx ymn ymx] = (db(1), db(2), db(3), db(4));
                dx = xmx - xmn;
                dy = ymx - ymn;
            end
        end
        rect=[xmn,ymn,xmx,ymx];
        axisdata=[2 10 2 10];
        gc = list(rect,axisdata);
    else //** rhs=5 as in Scicos ;)
        [rect,axisdata] = gc(1:2)
        [xmn ymn xmx ymx] = (rect(1), rect(2), rect(3), rect(4));
        dx  = xmx-xmn;
        dy  = ymx-ymn;
    end

    // Set menus and callbacks
    menu_d = ["Read","Save","Clear"]
    menu_e = ["Undo","Size","Replot","Ok","Abort"]
    menus  = list(["Edit","Data"],menu_e,menu_d)
    w="menus(2)(";rpar=")"
    Edit=w(ones(menu_e))+string(1:size(menu_e,"*"))+rpar(ones(menu_e))
    w="menus(3)(";rpar=")"
    Data=w(ones(menu_d))+string(1:size(menu_d,"*"))+rpar(ones(menu_d))

    //curwin = scf().figure_id
    curwin = gcf();
    curwin = curwin.figure_id;

    // Disable the menus and toolbars
    //toolbar(curwin,"off");
    delmenu(curwin,gettext("File"));
    delmenu(curwin,gettext("Tools"));
    delmenu(curwin,gettext("Edit"));;
    delmenu(curwin,"?");

    execstr("Edit_"+string(curwin)+"=Edit");
    execstr("Data_"+string(curwin)+"=Data");
    menubar(curwin,menus)
    //
    edit_curv_figure = gcf();
    edit_curv_figure.figure_name = "edit_curv";

    edit_curv_axes = gca();
    edit_curv_axes.data_bounds = [rect(1),rect(2);rect(3),rect(4)]
    edit_curv_axes.axes_visible="on";
    edit_curv_axes.grid=[4 4];
    if x<>[] then
        xpoly(x, y);
        hdl = gce();
        hdl.thickness = 2;
        hdl.mark_mode = "on";
        hdl.mark_style = 1;
        hdl.mark_size = 2;
    else
        hdl=[]
    end
    xtitle(tit(1),tit(2),tit(3));


    // -- boucle principale
    while %t then
        [n1,n2] = size(x);
        npt = n1*n2 ;

        [btn,xc,yc,win,Cmenu] = get_click();

        //** disp([btn,xc,yc,win]); //** DEBUG only

        c1 = [xc,yc];

        if Cmenu=="Quit" then Cmenu="Abort",end
        if Cmenu==[]     then Cmenu="edit",end
        if Cmenu=="Exit" then Cmenu="Ok",end

        select Cmenu
        case [] then
            // ce n est pas un menu
            break

        case "Ok" then    //    -- ok menu
            rect = matrix(edit_curv_axes.data_bounds',1,4);
            gc   = list(rect,axisdata);
            if db==[] | rhs>4
                delete(edit_curv_figure)
            else
                set("hdl", hdl);
            end
            return;

        case "Abort" then //    -- abort menu
            x = xsav
            y = ysav
            delete(edit_curv_figure)
            ok = %f;
            return

        case "XClose" then //** the user manually close the win
            x = xsav
            y = ysav
            ok = %f;
            return

        case "Undo" then
            x=xs;y=ys
            if x<>[] then hdl.data=[x y]; end

        case "Size" then
            while %t
                [ok,xmn,xmx,ymn,ymx]=getvalue("Please input new limits",..
                ["xmin";"xmax";"ymin";"ymax"],..
                list("vec",1,"vec",1,"vec",1,"vec",1),..
                string([xmn;xmx;ymn;ymx]))
                if ~ok then break,end
                if xmn>xmx|ymn>ymx then
                    messagebox("Limits are not accettable","modal");
                else
                    break
                end
            end
            if ok then
                dx=xmx-xmn;dy=ymx-ymn
                if dx==0 then dx=max(xmx/2,1),xmn=xmn-dx/10;xmx=xmx+dx/10;end
                if dy==0 then dy=max(ymx/2,1),ymn=ymn-dy/5;ymx=ymx+dy/10;end
                rect=[xmn,ymn,xmx,ymx];
                edit_curv_axes.data_bounds=[rect(1),rect(2);rect(3),rect(4)]
            end

        case "Clear" then
            if hdl<>[] then delete(hdl),hdl=[];end
            x=[];y=[];

        case "Read" then
            [x,y]=readxy()
            mx=min(prod(size(x)),prod(size(y)))
            if mx<>0 then
                xmx=max(x);xmn=min(x)
                ymx=max(y);ymn=min(y)
                dx=xmx-xmn;dy=ymx-ymn
                if dx==0 then dx=max(xmx/2,1),xmn=xmn-dx/10;xmx=xmx+dx/10;end
                if dy==0 then dy=max(ymx/2,1),ymn=ymn-dy/5;ymx=ymx+dy/10;end
            else
                xmn=0;ymn=0;xmx=1;ymx=1;dx=1;dy=1
            end
            rect=[xmn,ymn,xmx,ymx];
            edit_curv_axes.data_bounds=[rect(1),rect(2);rect(3),rect(4)]
            if x<>[] & y<>[] then
                if hdl==[] then
                    xpoly(x(1), y(1));
                    hdl = gce();
                    hdl.thickness = 2;                  // ADDED
                    hdl.mark_mode = "on";
                    hdl.mark_style = 1;
                    hdl.mark_size = 2;
                end
                hdl.data = [x y];
            else
                if hdl<>[] then delete(hdl),end
                x = [];
                y = [];
            end

        case "Save" then
            savexy(x,y)

        case "Replot" then
            // for compatibility only, perform nothing on purpose

        case "edit" then
            npt = size(x, "*")
            if npt<>0 then
                dist=((x-ones(npt,1)*c1(1))/dx).^2+((y-ones(npt,1)*c1(2))/dy).^2
                [m,k]=min(dist);
                m = sqrt(m)
            else
                m=3*eps
            end
            if m<eps then                 //on deplace le point
                xs = x; ys=y
                [x,y] = movept(x,y)
            elseif btn <> 127
                db = edit_curv_axes.data_bounds;
                if add==1 & xc>=db(1) & xc<=db(2) & yc>=db(3) & yc<= db(4) then
                    xs = x;
                    ys = y                    // on rajoute un point de cassure
                    [x, y] = addpt(c1, x, y)
                    hdl.data = [x y];
                end
            end
        end
    end
endfunction


function [btn,xc,yc,win,Cmenu] = get_click(flag)
    //** 05/01/09 : update for Scilab 5.1: (close code is now -1000)

    if ~or(winsid()==curwin) then
        Cmenu = "Quit";
        return        ;
    end

    if argn(2) == 1 then
        [btn, xc, yc, win, str] = xclick(flag);
    else
        [btn, xc, yc, win, str] = xclick();
    end

    if btn == -1000 then //** user close the window [X]
        if win == curwin then
            Cmenu = "XClose";
        else
            Cmenu = "Open/Set";
        end
        return ;
    end

    if btn == -2 then //** user select a dynamic menu
        xc = 0; yc = 0;
        execstr("Cmenu=" + part(str, 9:length(str) - 1) );
        execstr("Cmenu=" + Cmenu);
        return;
    end

    Cmenu = [];

endfunction


function [x,y] = addpt(c1,x,y)
    // permet de rajouter un point de cassure
    npt = prod(size(x))
    c1 = c1'
    if hdl==[] then
        x = c1(1);
        y = c1(2);
        xpoly(x, y);
        hdl = gce();
        hdl.thickness = 2;                  // ADDED
        hdl.mark_mode = "on";
        hdl.mark_style = 1;
        hdl.mark_size = 2;
        hdl = resume(hdl);
    end
    //recherche des intervalles en x contenant l'abscisse designee
    kk=[]
    if npt>1 then
        kk=find((x(1:npt-1)-c1(1)*ones(x(1:npt-1)))..
        .*(x(2:npt)-c1(1)*ones(x(2:npt)))<=0)
    end
    if  kk<>[] then
        //    recherche du segment sur lequel on a designé un point
        pp=[];d=[];i=0
        for k=kk
            i=i+1
            pr=projaff(x(k:k+1),y(k:k+1),c1)
            if (x(k)-pr(1))*(x(k+1)-pr(1))<=0 then
                pp = [pp pr]
                d1 = rect(3)-rect(1)
                d2 = rect(4)-rect(2)
                d = [d norm([d1;d2].\(pr-c1))]
            end
        end
        if d<>[] then
            [m,i] = min(d)
            if m<eps
                k=kk(i)
                pp=pp(:,i)
                x=x([1:k k:npt]);x(k+1)=pp(1);
                y=y([1:k k:npt]);y(k+1)=pp(2);
                hdl.data=[x y];
                return
            end
        end
    end
    d1=rect(3)-rect(1)
    d2=rect(4)-rect(2)
    if length(x)>0 & ..
       norm([d1;d2].\([x(1);y(1)]-c1)) < norm([d1;d2].\([x(npt);y(npt)]-c1))
        //  -- mise a jour de x et y
        x(2:npt+1) = x; x(1) = c1(1)
        y(2:npt+1) = y; y(1) = c1(2)
    else
        //  -- mise a jour de x et y
        x(npt+1) = c1(1)
        y(npt+1) = c1(2)
    end
    hdl.data = [x y];
endfunction

function [x,y] = movept(x,y)
    //on bouge un point existant
    hdl;
    rep(3) = -1
    while rep(3)==-1 do
        rep = xgetmouse();
        xc = rep(1);
        yc = rep(2);
        if modx==0 then xc = x(k);end
        if mody==0 then yc = y(k);end
        x(k) = xc;
        y(k) = yc;
        hdl.data =[x y];
        c2 = [xc; yc]
    end
    // "SUPPR has been pressed => we delete the point
    if rep(3)==127
        hdl.data(k,:) = [];
        x(k) = [];
        y(k) = [];
    end
endfunction


function [x,y] = readxy()

    function xy = findPolyline(children)
        xy = [];
        for i = 1:length(children)
            select children(i).type,
            case "Polyline" then
                xy = children(i).data;
                return
            case "Axes" then
                xy = findPolyline(children(i).children);
                return
            case "Compound" then
                xy = findPolyline(children(i).children);
                return
            end
        end
    endfunction

    fn=uigetfile(["*.scg";"*.sod";"*.xy"], "", _("Select a file to load"));
    if fn <> "" then
        [pth, fnm, ext] = fileparts(fn);
        flname = fnm + ext;

        select ext
        case ".scg" then
            loaded_figure=figure("visible", "off");
            if execstr("xload(fn, loaded_figure.figure_id)","errcatch") == 0 then
                loaded_figure.visible = "off";
                scf(edit_curv_figure);
                xy = findPolyline(loaded_figure.children);
                delete(loaded_figure);
                if xy <> [] then
                    x=xy(:,1);y=xy(:,2);
                else
                    msg = _("%s: The file "'%s"' does not contains any "'Polyline"' graphic entity.\n")
                    messagebox(msprintf(msg, "edit_curve", flname));
                    return
                end
            else
                msg = _("%s: Cannot open file "'%s"' for reading.\n")
                messagebox(msprintf(msg, "edit_curv", flname), "modal");
                return
            end
        case ".xy" then
            if execstr("xy = read(fn,-1,2)","errcatch") == 0 then
                x=xy(:,1);y=xy(:,2);
            else
                msg = _("%s: Cannot open file "'%s"' for reading.\n")
                messagebox(msprintf(msg, "edit_curv", flname), "modal");
                return
            end
        case ".sod" then
            if execstr("load(fn)","errcatch") == 0 then
                x=xy(:,1);y=xy(:,2);
            else
                msg = _("%s: Cannot open file "'%s"' for reading.\n")
                messagebox(msprintf(msg, "edit_curv", flname), "modal");
                return
            end
        else
            messagebox(_("Error in file format."), "modal");
            return
        end
    else
        x=x
        y=y
    end
endfunction


function savexy(x,y)
    fn=uiputfile(["*.sod";"*.xy"], "", _("Select a file to write"));
    if fn <> "" then
        [pth, fnm, ext] = fileparts(fn);
        flname = fnm + ext;
        xy = [x y];
        fil = fn;

        select ext
        case "" then
            fil = fil + ".xy";
            ext = ".xy";
        case ".xy" then
            // empty case fil = fn
        case ".sod" then
            // empty case fil = fn
        else
            fil = pth + fnm + ".xy";
            ext = ".xy";
        end

        select ext
        case ".sod" then
            if execstr("save(fil,""xy"")","errcatch")<>0 then
                msg = _("%s: The file "'%s"' cannot be written.\n")
                messagebox(msprintf(msg, "edit_curv", flname), "modal");
                return
            end
        case ".xy" then
            isErr = execstr("write(fil,xy)","errcatch")
            if isErr == 240 then
                mdelete(fil); // write cannot overwrite an existing file
                isErr = execstr("write(fil,xy)","errcatch");
            end
            if isErr <> 0 then
                msg = _("%s: The file "'%s"' cannot be written.\n")
                messagebox(msprintf(msg, "edit_curv", flname), "modal");
                return
            end
        end
    end
endfunction
