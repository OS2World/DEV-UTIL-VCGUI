{***********************************
 uSettings.pas
 Unit for loadings and saving
 settings.
 -----------------------------------
 begin  : Jun 12 2005
 author : Thomas Bohn
 eMail  : Thomas@Bohn-Stralsund.de
 -----------------------------------
 This document and the included
 information are released under
 GPL.
***********************************}
Unit uSettings;

Interface

uses Classes, SysUtils, Forms, Messages, IniFiles, Outline, uString,
     uSysInfo, uMain, uComment;

Type

  mySettings = class
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
    Procedure LoadProgramSettings;
    Procedure LoadProjectSettings;
    Procedure SaveProgramSettings;
    Procedure SaveProjectSettings(aOutLine: TOutline);
  End;

Implementation

uses uProfile;

{***********************************
*
* load program settings
*
***********************************}
Procedure mySettings.LoadProgramSettings;
var
  myIniFile: TAsciiIniFile;
  tmpIni: String;
  nInterval: longint;
  sOS2Dir: String;
begin
  sOS2Dir := ExtractFilePath(goSysInfo.UserINI);
  tmpIni := ChangeFileExt(Paramstr(0),'.cfg');
  myIniFile := TAsciiInifile.Create(tmpIni);
  myOS2CVSfrm.myRefreshTimer.Stop;
  profileFrm.myCVSEditFileName.Filename := myIniFile.ReadString('CVS','EXEPath', ExtractFilePath(paramstr(0))+'cvs.exe');
  profileFrm.myCheckoutROChb.Checked := myIniFile.ReadBool('CVS','ReadOnly', false );
  profileFrm.myViewerEditFileName.Filename := myIniFile.ReadString('Global','ViewerPath', sOS2Dir + 'e.exe');
  profileFrm.myEditorEditFileName.Filename := myIniFile.ReadString('Global','EditorPath', sOS2Dir + 'e.exe');
  profileFrm.myDiffEditFileName.Filename := myIniFile.ReadString('Global','DiffPath', 'pmdiff.exe');
  profilefrm.myRefreshChb.Checked := myIniFile.ReadBool('Global', 'RefreshActive', true);
  nInterval := myIniFile.ReadInteger('Global', 'RefreshTime', 15000);
  if nInterval < 2000 then nInterval := 10000;
  myOS2CVSfrm.myRefreshTimer.Interval := nInterval;
  if profileFrm.myRefreshChb.Checked then
    myOS2CVSfrm.myRefreshTimer.Start;
  myIniFile.Free;
end;

{***********************************
*
* save program settings
*
***********************************}
Procedure mySettings.SaveProgramSettings;
var
  myIniFile: TAsciiIniFile;
  tmpIni: String;
begin
  tmpIni := ChangeFileExt(Paramstr(0),'.cfg');
  myIniFile := TAsciiInifile.Create(tmpIni);
  myIniFile.WriteString('CVS','EXEPath', profileFrm.myCVSEditFileName.Filename);
  myIniFile.WriteBool('CVS','ReadOnly', profileFrm.myCheckoutROChb.Checked);
  myIniFile.WriteString('Global','ViewerPath', profileFrm.myViewerEditFileName.Filename);
  myIniFile.WriteString('Global','EditorPath', profileFrm.myEditorEditFileName.Filename);
  myIniFile.WriteString('Global','DiffPath', profileFrm.myDiffEditFileName.Filename);
  myIniFile.WriteBool('Global', 'RefreshActive', profileFrm.myRefreshChb.Checked );
  myIniFile.WriteInteger('Global', 'RefreshTime', myOS2CVSfrm.myRefreshTimer.Interval);
  myIniFile.Free;
end;

{***********************************
*
* load project settings
*
***********************************}
Procedure mySettings.LoadProjectSettings;
var
  tmpPrj, tmpCcm: String;
  tmpInd: Integer;
  tmpList: TStringList;
begin
  // load project tree
  myOS2CVSfrm.myProjectOutLn.clear;
  tmpPrj := ChangeFileExt(Paramstr(0),'.prj');
  tmpList := TStringList.Create;
  if FileExists(tmpPrj) then begin
    tmpList.LoadFromFile(tmpPrj);
    if tmpList.Count > 0 then begin
      for tmpInd := 1 to tmpList.Count do
        myOS2CVSfrm.AddFolderToProjects(tmpList.Strings[tmpInd-1],false);
    end;
  end;
  // load commit comments
  tmpCcm := ChangeFileExt(Paramstr(0),'.ccm');
  if FileExists(tmpCcm) then begin
    myCommentFrm.myCommentComboBox.Items.LoadFromFile(tmpCcm);
  end;
end;

{***********************************
*
* save project settings
*
***********************************}
Procedure mySettings.SaveProjectSettings(aOutLine: TOutline);
var
  tmpPrj, tmpCcm: String;
  tmpInd: Integer;
  tmpList: TStringList;
begin
  // save project tree
  tmpPrj := ChangeFileExt(Paramstr(0),'.prj');
  tmpList := TStringList.Create;
  for tmpInd := 1 to aOutLine.ItemCount do
    if aOutLine.Items[tmpInd].Level = 1 then
      tmpList.Add(aOutLine.Items[tmpInd].Text);
  tmpList.SaveToFile(tmpPrj);
  // save commit comments
  tmpCcm := ChangeFileExt(Paramstr(0),'.ccm');
  myCommentFrm.myCommentComboBox.Items.SaveToFile(tmpCcm);
end;

Initialization

End.
