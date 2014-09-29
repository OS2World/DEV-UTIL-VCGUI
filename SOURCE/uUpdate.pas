{***********************************
 uUpdate.pas
 unit for update
 -----------------------------------
 begin  : Jul 29 2006
 author : Thomas Bohn
 eMail  : Thomas@Bohn-Stralsund.de
 -----------------------------------
 This document and the included
 information are released under
 GPL.
***********************************}
Unit uUpdate;

Interface

Uses
  Classes, Forms, Graphics, ExtCtrls, Buttons, StdCtrls, SysUtils, uString,
  Dialogs, uCVS, Calendar;

Type
  TupdateFrm = Class (TForm)
    Panel1: TPanel;
    myOkBtn: TButton;
    myCancelBtn: TButton;
    myCommonGroup: TGroupBox;
    myPruneChb: TCheckBox;
    myCleanCopyChb: TCheckBox;
    myNoRecurseChb: TCheckBox;
    myChangeGroupBox: TGroupBox;
    myRevLbl1: TLabel;
    myHeadChb: TCheckBox;
    myRevCmb: TComboBox;
    myGetTagsBtn: TButton;
    myMergeGroupBox: TGroupBox;
    myMergeRevCmb: TComboBox;
    myMergeBranchLabel: TLabel;
    myMergeGetTagsBtn: TButton;
    myDayLbl: TLabel;
    myMonthLbl: TLabel;
    myYearLbl: TLabel;
    myHourLbl: TLabel;
    myMinLbl: TLabel;
    myEditDate: tEditDate;
    myHourCmb: TComboBox;
    myMinCmb: TComboBox;
    myUseDateTime: TCheckBox;
    myCreateDirChb: TCheckBox;
    Function myGetTagsBranches: TStringList;
    Procedure myMergeGetTagsBtnOnClick (Sender: TObject);
    Procedure myGetTagsBtnOnClick (Sender: TObject);
    Procedure updateFrmOnShow (Sender: TObject);
    Procedure myOkBtnOnClick (Sender: TObject);
    Procedure myCancelBtnOnClick (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  End;

Var
  updateFrm: TupdateFrm;

Implementation

uses uMain, uProfile;

{***********************************
* get tags / branches list
*
* @return TStringList
***********************************}
Function TupdateFrm.myGetTagsBranches: TStringList;
var
  oCVS: myCVS;
  oLogList: TStringList;
  nInd: Integer;
  bRead : Boolean;
  sTag: String;
Begin
  oLogList := TStringList.create;
  RESULT := TStringList.create;
  oCVS:= myCVS.create;
  oLogList := oCVS.GetTagList(myNoRecurseChb.checked);
  oCVS.free;
  bRead := false;
  for nInd := 0 to oLogList.count-1 do begin
   if (pos('keyword substitution:',oLogList.Strings[nInd]) <> 0) or
       (pos('total revisions:',oLogList.Strings[nInd]) <> 0) or
       (pos('===================',oLogList.Strings[nInd]) <> 0) then begin
      bRead := false;
    end;
    sTag := trim(oLogList.Strings[nInd]);
    sTag := copy(sTag,1,pos(':',sTag)-1);
    if (bRead) and (RESULT.IndexOf(sTag)=-1) then
      RESULT.Add(sTag);
    if (pos('keyword substitution:',oLogList.Strings[nInd]) <> 0) or
       (pos('total revisions:',oLogList.Strings[nInd]) <> 0) or
       (pos('===================',oLogList.Strings[nInd]) <> 0) then begin
      bRead := false;
    end;
    if pos('symbolic names:',oLogList.Strings[nInd]) <> 0 then begin
      bRead := true;
    end;
  end;
End;

{***********************************
* get tags / branches list for
* change to combobox
*
* @param Sender has called method
***********************************}
Procedure TupdateFrm.myGetTagsBtnOnClick (Sender: TObject);
var
  oTagList: TStringList;
Begin
  Cursor := crHourGlass;
  myRevCmb.clear;
  oTagList := TStringList.create;
  oTagList := myGetTagsBranches;
  if oTagList.count > 0 then begin
    myRevCmb.Items.AddStrings(oTagList);
  end;
  Cursor := crDefault;
End;

{***********************************
* get tags / branches list for
* merge combobox
*
* @param Sender has called method
***********************************}
Procedure TupdateFrm.myMergeGetTagsBtnOnClick (Sender: TObject);
var
  oTagList: TStringList;
Begin
  Cursor := crHourGlass;
  myMergeRevCmb.clear;
  oTagList := TStringList.create;
  oTagList := myGetTagsBranches;
  if oTagList.count > 0 then begin
    myMergeRevCmb.Items.AddStrings(oTagList);
  end;
  Cursor := crDefault;
End;

{***********************************
* formshow
*
* @param Sender has called method
***********************************}
Procedure TupdateFrm.updateFrmOnShow (Sender: TObject);
Begin
  myHeadChb.checked := false;
  myRevCmb.Text := '';
  myUseDateTime.Checked := false;
End;

{***********************************
* update button clicked
*
* @param Sender has called method
***********************************}
Procedure TupdateFrm.myOkBtnOnClick (Sender: TObject);
var
  oCVS: myCVS;
  bRet: Boolean;
  oSelectedList: TStringList;
  sAddPar, sFuncPar: String;
  sUpdateFunc: String;
  bRefreshTree: Boolean;
  sDateTime: String;
  nDate, nTime: Extended;
Begin
  Cursor := crHourGlass;
  oCVS := myCVS.Create;
  oSelectedList := myOS2CVSFrm.getFileList('CVS');
  bRefreshTree := (oSelectedList.Count = 0) and (myPruneChb.checked);
  sAddPar := '';
  sFuncPar := '';
  if profileFrm.myCheckoutROChb.checked then
    sAddpar := sAddpar + '-r';
  if myNoRecurseChb.checked then
    sAddPar := sAddPar + ' -l';
  if myPruneChb.checked then
    sFuncPar := sFuncPar + '-P';
  if myCreateDirChb.checked then
    sFuncPar := sFuncPar + ' -d';

  if myHeadChb.checked then
    sFuncPar := sFuncPar + ' -A'
  else
    if myRevCmb.Text <> '' then          // change to rev/tag/branch
      sFuncPar := sFuncPar + ' -r "' + myRevCmb.Text + '"'
    else
      if myUseDateTime.Checked then begin     // change to datetime
        nDate := myEditDate.Date;
        sDateTime := FormatDateTime('yyyy-mm-dd',nDate);
        if myHourCmb.Text <> '' then begin
          sDateTime := sDateTime + ' ' + myHourCmb.Text;   // hours
          if myMinCmb.Text <> '' then
            sDateTime := sDateTime + ':' + myMinCmb.Text;  // min
          sDateTime := sDateTime + ':00';   // sec
        end;
        sFuncPar := sFuncPar + ' -D "' + sDateTime + '"'
      end else
        if myMergeRevCmb.Text <> '' then      // merge branch
          sFuncPar := sFuncPar + ' -j "' + myMergeRevCmb.Text + '"';
  if myCleanCopyChb.checked then
    sUpdateFunc := 'UpdateReplace'
  else
    sUpdateFunc := 'UpdatePatch';
  bRet := oCVS.CallCVSFunction(sUpdateFunc, myOS2CVSFrm.myProjectOutLn.SelectedNode.FullPath,
                            '',  myOS2CVSFrm.getFileListString('CVS'), sAddPar, sFuncPar, '' );
  if oCVS.CVSLog.count > 0 then begin
    myOS2CVSFrm.myLogListBox.Items.AddStrings(oCVS.CVSLog);
    myOS2CVSFrm.myLogListBox.ItemIndex := myOS2CVSFrm.myLogListBox.Items.count-1;
  end;
  oCVS.free;
  Cursor := crDefault;
  close;
  if bRefreshTree then
    myOS2CVSfrm.refreshMenuItemOnClick(self);
End;

{***********************************
* cancel button clicked
*
* @param Sender has called method
***********************************}
Procedure TupdateFrm.myCancelBtnOnClick (Sender: TObject);
Begin
  close;
End;

Initialization
  RegisterClasses ([TupdateFrm, TPanel, TButton,
    TGroupBox, TCheckBox, TLabel, TComboBox, tEditDate]);
End.
