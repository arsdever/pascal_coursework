program kursayin;

uses crt,graphics,mouse;

type  spr = record
             x1,x2,y1,y2:word
           end;
      vekt = array[1..20] of word;
      lvekt = array[1..20] of longint;
      zang = array[1..20] of vekt;

const numfiles=3;
      maxmenu=4;
      small=3;
      sprc=maxmenu+small+2;
      filenames:array[1..numfiles] of string[12]=('menubg.bmp','sprmp.spr','bg.bmp');
      ffldr='files\';

var f          :file;
    menuspr    :array[0..sprc-1] of spr;
    spco       :spr;
    sprts      :array[0..sprc-1] of pointer;
    mousebg    :pointer;
    res        :integer;
    menusel    :byte;
    rk         :char;
    curs:byte;
    i:word;
    b:byte;
    btnc:word;
    st:mouse_state;
    doserr:integer;

function l(x:string):integer;
begin
  l:=length(x)
end;

procedure pahanj;
const pahanj = 'μολ› ‰« m §ƒ―£ε ‘•λ ώ mxm νοο γοσ«―£ §νο•ρ:';
      pahanj1= '‹§‰— B λ‰ν―ο• ινρ§« ώ ον›§« —…―ο•‘§• ƒ—―-ι™‰§« ώ ›ο…•ο,';
      pahanj2= '―ο• b[i] νοο‰ο λιο ‰« νολ› §νο•ρ• i-ο‡ ν―£• ‹σ©… ο“‰χ σ«‰ρ―£ νοο‰ο•';
      pahanj3= 'χησι•«‰ο• ον‡ο©—•«:';
      pahanj4= 'θ‰£§‰χ ρ«ρ› ―¥ ­οσ«‰—σ §ο...';
begin
  graph_drawbmp(0,0,ffldr+filenames[3]);
  graph_rectangle(10,10,1013,20,11,11,true);
  graph_rectangle(10,10,20,130,11,11,true);
  graph_rectangle(10,120,1013,130,11,11,true);
  graph_rectangle(1003,10,1013,130,11,11,true);
  graph_rectangle(20,20,1003,120,20,20,true);
  rk:=#0;
  st.btn:=0;
  graph_say(30,30,72,pahanj);
  graph_say(30,46,72,pahanj1);
  graph_say(30,62,72,pahanj2);
  graph_say(30,78,72,pahanj3);
  graph_say(30,100,72,pahanj4);
  repeat until readkey<>#0
end;
(*
procedure lucum;
var m:byte;
    xx,yy,i,j,j1,lv:byte;
    numt:string;
    errp:integer;
    els:byte;
    epos:array[1..7] of elemt;
    keyenabled:boolean;
    mz:zang;
    bv:lvekt;
    kv:vekt;
    zv:vekt;

function art(b:vekt;m:byte):longint;
var p:longint;
    i:byte;
begin
  p:=1;
  for i:=1 to m do p:=p*b[i];
  art:=p
end;

procedure zuyg(x:vekt;m:byte;var y:vekt;var n:byte);
var i:byte;
begin
  n:=0;
  for i:=1 to m do
  if (x[i]>0)and((x[i] mod 2)=0) then
  begin
    inc(n);
    y[n]:=x[i]*x[i]
  end
end;

procedure resettextboxes;
var i:byte;
begin
  if m<2 then m:=2;
  if xx>m then xx:=m;
  if yy>m then yy:=m;
  if els=0 then exit;
  for i:=1 to 4 do
  graph_textbox(epos[i],false);
  graph_say(epos[1].x,epos[1].y,0,bts(m));
  graph_say(epos[2].x,epos[2].y,0,bts(xx));
  graph_say(epos[3].x,epos[3].y,0,bts(yy));
  graph_say(epos[4].x,epos[4].y,0,its(mz[xx,yy]));
  els:=0
end;

function calc:boolean;
var i,j:byte;
begin
  for i:=1 to m do
  begin
    for j:=1 to m do kv[j]:=mz[i,j];
    zuyg(kv,m,zv,lv);
    if lv=0 then
    begin
      calc:=true;
      exit
    end;
    bv[i]:=art(zv,lv)
  end;
  calc:=false
end;

begin
  m:=2;
  st.x:=0;
  st.y:=0;
  st.btn:=0;
  curs:=1;
  isscr:=false;
  els:=0;
  for xx:=1 to 19 do
  for yy:=1 to 19 do mz[xx,yy]:=0;
  xx:=1;
  yy:=1;
  with epos[1] do
  begin
    x:=550;
    y:=13;
    w:=26;
    h:=16;
    lbl:='¦νο•ρ• νοο‰ο• χ« : '
  end;
  with epos[2] do
  begin
    x:=500;
    y:=50;
    w:=26;
    h:=16;
    lbl:='M['
  end;
  with epos[3] do
  begin
    x:=532;
    y:=50;
    w:=26;
    h:=16;
    lbl:=','
  end;
  with epos[4] do
  begin
    x:=574;
    y:=50;
    w:=106;
    h:=16;
    lbl:=']='
  end;
  with epos[5] do
  begin
    x:=700;
    y:=10;
    w:=150;
    h:=26;
    lbl:='μγ‰— ι©σ«'
  end;
  with epos[6] do
  begin
    x:=855;
    y:=10;
    w:=150;
    h:=26;
    lbl:='μγ‰— ν―£'
  end;
  with epos[7] do
  begin
    x:=700;
    y:=40;
    w:=305;
    h:=26;
    lbl:='­λ‰—'
  end;
  graph_drawbmp(0,0,ffldr+filenames[3]);
  graph_drawtrbmp(10,5,253,ffldr+filenames[4]);
  graph_textbox(epos[1],false);
  graph_say(epos[1].x,epos[1].y,0,bts(m));
  graph_textbox(epos[2],false);
  graph_say(epos[2].x,epos[2].y,0,bts(xx));
  graph_textbox(epos[3],false);
  graph_say(epos[3].x,epos[3].y,0,bts(yy));
  graph_textbox(epos[4],false);
  graph_say(epos[4].x,epos[4].y,0,its(mz[xx,yy]));
  graph_button(epos[5]);
  graph_button(epos[6]);
  graph_button(epos[7]);
  graph_rectangle(412,200,612,500,10,47,true);
  graph_puttrimage(10,630,sprts[3],253);
  numt:='';
  repeat
    if (st.x<>gms.x) or (st.y<>gms.y) or (st.btn<>gms.btn) then
    begin
      if isscr then graph_putimage(st.x,st.y,scr);
      if not(isscr) then isscr:=true;
      st:=gms;
      for i:=1 to 4 do
      begin
        if mouse_in(epos[i].x-3,epos[i].y-3,epos[i].w,epos[i].h,st) then
        begin
          curs:=3;
          break
        end;
        curs:=1
      end;
      if curs=1 then
      for i:=5 to 7 do
      begin
        if mouse_in(epos[i].x,epos[i].y,epos[i].w,epos[i].h,st) then
        begin
          curs:=2;
          break
        end;
        curs:=1
      end;
      if mouse_rad(74,694,64,st) then curs:=2;
      if st.btn=1 then
      begin
        resettextboxes;
        if mouse_in(epos[1].x-3,epos[1].y-3,epos[1].w,epos[1].h,st) then
        begin
          els:=1;
          keyenabled:=true;
          graph_textbox(epos[1],true);
          graph_say(epos[1].x,epos[1].y,0,bts(m));
        end else
        if mouse_in(epos[2].x-3,epos[2].y-3,epos[2].w,epos[2].h,st) then
        begin
          els:=2;
          keyenabled:=true;
          graph_textbox(epos[2],true);
          graph_say(epos[2].x,epos[2].y,0,bts(xx));
        end else
        if mouse_in(epos[3].x-3,epos[3].y-3,epos[3].w,epos[3].h,st) then
        begin
          els:=3;
          keyenabled:=true;
          graph_textbox(epos[3],true);
          graph_say(epos[3].x,epos[3].y,0,bts(yy));
        end else
        if mouse_in(epos[4].x-3,epos[4].y-3,epos[4].w,epos[4].h,st) then
        begin
          els:=4;
          keyenabled:=true;
          graph_textbox(epos[4],true);
          graph_say(epos[4].x,epos[4].y,0,its(mz[xx,yy]));
        end else
        if mouse_in(epos[5].x-3,epos[5].y-3,epos[5].w,epos[5].h,st) then
        begin
          graph_rectangle(412,200,612,500,10,47,true);
          for j:=1 to m do graph_say(422,210+(j-1)*15,10,'m['+bts(j)+','+bts(yy)+']='+lts(mz[j,yy]))
        end else
        if mouse_in(epos[6].x-3,epos[6].y-3,epos[6].w,epos[6].h,st) then
        begin
          graph_rectangle(412,200,612,500,10,47,true);
          for j:=1 to m do graph_say(422,210+(j-1)*15,10,'m['+bts(xx)+','+bts(j)+']='+lts(mz[xx,j]))
        end else
        if mouse_in(epos[7].x-3,epos[7].y-3,epos[7].w,epos[7].h,st) then
        begin
          graph_rectangle(412,200,612,500,10,47,true);
          if not(calc) then
          for j:=1 to m do graph_say(422,210+(j-1)*15,10,'b['+bts(j)+']='+lts(bv[j])) else
          begin
            graph_say(492,210+9*15,10,'σ©…');
            graph_say(482,210+10*15,10,'νοο‰ο');
            graph_say(492,210+11*15,10,'α«');
          end
        end else
        if mouse_rad(74,694,64,st) then
        begin
          repeat st.btn:=gms.btn until st.btn=0;
          isscr:=false;
          exit
        end
      end;
      graph_getimage(st.x,st.y,st.x+cursorsz-1,st.y+cursorsz-1,scr);
      graph_puttrimage(st.x,st.y,cur[curs],tc)
    end;
    if keypressed and keyenabled then
    begin
      repeat rk:=readkey until rk<>#0;
      if rk in [#48..#57] then
      begin
        if els=1 then
        begin
          str(m,numt);
          if (rk>#48) and (numt='0') then numt:=rk
          else if l(numt)<2 then numt:=numt+rk;
          if (l(numt)>1)and(numt[1]<>#49) then numt:=numt[1]
        end else
        if els=2 then
        begin
          str(xx,numt);
          if (rk>#48) and (numt='0') then numt:=rk
          else if l(numt)<2 then numt:=numt+rk;
          if (l(numt)>1)and(numt[1]<>#49) then numt:=numt[1]
        end else
        if els=3 then
        begin
          str(yy,numt);
          if (rk>#48) and (numt='0') then numt:=rk
          else if l(numt)<2 then numt:=numt+rk;
          if (l(numt)>1)and(numt[1]<>#49) then numt:=numt[1]
        end else
        if els=4 then
        begin
          str(mz[xx,yy],numt);
          if (rk>#48) and (numt='0') then numt:=rk
          else if l(numt)<5 then
          if l(numt)>3 then
          begin
            if numt[1]<#51 then numt:=numt+rk
          end else numt:=numt+rk
        end
      end
      else if rk=#8 then
      begin
        if l(numt)>0 then delete(numt,length(numt),1)
      end
      else if rk=#27 then
      begin
        if isscr then graph_putimage(st.x,st.y,scr);
        isscr:=false;
        resettextboxes;
        els:=0;
        if m<2 then m:=2
      end;
      if isscr then graph_putimage(st.x,st.y,scr);
      isscr:=false;
      if els=1 then
      begin
        val(copy(numt,1,2),m,errp);
        graph_textbox(epos[1],true);
        graph_say(epos[1].x,epos[1].y,0,bts(m));
      end else
      if els=2 then
      begin
        val(copy(numt,1,2),xx,errp);
        if xx>m then xx:=m;
        graph_textbox(epos[2],true);
        graph_say(epos[2].x,epos[2].y,0,bts(xx));
      end else
      if els=3 then
      begin
        val(copy(numt,1,2),yy,errp);
        if yy>m then yy:=m;
        graph_textbox(epos[3],true);
        graph_say(epos[3].x,epos[3].y,0,bts(yy));
      end else
      if els=4 then
      begin
        val(copy(numt,1,10),mz[xx,yy],errp);
        graph_textbox(epos[4],true);
        graph_say(epos[4].x,epos[4].y,0,its(mz[xx,yy]));
      end;
      rk:=#0
    end
  until st.btn=2;
  isscr:=false
end;
*)
procedure lucum;
var nt:string[5];
    mz:zang;
    kv,zv:vekt;
    bv:lvekt;
    m,i,j,l:byte;
    err:integer;
    rk:char;
    f:file of word;

function getnumber(min,max:word):word;
var w:longint;
    m1:word;
begin
  w:=0;
  repeat
    str(w,nt);
    graph_say(512-length(nt)*5,95,127,nt);
    repeat rk:=readkey until ord(rk) in [13,48..57,27,8];
    if rk=#27 then exit;
    if rk=#8 then delete(nt,length(nt),1);
    if rk in [#48..#57] then
    begin
      if w<>0 then nt:=nt+rk else
      if w=0 then nt:=rk
    end;
    val(nt,w,err);
    if max<=255 then m1:=255 else m1:=65500;
    if w>max then w:=max;
    graph_rectangle(492,95,532,105,21,21,true)
  until (rk=#13) and (w>=min) and (w<=max);
  getnumber:=w
end;

procedure zuyg(v1:vekt;n1:byte;var v2:vekt;var n2:byte);
var i:byte;
begin
  n2:=0;
  for i:=1 to m do
  if (v1[i]>0) and (v1[i] mod 2=0) then
  begin
    inc(n2);
    v2[n2]:=sqr(v1[i])
  end
end;

function art(v:vekt;l:byte):longint;
var p:longint;
    i:byte;
begin
  p:=1;
  for i:=1 to l do p:=p*v[i];
  art:=p
end;

begin
  m:=0;
  graph_rectangle(0,0,1023,767,10,10,true);
  graph_rectangle(311,50,712,200,55,21,true);
  graph_say(452,65,127,'ª‰ο§σ›‰χ m-');
  m:=getnumber(2,10);
  if rk=#27 then exit;
  graph_rectangle(452,65,572,75,21,21,true);
  for i:=1 to m do
  begin
    repeat
      for j:=1 to m do
      begin
        graph_rectangle(472,65,552,75,21,21,true);
        graph_say(472,65,127,'M['+bts(i)+','+bts(j)+']');
        mz[i,j]:=getnumber(0,65500);
        if rk=#27 then exit;
        kv[j]:=mz[i,j]
      end;
      zuyg(kv,m,zv,l);
    until l<>0;
    bv[i]:=art(zv,l)
  end;
  graph_rectangle(311,50,712,200,10,10,true);
  graph_rectangle(411,50,612,m*15+65,55,21,true);
  for i:=1 to m do graph_say(421,45+i*15,127,'B['+bts(i)+']='+lts(bv[i]));
  assign(f,'zangvac.txt');
  rewrite(f);
  for i:=1 to m do
  for j:=1 to m do
  write(f,mz[i,j]);
  reset(f);
  graph_rectangle(501-(m*60)div 2,230,522+(m*60)div 2,245+m*15,55,21,true);
  for i:=1 to m do
  for j:=1 to m do
  begin
    read(f,mz[i,j]);
    graph_say(511-(m*60)div 2+(j-1)*60,240+(i-1)*15,127,wts(mz[i,j]))
  end;
  close(f);
  graph_say(397,550,127,'-= Press Spacebar to exit =-');
  repeat until readkey=#32
end;

{------------------------------- Game end -----------------------------------}
procedure game;
type records = record
                 pl1,pl2:word;
               end;
var i,j:byte;
    brd:array[0..19,0..19] of byte;
    st:mouse_state;
    gg,sg:record x,y:byte end;
    pl:byte;
    seled:record
            is:boolean;
            x,y:byte
          end;
    cls:array[0..5] of byte;
    p1,p2,em:word;
    op:string;
    win:boolean;
    rec:file of records;
    reclist:records;

procedure checkwin;
var i,j:byte;
begin
  p1:=0;
  p2:=0;
  em:=0;
  for i:=0 to 19 do
  for j:=0 to 19 do
  if brd[i,j]=1 then inc(p1) else
  if brd[i,j]=2 then inc(p2) else
  inc(em)
end;

procedure check(i,j:byte);
const dir:array[0..2] of integer = (-1,0,1);
var xx,yy:byte;
begin
  for xx:=0 to 2 do
  for yy:=0 to 2 do
  if (i+dir[xx]>=0)and(i+dir[xx]<20)and(j+dir[yy]>=0)and(j+dir[yy]<20) then
  if (brd[i+dir[xx],j+dir[yy]]<>0)and(brd[i+dir[xx],j+dir[yy]]<>pl) then
  begin
    brd[i+dir[xx],j+dir[yy]]:=pl;
    graph_rectangle(212+(i+dir[xx])*30,84+(j+dir[yy])*30,242+(i+dir[xx])*30,114+(j+dir[yy])*30,cls[pl+1]+1,cls[pl+1],true)
  end
end;

function blocktest:boolean;
var i,j:byte;xx,yy:integer;
    ret:boolean;

begin
  ret:=true;
  for i:=0 to 19 do
  for j:=0 to 19 do
    if brd[i,j]=pl then
    for xx:=-2 to 2 do
    for yy:=-2 to 2 do
      if (i+xx>=0)and(i+xx<20)and(j+yy>=0)and(j+yy<20)then
      if brd[i+xx,j+yy]=0 then
      begin
        ret:=false;
        blocktest:=ret;
        exit
      end;
  blocktest:=ret
end;

procedure click(i,j:byte);
var xx,yy:byte;
begin
  if not(seled.is) then
  begin
    if brd[i,j]=pl then
    begin
      seled.x:=i;
      seled.y:=j;
      seled.is:=true;
      graph_rectangle(212+i*30,84+j*30,242+i*30,114+j*30,cls[4],0,false);
    end
  end else
  begin
    if (seled.x=i)and(seled.y=j) then
    begin
      seled.is:=false;
      graph_rectangle(212+i*30,84+j*30,242+i*30,114+j*30,cls[1+pl]+1,0,false);
    end else
    if brd[seled.x,seled.y]=brd[i,j] then
    begin
      graph_rectangle(212+seled.x*30,84+seled.y*30,242+seled.x*30,114+seled.y*30,cls[1+pl]+1,0,false);
      seled.x:=i;
      seled.y:=j;
      graph_rectangle(212+i*30,84+j*30,242+i*30,114+j*30,cls[4],0,false);
    end else
    if brd[i,j]=0 then
    begin
      if (abs(i-seled.x)<2)and(abs(j-seled.y)<2) then
      begin
        brd[i,j]:=pl;
        graph_rectangle(212+seled.x*30,84+seled.y*30,242+seled.x*30,114+seled.y*30,cls[pl+1]+1,cls[pl+1],true);
        graph_rectangle(212+i*30,84+j*30,242+i*30,114+j*30,cls[pl+1]+1,cls[pl+1],true);
        seled.is:=false;
        check(i,j);
        if pl=1 then pl:=2 else pl:=1
      end else
      if (abs(i-seled.x)<3)and(abs(j-seled.y)<3) then
      begin
        brd[seled.x,seled.y]:=0;
        brd[i,j]:=pl;
        graph_rectangle(212+seled.x*30,84+seled.y*30,242+seled.x*30,114+seled.y*30,cls[1]+1,cls[1],true);
        graph_rectangle(212+i*30,84+j*30,242+i*30,114+j*30,cls[pl+1]+1,cls[pl+1],true);
        seled.is:=false;
        check(i,j);
        if pl=1 then pl:=2 else pl:=1
      end
    end
  end;
  if blocktest then
  begin
    for xx:=0 to 19 do
    for yy:=0 to 19 do
    begin
      if brd[xx,yy]=0 then
      begin
        brd[xx,yy]:=abs(pl-3);
        graph_rectangle(212+i*30,84+j*30,242+i*30,114+j*30,cls[pl+1]+1,cls[pl+1],true)
      end
    end
  end;
  checkwin;
  if (p1=0)or((em=0)and(p2>p1)) then
  begin
    reset(rec);
    read(rec,reclist);
    inc(reclist.pl2);
    rewrite(rec);
    write(rec,reclist);
    close(rec);
    graph_rectangle(512-150,384-100,512+150,384+100,0,cls[3],true);
    op:='!!! Player 2 wins !!!';
    graph_say(512-length(op)*4,300,243,op);
    op:='Player 1 : '+wts(reclist.pl1);
    graph_say(512-length(op)*4,330,243,op);
    op:='Player 2 : '+wts(reclist.pl2);
    graph_say(512-length(op)*4,350,243,op);
    op:='Press any key to return menu';
    graph_say(512-length(op)*4,380,243,op);
    readkey;
    win:=true;
    exit
  end else
  if (p2=0)or((em=0)and(p2<p1))  then
  begin
    reset(rec);
    read(rec,reclist);
    inc(reclist.pl1);
    rewrite(rec);
    write(rec,reclist);
    close(rec);
    graph_rectangle(512-150,384-100,512+150,384+100,0,cls[2],true);
    op:='!!! Player 1 wins !!!';
    graph_say(512-length(op)*4,300,239,op);
    op:='Player 1 : '+wts(reclist.pl1);
    graph_say(512-length(op)*4,330,239,op);
    op:='Player 2 : '+wts(reclist.pl2);
    graph_say(512-length(op)*4,350,239,op);
    op:='Press any key to return menu';
    graph_say(512-length(op)*4,380,239,op);
    readkey;
    win:=true;
    exit
  end else
  if (em=0)and(p2=p1) then
  begin
    graph_rectangle(512-150,384-100,512+150,384+100,0,cls[1],true);
    op:='!!! Draw !!!';
    graph_say(512-length(op)*4,380,0,op);
    readkey;
    win:=true;
    exit
  end;
  graph_rectangle(0,0,1023,10,cls[1],cls[1],true);
  graph_rectangle(0,0,round(1024/400*p1),10,cls[2],cls[2],true);
  graph_rectangle(1024-round(1024/400*p2),0,1023,10,cls[3],cls[3],true);
  graph_say(512-length(op)*4,40,16,emspace(length(op),#219));
  op:='Player '+bts(pl)+' turn';
  graph_say(512-length(op)*4,40,cls[pl+1],op)
end;

begin
  assign(rec,'recordlist.lst');
  {$I-}
    reset(rec);
  {$I+}
  if ioresult <> 0 then
  begin
    rewrite(rec);
    reclist.pl1:=0;
    reclist.pl2:=0;
    write(rec,reclist);
  end else read(rec,reclist);
  close(rec);
  win:=false;
  cls[0]:=16;
  cls[1]:=247;
  cls[2]:=14;
  cls[3]:=192;
  cls[4]:=54;
  cls[5]:=10;
  graph_init;
  graph_fontinit('files/f8x16A.ft');
  mouse_initcur;
  mouse_enable;
  mouse_hran(0,599);
  mouse_vran(0,599);
  graph_rectangle(0,10,1023,767,cls[0],cls[0],true);
  graph_rectangle(0,0,1023,10,cls[1],cls[1],true);
  graph_rectangle(212,84,812,684,cls[1]+1,cls[1],true);
  for i:=1 to 19 do
  begin
    graph_line(212+i*30,84,212+i*30,684,cls[1]+1);
    graph_line(212,84+i*30,812,84+i*30,cls[1]+1)
  end;
  for i:=0 to 19 do
  for j:=0 to 19 do brd[i,j]:=0;
  brd[1,1]:=1;
  graph_rectangle(242,114,272,144,cls[2]+1,cls[2],true);
  brd[18,18]:=2;
  graph_rectangle(212+18*30,84+18*30,242+18*30,114+18*30,cls[3]+1,cls[3],true);
  st.x:=0;
  st.y:=0;
  st.btn:=0;
  sg.x:=0;
  sg.y:=0;
  seled.is:=false;
  pl:=1;
  op:='Press mouse right button to exit';
  graph_say(512-length(op)*4,720,0,op);
  op:='Player '+bts(pl)+' turn';
  graph_say(512-length(op)*4,40,cls[pl+1],op);
  repeat
    gg.x:=gms.x div 30;
    gg.y:=gms.y div 30;
    if (sg.x<>gg.x) or (sg.y<>gg.y) or (st.btn<>gms.btn) then
    begin
      if isscr then graph_rectangle(213+sg.x*30,85+sg.y*30,241+sg.x*30,113+sg.y*30,cls[1+brd[sg.x,sg.y]],0,false);
      if not(isscr) then isscr:=true;
      st:=gms;
    begin
      sg.x:=st.x div 30;
      sg.y:=st.y div 30;
      gg.x:=gms.x div 30;
      gg.y:=gms.y div 30;
    end;
      if st.btn=1 then click(st.x div 30,st.y div 30);
      if win then exit;
      graph_rectangle(213+sg.x*30,85+sg.y*30,241+sg.x*30,113+sg.y*30,cls[5],0,false);
    end
  until st.btn>1
end;
{------------------------------- Game end -----------------------------------}

begin
  textmode(co80+font8x8);
  clrscr;
  i:=1;
  repeat
    assign(f,ffldr+filenames[i]);
    {$I-}reset(f);{I+}
    res:=ioresult;
    if res<>0 then
    begin
      textcolor(lightRed);
      writeln('Some files was deleted.');
      textcolor(yellow);
      repeat
        assign(f,ffldr+filenames[i]);
        {$I-}reset(f);{I+}
        res:=ioresult;
        if res<>0 then
        writeln(emspace(5,' ')+filenames[i]);
        inc(i)
      until i>numfiles;
      textcolor(green);
      writeln('Please reinstall program');
      writeln;
      textcolor(cyan);
      writeln('Press any key to exit...');
      readkey;
      halt
    end;
    close(f);
    inc(i)
  until i>numfiles;
  graph_init;
  graph_drawbmp(0,0,ffldr+filenames[1]);
  assign(f,ffldr+filenames[2]);
  reset(f,1);
  for i:=1 to sprc do
  begin
    blockread(f,spco,sizeof(spco));
    getmem(sprts[i-1],(spco.y2-spco.y1+1)*(spco.x2-spco.x1+1)+4);
    graph_getimage(spco.x1,spco.y1,spco.x2,spco.y2,sprts[i-1])
  end;
  close(f);
  graph_fontinit(ffldr+'f10x10AB.ft');
  repeat
    if not (rk in [#72,#75,#77,#80]) then
    begin
      mouse_init;
      graph_drawbmp(0,0,ffldr+filenames[3]);
      mouse_enable;
    end;
    for i:=0 to maxmenu-1 do
    graph_puttrimage(i*138+10,630,sprts[i],253);
    graph_puttrimage(menusel*138+10,630,sprts[4],253);
    rk:=#0;
    st.btn:=0;
    gms.btn:=0;
    repeat
      if (st.x<>gms.x) or (st.y<>gms.y) or (st.btn<>gms.btn) then
      begin
        if isscr then graph_putimage(st.x,st.y,scr);
        if not(isscr) then isscr:=true;
        st:=gms;
        for i:=0 to maxmenu-1 do
        if mouse_rad(74+i*138,694,64,st) then
        begin
          curs:=2;
          if menusel<>i then
          begin
            graph_puttrimage(menusel*138+10,630,sprts[menusel],253);
            menusel:=i;
            graph_puttrimage(menusel*138+10,630,sprts[4],253);
          end;
          break
        end else curs:=1;
        if curs=1 then st.btn:=0;
        graph_getimage(st.x,st.y,st.x+cursorsz-1,st.y+cursorsz-1,scr);
        graph_puttrimage(st.x,st.y,cur[curs],tc)
      end;
      if keypressed then rk:=readkey
    until (rk in [#27,#72,#75,#77,#80,#13,#32]) or (st.btn=1);
    if st.btn = 1 then case menusel of
      0: pahanj;
      1: lucum;
      2: game;
      else halt
    end else
    case ord(rk) of
      27:halt;
      72,75: if menusel>0 then dec(menusel) else menusel:=maxmenu-1;
      77,80: if menusel<maxmenu-1 then inc(menusel) else menusel:=0;
      13: case menusel of
            0: pahanj;
            1: lucum;
            2: game;
            else halt
          end
    end
  until rk=#27
end.