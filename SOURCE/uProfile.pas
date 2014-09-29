{***********************************
 uProfile.pas
 Unit for managing CVS profiles
 -----------------------------------
 begin  : Mar 12 2005
 author : Thomas Bohn
 eMail  : Thomas@Bohn-Stralsund.de
 -----------------------------------
 This document and the included
 information are released under
 GPL.
***********************************}
Unit uProfile;

Interface

Uses
  Classes, Forms, Graphics, Mask, StdCtrls, Buttons, uString, TabCtrls,
  ExtCtrls, Spin, Dialogs, SysUtils, FileCtrl;

Type

  tProfileFrm = Class (TForm)
    mySettingsNotebook: TTabbedNotebook;
    mySettingsBottomPanel: TPanel;
    OKBtn: TButton;
    myRefreshChb: TCheckBox;
    myViewerEditFileName: tEditFileName;
    myEditorEditFileName: tEditFileName;
    myViewerLabel: TLabel;
    myEditorLabel: TLabel;
    myCheckoutROChb: TCheckBox;
    myDiffPattLbl: TLabel;
    myDiffEditFileName: tEditFileName;
    myCVSEditFileName: tEditFileName;
    myCVSPathLbl: TLabel;
    CVSRootLbl: TLabel;
    CVSRootContentLbl: TLabel;
    myRefreshLbl: TLabel;
    myRefreshSpin: TSpinEdit;
    PassEdit: TEdit;
    NameLbl: TLabel;
    UserEdit: TEdit;
    NameCmb: TComboBox;
    UserLbl: TLabel;
    PassLbl: TLabel;
    RepoLbl: TLabel;
    RepoEdit: TEdit;
    AccessLbl: TLabel;
    NewBtn: TButton;
    DelBtn: TButton;
    AccessCmb: TComboBox;
    Procedure profileFrmOnShow (Sender: TObject);
    Procedure NameCmbOnScan (Sender: TObject; Var KeyCode: TKeyCode);
    Procedure NameCmbOnKeyPress (Sender: TObject; Var key: Char);
    Procedure RepoEditOnChange (Sender: TObject);
    Procedure PassEditOnChange (Sender: TObject);
    Procedure UserEditOnChange (Sender: TObject);
    Procedure AccessCmbOnItemSelect (Sender: TObject; Index: LongInt);
    Procedure NameCmbOnItemSelect (Sender: TObject; Index: LongInt);
    Procedure profileFrmOnClose (Sender: TObject; Var Action: TCloseAction);
    Procedure myNameChanged (Sender: TObject);
    Procedure DelBtnOnClick (Sender: TObject);
    Procedure NewBtnOnClick (Sender: TObject);
    Procedure CloseClick (Sender: TObject);
  Private
    {Private Deklarationen hier einfgen}
    bInitial, bTyped: Boolean;
    Procedure SetEnabledState(aEnabled: Boolean);
    Procedure myAddProfileEntry;
    Procedure myRefreshProfileEntry;
    Procedure myDelProfileEntry;
  Public
    Procedure LoadProfile;
  End;

Var
  profileFrm: tProfileFrm;

  ourProfiles: TStringList;
  Function GetCVSProfiles: TStringList;

Implementation

uses uStrings, uTools;

{***********************************
*
* formshow
*
* @param Sender
*
***********************************}
Procedure TprofileFrm.profileFrmOnShow (Sender: TObject);
Begin
  bTyped := false;
End;

{***********************************
*
* Set enabled state of edit fields
* according profile type
*
* @param aEnabled
*
***********************************}
Procedure tProfileFrm.SetEnabledState(aEnabled: Boolean);
Begin
  if aEnabled then begin
    NameCmb.Enabled := true;
    if AccessCmb.ItemIndex = 0 then begin
      UserEdit.Enabled := false;
      PassEdit.Enabled := false;
    end else begin
      UserEdit.Enabled := true;
      PassEdit.Enabled := true;
    end;
    RepoEdit.Enabled := true;
    AccessCmb.Enabled := true;
  end else begin
    NameCmb.Enabled := false;
    UserEdit.Enabled := false;
    PassEdit.Enabled := false;
    RepoEdit.Enabled := false;
    AccessCmb.Enabled := false;
  end;
End;

{***********************************
*
* close window
*
* @param Sender has called method
*
***********************************}
Procedure tProfileFrm.CloseClick (Sender: TObject);
Begin
  close;
End;

{***********************************
*
* Load profile
*
* @param Sender has called method
*
***********************************}
Procedure tProfileFrm.LoadProfile;
var
  sProfile: String;
  i: Integer;
Begin
  bInitial := true;           // to prevent refresh during loading
  if ourProfiles = nil then ourProfiles := TStringList.Create;
  AccessCmb.clear;
  AccessCmb.items.add(langProfilelocal);
  AccessCmb.items.add(langProfilePServer);
  sProfile := ChangeFileExt(Paramstr(0),'.prf');
  if FileExists(sProfile) then begin
    ourProfiles.LoadFromFile(sProfile);
    if ourProfiles.count > 0 then begin
      for i:= 0 to ourProfiles.count-1 do begin
        TokenInit(ourProfiles.Strings[i],'|',true);
        NameCmb.Items.Add(Token(1));
        if i = 0 then begin
          UserEdit.Text := Token(2);
          PassEdit.Text := DecodeString(Token(3));
          RepoEdit.Text := Token(4);
          if Token(5) = 'L' then
            AccessCmb.ItemIndex := 0
          else
            AccessCmb.ItemIndex := 1;
        end;
      end;
      NameCmb.ItemIndex := 0;
    end;
  end;
  SetEnabledState(NameCmb.Items.Count > 0);
  bInitial := false;
End;

{***********************************
*
* OnClose event procedure
*
* @param Sender has called method
*
***********************************}
Procedure TprofileFrm.profileFrmOnClose (Sender: TObject;
  Var Action: TCloseAction);
var
  sProfile: String;
Begin
  sProfile := ChangeFileExt(Paramstr(0),'.prf');
  ourProfiles.SaveToFile(sProfile);
End;

{***********************************
*
* New Profile event procedure
*
* @param Sender has called method
*
***********************************}
Procedure tProfileFrm.NewBtnOnClick (Sender: TObject);
Begin
  myAddProfileEntry;
  NameCmb.items.add(langProfileUntitled);
  SetEnabledState(true);
  NameCmb.ItemIndex := NameCmb.Items.Count-1;
End;

{***********************************
*
* Delete selected profile event procedure
*
* @param Sender has called method
*
***********************************}
Procedure tProfileFrm.DelBtnOnClick (Sender: TObject);
Begin
  myDelProfileEntry;
  NameCmb.ItemIndex := NameCmb.Items.Count-1;
  SetEnabledState(NameCmb.Items.Count > 0);
End;

{***********************************
*
* profile name combobox key detected
*
* @param Sender has called method
*
***********************************}
Procedure TprofileFrm.NameCmbOnScan (Sender: TObject; Var KeyCode: TKeyCode);
Begin
  if (KeyCode = kbBkSp) or (KeyCode = kbDel) then bTyped := true;
End;

{***********************************
*
* profile name combobox key pressed
*
* @param Sender has called method
*
***********************************}
Procedure TprofileFrm.NameCmbOnKeyPress (Sender: TObject; Var key: Char);
Begin
  bTyped := true;
End;

{***********************************
*
* profile name combobox changed
*
* @param Sender has called method
*
***********************************}
Procedure tProfileFrm.myNameChanged (Sender: TObject);
Begin
  NameCmb.Items.Strings[NameCmb.ItemIndex] := NameCmb.text;
  if bTyped then myRefreshProfileEntry;
  bTyped := false;
End;

{***********************************
*
* profile user editfield changed
*
* @param Sender has called method
*
***********************************}
Procedure TprofileFrm.UserEditOnChange (Sender: TObject);
Begin
  myRefreshProfileEntry;
End;

{***********************************
*
* profile password editfield changed
*
* @param Sender has called method
*
***********************************}
Procedure TprofileFrm.PassEditOnChange (Sender: TObject);
Begin
  myRefreshProfileEntry;
End;

{***********************************
*
* profile repository editfield changed
*
* @param Sender has called method
*
***********************************}
Procedure TprofileFrm.RepoEditOnChange (Sender: TObject);
Begin
  myRefreshProfileEntry;
End;

{***********************************
*
* profile type combobox changed
*
* @param Sender has called method
*
***********************************}
Procedure TprofileFrm.AccessCmbOnItemSelect (Sender: TObject; Index: LongInt);
Begin
  SetEnabledState(NameCmb.Items.Count > 0);
  myRefreshProfileEntry;
End;

{***********************************
*
* profile name item selected
*
* @param Sender has called method
*
***********************************}
Procedure TprofileFrm.NameCmbOnItemSelect (Sender: TObject; Index: LongInt);
Begin
  TokenInit(ourProfiles.Strings[NameCmb.ItemIndex],'|',true);
  UserEdit.Text := Token(2);
  PassEdit.Text := DecodeString(Token(3));
  RepoEdit.Text := Token(4);
  if Token(5) = 'L' then
    AccessCmb.ItemIndex := 0
  else
    AccessCmb.ItemIndex := 1;
End;

{***********************************
*
* add profile entry to profile list
*
***********************************}
Procedure tProfileFrm.myAddProfileEntry;
var
  sAccess: String;
begin
  if AccessCmb.ItemIndex = 0 then sAccess := 'L'
  else sAccess := 'P';
  ourProfiles.Add(NameCmb.Text+'|'+UserEdit.Text+'|'+CodeString(PassEdit.Text)+'|'
                 +RepoEdit.Text+'|'+sAccess);
end;

{***********************************
*
* refresh profile entry in profile list
*
***********************************}
Procedure tProfileFrm.myRefreshProfileEntry;
var
  sAccess: String;
begin
  if not bInitial then begin
    if AccessCmb.Text = langProfileLocal then sAccess := 'L'
    else sAccess := 'P';
    if NameCmb.ItemIndex = -1 then NameCmb.ItemIndex := 0;
    ourProfiles.Strings[NameCmb.ItemIndex] := NameCmb.Text+'|'+UserEdit.Text+'|'+
      CodeString(PassEdit.Text)+'|'+RepoEdit.Text+'|'+sAccess;
  end;
  if AccessCmb.Text = langProfileLocal then
    CVSRootContentLbl.Caption := ':'+AccessCmb.Text+':'+RepoEdit.Text
  else
    CVSRootContentLbl.Caption := ':'+AccessCmb.Text+':'+UserEdit.Text
      +':<password>@'+RepoEdit.Text;
end;

{***********************************
*
* del profile entry from profile list
*
***********************************}
Procedure tProfileFrm.myDelProfileEntry;
begin
  ourProfiles.Delete(NameCmb.ItemIndex);
  NameCmb.Items.Delete(NameCmb.ItemIndex);
end;

{***********************************
*
* Get CVSProfiles StringList
*
***********************************}
Function GetCVSProfiles: TStringList;
var
  sProfile: String;
Begin
  if ourProfiles = nil then begin
    ourProfiles := TStringList.Create;
    sProfile := ChangeFileExt(Paramstr(0),'.prf');
    if FileExists(sProfile) then begin
      ourProfiles.LoadFromFile(sProfile);
    end;
  end;
  RESULT := ourProfiles;
end;

Initialization
  RegisterClasses ([tProfileFrm,
    TSpeedButton, TTabbedNotebook, TPanel, TEdit, TLabel, TComboBox, TButton,
    TSpinEdit, tEditFileName, TCheckBox]);
End.
