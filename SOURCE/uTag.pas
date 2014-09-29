Unit uTag;

Interface

Uses
  Classes, Forms, Graphics, ExtCtrls, Buttons, StdCtrls, uString;

Type
  TmyTagBranchFrm = Class (TForm)
    myTypeRadioGroup: TRadioGroup;
    Panel1: TPanel;
    myOKBtn: TButton;
    myCancelBtn: TButton;
    myName: TEdit;
    myTagLabel: TLabel;
    myCommonGroupBox: TGroupBox;
    myNoRecurseChb: TCheckBox;
    Procedure myTagBranchFrmOnShow (Sender: TObject);
    Procedure myOKBtnOnClick (Sender: TObject);
    Procedure myCancelBtnOnClick (Sender: TObject);
  Private
    {Private Deklarationen hier einfgen}
  Public
    {™ffentliche Deklarationen hier einfgen}
  End;

Var
  myTagBranchFrm: TmyTagBranchFrm;

Implementation

uses uCVS, uMain;

{***********************************
* formshow
*
* @param Sender has called method
***********************************}
Procedure TmyTagBranchFrm.myTagBranchFrmOnShow (Sender: TObject);
Begin
  myName.Text := '';
  myTypeRadioGroup.ItemIndex := 0;
End;

{***********************************
* create button clicked
*
* @param Sender has called method
***********************************}
Procedure TmyTagBranchFrm.myOKBtnOnClick (Sender: TObject);
var
  oCVS: myCVS;
  bRet: Boolean;
  oSelectedList: TStringList;
  sAddPar: String;
Begin
  oCVS := myCVS.Create;
  oSelectedList := myOS2CVSFrm.getFileList('CVS');
  sAddPar := '';
  if myNoRecurseChb.checked then
    sAddPar := sAddPar + ' -l';
  case myTypeRadioGroup.ItemIndex of
    0:   bRet := oCVS.CallCVSFunction('CreateTag', myOS2CVSFrm.myProjectOutLn.SelectedNode.FullPath,
                '', myOS2CVSFrm.getFileListString('CVS'), sAddPar, '', myName.Text );
    1:   bRet := oCVS.CallCVSFunction('CreateBranch', myOS2CVSFrm.myProjectOutLn.SelectedNode.FullPath,
                '', myOS2CVSFrm.getFileListString('CVS'), sAddPar, '', myName.Text );
  end;
  if oCVS.CVSLog.count > 0 then begin
    myOS2CVSFrm.myLogListBox.Items.Add('');
    myOS2CVSFrm.myLogListBox.Items.AddStrings(oCVS.CVSLog);
    myOS2CVSFrm.myLogListBox.ItemIndex := myOS2CVSFrm.myLogListBox.Items.count-1;
  end;
  oCVS.free;
  close;
End;

{***********************************
* cancel button clicked
*
* @param Sender has called method
***********************************}
Procedure TmyTagBranchFrm.myCancelBtnOnClick (Sender: TObject);
Begin
  close;
End;

Initialization
  RegisterClasses ([TmyTagBranchFrm, TRadioGroup, TPanel, TButton, TEdit, TLabel,
    TGroupBox, TCheckBox]);
End.
