unit graphics;

interface

uses crt;

type    trgb = record b,g,r,i:byte end;
	rgb_palette = array[0..255] of trgb;
        bmp_fileheader = record
                        sign:word;
                        size:longint;
                        res1,res2:word;
                        offs:longint
                      end;
        bmp_infoheader = record
                        hesi:longint;
                        w,h:longint;
                        pl:word;
                        bpp:word;
                        comp:longint;
                        sized:longint;
                        hppm,vppm:longint;
                        numcol,nimcol:longint
                      end;
        bmp_header     = record
                        f:bmp_fileheader;
                        i:bmp_infoheader;
                        p:rgb_palette
                      end;
        vesainfo       = record
                        modeattr:word;
                        awinattr,bwinattr:byte;
                        gran,size,startsega,startsegb:word;
                        farwinpos:longint;
                        bpl:word;
                        width,height:word;
                        charcellw,charcellh,mempl,bpp,banknum,memmodel:byte;
                        sizebank,imgpg,res:byte;
                        rms,rmp,gms,gmp,bms,bmp,resms,resmp,dsminf:byte;
                        vidbufadd,offscrpoi:longint;
                        offscrmem:word;
                        res1:array[0..$0ff-$30] of byte
                      end;
        mouse_state    = record
                        x,y,btn:word
                      end;
        cursorimg = array[0..15] of byte;
        elemt = record
                  x,y,w,h:word;
                  lbl:string
                end;

const
	_read=1;
        normalput=0;
        orput=1;
        xorput=2;
        andput=3;
        scrw=1024;
        scrh=768;
        fontd=0;
        fontl=2;
        tc=253;
var
	bank:word;
	windowB:boolean;
	granularity:word;
	err:integer;
	handler:word;
        vesa:array[0..63] of longint;
        ascii:array[0..255] of pointer;
        fontw,fonth:byte;

{ GRAPH INSTRUCTIONS }

procedure graph_getvesainfo;
procedure graph_init;
procedure graph_pixel(x,y:word;col:byte);
procedure graph_setrgbpalarr(rgbp:rgb_palette);
procedure graph_getimage(x1,y1,x2,y2:word;p:pointer);
procedure graph_putimage(x,y:word;p:pointer);
procedure graph_puttrimage(x,y:word;p:pointer;trc:byte);
procedure graph_putchar(x,y:word;col:byte;p:pointer);
procedure graph_drawbmp(x,y:word;p:string);
procedure graph_drawtrbmp(x,y:word;trc:byte;p:string);
procedure graph_fontinit(pth:string);
procedure graph_say(x,y:word;col:byte;txt:string);
procedure graph_clear(c:byte);

{ GRAPHICAL HELPERS}

procedure graph_rectangle(x,y,x1,y1:word;lc,fc:byte;fl:boolean);
procedure graph_line(x,y,x1,y1:word;lc:byte);
procedure graph_textbox(elem:elemt;focus:boolean);
procedure graph_button(elem:elemt);

{ OTHER }

function emspace(count:byte;ch:char):string;
function bts(n:byte):string;
function boolts(n:boolean):string;
function its(n:integer):string;
function wts(n:word):string;
function lts(n:longint):string;
function bytetohex(b:byte):string;
function lsqr(x:integer):longint;
function lsum(x,y:longint):longint;

implementation

procedure graph_getvesainfo;assembler;
asm
  mov ax,seg vesa
  mov es,ax
  mov ax,offset vesa
  mov di,ax
  mov ax,4f00h
  int 10h
end;

procedure graph_init;assembler;
asm
	mov	ax,4F02h
	mov	bx,105H
	int	10h
	mov	cx,101H
	mov	ax,seg vesa
	mov	es,ax
	mov	di,offset vesa
	mov	ax,4f01H
	int	10H
	mov	al,[es:di+3]
	and	al,01H
	mov	WindowB,al
	mov	ax,64
	mov	cx,[es:di+4]
	div	cl
	mov	granularity,ax
	mov	dx,0
	mov	ax,4f05H
	mov	bx,0
	int	10H
	cmp	WindowB,true
	jne	@BankOK
	mov	ax,4f05H
	mov	bx,1
	int	10H
	@BankOK:
	mov	bank,0
end;

procedure graph_swbank;assembler;
asm
    mov ax,4f05h
	xor bx,bx
	mov dx,[bank]
    shl dx,4
	int 10h
end;

procedure graph_pixel;assembler;
asm
	mov ax,0002h
	int 33h
	mov	ax,y
	mov	dx,scrw
	mul	dx
	add	ax,x
	adc	dx,0
	mov	di,ax
	cmp	dx,bank
	je	@BankOK
	mov	bank,DX
	mov	ax,granularity
	mul	dl
	mov	dx,ax
	mov	ax,4f05H
	mov	bx,0
	int	10H
	cmp	WindowB,True
	jne	@BankOK
	mov	ax,4f05H
	mov	bx,1
	int	10H
	@BankOK:
	mov	es,[SegA000]
	mov	al,col
	mov	[es:di],al
	mov	ax,0001h
	int	33h
end;

procedure graph_setrgbpalarr;assembler;
asm
	push di
	mov cx,1024
	les di,rgbp
	@loop:
	mov dx,03c8h
	mov ax,1024
	sub ax,cx
	shr ax,2
	out dx,al
	mov dx,03c9h
	mov al,es:[di+2]
	shr al,2
	out dx,al
	mov al,es:[di+1]
	shr al,2
	out dx,al
	mov al,es:[di]
	shr al,2
	out dx,al
	inc di
	inc di
	inc di
	inc di
	dec cx
	dec cx
	dec cx
	loop @loop
end;

procedure graph_getimage;assembler;
var xx,yy,w,h:word;
asm
	mov ax,0002h
	int 33h
        les di,p
        mov ax,[x2]
        sub ax,[x1]
        inc ax
        mov es:[di],ax
        mov [w],ax
        mov ax,y2
        sub ax,y1
        inc ax
        mov es:[di+2],ax
        mov [h],ax
        inc di
        inc di
        inc di
        inc di
        mov cx,[w]
        jmp @horis
        @horis:
        mov [xx],cx
        mov ax,[x1]
        add [xx],ax
        @horis1:
        dec [xx]
        cmp [xx],1023
        jg @horis1
        push cx
        mov cx,[h]
        @vert:
        mov [yy],cx
        mov ax,[y1]
        add [yy],ax
        dec [yy]
        push cx
	mov	ax,[yy]
        mov     dx,scrw
        mul     dx
	add	ax,[xx]
	adc	dx,0
	mov	si,ax
	cmp	dx,[bank]
	je	@BankOK
	mov	[bank],dx
	mov	ax,granularity
	mul	dl
	mov	dx,ax
	mov	ax,4f05H
	mov	bx,0
	int	10H
	cmp	WindowB,True
	jne	@BankOK
	mov	ax,4f05H
	mov	bx,1
	int	10H
	@BankOK:
        push es
        mov es,[SegA000]
        mov     al,[es:si]
        pop es
	mov	[es:di],al
        inc di
        pop cx
        loop @vert
        pop cx
        loop @horis
	mov ax,0001h
	int 33h
end;

procedure graph_puttrimage;assembler;
var w,h,xx,yy:word;
asm
	mov ax,0002h
	int 33h
	les si,p
	mov ax,es:[si]
        mov [w],ax
        mov ax,es:[si+2]
	mov [h],ax
	inc si
	inc si
	inc si
	inc si
	mov cx,[w]
	@phoris:
	mov [xx],cx
        mov ax,[x]
        add [xx],ax
        @phoris1:
        dec [xx]
        cmp [xx],1023
        jg @phoris1
	push cx
	mov cx,[h]
	@pvert:
	mov [yy],cx
        mov ax,[y]
        add [yy],ax
        @pvert1:
        dec [yy]
        cmp [yy],767
        jg @pvert1
	push cx
        push si
	mov	ax,[yy]
        mov     dx,scrw
        mul     dx
	add	ax,[xx]
	adc	dx,0
	mov	di,ax
	cmp	dx,[bank]
	je	@BankOK
	mov	[bank],dx
        mov	ax,granularity
	mul	dl
	mov	dx,ax
	mov	ax,4f05H
	mov	bx,0
	int	10H
	cmp	WindowB,True
	jne	@BankOK
	mov	ax,4f05H
	mov	bx,1
	int	10H
	@BankOK:
        pop si
        mov     al,[es:si]
        cmp al,[trc]
        je @lp
        push es
        mov es,[SegA000]
	mov [es:di],al
        pop es
        @lp:
	inc si
	pop cx
	loop @pvert
	pop cx
	loop @phoris
	mov ax,0001h
	int 33h
end;

procedure graph_putimage;assembler;
var w,h,xx,yy:word;
asm
	mov ax,0002h
	int 33h
	les si,p
	mov ax,es:[si]
        mov [w],ax
        mov ax,es:[si+2]
	mov [h],ax
	inc si
	inc si
	inc si
	inc si
	mov cx,[w]
        jmp @phoris
        @phoris1:
        dec cx
	@phoris:
	mov [xx],cx
        mov ax,[x]
        add [xx],ax
        dec [xx]
        cmp xx,1023
        jg @phoris1
	push cx
	mov cx,[h]
	@pvert:
	mov [yy],cx
        mov ax,[y]
        add [yy],ax
        dec [yy]
	push cx
        push si
	mov	ax,[yy]
        mov     dx,scrw
        mul     dx
	add	ax,[xx]
	adc	dx,0
	mov	di,ax
	cmp	dx,[bank]
	je	@BankOK
	mov	[bank],dx
        mov	ax,granularity
	mul	dl
	mov	dx,ax
	mov	ax,4f05H
	mov	bx,0
	int	10H
	cmp	WindowB,True
	jne	@BankOK
	mov	ax,4f05H
	mov	bx,1
	int	10H
	@BankOK:
        pop si
        mov     al,[es:si]
        push es
        mov es,[SegA000]
	mov [es:di],al
        pop es
	inc si
	pop cx
	loop @pvert
	pop cx
	loop @phoris
	mov ax,0001h
	int 33h
end;

procedure graph_putchar;assembler;
var w,h,xx,yy:word;
asm
	mov ax,0002h
	int 33h
	les si,p
	mov ax,es:[si]
        mov [w],ax
        mov ax,es:[si+2]
	mov [h],ax
	inc si
	inc si
	inc si
	inc si
	mov cx,[w]
	@phoris:
	mov [xx],cx
        mov ax,[x]
        add [xx],ax
        dec [xx]
	push cx
	mov cx,[h]
	@pvert:
	mov [yy],cx
        mov ax,[y]
        add [yy],ax
        dec [yy]
	push cx
        push si
	mov	ax,[yy]
        mov     dx,scrw
        mul     dx
	add	ax,[xx]
	adc	dx,0
	mov	di,ax
	cmp	dx,[bank]
	je	@BankOK
	mov	[bank],dx
        mov	ax,granularity
	mul	dl
	mov	dx,ax
	mov	ax,4f05H
	mov	bx,0
	int	10H
	cmp	WindowB,True
	jne	@BankOK
	mov	ax,4f05H
	mov	bx,1
	int	10H
	@BankOK:
        pop si
        mov     al,[es:si]
        cmp al,253
        je @lp
        push es
        mov es,[SegA000]
        and al,[col]
	mov [es:di],al
        pop es
        @lp:
	inc si
	pop cx
	loop @pvert
	pop cx
	loop @phoris
	mov ax,0001h
	int 33h
end;

procedure graph_drawtrbmp;
var f          :file;
    bmp        :bmp_header;
    xx,yy      :word;
    col        :array[0..1500] of byte;

begin
  assign(f,p);
  reset(f,1);
  blockread(f,bmp,sizeof(bmp));
  graph_setrgbpalarr(bmp.p);
  seek(f,bmp.f.offs);
  yy:=bmp.i.h-1;
  while not(eof(f)) do
  begin
    blockread(f,col,bmp.i.w);
    for xx:=bmp.i.w-1 downto 0 do
    if col[xx]<>trc then graph_pixel(xx+x,yy+y,col[xx]);
    dec(yy)
  end;
  close(f);
end;

procedure graph_drawbmp;
var f          :file;
    bmp        :bmp_header;
    xx,yy      :word;
    col        :array[0..1500] of byte;

begin
  assign(f,p);
  reset(f,1);
  blockread(f,bmp,sizeof(bmp));
  graph_setrgbpalarr(bmp.p);
  seek(f,bmp.f.offs);
  yy:=bmp.i.h-1;
  while not(eof(f)) do
  begin
    blockread(f,col,bmp.i.w);
    for xx:=bmp.i.w-1 downto 0 do
    graph_pixel(xx+x,yy+y,col[xx]);
    dec(yy)
  end;
  close(f);
end;

procedure graph_fontinit;
var i:byte;
    f:file;
begin
  assign(f,pth);
  {$I-}
  reset(f,2);
  {$I+}
  if ioresult<>0 then
  begin
    textmode(co80+font8x8);
    clrscr;
    textcolor(lightred);
    writeln('Font not found.');
    writeln;
    textcolor(cyan);
    writeln('Press any key to exit...');
    readkey;
    halt
  end;
  seek(f,3);
  blockread(f,fontw,1);
  blockread(f,fonth,1);
  close(f);
  graph_drawbmp(0,0,pth);
  for i:=0 to 255 do
  begin
    getmem(ascii[i],fontw*fonth+4);
    graph_getimage((i mod 16)*fontw,(i div 16)*fonth,(i mod 16)*fontw+fontw-1,(i div 16)*fonth+fonth-1,ascii[i])
  end;
end;

procedure graph_say;
var i:byte;
    xx:longint;
    yy:word;
begin
  xx:=0;
  yy:=0;
  if txt[0]=#0 then exit;
  for i:=1 to ord(txt[0]) do
  begin
    if x-xx+i*(fontw+fontd)>1023 then begin xx:=x+(i-1)*(fontw+fontd);yy:=yy+fonth+fontl end;
    graph_putchar(x-xx+(i-1)*(fontw+fontd),y+yy,col,ascii[ord(txt[i])])
  end
end;

procedure graph_rectangle;
var i,j:word;
begin
  if fl then
  for i:=x+1 to x1-1 do
  for j:=y+1 to y1-1 do
  graph_pixel(i,j,fc);
  for i:=x to x1 do
  begin
    graph_pixel(i,y,lc);
    graph_pixel(i,y1,lc)
  end;
  for i:=y to y1 do
  begin
    graph_pixel(x,i,lc);
    graph_pixel(x1,i,lc)
  end
end;

procedure graph_line;
var i:word;
    dx,dy:real;
begin
  if x=x1 then for i:=y to y1 do graph_pixel(x,i,lc) else
  if y=y1 then for i:=x to x1 do graph_pixel(i,y,lc) else
  begin
    dx:=(x1-x)/1023;
    dy:=(y1-y)/1023;
    for i:=0 to 1023 do
    graph_pixel(round(x+dx*i),round(y+dy*i),lc)
  end;
end;

procedure graph_clear;
begin
  graph_rectangle(0,0,scrw,scrh,c,c,true)
end;

procedure graph_textbox;
var ms:byte;
begin
  ms:=(elem.w-6) div 10;
  if ms=0 then ms:=20;
  graph_say(elem.x-length(elem.lbl)*10,elem.y,0,elem.lbl);
  if focus then
  graph_rectangle(elem.x-3,elem.y-3,elem.x+ms*10+3,elem.y+13,224,246,true) else
  graph_rectangle(elem.x-3,elem.y-3,elem.x+ms*10+3,elem.y+13,0,245,true);
end;

procedure graph_button;
begin
  graph_rectangle(elem.x,elem.y,elem.x+elem.w,elem.y+elem.h,10,47,true);
  graph_say(elem.x+(elem.w-length(elem.lbl)*10) div 2,elem.y+elem.h div 2-5,10,elem.lbl)
end;

function emspace;
var t:string;
begin
  t:='';
  if count=0 then
  begin
    emspace:=t;
    exit
  end;
  repeat
    t:=t+ch;
    dec(count)
  until count=0;
  emspace:=t
end;

function bts;
var t:string;
begin
  str(n,t);
  bts:=t
end;

function boolts;
begin
  if n then boolts:='true' else boolts:='false'
end;

function wts;
var t:string;
begin
  str(n,t);
  wts:=t
end;

function its;
var t:string;
begin
  str(n,t);
  its:=t
end;

function lts;
var t:string;
begin
  str(n,t);
  lts:=t
end;

function bytetohex;
const hx:array[0..15] of char = '0123456789ABCDEF';
var t:string[2];
begin
  t:=hx[b div 16]+hx[b mod 16];
  bytetohex:=t;
end;

function lsqr;
var k:longint;
begin
  k:=x;
  lsqr:=k*k
end;

function lsum;
begin
  lsum:=x+y
end;


end.