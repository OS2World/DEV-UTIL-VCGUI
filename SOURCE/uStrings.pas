{***********************************
 uStrings.pas
 Unit for manipulation of language
 dependent strings
 -----------------------------------
 begin  : Jun 12 2005
 author : Thomas Bohn
 eMail  : Thomas@Bohn-Stralsund.de
 -----------------------------------
 This document and the included
 information are released under
 GPL.
***********************************}
Unit uStrings;

Interface

var
  langStateSeemsActual : String = 'Seems actual';
  langStateActual    : String = 'Actual';
  langStateModified  : String = 'Modified';
  langStateAbsent    : String = 'Absent';
  langStateConflict  : String = 'Conflict';
  langProfileLocal   : String = 'local';
  langProfilePServer : String = 'pserver';
  langProfileUntitled: String = '<untitled>';
  langCVSstart       : String = '---> begin';
  langCVSdone        : String = '---> done';
  langNoCMD          : String = 'Batchfiles are not allowed here !';
  langHistory        : String = 'History';
  langDeleteLocal    : String = 'Local delete of files and/or directories:';
  langDeleteFiles    : String = 'Delete files:';
  langDeleteDir      : String = 'Delete directory:';
  langDelTrue        : String = '-> ok';
  langDelFalse       : String = '-> failed';
  langNoComment      : String = '*** empty log message ***';
  langCVSStartProblem: String = 'cvs start problem';
  langSVNStartProblem: String = 'svn start problem';
  langLoadProgSettings : String = 'Loading program settings...';
  langLoadProjectTree  : String = 'Loading project tree...';
  langSaveProgSettings : String = 'Saving program settings...';
  langSaveProjectTree  : String = 'Saving project tree...';
  langCVSrepoCreated   : String = 'CVS repository created.';

Implementation

Initialization
End.
