program Tut04;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
    cthreads, {$ENDIF} {$ENDIF}
    Interfaces, // this includes the LCL widgetset
    MultiMon,
    SysUtils,
    Windows,
    Dialogs,
    App04;

{$R *.res}


begin
    // create the window
    if (not InitializeWindow( hInstance, SW_SHOW, Width, Height, FullScreen)) then
    begin
        MessageBox(0, 'Window Initialization - Failed',
            'Error', MB_OK);
        Exit;
    end;
    // initialize direct3d
    if (not InitD3D()) then
    begin
        MessageBox(0, 'Failed to initialize direct3d 12',
            'Error', MB_OK);
        Cleanup();
        Exit;
    end;


    // start the main loop
    mainloop();

    // we want to wait for the gpu to finish executing the command list before we start releasing everything
    WaitForPreviousFrame();

    // close the fence event
    CloseHandle(fenceEvent);

    // clean up everything
    Cleanup();

end.
