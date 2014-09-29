{***********************************
 Program OS2VC
 -----------------------------------
 begin  : Jan 01 2005
 author : Thomas Bohn
 eMail  : Thomas@Bohn-Stralsund.de
 -----------------------------------
 This document and the included
 information are released under
 GPL.
***********************************}
Program OS2VC;

Uses
  Forms, Graphics, uMain, uProfile, uComment, uHistory, uCheckout, uUpdate,
uImport, uAbout, uTag;

{$r OS2VC.scu}

Begin
  Application.Create;
  Application.CreateForm (TmyOS2CVSfrm, myOS2CVSfrm);
  Application.Run;
  Application.Destroy;
End.
