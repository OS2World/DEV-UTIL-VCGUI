Unit uImport;

Interface

Uses
  Classes, Forms, Graphics, StdCtrls, Buttons, ExtCtrls, SysUtils, Menus,
  FileCtrl, uString, Dialogs;

Type
  TmyImportFrm = Class (TForm)
    myProfileCombo: TComboBox;
    myProfileLbl: TLabel;
    myFilemaskEdit: TEdit;
    myFilemaskLbl: TLabel;
    myAddIgnoreBtn: TButton;
    myAddBinBtn: TButton;
    myIgnoreListbox: TListBox;
    Panel1: TPanel;
    myBinaryListbox: TListBox;
    myVendorEdit: TEdit;
    myReleaseEdit: TEdit;
    myVendorLbl: TLabel;
    myReleaseLbl: TLabel;
    myImportEditFileName: tEditFileName;
    myFolderlbl: TLabel;
    myImportNameEdit: TEdit;
    myImportNameLbl: TLabel;
    myImportCommentMemo: TMemo;
    myImportCommentLbl: TLabel;
    myIgnoreLbl: TLabel;
    myBinLbl: TLabel;
    myOkBtn: TButton;
    myCancelBtn: TButton;
    myBinDelPopupMenu: TPopupMenu;
    myBinDelMenuItem: TMenuItem;
    myIgnoreDelPopupMenu: TPopupMenu;
    myIgnoreDelMenuItem: TMenuItem;
    Procedure myImportNameEditOnChange (Sender: TObject);
    Procedure myReleaseEditOnChange (Sender: TObject);
    Procedure myVendorEditOnChange (Sender: TObject);
    Procedure myProfileComboOnChange (Sender: TObject);
    Procedure myImportEditFileNameOnChange (Sender: TObject);
    Procedure myIgnoreDelMenuItemOnClick (Sender: TObject);
    Procedure myBinDelMenuItemOnClick (Sender: TObject);
    Procedure myImportFrmOnShow (Sender: TObject);
    Procedure myAddBinBtnOnClick (Sender: TObject);
    Procedure myAddIgnoreBtnOnClick (Sender: TObject);
    Procedure myCancelBtnOnClick (Sender: TObject);
    Procedure myOkBtnOnClick (Sender: TObject);
  Private
    Procedure myRefreshEnabledState (Sender: TObject);
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  End;

Var
  myImportFrm: TmyImportFrm;

Implementation

uses uMain, uTools, uCVS, uProfile, uStrings;

{***********************************
* formshow import window
*
* @param Sender has called method
***********************************}
Procedure TmyImportFrm.myImportFrmOnShow (Sender: TObject);
var
  sPrbFile: String;
  sPriFile: String;
  nInd: Integer;
Begin
  myProfileCombo.clear;
  for nInd := 0 to ourProfiles.count-1 do begin
    TokenInit(ourProfiles.Strings[nInd],'|',false);
    myProfileCombo.Items.Add(Token(1));
  end;
  sPrbFile := ChangeFileExt(Paramstr(0),'.prb');
  if FileExists(sPrbFile) then
    myBinaryListbox.Items.LoadFromFile(sPrbFile);
  sPriFile := ChangeFileExt(Paramstr(0),'.pri');
  if FileExists(sPriFile) then
    myIgnoreListbox.Items.LoadFromFile(sPriFile);
  myImportEditFilename.Filename := myOS2CVSFrm.myProjectOutLn.SelectedNode.FullPath;
End;

{***********************************
* add to binary button clicked
*
* @param Sender has called method
***********************************}
Procedure TmyImportFrm.myAddBinBtnOnClick (Sender: TObject);
var
  sPrbFile: String;
Begin
  myBinaryListbox.Items.Add(myFilemaskEdit.Text);
  sPrbFile := ChangeFileExt(Paramstr(0),'.prb');
  myBinaryListbox.Items.SaveToFile(sPrbFile);
End;

{***********************************
* add to ignore button clicked
*
* @param Sender has called method
***********************************}
Procedure TmyImportFrm.myAddIgnoreBtnOnClick (Sender: TObject);
var
  sPriFile: String;
Begin
  myIgnoreListbox.Items.Add(myFilemaskEdit.Text);
  sPriFile := ChangeFileExt(Paramstr(0),'.pri');
  myIgnoreListbox.Items.SaveToFile(sPriFile);
End;

{***********************************
* cancel button clicked
*
* @param Sender has called method
***********************************}
Procedure TmyImportFrm.myCancelBtnOnClick (Sender: TObject);
Begin
  close;
End;

{***********************************
* import button clicked
*
* @param Sender has called method
***********************************}
Procedure TmyImportFrm.myOkBtnOnClick (Sender: TObject);
var
  oCVS: myCVS;
  bRet: Boolean;
  sRoot, sModule, sComment, sVendor, sRelease: AnsiString;
  sIgnore, sBinary: AnsiString;
  nInd: Integer;
Begin
  TokenInit(ourProfiles.Strings[myProfileCombo.ItemIndex],'|',true);
  if Token(5) = 'L' then
    sRoot := ':local:' + Token(4)
  else
    sRoot := ':pserver:' + Token(2) + ':' + Token(3) + '@' + Token(4);

  sModule := myImportNameEdit.Text;
  sVendor := myVendorEdit.Text;
  sRelease := myReleaseEdit.Text;

  sComment := myImportCommentMemo.Lines.Text;
  while pos(#13#10,sComment) <> 0 do
    sComment := ReplaceStr(sComment,#13#10,' ');
  sComment := trim(sComment);
  if sComment = '' then sComment := langNoComment;

  oCVS := myCVS.Create;
  oCVS.CreateIgnoreList(myImportEditFilename.Filename);  // fill ourCVSIgnoreList

  sIgnore := '';
  for nInd := 0 to ourCVSIgnoreList.count-1 do
    sIgnore := sIgnore + '-I "' + ourCVSIgnoreList.Strings[nInd] + '" ';
  for nInd := 0 to myIgnoreListbox.items.count-1 do
    sIgnore := sIgnore + '-I "' + myIgnoreListbox.Items.Strings[nInd] + '" ';
  sBinary := '';
  for nInd := 0 to myBinaryListbox.items.count-1 do
    sBinary := sBinary + '-W "' + myBinaryListbox.Items.Strings[nInd] +
      ' -k ''b''" ';

  bRet := oCVS.CallCVSFunction('Import', sRoot, myImportEditFilename.Filename,
     sIgnore + ' ' + sBinary, '-r', sModule + ' ' + sVendor + ' ' + sRelease, sComment );
  if oCVS.CVSLog.count > 0 then begin
    myOS2CVSFrm.myLogListBox.Items.AddStrings(oCVS.CVSLog);
    myOS2CVSFrm.myLogListBox.ItemIndex := myOS2CVSFrm.myLogListBox.Items.count-1;
  end;
  oCVS.free;
  close;
End;

{***********************************
* delete entry menu item clicked
* on popup in binary listbox
*
* @param Sender has called method
***********************************}
Procedure TmyImportFrm.myBinDelMenuItemOnClick (Sender: TObject);
var
  nInd: Integer;
  sPrbFile: String;
Begin
  if myBinaryListbox.SelCount > 0 then begin
    nInd := myBinaryListbox.Items.count-1;
    while nInd >= 0 do begin
      if myBinaryListbox.Selected[nInd] then
        myBinaryListbox.Items.Delete(nInd)
      else
        dec(nInd);
    end;
  end;
  sPrbFile := ChangeFileExt(Paramstr(0),'.prb');
  myBinaryListbox.Items.SaveToFile(sPrbFile);
End;

{***********************************
* delete entry menu item clicked
* on popup in ignore listbox
*
* @param Sender has called method
***********************************}
Procedure TmyImportFrm.myIgnoreDelMenuItemOnClick (Sender: TObject);
var
  nInd: Integer;
  sPriFile: String;
Begin
  if myIgnoreListbox.SelCount > 0 then begin
    nInd := myIgnoreListbox.Items.count-1;
    while nInd >= 0 do begin
      if myIgnoreListbox.Selected[nInd] then
        myIgnoreListbox.Items.Delete(nInd)
      else
        dec(nInd);
    end;
  end;
  sPriFile := ChangeFileExt(Paramstr(0),'.pri');
  myIgnoreListbox.Items.SaveToFile(sPriFile);
End;

Procedure TmyImportFrm.myImportEditFileNameOnChange (Sender: TObject);
var
  nPos: Integer;
Begin
  myRefreshEnabledState(Sender);
  nPos := lastpos('\',myImportEditFilename.Filename);
  myImportNameEdit.Text := copy(myImportEditFilename.Filename,nPos+1,99);
End;

Procedure TmyImportFrm.myReleaseEditOnChange (Sender: TObject);
Begin
  myRefreshEnabledState(Sender);
End;

Procedure TmyImportFrm.myVendorEditOnChange (Sender: TObject);
Begin
  myRefreshEnabledState(Sender);
End;

Procedure TmyImportFrm.myProfileComboOnChange (Sender: TObject);
Begin
  myRefreshEnabledState(Sender);
End;

Procedure TmyImportFrm.myImportNameEditOnChange (Sender: TObject);
Begin
  myRefreshEnabledState(Sender);
End;

{***********************************
* refresh enabled state of import button
*
* @param Sender has called method
***********************************}
Procedure TmyImportFrm.myRefreshEnabledState (Sender: TObject);
begin
  if (myImportEditFilename.Filename <> '') and (myProfileCombo.Text <> '')
  and (myVendorEdit.Text <> '') and (myReleaseEdit.Text <> '')
  and (myImportNameEdit.Text <> '')
  then
    myOKBtn.Enabled := true
  else
    myOKBtn.Enabled := false;
end;

Initialization
  RegisterClasses ([TmyImportFrm, TComboBox, TLabel, TEdit, TButton, TListBox
   , TPanel, TPopupMenu, TMenuItem, tEditFileName, TMemo]);
End.
