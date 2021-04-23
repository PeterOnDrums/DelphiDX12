program Tut02;

//{$mode delphiunicode}
{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
    cthreads, {$ENDIF} {$ENDIF}
    Interfaces, // this includes the LCL widgetset
    MultiMon,
    Windows,
    app;

{$R *.res}


begin
  // create the window
  if (not InitializeWindow( hInstance, SW_SHOW, Width, Height, FullScreen)) then
    begin
      MessageBox( 0, 'Window Initialization - Failed', 'Error', MB_OK);
      Exit;
    end;

    // start the main loop
    mainloop();
end.
