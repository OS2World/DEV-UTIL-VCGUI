{***********************************
 uAbout.pas
 unit for showing product information
 -----------------------------------
 begin  : Aug 27 2006
 author : Thomas Bohn
 eMail  : Thomas@Bohn-Stralsund.de
 -----------------------------------
 This document and the included
 information are released under
 GPL.
***********************************}
Unit uAbout;

Interface

Uses
  Classes, Forms, Graphics, INet, StdCtrls, Buttons;

Type
  TmyAboutFrm = Class (TForm)
    myProductLbl: TLabel;
    myCloseBtn: TButton;
    myAuthorLbl: TLabel;
    myWebLbl: TLabel;
    myeMailLbl: TLabel;
    myVersionLabel: TLabel;
    myWDSibylLbl: TLabel;
    myWDWebLbl: TLabel;
    Procedure myCloseBtnOnClick (Sender: TObject);
  Private
    {Private Deklarationen hier einfÅgen}
  Public
    {ôffentliche Deklarationen hier einfÅgen}
  End;

Var
  myAboutFrm: TmyAboutFrm;

Implementation

Procedure TmyAboutFrm.myCloseBtnOnClick (Sender: TObject);
Begin
  close;
End;

Initialization
  RegisterClasses ([TmyAboutFrm, TLabel, TButton]);
End.
