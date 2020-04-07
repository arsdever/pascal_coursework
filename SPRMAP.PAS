type ty = array[0..8,0..3] of word;
const q:ty =
      ((0,127,0,127),(0,127,128,255),
       (128,255,0,127),(128,255,128,255),(256,383,0,127),
       (256,319,128,191),(320,383,128,191),(320,383,192,255),(256,319,192,255));
var f:file;
begin
assign(f,'files\sprmp.spr');
rewrite(f,1);
blockwrite(f,q,sizeof(q))
end.