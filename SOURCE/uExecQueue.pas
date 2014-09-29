{***********************************
 uExecQueue.pas
 unit for executing programs
***********************************}
Unit uExecQueue;

Interface

Type

  TermQResults = record
    SessionID: WORD;
    ResultCode: WORD;
  end;

Const
  COULD_NOT_START=-7;
  INTERNAL_ERROR=-77;

Var
  DosStartSessionResult: integer;

  Function RunProgram( name, parameters, mode, aType: String ):integer;
  Function RunCommand( command, mode: String ):integer;

Implementation

Uses BseDos, OS2Def, BseErr, Dialogs, SysUtils;

Function RunCommand( command, mode: string ):integer;
Begin
  Result:=RunProgram( 'cmd.exe', '/c '+command, mode, 'VIO' );
End;

Function RunProgram( name, parameters, mode, aType: String ): integer;
Type
  pByte=^BYTE;
Var
  psd:STARTDATA;
  SessID:LONGWORD;
  apid:LONGWORD;
  PgmName:CSTRING;
  ObjBuf:CSTRING;
  rc:Integer;

  Args: CSTRING;

  TerminationQueue:HQueue;
  QueueName: CSTRING;
  QueueRequest: REQUESTDATA;
  DataLength: ULONG;
  DataAddress: ^TermQResults;
  ElementCode: ULONG;
  NoWait: BOOL;
  ElemPriority: BYTE;
  SemHandle: HEV;

Begin
  DosStartSessionResult:=0;

  QueueName:='\QUEUES\SIBYL_EXECUTE_TERMQ';
  rc:= DosCreateQueue( TerminationQueue,
  QUE_FIFO, // normal queue
  QueueName );
  if (rc<>0) then
  begin
  Result:=INTERNAL_ERROR;
  exit;
  end;

  psd.Length := SizeOf( psd );
  psd.Related := SSF_RELATED_CHILD; // Yes we want to know about it
  psd.FgBg := SSF_FGBG_BACK; // run in background
  psd.TraceOpt := SSF_TRACEOPT_NONE; // no tracing!

  PgmName := name; // copy to a cstring
  psd.PgmName := @PgmName; // program
  psd.PgmTitle := @PgmName; // window title

  Args:=parameters; // copy to a cstring
  psd.PgmInputs := @Args; //arguments
  psd.TermQ := @QueueName; // Termination Queue name
  psd.Environment := NIL; // no special environment to pass
  psd.InheritOpt := SSF_INHERTOPT_PARENT;
  // use parent file handles
  // AND (more importantly) parent's current drive and dir
  if aType = 'DEFAULT' then
    psd.SessionType := SSF_TYPE_DEFAULT // whatever the exe says
  else if aType = 'PM' then
    psd.SessionType := SSF_TYPE_PM
  else if aType = 'VIO' then
    psd.SessionType := SSF_TYPE_WINDOWABLEVIO;
  psd.IconFile := NIL; // no icon file
  psd.PgmHandle := 0; // no program handle
  if mode = 'HIDE' then
    psd.PgmControl := SSF_CONTROL_INVISIBLE  // run hided
  else if mode = 'MINIMIZED' then
    psd.PgmControl := SSF_CONTROL_MINIMIZE  // run minimized
  else if mode = 'MAXIMIZED' then
    psd.PgmControl := SSF_CONTROL_MAXIMIZE  // run maximized
  else if mode = 'NORMAL' then
    psd.PgmControl := SSF_CONTROL_VISIBLE;  // run normal
  psd.InitXPos :=0; // position x
  psd.InitYPos :=0; // position y
  psd.Reserved := 0; // blah
  psd.ObjectBuffer := @ObjBuf; // put errors here
  psd.ObjectBuffLen := 100; // up to 100 chars

  rc := DosStartSession( psd, SessID, apid );

  if (rc<>0)
  // but we don't care if it just started in the background!
  and (rc<>ERROR_SMG_START_IN_BACKGROUND)
  then
  begin
  Result:=COULD_NOT_START;
  DosStartSessionResult:=rc;
  DosCloseQueue( TerminationQueue );
  exit;
  end;

  // DosCloseQueue( TerminationQueue );
  // exit;
  ElementCode:=0; // get element at front of queue
  NoWait:=FALSE; // wait for data
  SemHandle:=0; // unused, synchronous call
  rc:= DosReadQueue( TerminationQueue,QueueRequest,DataLength,DataAddress,
  ElementCode,NoWait,ElemPriority,SemHandle );
  // Oh well... if we got something it's probably OK!
  Result:=DataAddress^.ResultCode;
  DosCloseQueue( TerminationQueue );
  // Free the memory used by the queue element
  DosFreeMem( DataAddress );
End;

Initialization
End.
