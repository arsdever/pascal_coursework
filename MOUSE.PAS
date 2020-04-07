unit mouse;

interface

uses crt,graphics;

type
	mouse_state    = record
		x,y,btn:word
		end;
	cursorimg = array[0..31] of word;

const defcur:cursorimg  = ($7fff,$3fff,$1fff,$0fff,$07ff,$03ff,$01ff,$00ff,
                           $00ff,$0fff,$1bff,$31ff,$fbff,$ffff,$ffff,$ffff,
                           $8000,$c000,$a000,$9000,$8800,$8400,$8200,$8100,
                           $8f00,$9000,$a400,$ca00,$0400,$0000,$0000,$0000);
      deflink:cursorimg = ($f3ff,$e1ff,$e1ff,$e1ff,$e1ff,$e04f,$e001,$e000,
                           $e000,$8000,$0000,$0000,$8000,$8001,$8001,$c003,
                           $0c00,$1200,$1200,$1200,$1200,$13b0,$124e,$1249,
                           $1249,$7249,$9009,$8001,$4001,$4002,$4002,$3FFC);
      defintmask = 31;
      cursornum = 3;
      cursorsz = 32;
      cursorfile = 'cursor';
      lkhov = 1;
      txhov = 2;

var f             :file;
    cur           :array[1..cursornum] of pointer;
    scr           :pointer;
    isscr         :boolean;
    gms           :mouse_state;

function mouse_init:integer;
procedure mouse_initcur;
procedure mouse_show;
procedure mouse_hide;
procedure mouse_getstate(var ms:mouse_state);
procedure mouse_setpos(x,y:word);
procedure mouse_hran(min,max:word);
procedure mouse_vran(min,max:word);
procedure mouse_setgraphcur(spx,spy:word;cur:cursorimg);
procedure mouse_setuserint;
procedure mouse_setmickpixrat(hr,vr:word);
procedure mouse_setintrate(r:word);
procedure mouse_enable;
function mouse_in(x,y,w,h:word;s:mouse_state):boolean;
function mouse_rad(x,y,r:word;s:mouse_state):boolean;
procedure mouse_funct;

implementation

procedure mouse_funct;
var mx,my,btn:word;
begin
  asm
    mov mx,cx
    mov my,dx
    mov btn,bx
  end;
  gms.x:=mx;
  gms.y:=my;
  gms.btn:=btn;
end;

function mouse_init;assembler;
asm
	mov ax,0h
	int 33h
	lea di,mouse_init
	and ax,bx
	mov es:[di],ax
end;

procedure mouse_initcur;
var i:byte;
begin
  graph_drawbmp(0,0,cursorfile+bts(cursorsz)+'.cr');
  for i:=1 to cursornum do
  begin
    getmem(cur[i],cursorsz*cursorsz+4);
    graph_getimage((i-1)*cursorsz,0,i*cursorsz-1,cursorsz-1,cur[i])
  end
end;

procedure mouse_show;assembler;
asm
	mov ax,01h
	int 33h
end;

procedure mouse_hide;assembler;
asm
	mov ax,02h
	int 33h
end;

procedure mouse_getstate;assembler;
asm
	mov ax,03h
	int 33h
	les di,ms
	mov es:[di],cx
	mov es:[di+2],dx
	mov es:[di+4],bx
end;
procedure mouse_setpos;assembler;
asm
  mov ax,04h
  mov cx,[x]
  mov dx,[y]
  int 33h
end;
procedure mouse_hran;assembler;
asm
  mov cx,[min]
  mov dx,[max]
  mov ax,07h
  int 33h
end;
procedure mouse_vran;assembler;
asm
  mov cx,[min]
  mov dx,[max]
  mov ax,08h
  int 33h
end;
procedure mouse_setgraphcur;assembler;
asm
  les dx,cur
  mov ax,09h
  mov bx,0
  mov cx,0
  int 33h
end;
procedure mouse_setuserint;assembler;
asm
  mov ax,seg mouse_funct
  mov es,ax
  mov ax,0ch
  mov cx,31
  mov dx,offset mouse_funct
  int 33h
end;
procedure mouse_setmickpixrat;assembler;
asm
  mov ax,0fh
  mov cx,[hr]
  mov dx,[vr]
  int 33h
end;
procedure mouse_setintrate;assembler;
asm
	mov ax,01ch
	mov bx,[r]
	int 33h
end;

procedure mouse_enable;
begin
  mouse_hran(0,1023);
  mouse_vran(0,767);
  mouse_setmickpixrat(8,8);
  mouse_setintrate(4);
  mouse_setuserint;
end;

function mouse_in;
begin
  mouse_in:=((s.x>=x)and(s.y>=y)and(s.x<x+w)and(s.y<y+h))
end;

function mouse_rad;
begin
  mouse_rad:=lsum(lsqr(s.x-x),lsqr(s.y-y))<=lsqr(r)
end;

begin
  assign(f,cursorfile+bts(cursorsz)+'.cr');
  {$I-}
  reset(f);
  {$I+}
  if ioresult<>0 then
  begin
    textcolor(lightRed);
    clrscr;
    writeln('Some files was deleted.');
    textcolor(yellow);
    writeln(emspace(5,' '),cursorfile+bts(cursorsz)+'.cr');
    textcolor(green);
    writeln('Please reinstall program');
    writeln;
    textcolor(cyan);
    writeln('Press any key to exit...');
    readkey;
    halt
  end;
  close(f);
  gms.x:=0;
  gms.y:=0;
  gms.btn:=0;
  getmem(scr,cursorsz*cursorsz+4);
  isscr:=false;
  mouse_initcur
end.