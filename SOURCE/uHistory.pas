{***********************************
 uHistory.pas
 unit for showing history
 -----------------------------------
 begin  : Jul 15 2006
 author : Thomas Bohn
 eMail  : Thomas@Bohn-Stralsund.de
 -----------------------------------
 This document and the included
 information are released under
 GPL.
***********************************}
Unit uHistory;

Interface

Uses
  Classes, Forms, Graphics, ExtCtrls, ComCtrls, Buttons, SysUtils,
  Dialogs, DOS, uString, uStrings, uCVS, uProfile, uTools, StdCtrls, Menus;

Type
  TmyHistoryFrm = Class (TForm)
    Panel1: TPanel;
    myHistoryList: tMultiColumnList;
    myListPopupMenu: TPopupMenu;
    myViewMenuItem: TMenuItem;
    myEditMenuItem: TMenuItem;
    myDiffWorkingMenuItem: TMenuItem;
    myDiffSelectedMenuItem: TMenuItem;
    MenuItem3: TMenuItem;
    myCommentMemo: TMemo;
    Procedure myDiffSelectedMenuItemOnClick (Sender: TObject);
    Procedure myEditMenuItemOnClick (Sender: TObject);
    Procedure myViewMenuItemOnClick (Sender: TObject);
    Procedure myDiffWorkingMenuItemOnClick (Sender: TObject);
    Procedure myHistoryFrmOnShow (Sender: TObject);
    Procedure myHistoryListOnItemFocus (Sender: TObject; Index: LongInt);
  Private
    myFolder: String;
    myFileName: String;
    Procedure myCheckoutAndRun(Sender: TObject);
  Public
    property Filename: String read myFilename write myFilename;
    property Folder: String read myFolder write myFolder;
    ourCommentList: TStringList;
  End;

Var
  myHistoryFrm: TmyHistoryFrm;

Implementation

uses uMain;

{***********************************
* formshow
*
* @param Sender has called method
***********************************}
Procedure TmyHistoryFrm.myHistoryFrmOnShow (Sender: TObject);
var
  nInd: Integer;
Begin
  Caption := langHistory +': ' + myFilename;
  myCommentMemo.Clear;
  myHistoryList.ItemIndex := -1;
End;

{***********************************
* checkout files and run diff,view or edit
*
* @param Sender has called method
***********************************}
Procedure TmyHistoryFrm.myCheckoutAndRun(Sender: TObject);
var
  sRev1, sRev2: String;
  sFile1, sFile2: String;
  bRet: Boolean;
  nInd: Integer;
  oCVS: myCVS;
  sTmpPath: String;
  sAddpar: String;
  nPar, nI: Integer;
  nId: longword;
  sPar: String;
  sExe: String;
  sProgram: String;
Begin
  if (Sender = myDiffSelectedMenuItem) or (Sender = myDiffWorkingMenuItem) then
    sProgram := profileFrm.myDiffEditFileName.Filename
  else if Sender = myViewMenuItem then
    sProgram := profileFrm.myViewerEditFileName.Filename
  else if Sender = myEditMenuItem then
    sProgram := profileFrm.myEditorEditFileName.Filename;

  sRev1 := '';
  sRev2 := '';
  // get revisions to diff
  for nInd := 0 to myHistoryList.Count-1 do begin
    if myHistoryList.Selected[nInd] then begin
      if sRev1 = '' then sRev1 := myHistoryList.values[0,nInd]
      else sRev2 := myHistoryList.values[0,nInd];
    end;
  end;
  // check program
  if (pos('.CMD',uppercase(sProgram)) <> 0) or
   (pos('.BAT',uppercase(sProgram)) <> 0)
  then begin
    ShowMessage(langNoCMD);
    exit;
  end;
  sTmpPath := GetEnv('TMP');
  oCVS := myCVS.Create;
  sAddpar := '-p -r ' + sRev1;
  bRet := oCVS.CallCVSFunction('CheckoutDiff', AddPathSeparator(myFolder),
    sTmpPath, myOS2CVSfrm.getFileListString('CVS'), sAddPar, sRev1, '' );
  sFile1 := sTmpPath + '\' + myFilename + '#' + sRev1;
  if Sender = myDiffWorkingMenuItem then
    sFile2 := AddPathSeparator(myFolder) + myFilename
  else begin
    sAddpar := '-p -r ' + sRev2;
    bRet := oCVS.CallCVSFunction('CheckoutDiff', AddPathSeparator(myFolder),
      sTmpPath, myOS2CVSfrm.getFileListString('CVS'), sAddPar, sRev2, '' );
    if sRev2 <> '' then
      sFile2 := sTmpPath + '\' + myFilename + '#' + sRev2
    else
      sFile2 := '';
  end;
  Exec_Visible := true;
  AsynchExec := true;
  nPar := TokenInit(sProgram,' ',false);
  sExe := Token(1);
  sPar := '';
  for nI := 2 to nPar do
    sPar := sPar + Token(nI) + ' ';
  nId := Exec(sExe, sPar + sFile1 + ' ' +sFile2);
  DosExitCode(nId);
  DeleteFile(sFile1);
  if Sender <> myDiffWorkingMenuItem then   // Attention
    DeleteFile(sFile2);
end;

{***********************************
* diff selected
*
* @param Sender has called method
***********************************}
Procedure TmyHistoryFrm.myDiffSelectedMenuItemOnClick (Sender: TObject);
Begin
  myCheckoutAndRun(Sender);
End;

{***********************************
* diff with working copy
*
* @param Sender has called method
***********************************}
Procedure TmyHistoryFrm.myDiffWorkingMenuItemOnClick (Sender: TObject);
Begin
  myCheckoutAndRun(Sender);
End;

{***********************************
* view selected
*
* @param Sender has called method
***********************************}
Procedure TmyHistoryFrm.myViewMenuItemOnClick (Sender: TObject);
Begin
  myCheckoutAndRun(Sender);
End;

{***********************************
* edit button clicked
*
* @param Sender has called method
***********************************}
Procedure TmyHistoryFrm.myEditMenuItemOnClick (Sender: TObject);
Begin
  myCheckoutAndRun(Sender);
End;

{***********************************
* select or deselect entry in HistList
*
* @param Sender has called method
* @param Index
***********************************}
Procedure TmyHistoryFrm.myHistoryListOnItemFocus (Sender: TObject; Index: LongInt);
Begin
  if myHistoryList.SelCount = 2 then myDiffSelectedMenuItem.Enabled := true
  else myDiffSelectedMenuItem.Enabled := false;
  if myHistoryList.SelCount > 0 then begin
    myViewMenuItem.Enabled := true;
    myEditMenuItem.Enabled := true;
    myDiffWorkingMenuItem.Enabled := true;
  end else begin
    myViewMenuItem.Enabled := false;
    myEditMenuItem.Enabled := false;
    myDiffWorkingMenuItem.Enabled := false;
  end;
  if myHistoryList.SelCount = 1 then begin
    myDiffWorkingMenuItem.Enabled := true;
  end else begin
    myDiffWorkingMenuItem.Enabled := false;
  end;
  myCommentMemo.Text := myHistoryList.Values[3,Index];
End;


Initialization
  RegisterClasses ([TmyHistoryFrm, TPanel, tMultiColumnList, TMemo,
    TPopupMenu, TMenuItem]);
End.
