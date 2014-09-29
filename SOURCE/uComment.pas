{***********************************
 uComment.pas
 unit for commit comments
 -----------------------------------
 begin  : Jul 15 2006
 author : Thomas Bohn
 eMail  : Thomas@Bohn-Stralsund.de
 -----------------------------------
 This document and the included
 information are released under
 GPL.
***********************************}
Unit uComment;

Interface

Uses
  Classes, Forms, Graphics, StdCtrls, Buttons, ExtCtrls, Dialogs,
  SysUtils, uString;

Type
  TmyCommentFrm = Class (TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    myCommentMemo: TMemo;
    myCommentComboBox: TComboBox;
    myOkBtn: TButton;
    myCancelBtn: TButton;
    Procedure myCancelBtnOnClick (Sender: TObject);
    Procedure myCommentComboBoxOnItemSelect (Sender: TObject; Index: LongInt);
    Procedure myCommentFrmOnShow (Sender: TObject);
    Procedure myOkBtnOnClick (Sender: TObject);
  Private
    myComment: String;
  Public
    property Comment: String read myComment;
  End;

Var
  myCommentFrm: TmyCommentFrm;

Implementation

uses uCVS, uMain, uStrings;

{***********************************
* select item in saved comment list
*
* @param Sender has called method
* @param Index
***********************************}
Procedure TmyCommentFrm.myCommentComboBoxOnItemSelect (Sender: TObject;
  Index: LongInt);
Begin
  myCommentMemo.Lines.Text := myCommentCombobox.Text;
End;

{***********************************
* formshow
*
* @param Sender has called method
***********************************}
Procedure TmyCommentFrm.myCommentFrmOnShow (Sender: TObject);
Begin
  myCommentMemo.Clear;
End;

{***********************************
* commit button clicked
*
* @param Sender has called method
***********************************}
Procedure TmyCommentFrm.myOkBtnOnClick (Sender: TObject);
var
  oCVS: myCVS;
  bRet: Boolean;
  oSelectedList: TStringList;
Begin
  myComment := myCommentMemo.Lines.Text;
  while pos(#13#10,myComment) <> 0 do
    myComment := ReplaceStr(myComment,#13#10,' ');
  myComment := trim(myComment);
  if myComment = '' then myComment := langNoComment;
  if myCommentCombobox.Items.IndexOf(myComment) = -1 then
    myCommentCombobox.Items.Insert(0,myComment);
  oCVS := myCVS.Create;
  oSelectedList := myOS2CVSFrm.getFileList('CVS');
  bRet := oCVS.CallCVSFunction('Commit', myOS2CVSFrm.myProjectOutLn.SelectedNode.FullPath,
                '',  myOS2CVSFrm.getFileListString('CVS'), '', '', myCommentFrm.Comment );
  if oCVS.CVSLog.count > 0 then begin
    myOS2CVSFrm.myLogListBox.Items.Add('');
    myOS2CVSFrm.myLogListBox.Items.AddStrings(oCVS.CVSLog);
    myOS2CVSFrm.myLogListBox.ItemIndex := myOS2CVSFrm.myLogListBox.Items.count-1;
  end;
  oCVS.free;
End;

{***********************************
* cancel button clicked
*
* @param Sender has called method
***********************************}
Procedure TmyCommentFrm.myCancelBtnOnClick (Sender: TObject);
Begin
  close;
End;

Initialization
  RegisterClasses ([TmyCommentFrm, TPanel, TMemo, TComboBox, TButton]);
End.
