uses gr,umouse;

const sz=20;

var i:byte;
    bb,xx:word;
    st:mouse_state;
    c:byte;

begin
  graph_init;
  graph_fontinit('files\f10x10AB.ft');
  mouse_initcur;
  mouse_enable;
  for i:=0 to 255 do
  graph_rectangle((i div 16)*sz,(i mod 16)*sz,(i div 16)*sz+sz-1,(i mod 16)*sz+sz-1,i,i,true);
  st.x:=0;
  st.y:=0;
  st.btn:=0;
  isscr:=false;
  repeat
    if (st.x<>gms.x) or (st.y<>gms.y) or (st.btn<>gms.btn) then
    begin
      if isscr then graph_putimage(st.x,st.y,scr);
      if not(isscr) then isscr:=true;
      st:=gms;
      if mouse_in(0,0,16*sz,16*sz,st) then
      begin
        c:=(st.x div sz)*16+st.y div sz;
        graph_rectangle(550,0,600,50,c,c,true);
        graph_say(550,60,0,'ллл');
        graph_say(550,60,255,bts(c))
      end;
      graph_getimage(st.x,st.y,st.x+cursorsz-1,st.y+cursorsz-1,scr);
      graph_puttrimage(st.x,st.y,cur[1],tc)
    end
  until st.btn<>0
end.