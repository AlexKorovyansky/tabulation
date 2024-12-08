Program createfile;
uses crt;

function read_tab_parm (var parm: integer; line:string): byte;
var s: string;
    code: integer;
Begin
  read_tab_parm:=0;
  write(line);
  readln(s);
  val(s,parm,code);
  if (code<>0) or (parm<0) or (parm>1) then read_tab_parm:=1;
end;


function read_integer_parm (var parm: integer; line:string): byte;
var s: string;
    code: integer;
Begin
  read_integer_parm:=0;
  write(line);
  readln(s);
  val(s,parm,code);
  if code<>0 then read_integer_parm:=1;
end;

function read_real_parm (var parm: real; line: string): byte;
var s: string;
    code:integer;
Begin
  read_real_parm:=0;
  write(line);
  readln(s);
  val(s,parm,code);
  if code<>0 then read_real_parm:=1;
end;

Procedure create_file;
 var tfile: text;
     col,row, parm:integer;
     x_min,x_max,p_min,p_max,h:real;
Begin
  clrscr;
  assign(tfile, 'd:\config.txt');
  rewrite(tfile);
  while Read_integer_parm(row,'Введите количество строк: ')<>0 do writeln('Повторите ввод');
  while Read_integer_parm(col,'Введите количество столбцов: ')<>0 do writeln('Повторите ввод');
  while read_real_parm(x_min,'Введите минимальную границу X: ')<>0 do writeln('Повторите ввод');
  while read_real_parm(x_max,'Введите максимальную границу X: ')<>0 do writeln('Повторите ввод');
  while read_real_parm(p_min,'Введите минимальную границу P: ')<>0 do writeln('Повторите ввод');
  while read_real_parm(p_max,'Введите максимальную границу P: ')<>0 do writeln('Повторите ввод');
  while read_real_parm(h,'Введите шаг табулирования: ')<>0 do writeln('Повторите ввод');
  while read_tab_parm(parm,'Введите параметр табулирования (0: от начала к концу, 1: наоборот):')<>0
  do writeln('Повторите ввод');
  {Запись в файл}
  writeln(tfile,col);
  writeln(tfile,row);
  writeln(tfile,x_min);
  writeln(tfile,x_max);
  writeln(tfile,p_min);
  writeln(tfile,p_max);
  writeln(tfile,h);
  close(tfile);
end;

Begin
  create_file;
end.