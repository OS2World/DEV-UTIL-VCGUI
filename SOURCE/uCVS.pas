{***********************************
 uCVS.pas
 Unit for CVS handling
 -----------------------------------
 begin  : Mar 12 2005
 author : Thomas Bohn
 eMail  : Thomas@Bohn-Stralsund.de
 -----------------------------------
 This document and the included
 information are released under
 GPL.
***********************************}
Unit uCVS;

Interface

uses Classes, SysUtils, Dialogs, DOS, uString, uTools, uExecQueue, Forms;

Type

  myCVSEntryRec = Record
    Name: String;
    Revision: String;
    Tag: String;
    Option: String;
    State: String;
    LastUpdate: String;
  end;

  myCVS = class
    Constructor Create;
    Destructor Destroy; override;
  Private
    {Private Deklarationen hier einfÅgen}
    myCVSBaseLst: TStringList;
    myCVSLogLst: TStringList;
    Function myCVSEntryParser(aLine: String): myCVSEntryRec;
    Procedure myCVSLog(aLogfile, aErrFile, aLogCmd: String; aNoState: Boolean);
  Public
    {ôffentliche Deklarationen hier einfÅgen}
    Function UpdateCVS(aFolder: String): TStringList;
    Function UpdateFiles(aFolder: String; aNonCVS: Boolean): TStringList;
    Function GetRoot(aFolder: String): String;
    Function GetRootForRootText(aRootText: String; aWithPass: Boolean): String;
    Function GetRepository(aFolder: String): String;
    Function CallCVSFunction(aFunction, aLocation, aTarget, aFiles,
                     aAddPar, aFuncPar, aComment: AnsiString): Boolean;
    Function GetTagList(aNoRecurse: Boolean): TStringList;
    property CVSLog: TStringList read myCVSLogLst;
    Procedure CreateIgnoreList(aFolder: String);
    Function CheckMask(aName: String): Boolean;
  End;

var
   ourCVSFileList: TStringList;
   ourCVSIgnoreList: TStringList;

Implementation

uses uMain, uSettings, uStrings, uProfile;

{***********************************
* constructor for eCVS class
***********************************}
Constructor myCVS.Create;
begin
  myCVSBaseLst := TStringList.Create;
  myCVSLogLst := TStringList.Create;
  if ourCVSFileList = nil then
    ourCVSFileList.Create;
end;

{***********************************
* destructor for eCVS class
***********************************}
Destructor myCVS.Destroy;
begin
  inherited Destroy;
  myCVSBaseLst.Destroy;
  myCVSLogLst.Destroy;
end;

{***********************************
* parse line from cvs "entries" file
*
* @param aLine
* @return myCVSEntryRec
***********************************}
Function myCVS.myCVSEntryParser(aLine: String): myCVSEntryRec;
var
  tmpPart: String;
  tmpPos: Integer;
begin
  tmpPart := copy(aLine,2,100);
  tmpPos  := pos('/',tmpPart);
  RESULT.Name := copy(tmpPart,1,tmpPos-1);
  tmpPart := copy(tmpPart,tmpPos+1,80);
  tmpPos  := pos('/',tmpPart);
  RESULT.Revision  := copy(tmpPart,1,tmpPos-1);
  tmpPart := copy(tmpPart,tmpPos+1,75);
  tmpPos  := pos('/',tmpPart);
  RESULT.LastUpdate  := copy(tmpPart,1,tmpPos-1);
  tmpPart := copy(tmpPart,tmpPos+1,65);
  tmpPos  := pos('/',tmpPart);
  RESULT.Option  := copy(tmpPart,1,tmpPos-1);
  RESULT.State := langStateSeemsActual;
  tmpPart := copy(tmpPart,tmpPos+2,40);   // first letter is a additional 'T'
  RESULT.Tag  := tmpPart;
end;

{***********************************
* Fill log with output of CVS
*
* @param aLogfile
* @param aErrFile
* @param aLogCmd
***********************************}
Procedure myCVS.myCVSLog(aLogfile, aErrFile, aLogCmd: String; aNoState: Boolean);
var
  oLoadLst: TStringList;
begin
  oLoadLst := TStringList.create;
  myCVSLogLst.clear;
  if FileExists(aErrfile) then begin
    oLoadLst.LoadFromFile(aErrfile);
    myCVSLogLst.AddStrings(oLoadLst);
  end;
  if FileExists(aLogfile) then begin
    oLoadLst.LoadFromFile(aLogfile);
    myCVSLogLst.AddStrings(oLoadLst);
  end;
  if not aNoState then begin
    myCVSlogLst.Insert(0,aLogCmd);
    myCVSlogLst.Insert(1,langCVSstart);
    myCVSlogLst.Insert(myCVSlogLst.count,langCVSdone);
    myCVSlogLst.Insert(myCVSlogLst.count,'');
  end;
end;

// public methods

{***********************************
* update cvs entries file list
*
* @param aFolder
* @return TStringList
***********************************}
Function myCVS.UpdateCVS(aFolder: String): TStringList;
var
  nInd, nInd2: Integer;
  CVSRec : myCVSEntryRec;
  sLastUpdate: String;
  nLastUpdate: TDateTime;
  nToken: Integer;
  sState: String;
Begin
  // get filenames for CVSList
  myCVSBaseLst.Sorted := true;
  RESULT := TStringList.Create;
  if FileExists(aFolder+'\CVS\Entries') then begin
    myCVSBaseLst.LoadFromFile(aFolder+'\CVS\Entries');
    for nInd := 0 to myCVSBaseLst.Count-1 do begin
      if copy(myCVSBaseLst.Strings[nInd],1,1) <> 'D' then begin      // not a folder
        CVSRec := myCVSEntryParser(myCVSBaseLst.Strings[nInd]);
        sLastUpdate := CVSRec.LastUpdate;
        nToken := TokenInit(sLastUpdate, ' ', false);
        if nToken = 5 then begin
          nLastUpdate := EncodeDate(strtoint(Token(5)),MonthToNum(Token(2)),
            strtoint(Token(3)));
          sLastUpdate := DateToStr(nLastUpdate) + ' ' + Token(4);
        end;    // else original form entries file (eg. result of merge)
        sState := CVSRec.State;
        for nInd2 := 0 to ourCVSFileList.Count-1 do
          if pos(aFolder + '\' + CVSRec.Name+'|',ourCVSFileList.Strings[nInd2]) <> 0 then begin
            TokenInit(ourCVSFileList.Strings[nInd2],'|',false);
            sState := Token(2);
            break;
          end;
        if not CheckMask(CVSRec.Name) then
          RESULT.Add(CVSRec.Name+'|'+CVSRec.Revision+'|'+CVSRec.Tag+'|'+CVSRec.Option+'|'+
                    sState+'|'+sLastUpdate);
      end;
    end;
  end;
  RESULT.sorted := true;
end;

{***********************************
* update files list for non CVS list
* and modify timestamp in CVS list
*
* @param aFolder
* @param aNonCVS
* @return TStringList
***********************************}
Function myCVS.UpdateFiles(aFolder: String; aNonCVS: Boolean): TStringList;
var
  SearchRec:TSearchRec;
  Status: Integer;
  nInd: Integer;
  bCheck: Boolean;
  sFileDate: String;
  sTest: String;
Begin
  // get filenames for nonCVSList
  RESULT := TStringList.Create;
  Status:=SysUtils.FindFirst(aFolder+'\*.*',faAnyFile,SearchRec);
  While Status=0 Do
  Begin
    If ((SearchRec.Attr) And (faDirectory)) <> 0 Then
    Begin
      Status:=SysUtils.FindNext(SearchRec);
      continue;
    End;
    bCheck := false;
    for nInd := 0 to myCVSBaseLst.Count-1 do begin
      sTest := myCVSBaseLst.Strings[nInd];
      if (pos(SearchRec.Name,myCVSBaseLst.Strings[nInd]) = 2) then begin
        bCheck := true;
        break;
      end;
    end;
    if ((aNonCVS) and (not bCheck)) or ((not aNonCVS) and (bCheck)) then
      if (uppercase(SearchRec.Name) <> '.CVSIGNORE') then begin
        sFileDate := DateTimeToStr(FiledateToDateTime(SearchRec.Time));
        TokenInit(sFileDate,' ',false);
        sFileDate := Token(1) + ' ' + ReplaceAll(Token(2),TIMESEPARATOR,':');
        if not CheckMask(SearchRec.Name) then
          RESULT.Add(SearchRec.Name+'|'+ sFileDate+'|'+inttostr(SearchRec.Size));
      end;
    Status:=SysUtils.FindNext(SearchRec);
  End;
  RESULT.sorted := true;
End;

{***********************************
* get CVS root for specified folder
*
* @param aFolder
* @return String
***********************************}
Function myCVS.GetRoot(aFolder: String): String;
var
  oList: TStringList;
begin
  RESULT := '';
  if FileExists(AddPathSeparator(aFolder)+'CVS\Root') then begin
    oList := TStringList.Create;
    oList.LoadFromFile(AddPathSeparator(aFolder)+'CVS\Root');
    RESULT := AddPathSeparator(oList.Strings[0]);
  end;
end;

{***********************************
* Get full root with real password
*
* @param aRootText
* @param aWithPass
* @return String
***********************************}
Function myCVS.GetRootForRootText(aRootText: String; aWithPass: Boolean): String;
var
  i : Integer;
  sRootItem, sRootItemP, sRootResult: String;
  oProfiles: TStringList;
begin
  RESULT := '';
  oProfiles := GetCVSProfiles;
  for i:= 0 to oProfiles.count-1 do begin
    TokenInit(oProfiles.Strings[i],'|',true);
    if Token(5) = 'L' then begin
      sRootItem := ':local:'+AddPathSeparator(Token(4));
      sRootResult := sRootItem;
    end else begin
      sRootItem := ':pserver:'+Token(2)+'@'+ AddPathSeparator(Token(4));
      sRootItemP := ':pserver:'+Token(2)+':' + DecodeString(Token(3))+'@'+ AddPathSeparator(Token(4));
      sRootResult := ':pserver:'+Token(2);
      if aWithPass then
        sRootResult := sRootItemP
      else
        sRootResult := sRootItem;
    end;
    if (uppercase(aRootText) = uppercase(sRootItem)) or
    (uppercase(aRootText) = uppercase(sRootItemP))
    then begin
      RESULT := sRootResult;
      break;
    end;
  end;
end;

{***********************************
* get Repository for specified folder
*
* @param aFolder
* @return String
***********************************}
Function myCVS.GetRepository(aFolder: String): String;
var
  oList: TStringList;
begin
  RESULT := '';
  if FileExists(aFolder+'\CVS\Repository') then begin
    oList := TStringList.Create;
    oList.LoadFromFile(aFolder+'\CVS\Repository');
    RESULT := oList.Strings[0];
  end;
end;

{***********************************
* Execute CVS command
*
* @param aFunction
* @param aLocation
* @param aFiles
* @param aAddPar global parameters
* @param aFuncPar special parameters
* @param aComment commit comment
* @return Boolean
***********************************}
Function myCVS.CallCVSFunction(aFunction, aLocation, aTarget, aFiles,
                               aAddPar, aFuncPar, aComment: AnsiString): Boolean;
var
  sCVSCmd: AnsiString;
  sCVSOut, sCVSErr: AnsiString;
  sCVSLog: AnsiString;
  nCursor: Longint;
  sFolder: AnsiString;
  oCmdFile: Text;
  sTmpPath: String;
  nInd, nLen: Integer;
begin
  nCursor := myOS2CVSFrm.Cursor;
  myOS2CVSFrm.Cursor := crHourGlass;
  sTmpPath := GetEnv('TMP');
  sCVSOut := sTmpPath + '\CVSOUT.LOG';
  sCVSErr := sTmpPath + '\CVSERR.LOG';
  sFolder := '';
  if FileExists(sCVSOut) then
    DeleteFile(sCVSOut);
  if FileExists(sCVSErr) then
    DeleteFile(sCVSErr);
  if aFunction = 'AddDir' then begin
    sCVSCmd := ' -d ' + GetRootForRootText(GetRoot(aLocation+'\..'),true); // special CVSRoot
    sCVSCmd := sCVSCmd + ' add ' + '"' + aLocation + '"';
    sCVSLog := 'cvs add ' + aLocation;
  end else
  if aFunction = 'CheckoutModule' then begin
    sFolder := aTarget;
    sCVSCmd := ' -d ' + GetRootForRootText(aLocation,true); // special CVSRoot
    sCVSCmd := sCVSCmd + ' co -P ' + aAddPar;
    sCVSLog := 'cvs co -P '+ aAddPar;
    if aComment <> '' then begin          // Checkout as
      sCVSCmd := sCVSCmd + ' -d ' + aComment;
      sCVSLog := sCVSLog + ' -d ' + aComment;
    end;
    if aFiles = '' then aFiles := '.';
    sCVSCmd := sCVSCmd + ' -- "' + aFiles + '"';
    sCVSLog := sCVSLog + ' -- ' + aFiles;
  end else
  if aFunction = 'Init' then begin
    // CVSRoot for this function in parameter aLocation (only local folder allowed)
    sCVSCmd := ' -d ' + aLocation + ' init';
    sCVSLog := 'cvs -d ' + aLocation + ' init';
  end else
  if aFunction = 'Import' then begin
    sFolder := aTarget;
    // CVSRoot for this function in parameter aLocation
    sCVSCmd := ' -d ' + aLocation + ' ' + aAddPar + ' import ';
    sCVSCmd := sCVSCmd + aFiles;
    sCVSCmd := sCVSCmd + ' -m "' + aComment + '" ';
    sCVSCmd := sCVSCmd + aFuncPar;
    sCVSLog := 'cvs ' + aAddPar  + ' import -m "' + aComment + '" ' + aFuncPar;
  end else begin
    sFolder := aLocation;
    sCVSCmd := ' -d ' + GetRootForRootText(GetRoot(aLocation),true);
    if aFunction = 'UpdatePatch' then begin
      sCVSCmd := sCVSCmd + ' update ' + aFuncPar + ' ' + aAddPar + ' ' + aFiles;
      sCVSLog := 'cvs update ' + aFuncPar + ' ' + aAddPar + ' ' + aFiles;
    end;
    if aFunction = 'UpdateReplace' then begin
      sCVSCmd := sCVSCmd + ' update -C ' + aFuncPar + ' ' + aAddPar + ' ' + aFiles;
      sCVSLog := 'cvs update -C ' + aFuncPar + ' ' + aAddPar + ' ' + aFiles;
    end;
    if aFunction = 'Commit' then begin
      sCVSCmd := sCVSCmd + ' commit ' + ' ' + aAddPar;
      sCVSLog := 'cvs commit ' + aAddPar;
      if aComment <> '' then begin
        sCVSCmd := sCVSCmd + ' -m "' + aComment + '" ' + aFiles;
        sCVSLog := sCVSLog + ' -m "' + aComment + '" ' + aFiles;
      end;
    end;
    if aFunction = 'CheckoutDiff' then begin
      sCVSCmd := sCVSCmd + ' update ' + aAddPar + ' ' + trim(aFiles) +
        ' > ' + aTarget + '\'  + trim(aFiles) + '#' + aFuncPar;
      sCVSLog := 'cvs update ' + aAddPar + ' ' + aFiles;
    end;
    if aFunction = 'LogHistory' then begin
      sCVSCmd := sCVSCmd + ' ' + aAddPar + ' log ' + trim(aFiles);
      sCVSLog := 'cvs log '+ aFiles;
    end;
    if aFunction = 'LogTags' then begin
      sCVSCmd := sCVSCmd + ' log -h ' + aAddPar;
      sCVSLog := 'cvs log -h ' + aAddPar;
    end;
    if aFunction = 'Edit' then begin
      sCVSCmd := sCVSCmd + ' edit ' + aAddPar + trim(aFiles);
      sCVSLog := 'cvs edit ' + aAddPar + aFiles;
    end;
    if aFunction = 'UnEdit' then begin
      sCVSCmd := sCVSCmd + ' unedit ' + aAddPar + trim(aFiles);
      sCVSLog := 'cvs unedit ' + aAddPar + aFiles;
    end;
    if aFunction = 'AddFiles' then begin
      sCVSCmd := sCVSCmd + ' add ' + aFuncPar + ' ' + aAddPar + ' ' + trim(aFiles);
      sCVSLog := 'cvs add ' + aFuncPar + ' ' + aAddPar + ' ' + aFiles;
    end;
    if aFunction = 'Remove' then begin
      sCVSCmd := sCVSCmd + ' remove ' + aFuncPar + ' ' + aAddPar + ' ' + trim(aFiles);
      sCVSLog := 'cvs remove ' + aFuncPar + ' ' + aAddPar + ' ' + aFiles;
    end;
    if aFunction = 'CreateTag' then begin
      sCVSCmd := sCVSCmd + ' tag -c ' + aFuncPar + ' ' + aAddPar + ' ' + trim(aFiles) + ' ' + aComment;
      sCVSLog := 'cvs tag -c ' + aFuncPar + ' ' + aAddPar + ' ' + aFiles + ' ' + aComment;
    end;
    if aFunction = 'CreateBranch' then begin
        sCVSCmd := sCVSCmd + ' tag -c -b' + aFuncPar + ' ' + aAddPar + ' ' + trim(aFiles) + ' ' + aComment;
        sCVSLog := 'cvs tag -c -b' + aFuncPar + ' ' + aAddPar + ' ' + aFiles + ' ' + trim(aFiles) + ' ' + aComment;
    end;
  end;
  // add redirection
  if (pos(' > ',sCVSCmd) = 0) and (pos(' 1> ',sCVSCmd) = 0)
  and (pos(' 2> ',sCVSCmd) = 0) then
    sCVSCmd := sCVSCmd + ' 1> ' + sCVSOut + ' 2> ' + sCVSErr;

  Assign(oCmdFile,sTmpPath + '\cvsstart.cmd');
  Rewrite(oCmdFile,1);
  IF IOResult <> 0 THEN ShowMessage(langCVSStartProblem)
  else begin
    writeln(oCMDfile,'@echo off');
    writeln(oCMDfile,copy(sFolder,1,1)+':');
    if (length(sFolder) > 3) and (lastpos('\',sFolder) = length(sFolder)) then
      sFolder := copy(sFolder,1,length(sFolder)-1); // cd works not with \ at the end
    writeln(oCMDfile,'cd ' + sFolder);
    write(oCMDfile,profileFrm.myCVSEditFileName.Filename);
    nLen := length(sCVSCmd);
    for nInd := 1 to nLen mod 254 do begin
      write(oCMDfile, copy(sCVSCmd,((nInd-1)*254)+1,254));
    end;
    close(oCMDfile);
  end;
  RunCommand( sTmpPath + '\cvsstart.cmd', 'HIDE' );
  if aFunction = 'LogTags' then
    myCVSLog(sCVSOut,sCVSErr,sCVSLog,true)
  else
    myCVSLog(sCVSOut,sCVSErr,sCVSLog,false);
  RESULT := true;
  DeleteFile( sTmpPath + '\cvsstart.cmd' );
  myOS2CVSFrm.Cursor := nCursor;
end;

{***********************************
* Get CVS Taglist
*
* @param aNoRecurse
***********************************}
Function myCVS.GetTagList( aNoRecurse: Boolean): TStringList;
var
  sAddPar: String;
  bRet: Boolean;
Begin
  RESULT := TStringList.create;
  sAddPar := '';
  if aNoRecurse then
    sAddPar := sAddPar + '-l';
  bRet := CallCVSFunction('LogTags', myOS2CVSfrm.myProjectOutLn.SelectedNode.FullPath,
    '', '', sAddPar, '', '' );
  if myCVSlogLst.count > 0 then
    RESULT.AddStrings(myCVSlogLst);
end;

{***********************************
* Create ignore list for environment
* and .cvsignore files
*
* @param aFolder
***********************************}
Procedure myCVS.CreateIgnoreList(aFolder: String);
var
  sIgnoreVar: String;
  nTokenCount, nInd: Integer;
  sHomeVar: String;
  sIgnoreFile: String;
  oTempList: TStringList;
begin
  // prepare ignore list
  if ourCVSIgnoreList = nil then
    ourCVSIgnoreList.Create
  else
    ourCVSIgnoreList.Clear;

  // at first read contents of environment variable CVSIGNORE
  sIgnoreVar := GetEnv('CVSIGNORE');
  if sIgnoreVar <> '' then begin
    nTokenCount := TokenInit(sIgnoreVar,' ',false);
    for nInd := 0  to nTokenCount-1 do
      ourCVSIgnoreList.Add(Token(nInd+1));
  end;

  // now get contents of user file .cvsignore
  oTempList := TStringList.Create;
  sHomeVar := GetEnv('HOME');
  sIgnoreFile := sHomeVar + '\.cvsignore';
  if FileExists(sIgnoreFile) then begin
    oTempList.LoadFromFile(sIgnoreFile);
    ourCVSIgnoreList.AddStrings(oTempList);
  end;

  // and now look in actual directory
  oTempList.clear;
  sIgnoreFile := aFolder + '\.cvsignore';
  if FileExists(sIgnoreFile) then begin
    oTempList.LoadFromFile(sIgnoreFile);
    ourCVSIgnoreList.AddStrings(oTempList);
  end;
end;

{***********************************
* Check filename for matching ignore
* wildcard
*
* @param aName
***********************************}
Function myCVS.CheckMask(aName: String): Boolean;
var
  nInd: Integer;
begin
  RESULT := false;
  for nInd := 0 to ourCVSIgnoreList.count-1 do begin
    if StrMatch(uppercase(ourCVSIgnoreList.Strings[nInd]),uppercase(aName),'*','?') then begin
      RESULT := true;
      break;
    end;
  end;
end;

Initialization

End.
