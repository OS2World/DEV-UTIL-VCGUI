{***********************************
 uCheckout.pas
 unit for checkout module
 -----------------------------------
 begin  : Jul 20 2006
 author : Thomas Bohn
 eMail  : Thomas@Bohn-Stralsund.de
 -----------------------------------
 This document and the included
 information are released under
 GPL.
***********************************}
Unit uCheckout;

Interface

Uses
  Classes, Forms, Graphics, ExtCtrls, StdCtrls, Buttons, FileCtrl, uProfile,
  uTools, uCVS, uString, SysUtils;

Type
  TmyCheckOutFrm = Class (TForm)
    Panel1: TPanel;
    myProfileCombo: TComboBox;
    myProfileLbl: TLabel;
    myModuleLbl: TLabel;
    myModuleEdit: TEdit;
    myTagLbl: TLabel;
    myTagEdit: TEdit;
    myTargetLbl: TLabel;
    myCancelBtn: TButton;
    myTargetFolderEditFilename: tEditFileName;
    myCheckoutLbl: TLabel;
    myNoRecurseChb: TCheckBox;
    myCheckoutFolderLbl: TLabel;
    myCheckoutAsLbl: TLabel;
    myCheckoutAsEdit: TEdit;
    myOKBtn: TButton;
    Procedure myCheckoutAsEditOnChange (Sender: TObject);
    Procedure myTargetFolderEditFilenameOnChange (Sender: TObject);
    Procedure myModuleEditOnChange (Sender: TObject);
    Procedure myProfileComboOnChange (Sender: TObject);
    Procedure myOkBtnOnClick (Sender: TObject);
    Procedure myCheckoutFrmOnShow (Sender: TObject);
    Procedure myCancelBtnOnClick (Sender: TObject);
  Private
    Procedure myCheckInputs (Sender: TObject);
  Public
    {™ffentliche Deklarationen hier einfgen}
  End;

Var
  myCheckOutFrm: TmyCheckOutFrm;

Implementation

uses uMain;

{***********************************
* checkout button clicked
*
* @param Sender has called method
***********************************}
Procedure TmyCheckOutFrm.myOkBtnOnClick (Sender: TObject);
var
  nInd: Integer;
  oCVS: myCVS;
  bRet: Boolean;
  sAddPar: String;
  sRoot,sRootFile: String;
  sTargetFolder: String;
Begin
  Cursor := crHourglass;
  oCVS := myCVS.Create;
  if profileFrm.myCheckoutROChb.checked then
    sAddpar := '-r'
  else
    sAddpar := '';
  if myNoRecurseChb.checked then
    sAddPar := sAddPar + ' -l';
  TokenInit(ourProfiles.Strings[myProfileCombo.ItemIndex],'|',true);
  if Token(5) = 'L' then
    sRoot := ':local:' + AddPathSeparator(Token(4))
  else
    sRoot := ':pserver:' + Token(2) + '@' + AddPathSeparator(Token(4));
  bRet := oCVS.CallCVSFunction('CheckoutModule', sRoot, myTargetFolderEditFilename.Filename,
                            myModuleEdit.Text, sAddPar, myTagEdit.Text, myCheckoutAsEdit.Text );
  if oCVS.CVSLog.count > 0 then begin
    myOS2CVSFrm.myLogListBox.Items.AddStrings(oCVS.CVSLog);
    myOS2CVSFrm.myLogListBox.ItemIndex := myOS2CVSFrm.myLogListBox.Items.count-1;
  end;
  oCVS.free;
  if myCheckoutAsEdit.Text <> '' then
    sTargetFolder := AddPathSeparator(myTargetFolderEditFilename.Filename)+myCheckoutAsEdit.Text
  else
    sTargetFolder := AddPathSeparator(myTargetFolderEditFilename.Filename)+myModuleEdit.Text;
  sRootFile := AddPathSeparator(sTargetFolder)+'CVS\Root';
  myOS2CVSFrm.myCVSList.DeSelectAll;
  myOS2CVSFrm.RefreshLists('Update',sTargetFolder,nil,true,true);
  myOS2CVSfrm.refreshMenuItemOnClick(self);
  for nInd := 1 to myOS2CVSFrm.myProjectOutLn.ItemCount do begin
    if myOS2CVSFrm.myProjectOutLn.Items[nInd].Fullpath = sTargetFolder then
    begin
      myOS2CVSFrm.myProjectOutLn.SelectedNode := myOS2CVSFrm.myProjectOutLn.Items[nInd];
      myOS2CVSFrm.myProjectOutLn.Items[myOS2CVSFrm.myProjectOutLn.SelectedNode.TopItem].Expand;
      myOS2CVSFrm.myProjectOutLn.SelectedNode := myOS2CVSFrm.myProjectOutLn.Items[nInd];
      break;
    end;
  end;
  Cursor := crDefault;
  close;
End;

{***********************************
* formshow
*
* @param Sender has called method
***********************************}
Procedure TmyCheckOutFrm.myCheckoutFrmOnShow (Sender: TObject);
var
  nInd: Integer;
Begin
  myProfileCombo.clear;
  for nInd := 0 to ourProfiles.count-1 do begin
    TokenInit(ourProfiles.Strings[nInd],'|',false);
    myProfileCombo.Items.Add(Token(1));
  end;
  myTargetFolderEditFilename.Filename := myOS2CVSFrm.myProjectOutLn.SelectedNode.FullPath;
  myCheckInputs(Sender);
End;

{***********************************
* cancel button clicked
*
* @param Sender has called method
***********************************}
Procedure TmyCheckOutFrm.myCancelBtnOnClick (Sender: TObject);
Begin
  close;
End;

Procedure TmyCheckOutFrm.myProfileComboOnChange (Sender: TObject);
Begin
  myCheckInputs(Sender);
End;

Procedure TmyCheckOutFrm.myModuleEditOnChange (Sender: TObject);
Begin
  myCheckInputs(Sender);
End;

Procedure TmyCheckOutFrm.myTargetFolderEditFilenameOnChange (Sender: TObject);
Begin
  myCheckInputs(Sender);
End;

Procedure TmyCheckOutFrm.myCheckoutAsEditOnChange (Sender: TObject);
Begin
  myCheckInputs(Sender);
End;

{***********************************
* check Inputs
*
* @param Sender has called method
***********************************}
Procedure TmyCheckOutFrm.myCheckInputs (Sender: TObject);
begin
  if (myProfileCombo.Itemindex > -1) and
  (myTargetFolderEditFilename.Filename <> '') then begin
    myCheckoutAsEdit.Enabled := true;
  end else begin
    myCheckoutAsEdit.Enabled := false;
  end;
  if (myProfileCombo.Itemindex > -1) and
  (myTargetFolderEditFilename.Filename <> '') then begin
    myOkBtn.Enabled := true;
  end else begin
    myOkBtn.Enabled := false;
  end;
  if myCheckoutAsEdit.Text <> '' then
    myCheckoutFolderLbl.Caption := AddPathSeparator(myTargetFolderEditFilename.Filename) +
                                   myCheckoutAsEdit.Text
  else
    myCheckoutFolderLbl.Caption := AddPathSeparator(myTargetFolderEditFilename.Filename) +
                                   myModuleEdit.Text;
end;

Initialization
  RegisterClasses ([TmyCheckOutFrm, TPanel, TComboBox, TLabel, TEdit, TButton
   , tEditFileName, TCheckBox]);
End.
