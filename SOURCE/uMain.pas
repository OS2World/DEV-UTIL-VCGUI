{***********************************
 uMain.pas
 Main Unit of program OS2VC
 -----------------------------------
 begin  : Jun 12 2005
 author : Thomas Bohn
 eMail  : Thomas@Bohn-Stralsund.de
 -----------------------------------
 This document and the included
 information are released under
 GPL.
***********************************}
Unit uMain;

Interface

Uses
  Classes, Forms, Graphics, Menus, Buttons, StdCtrls, ExtCtrls, ComCtrls,
  DirOutLn, OutLine, TabCtrls, ListView, DOS,
  uString, Grids, Dialogs, SysUtils, FileCtrl, Inifiles, uTools, GlyphBtn,
  XplorBtn;

Type

  TmyOS2CVSfrm = Class (TForm)
    myMainMnu: TMainMenu;
    myProjectMenu: TMenuItem;
    myCVSMenu: TMenuItem;
    myOptionsMenu: TMenuItem;
    myMainToolbar: TToolbar;
    myChangeDirDialog: TChangeDirDialog;
    myPopupMenuPrj: TPopupMenu;
    myExpandMenuItem: TMenuItem;
    myCollapseMenuItem: TMenuItem;
    myRefreshTimer: TTimer;
    myEditTbt: TExplorerButton;
    myUneditTbt: TExplorerButton;
    myBevelTbt3: TBevel;
    myAddAsciiTbt: TExplorerButton;
    myAddBinTbt: TExplorerButton;
    myAddFolderTbt: TExplorerButton;
    myHistoryTbt: TExplorerButton;
    myDiffTbt: TExplorerButton;
    myBevelTbt1: TBevel;
    myBevelTbt2: TBevel;
    myUpdateTbt: TExplorerButton;
    myCommitTbt: TExplorerButton;
    myCVSUpdatePrj: TMenuItem;
    myCVSCommitPrj: TMenuItem;
    MenuItem15: TMenuItem;
    myCVSEditPrj: TMenuItem;
    myCVSUneditPrj: TMenuItem;
    myDeleteLocalFile: TMenuItem;
    myCVSDeleteBothFile: TMenuItem;
    MenuItem13: TMenuItem;
    myCVSUpdateFile: TMenuItem;
    MenuItem8: TMenuItem;
    myCVSCommitFile: TMenuItem;
    myCVSDiffFile: TMenuItem;
    MenuItem12: TMenuItem;
    myCVSEditFile: TMenuItem;
    myCVSUneditFile: TMenuItem;
    myCVSHistoryFile: TMenuItem;
    myNonCVSFilesAddSubMenu: TMenuItem;
    myAddAsciiFiles: TMenuItem;
    myAddBinaryFiles: TMenuItem;
    myPrjPanel: TPanel;
    myStatusBar: TStatusBar;
    myFilesPanel: TPanel;
    myLogPanel: TPanel;
    myPrjSizeBorder: TSizeBorder;
    myLogSizeBorder: TSizeBorder;
    myProjectOutln: TOutline;
    myFilesNotebook: TTabbedNotebook;
    myLogListBox: TListBox;
    myCVSCreateTagBranchFile: TMenuItem;
    myCreateTagBranchPrj: TMenuItem;
    myCVSCreateTagBranch: TMenuItem;
    myPrjCVSSubmenu: TMenuItem;
    myProjectCVSImport: TMenuItem;
    myProjectCVSCheckout: TMenuItem;
    myProjectCVSRepo: TMenuItem;
    MenuItem3: TMenuItem;
    myStartTimer: TTimer;
    myCVSList: tMultiColumnList;
    myNonCVSList: tMultiColumnList;
    myAddDirectoryPrj: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem7: TMenuItem;
    myPopupMenuCVS: TPopupMenu;
    myCVSFileView: TMenuItem;
    myCVSFileEdit: TMenuItem;
    myPopupMenuNonCVS: TPopupMenu;
    myNonCVSFileView: TMenuItem;
    myNonCVSFileEdit: TMenuItem;
    myHelpAbout: TMenuItem;
    myHelpMenu: TMenuItem;
    myPopupMenuLog: TPopupMenu;
    myClearMenuItem: TMenuItem;
    myRefreshMenuItem: TMenuItem;
    myCVSHistory: TMenuItem;
    myCVSDiff: TMenuItem;
    myCVSUpdate: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    myCVSCommit: TMenuItem;
    MenuItem4: TMenuItem;
    myCVSEdit: TMenuItem;
    myCVSUnEdit: TMenuItem;
    MenuItem5: TMenuItem;
    myProjectQuit: TMenuItem;
    myProjectRemoveItem: TMenuItem;
    MenuItem6: TMenuItem;
    myDeleteSubmenu: TMenuItem;
    myDeleteBoth: TMenuItem;
    myDeleteLocal: TMenuItem;
    myCVSaddSubMenu: TMenuItem;
    myAddAscii: TMenuItem;
    myAddBinary: TMenuItem;
    myAddDirectory: TMenuItem;
    myOptSettings: TMenuItem;
    myProjectAddMnuItem: TMenuItem;
    Procedure myCVSCreateTagBranchOnClick (Sender: TObject);
    Procedure myProjectCVSRepoOnClick (Sender: TObject);
    Procedure myStartTimerOnTimer (Sender: TObject);
    Procedure myLogSizeBorderOnSized (Sender: TObject; Var SizeDelta: LongInt);
    Procedure myHelpAboutOnClick (Sender: TObject);
    Procedure myFileEditOnClick (Sender: TObject);
    Procedure myFileViewOnClick (Sender: TObject);
    Procedure myAddFilesOnClick (Sender: TObject);
    Procedure myProjectCVSImportOnClick (Sender: TObject);
    Procedure myClearMenuItemOnClick (Sender: TObject);
    Procedure myDeleteBothOnClick (Sender: TObject);
    Procedure myDeleteLocalOnClick (Sender: TObject);
    Procedure myAddDirectoryOnClick (Sender: TObject);
    Procedure myCVSUnEditOnClick (Sender: TObject);
    Procedure myCVSEditOnClick (Sender: TObject);
    Procedure myCVSUpdateOnClick (Sender: TObject);
    Procedure refreshMenuItemOnClick (Sender: TObject);
    Procedure myProjectCVSCheckoutOnClick (Sender: TObject);
    Procedure myCVSListOnItemFocus (Sender: TObject; Index: LongInt);
    Procedure myNonCVSListOnItemFocus (Sender: TObject; Index: LongInt);
    Procedure myCVSHistoryOnClick (Sender: TObject);
    Procedure myCVSDiffOnClick (Sender: TObject);
    Procedure myFilesNotebookOnPageChanged (Sender: TObject);
    Procedure myCVSCommitOnClick (Sender: TObject);
    Procedure refreshLists(aType, aFolder: String; aFileList: TStringList; aShow, aRecursive: Boolean);
    Procedure refreshContrDir(aType, aFolder: String; aFileList: TStringList; aShow: Boolean);
    Procedure refreshNotContrDir(aType, aFolder: String);
    Procedure myProjectRemoveItemOnClick (Sender: TObject);
    Procedure myProjectQuitOnClick (Sender: TObject);
    Procedure myRefreshTimerOnTimer (Sender: TObject);
    Function getFileList(aList: String): TStringlist;
    Function getFileListString(aList: String): String;
    Function getFileRevision: String;
    Procedure myOS2CVSfrmOnClose (Sender: TObject; Var Action: TCloseAction);
    Procedure projectCollapse (Sender: TObject);
    Procedure projectExpand (Sender: TObject);
    Procedure myPrjSizeBorderOnSized (Sender: TObject; Var SizeDelta: LongInt);
    Procedure myOS2CVSfrmOnShow (Sender: TObject);
    Procedure myProjectOutlnOnClick (Sender: TObject);
    Procedure myProjectAddMnuItemOnClick (Sender: TObject);
    Procedure AddFolderToProjects( aFolder: String; aSave: Boolean );
    Procedure myOptSettingsOnClick (Sender: TObject);
    Procedure refreshEnabledState;
  Private
    bStarted: Boolean;
  Public
    {™ffentliche Deklarationen hier einfgen}
  End;

Var
  myOS2CVSfrm: TmyOS2CVSfrm;

Implementation

uses uCVS, uStrings, uSettings, uProfile, uExecQueue, uHistory, uCheckout,
     uUpdate, uComment, uImport, uTag, uAbout;

{***********************************
* clear log listbox
*
* @param Sender called method
***********************************}
Procedure TmyOS2CVSfrm.myClearMenuItemOnClick (Sender: TObject);
Begin
  myLogListbox.clear;
End;

{***********************************
* refresh project folder tree
*
* @param Sender called method
***********************************}
Procedure TmyOS2CVSfrm.refreshMenuItemOnClick (Sender: TObject);
var
  lSettings: mySettings;
  nInd, nIndex: Integer;
  oItemExpList: TStringList;
begin
  myOS2CVSFrm.Cursor := crHourGlass;
  oItemExpList := TStringList.Create;
  oItemExpList.Add(inttostr(myProjectOutLn.SelectedNode.Index));
  myProjectOutLn.BeginUpdate;
  while myProjectOutLn.SelectedNode.Parent.Index > 0 do begin
    nIndex := myProjectOutLn.SelectedNode.Parent.Index;
    myProjectOutLn.SelectedNode := myProjectOutLn.Items[nIndex];
    oItemExpList.Add(inttostr(myProjectOutLn.SelectedNode.Index));
  end;
  lSettings := mySettings.create;
  lSettings.LoadProjectSettings;
  lSettings.free;
  for nInd := oItemExpList.count-1 downto 0 do begin
    nIndex := strtoint(oItemExpList.Strings[nInd]);
    if nIndex <= myProjectOutLn.ItemCount then
      myProjectOutLn.Items[nIndex].Expand;
    if nInd = 0 then
      myProjectOutLn.SelectedNode := myProjectOutLn.Items[nIndex];
  end;
  myProjectOutLn.EndUpdate;
  oItemExpList.Free;
  myOS2CVSFrm.Cursor := crDefault;
End;

{***********************************
* collapse project folder tree
*
* @param Sender called method
***********************************}
Procedure TmyOS2CVSfrm.projectCollapse (Sender: TObject);
Begin
  myProjectoutLn.FullCollapse;
End;

{***********************************
* expand project folder tree
*
* @param Sender called method
***********************************}
Procedure TmyOS2CVSfrm.projectExpand (Sender: TObject);
Begin
  myProjectOutLn.FullExpand;
End;

{***********************************
* start time event, only for code
* executed after main form is shown
* (formpaint doesn't work correct)
*
* @param Sender called method
***********************************}
Procedure TmyOS2CVSfrm.myStartTimerOnTimer (Sender: TObject);
var
  lSettings: mySettings;
Begin
  if not bStarted then begin
    bStarted := true;
    myOS2CVSFrm.Cursor := crHourGlass;
    myStatusbar.Panels[1].Text := langLoadProgSettings;
    Application.ProcessMessages;
    lSettings := mySettings.create;
    lSettings.LoadProgramSettings;
    myStatusbar.Panels[1].Text := langLoadProjectTree;
    Application.ProcessMessages;
    lSettings.LoadProjectSettings;
    lSettings.free;
    profileFrm.LoadProfile;
    myOS2CVSFrm.Cursor := crDefault;
    myStatusbar.Panels[1].Text := '';
  end;
  myStartTimer.stop;
  myRefreshTimer.Tag := 1;      // enable refresh timer
End;

{***********************************
* Main window OnShow event procedure
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myOS2CVSfrmOnShow (Sender: TObject);
Begin
  bStarted := false;
  myStartTimer.start;
  LongTimeFormat := 'hh:mm:ss';
End;

{***********************************
* Main window OnClose event procedure
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myOS2CVSfrmOnClose (Sender: TObject; Var Action: TCloseAction);
var
  lSettings: mySettings;
begin
  myOS2CVSFrm.Cursor := crHourGlass;
  lSettings := mySettings.create;
  myStatusbar.Panels[1].Text := langSaveProjectTree;
  Application.ProcessMessages;
  lSettings.SaveProjectSettings(myProjectOutln);
  myStatusbar.Panels[1].Text := langSaveProgSettings;
  Application.ProcessMessages;
  lSettings.SaveProgramSettings;
  lSettings.Free;
  myOS2CVSFrm.Cursor := crDefault;
End;

{***********************************
* click on tree item event procedure
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myProjectOutlnOnClick (Sender: TObject);
begin
  if myProjectOutLn.SelectedNode.FullPath <> myStatusBar.Panels[0].Text then begin
    refreshLists('Full',myProjectOutLn.SelectedNode.FullPath,nil,true,false);
  end;
  refreshEnabledState;
end;

{***********************************
* select or deselect item in CVSList
*
* @param Sender has called method
* @param Index
***********************************}
Procedure TmyOS2CVSfrm.myCVSListOnItemFocus (Sender: TObject; Index: LongInt);
Begin
  refreshEnabledState;
End;

{***********************************
* select or deselect item in nonCVSList
*
* @param Sender has called method
* @param Index
***********************************}
Procedure TmyOS2CVSfrm.myNonCVSListOnItemFocus (Sender: TObject; Index: LongInt);
Begin
  refreshEnabledState;
End;

{***********************************
* cange page in notebook event procedure
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myFilesNotebookOnPageChanged (Sender: TObject);
Begin
  if myProjectOutLn.Itemcount > 0 then begin
    refreshLists('Full',myProjectOutLn.SelectedNode.FullPath,nil,true,false);
  end;
  refreshEnabledState;
End;

{***********************************
* Global refresh procedure
*
* @param aType
* @param aFolder
* @param aFileList
* @param aRecursive
***********************************}
Procedure TmyOS2CVSfrm.refreshLists(aType, aFolder: String; aFileList: TStringList; aShow, aRecursive: Boolean);
var
  SR: TSearchRec;

Begin
  if myFilesNotebook.PageIndex = 0 then begin     // controlled page
    if (aFileList = nil) and (aRecursive) and
    (myCVSList.Selcount = 0) then begin
      if (FindFirst(aFolder+'\*',faDirectory,SR)=0) then begin
        repeat
          if (SR.Name<>'.') and (SR.Name<>'..') and (SR.Name<>'.svn')
          and (SR.Name<>'CVS') and (SR.Attr=faDirectory) then begin
            refreshContrDir(aType, aFolder + '\' + SR.Name, aFileList, false);
            Application.ProcessMessages;
            refreshLists(aType, aFolder + '\' + SR.Name, nil, false, true);  // recursive
          end;
        until FindNext(SR)<>0;
      end;
      FindClose(SR);
    end;
    refreshContrDir(aType, aFolder, aFileList, aShow);
  end else begin                                  // not controlled page
    refreshNotContrDir(aType, aFolder);
  end;
end;

{***********************************
* Refresh procedure for controlled
* list
*
* @param aType
* @param aFolder
* @param aFileList
* @param aShow
***********************************}
Procedure TmyOS2CVSfrm.refreshContrDir(aType, aFolder: String; aFileList: TStringList; aShow: Boolean);
var
  nInd, nInd2: Integer;
  sLine, sLine2: String;
  sName, sName2: String;
  sFileDate: String;
  oList, oList2: TStringList;
  sRoot, sRootText: String;
  oCVS: myCVS;
  oCVSSel: TStringList;
  nIndex: Integer;
  nLCount: Integer;
  sState: String;
  sSelected: String;
  bFound: Boolean;
  sTempVal: String;
Begin
  // at first get selected files
  sSelected := getFileListString('CVS');

  // now save selected state of list
  oCVSSel := TStringList.create;
  if myCVSList.Selcount > 0 then
    for nInd:=0 to myCVSList.Items.count-1 do
      if myCVSList.Selected[nInd] then
        oCVSSel.Add(myCVSList.Values[0,nInd]);

  // now refresh file list and put filedate in CVSList
  oList := TStringList.Create;
  oCVS := myCVS.Create;
  oCVS.CreateIgnoreList(aFolder);
  oList := oCVS.UpdateCVS(aFolder);
  sRoot := oCVS.GetRoot(aFolder);
  oList2 := TStringList.Create;
  oList2 := oCVS.UpdateFiles(aFolder,false);
  for nInd2 := 0 to oList2.Count-1 do
    for nInd := 0 to oList.Count -1 do begin
      sLine  := oList.Strings[nInd];
      sName := copy(sLine,1,pos('|',sLine)-1);
      sLine2 := oList2.Strings[nInd2];
      sName2 := copy(sLine2,1,pos('|',sLine2)-1);
      if sName = sName2 then begin
        TokenInit(sLine2,'|',false);
        sFileDate := Token(2);
        oList.Strings[nInd] := oList.Strings[nInd]
         + '|' + trim(sFileDate) + '|' + Token(3);
      end;
    end;

  // hide file date/time for not modified entries
  for nInd := 0 to oList.count-1 do begin
    TokenInit(oList.Strings[nInd],'|',true);
    if Token(6) = Token(7) then begin           // not modified or absent
      oList.Strings[nInd] := Token(1) + '|' + Token(2) + '|' +
      Token(3) + '|' + Token(4) + '|';
      if (aType = 'Full') or (aType = 'Check') or (aType = 'State') then begin
        sState := Token(5);
      end else if (aType = 'Update') and ((sSelected = '') or (pos(Token(1),sSelected) <> 0)) then begin
        sState := langStateActual;
      end else begin
        if myProjectOutLn.SelectedNode.Fullpath = aFolder then
          sState := myCVSList.Values[4,nInd];
      end;
      bFound := false;
      for nInd2 := 0 to ourCVSFileList.Count-1 do begin
        if (pos(aFolder+'\'+Token(1)+'|',ourCVSFileList.Strings[nInd2]) <> 0)
        then begin
          ourCVSFileList.Strings[nInd2] := aFolder+'\'+Token(1)+'|' + sState;
          bFound := true;
          break;
        end;
      end;
      if not bFound then
        ourCVSFileList.Add(aFolder+'\'+Token(1)+'|'+sState);
      oList.Strings[nInd] := oList.Strings[nInd] + sState + '|' + Token(6) + '||' + Token(8);
    end else begin
      if Token(8) = '' then       // file is absent
        oList.Strings[nInd] := Token(1) + '|' + Token(2) + '|' +
        Token(3) + '|' + Token(4) + '|' + langStateAbsent
        + '|' + Token(6) + '|'+ Token(7) + '|' + Token(8)
      else
        if pos('RESULT OF MERGE+',uppercase(Token(6))) <> 0 then
        oList.Strings[nInd] := Token(1) + '|' + Token(2) + '|' +
        Token(3) + '|' + Token(4) + '|' + langStateConflict
        + '|' + Token(6) + '|'+ Token(7) + '|' + Token(8)
      else                        // file is modified
        oList.Strings[nInd] := Token(1) + '|' + Token(2) + '|' +
        Token(3) + '|' + Token(4) + '|' + langStateModified
        + '|' + Token(6) + '|'+ Token(7) + '|' + Token(8);
    end;
  end;

  // fill multicolumn lists if aShow is true
  if aShow then begin
    // fill CVSList and set selected state
    myCVSList.BeginUpdate;
    if (aType = 'Full') then begin          // full refresh on folder click
      myCVSList.clear;
      myCVSList.items.addstrings(oList);
    end else
    if (aType = 'Check') then begin           // timer refresh
      nInd2 := 0;
      while nInd2 <= myCVSList.count-1 do begin
        for nInd := 0 to oList.count-1 do begin
          sTempVal := oList.Strings[nInd];
          if pos(myCVSList.Values[0,nInd2]+'|',sTempVal) <> 0 then begin
            TokenInit(sTempVal,'|',true);
            myCVSList.Values[4,nInd2] := Token(5);
            myCVSList.Values[6,nInd2] := Token(7);
            myCVSList.Values[7,nInd2] := Token(8);
            oList.Delete(nInd);
            break;
          end;
        end;
        inc(nInd2);
      end;
    end else begin                             // other refresh types
      for nInd := 0 to oList.Count-1 do begin
        if (nInd > myCVSList.Count-1) then
          myCVSList.Add(oList.Strings[nInd])
        else begin
          TokenInit(oList.Strings[nInd],'|',true);
          if (aFileList <> nil) and (aFileList.count > 0) then begin
            nIndex := aFileList.IndexOf(Token(1));
            if nIndex <> -1 then nIndex := nInd;
          end else begin
            nIndex := -1;
            for nInd2 := 0 to myCVSList.count-1 do
              if myCVSList.Values[0,nInd2] = Token(1) then
                nIndex := nInd2;
          end;
          if nIndex <> -1 then begin
            for nInd2 := 0 to 7 do begin
              myCVSList.Values[nInd2,nIndex] := Token(nInd2+1);
            end;
          end else
            myCVSList.Add(oList.Strings[nInd])
        end;
      end;
      nLCount := myCVSList.count;
      while nInd < nLCount do begin     // delete obsolete entries
        myCVSList.Delete(nInd);
        dec(nLCount);
      end;
    end;

    if oCVSSel.Count > 0 then begin            // set selection
      for nInd := 0 to oCVSSel.Count-1 do begin
        for nInd2:=0 to myCVSList.Items.count-1 do begin
          if myCVSList.Values[0,nInd2] = oCVSSel.Strings[nInd] then
            myCVSList.Selected[nInd2] := true;
        end;
      end;
    end;
    myCVSList.EndUpdate;
  end;

  myStatusBar.Panels[0].Text := aFolder;
  sRootText := oCVS.GetRootForRootText(sRoot,false);
  myStatusBar.Panels[1].Text := sRootText;
  oCVS.Destroy;

End;

{***********************************
* Refresh procedure for not controlled
* list
*
* @param aType
* @param aFolder
***********************************}
Procedure TmyOS2CVSfrm.refreshNotContrDir(aType, aFolder: String);
var
  oCVS: myCVS;
  nInd, nInd2: Integer;
  nIndex: Integer;
  nLCount: Integer;
  oList: TStringList;
  oNonCVSSel: TStringList;
  bChanged: Boolean;
  sTempVal: String;
begin
  bChanged := false;

  // now save selected state of list
  oNonCVSSel := TStringList.create;
  if myNonCVSList.Selcount > 0 then
    for nInd:=0 to myNonCVSList.Items.count-1 do
      if myNonCVSList.Selected[nInd] then
        oNonCVSSel.Add(myNonCVSList.Values[0,nInd]);

  // get filenames for nonCVSList
  oList := TStringList.Create;
  oCVS := myCVS.Create;
  oCVS.CreateIgnoreList(aFolder);
  oList := oCVS.UpdateCVS(aFolder);
  oList.clear;
  oList := oCVS.UpdateFiles(aFolder,true);
  myNonCVSList.BeginUpdate;
  if (aType = 'Full') then begin          // full refresh for click on folder
    myNonCVSList.clear;
    myNonCVSList.items.addstrings(oList);
  end else
  if aType = 'Check' then begin           // timer refresh
    nInd2 := 0;
    while nInd2 <= myNonCVSList.count-1 do begin
      for nInd := 0 to oList.count-1 do begin
        sTempVal := oList.Strings[nInd];
        if pos(myNonCVSList.Values[0,nInd2]+'|',sTempVal) <> 0 then begin
          TokenInit(sTempVal,'|',true);
          myNonCVSList.Values[1,nInd2] := Token(2);
          myNonCVSList.Values[2,nInd2] := Token(3);
          oList.Delete(nInd);
          break;
        end;
      end;
      if nInd > oList.count then begin      // file deleted
        myNonCVSList.Delete(nInd2);
        bChanged := true;
      end else
        inc(nInd2);
    end;
    if oList.count > 0 then begin            // new entries
      myNonCVSList.items.addstrings(oList);
      bChanged := true;
    end;
    if bChanged then myNonCVSList.sort(0);
  end else begin                             // other refresh types
    for nInd := 0 to oList.Count-1 do begin
      if (nInd > myNonCVSList.Count-1) then
        myNonCVSList.Add(oList.Strings[nInd])
      else begin
        TokenInit(oList.Strings[nInd],'|',true);
        nIndex := -1;
        for nInd2 := 0 to myNonCVSList.count-1 do
          if myNonCVSList.Values[0,nInd2] = Token(1) then begin
            nIndex := nInd2;
            break;
          end;
        if nIndex <> -1 then begin
          for nInd2 := 0 to 2 do
            myNonCVSList.Values[nInd2,nIndex] := Token(nInd2+1);
        end else
          myNonCVSList.Add(oList.Strings[nInd])
      end;
    end;
    nLCount := myNonCVSList.count;
    while nInd < nLCount do begin     // delete obsolete entries
      myNonCVSList.Delete(nInd);
      dec(nLCount);
    end;
  end;

  if oNonCVSSel.Count > 0 then          // set selection
    for nInd := 0 to oNonCVSSel.Count-1 do
      for nInd2:=0 to myNonCVSList.Items.count-1 do
        if myNonCVSList.Values[0,nInd2] = oNonCVSSel.Strings[nInd] then
          myNonCVSList.Selected[nInd2] := true;
  myNonCVSList.EndUpdate;
end;

{***********************************
* Add folder to project tree
*
* @param aFolder
***********************************}
Procedure TmyOS2CVSfrm.AddFolderToProjects( aFolder: String; aSave: Boolean );
var
  tmpIndRoot: integer;
  lSettings: mySettings;

  // sub procedure for adding subdirectories
  Procedure AddSubDirs(aLevel: Integer; aFolder: String);
  var
    Status: Integer;
    SearchRec:TSearchRec;
    tmpInd: Integer;
    oCVS: myCVS;
  begin
    Status:=FindFirst(aFolder+'\*',faAnyFile,SearchRec);
    While Status=0 Do
    Begin
      if (((SearchRec.Attr) and (faDirectory)) <> 0) and
      (SearchRec.Name <> '.') and (SearchRec.Name <> '..') and
      (SearchRec.Name <> 'CVS') then begin
        oCVS := myCVS.Create;
        oCVS.CreateIgnoreList(aFolder);
        if not oCVS.CheckMask(SearchRec.Name) then begin
          tmpInd := myProjectOutLn.AddChild(aLevel,SearchRec.Name);
          AddSubDirs(tmpInd,aFolder+'\'+SearchRec.Name);      // add subfolders recursiv
        end;
      end;
      Status:=FindNext(SearchRec);
    end;
  end;

// AddFolderToProjects
Begin
  Cursor := crHourGlass;
  tmpIndRoot := myProjectOutLn.Add(0,aFolder);    // add main folder
  AddSubDirs(tmpIndRoot,aFolder);               // add subfolders recursiv
  if aSave then
    lSettings.SaveProjectSettings(myProjectOutln);  // save in  project settings
  Cursor := crDefault;
end;

{***********************************
* Open profile settings window event procedure
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myOptSettingsOnClick (Sender: TObject);
Begin
  myRefreshTimer.Stop;
  profileFrm.myRefreshSpin.Value := trunc(myRefreshTimer.Interval/1000);
  profileFrm.ShowModal;
  myRefreshTimer.Interval := 1000 * profileFrm.myRefreshSpin.Value;
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.checked) then
    myRefreshTimer.Start;
End;

{***********************************
* Refresh Timer event procedure
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myRefreshTimerOnTimer (Sender: TObject);
Begin
  if (myProjectOutLn.SelectedItem <> -1) then begin
    // refresh not recursive
    RefreshLists('Check',myProjectOutLn.SelectedNode.FullPath,nil,true,false);
  end;
End;

{***********************************
* Helper function for getting selected files as StringList
*
* @param aList ('CVS' or 'nonCVS')
* @return TStringList
***********************************}
Function TmyOS2CVSfrm.getFileList(aList: String): TStringList;
var
  nInd: Integer;
Begin
  RESULT := TStringList.Create;
  if aList = 'CVS' then begin
    if myCVSList.Selcount > 0 then
      for nInd:=0 to myCVSList.Items.count-1 do
        if myCVSList.Selected[nInd] then
          RESULT.Add(myCVSList.Values[0,nInd]);
  end else begin
    if myNonCVSList.Selcount > 0 then
      for nInd:=0 to myNonCVSList.Items.count-1 do
        if myNonCVSList.Selected[nInd] then
          RESULT.Add(myNonCVSList.Values[0,nInd]);
  end;
End;

{***********************************
* Helper function for getting selected files as String
*
* @param aList ('CVS' or 'nonCVS')
* @return String
***********************************}
Function TmyOS2CVSfrm.getFileListString(aList: String): String;
var
  nInd: Integer;
Begin
  RESULT := '';
  if aList = 'CVS' then begin
    if myCVSList.Selcount > 0 then
      for nInd:=0 to myCVSList.Items.count-1 do
        if myCVSList.Selected[nInd] then
          RESULT := RESULT + myCVSList.Values[0,nInd] + ' ';
  end else begin
    if myNonCVSList.Selcount > 0 then
      for nInd:=0 to myNonCVSList.Items.count-1 do
        if myNonCVSList.Selected[nInd] then
          RESULT := RESULT + myNonCVSList.Values[0,nInd] + ' ';
  end;
End;

{***********************************
* Helper function for getting revision
*
* @return String
***********************************}
Function TmyOS2CVSfrm.getFileRevision: String;
var
  nInd : Integer;
begin
  RESULT := '';
  if myCVSList.Selcount = 1 then
    for nInd:=0 to myCVSList.Items.count-1 do
      if myCVSList.Selected[nInd] then
        RESULT := myCVSList.Values[1,nInd];
end;

{***********************************
* menu actions for CVS functions
***********************************}

{***********************************
* Add folder to project tree event procedure
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myProjectAddMnuItemOnClick (Sender: TObject);
Begin
  myRefreshTimer.Stop;
  if myChangeDirDialog.Execute then
    AddFolderToProjects(myChangeDirDialog.Directory,true);
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.Checked) then
    myRefreshTimer.Start;
End;

{***********************************
* Remove selected Folder from project list
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myProjectRemoveItemOnClick (Sender: TObject);
var
  lSettings: mySettings;
Begin
  myRefreshTimer.Stop;
  if (myProjectOutLn.SelectedItem <> -1) then begin
    myProjectOutLn.Delete(myProjectOutLn.SelectedItem);
    lSettings.SaveProjectSettings(myProjectOutln);  // save in  project settings
    myCVSList.Clear;
    myNonCVSList.Clear;
  end;
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.Checked) then
    myRefreshTimer.Start;
End;

{***********************************
* Quit program
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myProjectQuitOnClick (Sender: TObject);
Begin
  close;
End;

{***********************************
* Update function
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myCVSUpdateOnClick (Sender: TObject);
Begin
  myRefreshTimer.Stop;
  if updateFrm.ShowModal = mrOK then begin
    RefreshLists('Update',myProjectOutLn.SelectedNode.FullPath,nil,true,
      not updateFrm.myNoRecurseChb.Checked);
    myCVSList.DeSelectAll;
  end;
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.checked) then
    myRefreshTimer.Start;
End;

{***********************************
* Commit function
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myCVSCommitOnClick (Sender: TObject);
Begin
  myRefreshTimer.Stop;
  if myCommentFrm.ShowModal = mrOK then begin
    RefreshLists('Update',myProjectOutLn.SelectedNode.FullPath,nil,true,true);
    myCVSList.DeSelectAll;
  end;
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.checked) then
    myRefreshTimer.Start;
End;

{***********************************
* Diff function
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myCVSDiffOnClick (Sender: TObject);
var
  oCVS: myCVS;
  bRet: Boolean;
  oSelectedList: TStringList;
  sAddPar: String;
  sTmpPath: String;
  sOrgFile, sTmpFile: String;
  sRevision : String;
  nId : longword;
  nPar, nI : Integer;
  sPar : String;
  sExe : String;
Begin
  if (pos('.CMD',uppercase(profileFrm.myDiffEditFileName.Filename)) <> 0) or
     (pos('.BAT',uppercase(profileFrm.myDiffEditFileName.Filename)) <> 0)
  then begin
    ShowMessage(langNoCMD);
    exit;
  end;
  myRefreshTimer.Stop;
  sTmpPath := GetEnv('TMP');
  oCVS := myCVS.Create;
  oSelectedList := getFileList('CVS');
  sRevision := getFileRevision;
  sAddpar := '-p -r ' + sRevision;
  bRet := oCVS.CallCVSFunction('CheckoutDiff', myProjectOutLn.SelectedNode.FullPath,
    sTmpPath, getFileListString('CVS'), sAddPar, sRevision, '' );
  if oCVS.CVSLog.count > 0 then begin
    myLogListBox.Items.Add('');
    myLogListBox.Items.AddStrings(oCVS.CVSLog);
    myLogListBox.ItemIndex := myLogListBox.Items.count-1;
  end;
  oCVS.free;
  sOrgFile := myProjectOutLn.SelectedNode.FullPath + '\' + oSelectedList.Strings[0];
  sTmpFile := sTmpPath + '\' + oSelectedList.Strings[0] + '#' + sRevision;
  oSelectedList.Free;
  Exec_Visible := true;
  AsynchExec := true;
  nPar := TokenInit(profileFrm.myDiffEditFileName.Filename,' ',false);
  sExe := Token(1);
  sPar := '';
  for nI := 2 to nPar do
    sPar := sPar + Token(nI) + ' ';
  nId := Exec(sExe, sPar + sTmpFile + ' ' +sOrgFile);
  DosExitCode(nId);
  DeleteFile(sTmpFile);
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.checked) then
    myRefreshTimer.Start;
End;

{***********************************
* Log (history) function
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myCVSHistoryOnClick (Sender: TObject);
var
  oCVS: myCVS;
  bRet: Boolean;
  oSelectedList: TStringList;
  oLogList: TStringList;
  sOut: String;
  nInd: Integer;
  nState: integer;
  sFile: String;
  sRevision, sDateTime, sBranch, sComment: String;
  sDate, sTime: String;
Begin
  myRefreshTimer.Stop;
  sOut := GetEnv('TMP') + '\CVSOUT.LOG';
  oCVS := myCVS.Create;
  oSelectedList := getFileList('CVS');
  sFile := getFileListString('CVS');
  bRet := oCVS.CallCVSFunction('LogHistory', myProjectOutLn.SelectedNode.FullPath,
    '', sFile, '', '', '' );
  if oCVS.CVSLog.count > 0 then begin
    oLogList := TStringList.create;
    oLogList.sorted := false;
    if myHistoryFrm.ourCommentList = nil then
      myHistoryFrm.ourCommentList := TStringList.Create
    else
      myHistoryFrm.ourCommentList.Clear;
    myHistoryFrm.myHistoryList.clear;
    myHistoryFrm.myHistoryList.Listbox.Sorted := false;
    myHistoryFrm.Folder := myProjectOutLn.SelectedNode.FullPath;
    myHistoryFrm.Filename := trim(sFile);
    myLogListBox.Items.Add('');
    myLogListBox.Items.Add(langHistory + ': '+sFile);
    myLogListBox.ItemIndex := myLogListBox.Items.Count-1;
    oLogList.AddStrings(oCVS.CVSLog);
    nState := -1;
    for nInd := 0 to oLogList.count-1 do begin    // get history
      if (pos('-----------',oLogList.Strings[nInd]) <> 0) or
         (pos('===========',oLogList.Strings[nInd]) <> 0) then begin
        if nState = 4 then begin     // add to history list
          myHistoryFrm.myHistoryList.Add(sRevision+'|'+sDateTime+'|'+sBranch+'|'+sComment);
          myHistoryFrm.ourCommentList.Add(sComment);   // separate List
        end;
        nState := 0
      end else begin
        if pos('revision',oLogList.Strings[nInd]) = 1 then begin
          TokenInit(oLogList.Strings[nInd], ' ', false);
          sRevision := Token(2);
          nState := 1;
        end else
        if pos('date:',oLogList.Strings[nInd]) <> 0 then begin
          TokenInit(oLogList.Strings[nInd], ' ', false);
          sDate := Token(2);
          sTime := Token(3);
          TokenInit(sDate,'-',false);
          sDateTime := datetostr(EnCodeDate(strtoint(Token(1)),strtoint(Token(2)),
                       strtoint(Token(3)))) + ' ' + sTime;
          nState := 2;
        end else
        if pos('branches:',oLogList.Strings[nInd]) <> 0 then begin
          TokenInit(oLogList.Strings[nInd], ' ', false);
          sBranch := Token(2);
          nState := 3;
        end else
          if nState >= 2 then begin
            if nState = 2 then sBranch := ' ';
            sComment := oLogList.Strings[nInd];
            nState := 4;
          end;
      end;
    end;
    //myHistoryFrm.myHistoryList.sort(1);        // date
    myHistoryFrm.ShowModal;
  end;
  oCVS.free;
  oSelectedList.Free;
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.checked) then
    myRefreshTimer.Start;
End;

{***********************************
* edit file(s)
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myCVSEditOnClick (Sender: TObject);
var
  oCVS: myCVS;
  bRet: Boolean;
  oSelectedList: TStringList;
Begin
  myRefreshTimer.Stop;
  oCVS := myCVS.Create;
  oSelectedList := getFileList('CVS');
  bRet := oCVS.CallCVSFunction('Edit', myProjectOutLn.SelectedNode.FullPath,
                '',  getFileListString('CVS'), '', '', '' );
  if oCVS.CVSLog.count > 0 then begin
    myLogListBox.Items.AddStrings(oCVS.CVSLog);
    myLogListBox.ItemIndex := myLogListBox.Items.count-1;
  end;
  oCVS.free;
  RefreshLists('State',myProjectOutLn.SelectedNode.FullPath,oSelectedList,true,true);
  myCVSList.DeSelectAll;
  oSelectedList.Free;
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.checked) then
    myRefreshTimer.Start;
End;

{***********************************
* unedit file(s)
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myCVSUnEditOnClick (Sender: TObject);
var
  oCVS: myCVS;
  bRet: Boolean;
  oSelectedList: TStringList;
  sAddPar: String;
Begin
  myRefreshTimer.Stop;
  oCVS := myCVS.Create;
  if profileFrm.myCheckoutROChb.checked then
    sAddpar := '-r'
  else
    sAddpar := '';
  oSelectedList := getFileList('CVS');
  bRet := oCVS.CallCVSFunction('UnEdit', myProjectOutLn.SelectedNode.FullPath,
                '',  getFileListString('CVS'), sAddPar, '', '' );
  if oCVS.CVSLog.count > 0 then begin
    myLogListBox.Items.AddStrings(oCVS.CVSLog);
    myLogListBox.ItemIndex := myLogListBox.Items.count-1;
  end;
  oCVS.free;
  RefreshLists('State',myProjectOutLn.SelectedNode.FullPath,oSelectedList,true,true);
  myCVSList.DeSelectAll;
  oSelectedList.Free;
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.checked) then
    myRefreshTimer.Start;
End;

{***********************************
* checkout module
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myProjectCVSCheckoutOnClick (Sender: TObject);
Begin
  myRefreshTimer.Stop;
  myCheckoutFrm.ShowModal;      // refresh is done in uCheckout
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.checked) then
    myRefreshTimer.Start;
End;

{***********************************
* add ascii or binary files
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myAddFilesOnClick (Sender: TObject);
var
  oCVS: myCVS;
  bRet: Boolean;
  sFuncPar: String;
Begin
  myRefreshTimer.Stop;
  if (Sender = myAddBinary) or (Sender = myAddBinTbt) then
    sFuncPar := '-kb'
  else
    sFuncPar := '';
  oCVS := myCVS.Create;
  bRet := oCVS.CallCVSFunction('AddFiles', myProjectOutLn.SelectedNode.FullPath,
                '',  getFileListString('nonCVS'), '', sFuncPar, '' );
  if oCVS.CVSLog.count > 0 then begin
    myLogListBox.Items.AddStrings(oCVS.CVSLog);
    myLogListBox.ItemIndex := myLogListBox.Items.count-1;
  end;
  oCVS.free;
  myNonCVSList.DeSelectAll;
  RefreshLists('Full',myProjectOutLn.SelectedNode.FullPath,nil,true,false);
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.checked) then
    myRefreshTimer.Start;
End;

{***********************************
* add directory
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myAddDirectoryOnClick (Sender: TObject);
var
  oCVS: myCVS;
  bRet: Boolean;
Begin
  myRefreshTimer.Stop;
  oCVS := myCVS.Create;
  bRet := oCVS.CallCVSFunction('AddDir', myProjectOutLn.SelectedNode.FullPath,
                '',  '', '', '', '' );
  if oCVS.CVSLog.count > 0 then begin
    myLogListBox.Items.AddStrings(oCVS.CVSLog);
    myLogListBox.ItemIndex := myLogListBox.Items.count-1;
  end;
  oCVS.free;
  RefreshLists('Full',myProjectOutLn.SelectedNode.FullPath,nil,true,true);
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.checked) then
    myRefreshTimer.Start;
End;

{***********************************
* delete files/directories only local
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myDeleteLocalOnClick (Sender: TObject);
var
  oSelectedList: TStringList;
  oLogList: TStringList;
  nInd, nState : Integer;
  SearchRec: TSearchRec;
  bRet: Boolean;
  sFilename: String;
Begin
  myRefreshTimer.Stop;
  oLogList := TStringList.create;
  oLogList.Add(langDeleteLocal);
  if myFilesNotebook.PageIndex = 0 then          // CVSList active
    oSelectedList := getFileList('CVS')
  else                                         // nonCVSList active
    oSelectedList := getFileList('nonCVS');
  if oSelectedList.count > 0 then begin        // files selected, delete them
    oLogList.Add(langDeleteFiles);
    for nInd := 0 to oSelectedList.count-1 do begin
      sFilename := myProjectOutLn.SelectedNode.FullPath+'\'+oSelectedList.Strings[nInd];
      FileSetAttr(sFilename,0);       // remove read-only attr
      bRet := DeleteFile(sFilename);
      oLogList.Add(sFilename+' '+iif(bRet,langDelTrue,langDelFalse));
    end;
  end else begin             // no files selected, delete all files and dir
    oLogList.Add(langDeleteDir);
    nState:=FindFirst(myProjectOutLn.SelectedNode.FullPath+'\*',faAnyFile,SearchRec);
    sFilename := myProjectOutLn.SelectedNode.FullPath+'\'+SearchRec.Name;
    if nState = 0 then begin
      FileSetAttr(sFilename,0);       // remove read-only attr
      DeleteFile(sFilename);
    end;
    While nState=0 Do
    Begin
      nState:=FindNext(SearchRec);
      sFilename := myProjectOutLn.SelectedNode.FullPath+'\'+SearchRec.Name;
      if nState = 0 then begin
        FileSetAttr(sFilename,0);       // remove read-only attr
        DeleteFile(sFilename);
      end;
    End;
    {$I-}
    RmDir(myProjectOutLn.SelectedNode.FullPath);
    {$I+}
    IF IOResult <> 0
    THEN oLogList.Add(myProjectOutLn.SelectedNode.FullPath+' '+langDelFalse)
    ELSE begin
      oLogList.Add(myProjectOutLn.SelectedNode.FullPath+' '+langDelTrue);
      myProjectOutLn.SelectedNode := myProjectOutLn.Items[myProjectOutLn.SelectedNode.Index-1];
      refreshMenuItemOnClick(self);
    end;
  end;
  if oLogList.count > 0 then begin
    myLogListBox.Items.AddStrings(oLogList);
    myLogListBox.ItemIndex := myLogListBox.Items.count-1;
  end;
  oLogList.Free;
  RefreshLists('State',myProjectOutLn.SelectedNode.FullPath,oSelectedList,true,true);  // tricky, path may not valid
  oSelectedList.Free;
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.checked) then
    myRefreshTimer.Start;
End;

{***********************************
* delete files in CVS repository and local
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myDeleteBothOnClick (Sender: TObject);
var
  nInd, nInd2: Integer;
  oCVS: myCVS;
  bRet: Boolean;
  oSelectedList: TStringList;
Begin
  myRefreshTimer.Stop;
  oCVS := myCVS.Create;
  oSelectedList := getFileList('CVS');
  for nInd := 0 to oSelectedList.count-1 do begin
    for nInd2 := 0 to ourCVSFileList.Count-1 do begin
      if pos(myProjectOutLn.SelectedNode.FullPath+'\'+oSelectedList.Strings[nInd]+'|',ourCVSFileList.Strings[nInd2]) <> 0 then begin
        ourCVSFileList.Delete(nInd2);
        break;
      end;
    end;
  end;
  bRet := oCVS.CallCVSFunction('Remove', myProjectOutLn.SelectedNode.FullPath,
                '',  getFileListString('CVS'), '', '-f', '' );
  if oCVS.CVSLog.count > 0 then begin
    myLogListBox.Items.AddStrings(oCVS.CVSLog);
    myLogListBox.ItemIndex := myLogListBox.Items.count-1;
  end;
  RefreshLists('State',myProjectOutLn.SelectedNode.FullPath,oSelectedList,true,true);
  oCVS.free;
  oSelectedList.Free;
  myCommentFrm.ShowModal;           // commit the deleting
  myCVSList.DeSelectAll;
  myCVSList.Clear;
  RefreshLists('Full',myProjectOutLn.SelectedNode.FullPath,nil,true,false);
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.checked) then
    myRefreshTimer.Start;
End;

{***********************************
* create local CVS repository
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myProjectCVSRepoOnClick (Sender: TObject);
var
  oCVS: myCVS;
  bRet: Boolean;
  sCurrentDir: String;
  oSelectDlg: TChangeDirDialog;
Begin
  myRefreshTimer.Stop;
  GetDir(0,sCurrentDir);
  oSelectDlg := TChangeDirDialog.create(self);
  if oSelectDlg.Execute then begin
    oCVS := myCVS.Create;
    bRet := oCVS.CallCVSFunction('Init', oSelectDlg.Directory, '',  '', '', '', '' );
    if PathExists(AddPathSeparator(oSelectDlg.Directory)+'\CVSROOT') then begin
      if oCVS.CVSLog.count > 0 then begin
        myLogListBox.Items.Add(oCVS.CVSLog.Strings[0]);
        myLogListBox.Items.Add(oCVS.CVSLog.Strings[1]);
        myLogListBox.Items.Add(langCVSrepoCreated);
        myLogListBox.Items.Add(oCVS.CVSLog.Strings[2]);
        myLogListBox.ItemIndex := myLogListBox.Items.count-1;
      end;
    end else begin
      if oCVS.CVSLog.count > 0 then begin
        myLogListBox.Items.AddStrings(oCVS.CVSLog);
        myLogListBox.ItemIndex := myLogListBox.Items.count-1;
      end;
    end;
    oCVS.free;
    ChDir(sCurrentDir);
  end;
  oSelectDlg.Free;
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.checked) then
    myRefreshTimer.Start;
End;

{***********************************
* import CVS project
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myProjectCVSImportOnClick (Sender: TObject);
Begin
  myRefreshTimer.Stop;
  myImportFrm.ShowModal;
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.checked) then
    myRefreshTimer.Start;
End;

{***********************************
* view selected file, invoked from popup
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myFileViewOnClick (Sender: TObject);
var
  oSelectedList: TStringList;
  sOrgFile: String;
  nPar, nI: Integer;
  sPar : String;
  sExe : String;
Begin
  if (pos('.CMD',uppercase(profileFrm.myViewerEditFileName.Filename)) <> 0) or
     (pos('.BAT',uppercase(profileFrm.myViewerEditFileName.Filename)) <> 0)
  then begin
    ShowMessage(langNoCMD);
    exit;
  end;
  if myFilesNotebook.PageIndex = 0 then      // CVSList active
    oSelectedList := getFileList('CVS')
  else
    oSelectedList := getFileList('nonCVS');  // nonCVSList active
  sOrgFile := '';
  for nI := 0 to oSelectedList.count-1 do begin
    sOrgFile := sOrgFile + myProjectOutLn.SelectedNode.FullPath + '\' + oSelectedList.Strings[nI];
    if nI < oSelectedList.count-1 then sOrgFile := sOrgFile + ' ';
  end;
  oSelectedList.Free;
  Exec_Visible := true;
  AsynchExec := true;
  nPar := TokenInit(profileFrm.myViewerEditFileName.Filename,' ',false);
  sExe := Token(1);
  sPar := '';
  for nI := 2 to nPar do
    sPar := sPar + Token(nI) + ' ';
  if trim(sPar) = '' then
    sPar := + sOrgFile
  else
    sPar := sPar + ' '+ sOrgFile;
  Exec(sExe, sPar + ' ' +sOrgFile);
End;

{***********************************
* edit selected file, invoked from popup
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myFileEditOnClick (Sender: TObject);
var
  oSelectedList: TStringList;
  sOrgFile: String;
  nPar, nI: Integer;
  sPar : String;
  sExe : String;
  nId: longword;
Begin
  if (pos('.CMD',uppercase(profileFrm.myEditorEditFileName.Filename)) <> 0) or
     (pos('.BAT',uppercase(profileFrm.myEditorEditFileName.Filename)) <> 0)
  then begin
    ShowMessage(langNoCMD);
    exit;
  end;
  myRefreshTimer.Stop;
  if myFilesNotebook.PageIndex = 0 then      // CVSList active
    oSelectedList := getFileList('CVS')
  else
    oSelectedList := getFileList('nonCVS');  // nonCVSList active
  sOrgFile := '';
  for nI := 0 to oSelectedList.count-1 do begin
    sOrgFile := sOrgFile + myProjectOutLn.SelectedNode.FullPath + '\' + oSelectedList.Strings[nI];
    if nI < oSelectedList.count-1 then sOrgFile := sOrgFile + ' ';
  end;
  oSelectedList.Free;
  Exec_Visible := true;
  AsynchExec := true;
  nPar := TokenInit(profileFrm.myEditorEditFileName.Filename,' ',false);
  sExe := Token(1);
  sPar := '';
  for nI := 2 to nPar do
    sPar := sPar + Token(nI) + ' ';
  if trim(sPar) = '' then
    sPar := + sOrgFile
  else
    sPar := sPar + ' '+ sOrgFile;
  nID := Exec(sExe, sPar);
  DosExitCode(nId);
  RefreshLists('State',myProjectOutLn.SelectedNode.FullPath,oSelectedList,true,false);
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.checked) then
    myRefreshTimer.Start;
End;

{***********************************
* create tag or branch
*
* @param Sender has called method
***********************************}
Procedure TmyOS2CVSfrm.myCVSCreateTagBranchOnClick (Sender: TObject);
Begin
  myRefreshTimer.Stop;
  myTagBranchFrm.ShowModal;
  RefreshLists('Full',myProjectOutLn.SelectedNode.FullPath,nil,true,false);
  myCVSList.DeSelectAll;
  if (myRefreshTimer.Tag = 1) and (profileFrm.myRefreshChb.checked) then
    myRefreshTimer.Start;
End;

{***********************************
* refresh enabled state of menu points
***********************************}
Procedure TmyOS2CVSfrm.refreshEnabledState;
begin
  if myFilesNotebook.PageIndex = 0 then begin    // CVSList active
    myAddAscii.Enabled := false;
    myAddAsciiTbt.Enabled := false;
    myAddBinary.Enabled := false;
    myAddBinTbt.Enabled := false;
    myAddDirectory.Enabled := false;
    myAddFolderTbt.Enabled := false;
    myEditTbt.Enabled := true;
    myCVSEdit.Enabled := true;
    myCVSEditPrj.Enabled := true;
    myUneditTbt.Enabled := true;
    myCVSUnedit.Enabled := true;
    myCVSUneditPrj.Enabled := true;
    myCVSCommit.Enabled := true;
    myCommitTbt.Enabled := true;
    myCVSCommitPrj.Enabled := true;
    myCVSUpdate.Enabled := true;
    myUpdateTbt.Enabled := true;
    myCVSUpdatePrj.Enabled := true;
    myDeleteBoth.Enabled := true;
    if (myCVSList.count > 0) and (myCVSList.SelCount > 0) then begin        // files selected
      myCVSUpdateFile.Enabled := true;
      myDeleteLocal.Enabled := true;
      myCVSDeleteBothFile.Enabled := true;
      myCVSDiff.Enabled := (myCVSList.SelCount = 1);
      myDiffTbt.Enabled := (myCVSList.SelCount = 1);
      myCVSDiffFile.Enabled := (myCVSList.SelCount = 1);
      myCVSHistory.Enabled := (myCVSList.SelCount = 1);
      myHistoryTbt.Enabled := (myCVSList.SelCount = 1);
      myCVSHistoryFile.Enabled := (myCVSList.SelCount = 1);
      myCVSCommitFile.Enabled := true;
      myCVSEditFile.Enabled := true;
      myCVSUneditFile.Enabled := true;
      myCVSFileView.Enabled := true;
      myCVSFileEdit.Enabled := true;
      myCVSCreateTagBranchFile.Enabled := true;
    end else begin                            // no files selected
      myCVSUpdateFile.Enabled := false;
      myDeleteLocal.Enabled := false;
      myCVSDeleteBothFile.Enabled := false;
      myCVSDiff.Enabled := false;
      myDiffTbt.Enabled := false;
      myCVSDiffFile.Enabled := false;
      myCVSHistory.Enabled := false;
      myHistoryTbt.Enabled := false;
      myCVSHistoryFile.Enabled := false;
      myCVSCommitFile.Enabled := false;
      myCVSEditFile.Enabled := false;
      myCVSUneditFile.Enabled := false;
      myCVSFileView.Enabled := false;
      myCVSFileEdit.Enabled := false;
      myCVSCreateTagBranchFile.Enabled := false;
    end;
  end else begin                              // non CVSlist active
    myDeleteBoth.Enabled := false;
    myDeleteLocal.Enabled := true;
    myCVSEdit.Enabled := false;
    myEditTbt.Enabled := false;
    myCVSEditPrj.Enabled := false;
    myCVSUnedit.Enabled := false;
    myUneditTbt.Enabled := false;
    myCVSUneditPrj.Enabled := false;
    myCVSDiff.Enabled := false;
    myDiffTbt.Enabled := false;
    myCVSHistory.Enabled := false;
    myHistoryTbt.Enabled := false;
    myCVSCommit.Enabled := false;
    myCommitTbt.Enabled := false;
    myCVSCommitPrj.Enabled := false;
    myCVSUpdate.Enabled := false;
    myUpdateTbt.Enabled := false;
    myCVSUpdatePrj.Enabled := false;
    if (myNonCVSList.count > 0) and (myNonCVSList.SelCount > 0) then begin        // files selected
      myAddAscii.Enabled := true;
      myAddAsciiTbt.Enabled := true;
      myAddAsciiFiles.Enabled := true;
      myAddBinary.Enabled := true;
      myAddBinTbt.Enabled := true;
      myAddBinaryFiles.Enabled := true;
      myAddDirectory.Enabled := false;
      myAddFolderTbt.Enabled := false;
      myNonCVSFileView.Enabled := true;
      myNonCVSFileEdit.Enabled := true;
      myDeleteLocalFile.Enabled := true;
    end else begin                            // no files selected
      myAddAscii.Enabled := false;
      myAddAsciiTbt.Enabled := false;
      myAddAsciiFiles.Enabled := false;
      myAddBinary.Enabled := false;
      myAddBinTbt.Enabled := false;
      myAddBinaryFiles.Enabled := false;
      if (myProjectOutLn.ItemCount > 0) and (not FileExists(myProjectOutLn.SelectedNode.FullPath+'\CVS\Root')) then begin
        myAddDirectory.Enabled := true;
        myAddFolderTbt.Enabled := true;
        myAddDirectoryPrj.Enabled := true;
      end else begin
        myAddDirectory.Enabled := false;
        myAddFolderTbt.Enabled := false;
        myAddDirectoryPrj.Enabled := false;
      end;
      myNonCVSFileView.Enabled := false;
      myNonCVSFileEdit.Enabled := false;
      myDeleteLocalFile.Enabled := false;
    end;
  end;
end;

{***********************************
                                    * show about window
*
* @param Sender
***********************************}
Procedure TmyOS2CVSfrm.myHelpAboutOnClick (Sender: TObject);
Begin
  myAboutFrm.ShowModal;
End;

{***********************************
* splitter for prj sized
*
* @param Sender
* @param SizeDelta
***********************************}
Procedure TmyOS2CVSfrm.myPrjSizeBorderOnSized (Sender: TObject;
  Var SizeDelta: LongInt);
Begin
  myPrjPanel.Align := alNone;
  myFilesPanel.Align := alNone;
  myLogPanel.Align := alNone;
  myPrjPanel.Width := myPrjPanel.Width+SizeDelta;
  myFilesPanel.Width := myFilesPanel.Width-SizeDelta;
  myLogPanel.Width := myLogPanel.Width-SizeDelta;
  myFilesPanel.Left  := myFilesPanel.Left+SizeDelta;
  myLogPanel.Left  := myLogPanel.Left+SizeDelta;
  myPrjPanel.Align := alScale;
  myFilesPanel.Align := alScale;
  myLogPanel.Align := alScale;
End;

{***********************************
* splitter for log sized
*
* @param Sender
* @param SizeDelta
***********************************}
Procedure TmyOS2CVSfrm.myLogSizeBorderOnSized (Sender: TObject;
  Var SizeDelta: LongInt);
Begin
  myFilesPanel.Align  := alNone;
  myLogPanel.Align  := alNone;
  myFilesPanel.Height := myFilesPanel.Height-SizeDelta;
  myFilesPanel.Bottom := myFilesPanel.Bottom+SizeDelta;
  myLogPanel.Height := myLogPanel.Height+SizeDelta;
  myFilesPanel.Align  := alScale;
  myLogPanel.Align  := alScale;
End;

Initialization
  RegisterClasses ([TmyOS2CVSfrm, TMainMenu, TMenuItem, TToolbar,
    TSizeBorder, TChangeDirDialog,
    TPopupMenu, TTimer, TExplorerButton, TBevel, TPanel, TStatusBar, TOutline,
    TTabbedNotebook, TListBox, tMultiColumnList]);
End.
