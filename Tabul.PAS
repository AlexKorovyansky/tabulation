PROGRAM TAB;

Uses crt;

const
  xx=79;
  yy=15;
  Tabclr=7;
  BaseClr=15;
  TextClr=15;

 function chislo_str(row,col:integer;x_min,x_max,h:real):integer;        {Считает число страниц таблицы}

   {Функция возвращает число страниц необходимых для размещения
    таблицы (с col строками и row столбцами) всех значений аргумента от
    изменяемых от X_min до X_max с шагом h}

   var zn:integer;
   begin
     zn:=trunc((x_max-x_min)/h);
     if zn mod (row*col) = 0 then chislo_str:=(zn div (row*col)) else
     chislo_str:=(trunc(zn/(row*col)))+1;
   end;


  procedure start(x_min,x_max,h:real);
   {Процедура выводит на табулирумую функцию и параметры табулирования прочитиныые из файла}
     begin
     Clrscr;
     gotoxy(1,2);
     writeln('ПРОГРАММА ТАБУЛИРОВАНИЯ ФУНКЦИИ (Вариант №10)');
     writeln;
     writeln('      │         1                   ');
     writeln('      │         ─                   ');
     writeln('      │ ┌   4 4┐3                   ');
     writeln('      │ │1+x p │                    ');
     writeln('      │ └      ┘                    ');
     writeln('      │ ────────  , при X<= SinP    ');
     writeln('      │  2╖-x                        Шаг Табулирования(h) = ',h:-10:2);
     writeln(' F(x)=┤                             ');
     writeln('      │                              Отрезок табулирования = [',x_min:-10:4,';',x_max:-10:4,']');
     writeln('      │    5┌  │px│  ┐              ');
     writeln('      │  lg │ e    +1│ , при X> SinP');
     writeln('      │     └        ┘              ');
     writeln('      │                             ');
     writeln('      │                             ');
     writeln;
     end;

 function file_exists(filename:string):integer;
 {Функция возвращает 0 если файл с именем FileName существует
 и 1 если не существует}
 var efile:text;
 begin
   file_exists:=0;
   assign(efile,filename);
   {$i-}
   reset(efile);
   {$i+}
   if IOresult<>0 then
   begin
     file_exists:=1;
     clrscr;
     writeln('Файл не найден');
   end;
 end;

 function file_research(filename:string;rcol,rrow:integer;rx_min,rx_max,rp_min,rp_max,rh:real; parm:integer):integer;
 {Функция возвращает 0 если параметры содержащиеся в текстовом файле с именем FileName
 удовлетворяют условиям табулированиям и 1 если не удовлетворяют (файл поврежден)}
 var rfile:text;
 begin
   file_research:=0;
   if (rcol<=0) or (rrow<=0) or (rx_min>rx_max) or (rp_min>rp_max) or (parm<0) or (Parm>1) then file_research:=1;
 end;


 procedure read_file(var col, row: integer; var x_min, x_max, p_min, p_max, h: real; var parm: integer);
 {В процедуре производится чтение параметров табулировния
 выход: Col - число столбцов таблицы
        row - число строк
        x_min - минимальная граница табулирования
        x_max - максимальная граница табулировния
        p_min - минимальная граница параметра p
        p_max - максимальная граница параметра p
        h - шаг табулирования
        parm - опция табулирования (0 - от начала к концу))
                                  (1 - от конца к началу)}
 var cfile:text;
     filename:string;
 begin
   clrscr;
   repeat
     write('Введите путь к конфигурационному файлу (config.txt): ');
     readln(filename);
     if filename='exit' then halt;
     if filename='' then filename:='d:\Config.txt';
   until file_exists(filename)=0;
   assign(cfile, filename);
   reset(cfile);
   col:=0;
   row:=0;
   x_min:=0;
   x_max:=0;
   p_min:=0;
   p_max:=0;
   h:=0;
  {$i-}
   readln(cfile, col);
   readln(cfile, row);
   readln(cfile, x_min);
   readln(cfile, x_max);
   readln(cfile, p_min);
   readln(cfile, p_max);
   readln(cfile, h);
   readln(cfile,parm);
   {$i+}
   if (file_research(filename,col,row,x_min,x_max,p_min,p_max,h, parm)<>0) or
      (IOResult<>0) then
   begin
     clrscr;
     writeln('Файл поврежден');
     readkey;
     halt;
   end;
   close(cfile);
   clrscr;
 end;

 function get_p(p_min,p_max:real):real;{Получает значение параметра}
 {Функция возвращает значение параметра p находящегося в отрезке (p_min;p_max)}
  var b:boolean;
  p:real;
   begin
     b:=false;
     repeat
     write('Введите Параметр P (pє[',p_min:-10:4,';',p_max:-10:4,']): p=');
     readln(p);
     get_p:=p;
     if (p<=p_max) and (p>=p_min) then b:=true else
     writeln('Недопустимое Значение параметра');
     until b=true;
   end;

 procedure stroka(col,x,y,c1,c2,c3,c4:byte);
 {Процедура вывода на экран строки таблицы
 строка разбивается на col столбцов (col*2 под столбцов)
 вывод строки начинается с позиции x,y
 строка таблицы открывается символом #с1
 внутри ячейки ставится символ #с2
 подстолбцы и столбцы отделяются символом #с3
 строка таблицы закрывается символом #с4}
 var h1,h2:integer;
  begin
  gotoxy(x,y);
  h1:=xx div (col*2);
    for h2:=1 to h1*col*2 do
        begin
        if h2=1 then write(chr(c1));
        if h2=col*2*h1 then write(chr(c4)) else
        if (h2 mod h1 = 0) then write(Chr(c3)) else write(chr(c2));
        end;

  end;

 procedure tab_make(col,row:integer);
 {Выводит на экран расчерченную таблицу Col*row}
 var t1,m1,m2:integer;
    begin
      textcolor(TabClr);
      stroka(col,1,2,218,196,194,191);
      stroka(col,1,3,179,0,179,179);
      stroka(col,1,4,195,196,197,180);
      m1:= xx div (col*2);
      for m2:=0 to col-1 do
      begin
        gotoxy(m1*m2*2+2,3);
        write('Аргумент');
        gotoxy(m1*m2*2+m1+2,3);
        write('Функция');
      end;
      for t1:=5 to 5+row-1 do stroka(col,1,t1,179,0,179,179);
      stroka(col,1,5+row,192,196,193,217);
    end;

 procedure consider (var Fx: real; x,p:real; var code:byte);
 {Выход Fx - значение функции}
 var r:real;
 begin
   code:=0;
   if (2*pi-x= 0) or ( (ln (exp (abs (p*x) ) + 1 )) / exp( 5*ln (ln (10) ) )< 0) then code:=1 else
   if x<=sin(p) then Fx:= exp(1/3*ln(1+x*x*x*x*p*p*p*p))/(2*pi-x)
                else Fx:= exp(5*ln(ln(exp(abs(p*x))+1)))/exp(5*ln(ln(10)));

 end;

 procedure zapolnenie(col,row:integer;x_min,x_max,p_min,p_max,h:real;n:integer;p:real; parm:integer);
 {Заполняет расчерченную таблицу значениями аргумента и функции}
   var lim_x,x,Fx:real;
   r,c:integer;
   error_code: byte;
   s:real;
   begin
     TextColor(TextClr);
     gotoxy(1,1);
     write('Страница ',n,'/',chislo_Str(col,row,x_min,x_max,h),'  p=',p);
     case parm of
     0: begin{От меньшего к большему}
          lim_x:= x_min + n*row*col*h;
          x:= x_min + (n - 1)*row*col*h;
        end;
     1: begin {От большего к меньшему}
          s:= x_max;
          x_max:= x_min;
          x_min:= s;
          lim_x:= x_min - n*row*col*h;
          x:=x_min - (n - 1)*row*col*h;
          h:=-h;
        end;
     end;{ case}
     r:=0;
     c:=0;
     repeat
       if c=col then
       begin
         r:=r+1;
         c:=0;
       end;
{}     if ((x>x_max+h/2) and (parm=1)) or (x<x_max+h/2) and (parm=0) then
       begin
         consider(Fx,x,p,error_code);
         gotoxy((xx div (col*2))*c*2+2,5+r);{ВЫВОД X}
         write(x:9:5);
         gotoxy((xx div (col*2))*c*2+2+(xx div (col*2)),5+r); {ВЫВОД Y}
         if error_code= 0 then write(Fx:9:5) else write('Не определена');
       end;
       x:=x+h;
       c:=c+1;
     until (r+1=row) and (c=col);
     gotoxy(1,5+row+1);
     write('Нажмите Enter Для Перехода На Следующую Страницу');
   end;

 Var n,n_max,s,l1,l2:integer;
     p:real;
     COL, ROW, PARM:integer;
     X_MIN,X_MAX,P_MIN,P_MAX,H:real;

 begin
   textcolor(BaseClr);
   {Обнуление}
   COL:= 0; X_MIN:= 0; P_MIN:= 0; H:= 0;
   ROW:= 0; X_MAX:= 0; P_MAX:= 0; PARM:= 0;
   read_file(col, row, x_min, x_max, p_min, p_max, h, parm);
   n_max:=chislo_str(col, row, x_min, x_max, h);
   start(x_min,x_max,h);        {n - номер страницы}
   p:=get_p(p_min,p_max);
   clrscr;
   {========}
   n:=0;
   repeat
     clrscr;
     tab_make(col,row);
     n:=n+1;
     zapolnenie(col,row,x_min,x_max,p_min,p_max,h,n,p,parm);
     readln;
   until n>=n_max;
   writeln('ВСЁ');
   readkey;
 END.
