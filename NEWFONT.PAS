uses gr;
var f:file;
    arr:bmp_header;
begin
  assign(f,'files\f10x10AB.ft');
  reset(f,1);
  blockread(f,arr,54);
  reset(f,1);
  arr.f.res1:=10;
  arr.f.res2:=10;
  blockwrite(f,arr,54);
  close(f)
end.
