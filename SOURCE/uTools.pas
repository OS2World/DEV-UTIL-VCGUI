{***********************************
 uTools.pas
 tobo common tool unit
 -----------------------------------
 begin  : Jun 1 2006
 author : Thomas Bohn
 eMail  : Thomas@Bohn-Stralsund.de
 -----------------------------------
 This document and the included
 information are released under
 GPL.
***********************************}
Unit uTools;

Interface

uses SysUtils;

Function TokenInit(aText, aSep: String; aEmpty: Boolean): Integer;
Function Token(aNum: Integer): String;
Function MonthToNum(aMonthStr: String): Integer;
Function CodeString(aText: String): String;
Function DeCodeString(aText: String): String;

var
  ourToken : array[1..100] of String;

Implementation

{***********************************
* TokenInit for incremental
* tokenizer
*
* @param aText
* @param aSep
* @param aEmpty
* @return Integer
***********************************}
Function TokenInit(aText, aSep: String; aEmpty: Boolean): Integer;
var
  i: Integer;
  sFragment: String;
begin
  for i:=1 to 100 do
    ourToken[i] := '';
  i := 1;
  while pos(aSep,aText) <> 0 do begin
    sFragment := copy(aText,1,pos(aSep,aText)-1);
    if (sFragment <> '') or (aEmpty) then begin
      ourToken[i] := sFragment;
      inc(i);
    end;
    aText := copy(aText,pos(aSep,aText)+1,length(aText));
  end;
  ourToken[i] := aText;
  RESULT := i;           // last Element
end;

{***********************************
* Return one token from tokenizer
*
* @param aNum
* @return String
***********************************}
Function Token(aNum: Integer): String;
begin
  RESULT := ourToken[aNum];
end;

{***********************************
* Get month number from month short name
*
* @param aMonthStr
* @return Integer
***********************************}
Function MonthToNum(aMonthStr: String): Integer;
begin
  if uppercase(aMonthStr) = 'JAN' then
    RESULT := 1
  else if uppercase(aMonthStr) = 'FEB' then
    RESULT := 2
  else if uppercase(aMonthStr) = 'MAR' then
    RESULT := 3
  else if uppercase(aMonthStr) = 'APR' then
    RESULT := 4
  else if uppercase(aMonthStr) = 'MAY' then
    RESULT := 5
  else if uppercase(aMonthStr) = 'JUN' then
    RESULT := 6
  else if uppercase(aMonthStr) = 'JUL' then
    RESULT := 7
  else if uppercase(aMonthStr) = 'AUG' then
    RESULT := 8
  else if uppercase(aMonthStr) = 'SEP' then
    RESULT := 9
  else if uppercase(aMonthStr) = 'OCT' then
    RESULT := 10
  else if uppercase(aMonthStr) = 'NOV' then
    RESULT := 11
  else if uppercase(aMonthStr) = 'DEC' then
    RESULT := 12;
end;

{***********************************
* Encode String
*
* @param aText
* @return String
***********************************}
Function  CodeString(aText: String): String;
var i, n: Integer;
begin
  RESULT := '';
  n := 42;
  for i := 1 to Length(aText) do
  begin
    RESULT := RESULT + chr(35 +(ord(aText[i]) xor n));
    dec(n);
    if n < -36
    then n := 36;
  end;
end;

{***********************************
* Decode String
*
* @param aText
* @return String
***********************************}
Function  DeCodeString(aText: String): String;
var i, n: Integer;
begin
  RESULT := '';
  n := 42;
  for i := 1 to Length(aText) do
  begin
    RESULT := RESULT + chr((ord(aText[i])-35) xor n);
    dec(n);
    if n < -36
    then n := 36;
  end;
end;

Initialization
End.
