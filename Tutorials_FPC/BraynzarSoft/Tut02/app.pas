unit app;

{$mode objfpc}{$H+}

// -----------------------------------------------------------------------------
//
// separate file, extracetd from Tut02.lpr - 2021-04-22
//
// -----------------------------------------------------------------------------


interface

uses
  Interfaces, // this includes the LCL widgetset
  MultiMon,
  JwaWindows,
  //Windows,
  Classes, SysUtils;


var
  // Handle to the window
  aHandle: HWnd = 0;

  // width and height of the window
  Width: integer  = 800;
  Height: integer = 600;

  // is window full screen?
  FullScreen: boolean = False;


function WndProc( aHandle: HWND; msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
function InitializeWindow( {%H-}Instance: PtrUInt; ShowWnd: integer; Width: integer; Height: integer; fullscreen: boolean): boolean;
procedure mainloop();



implementation


function WndProc( aHandle: HWND; msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
    case (msg) of
        WM_KEYDOWN:
        begin
            if (wParam = VK_ESCAPE) then
            begin
                if (MessageBox(0, 'Are you sure you want to exit?', 'Really?', MB_YESNO or MB_ICONQUESTION) = idYes) then
                    DestroyWindow( aHandle);
            end;
            Result := 0;
        end;

        WM_DESTROY:
        begin
            PostQuitMessage(0);
            Result := 0;
        end
        else
            Result := DefWindowProc( aHandle, msg, wParam, lParam);
    end;
end;


function InitializeWindow( {%H-}Instance: PtrUInt; ShowWnd: integer; Width: integer; Height: integer; fullscreen: boolean): boolean;
var
    hMon: HMonitor;
    mi: TMONITORINFO;
    wc: WNDCLASSEXA;//WNDCLASSEXW;
begin
    Result := False;
    if (fullscreen) then
      begin
        hmon := MonitorFromWindow( aHandle, MONITOR_DEFAULTTONEAREST);
        mi.cbSize := sizeof(mi);
        GetMonitorInfo(hmon, @mi);

        Width := mi.rcMonitor.right - mi.rcMonitor.left;
        Height := mi.rcMonitor.bottom - mi.rcMonitor.top;
      end;


    wc.cbSize        := sizeof(WNDCLASSEXW);
    wc.style         := CS_HREDRAW or CS_VREDRAW;
    wc.lpfnWndProc   := @WndProc;
    wc.cbClsExtra    := 0;
    wc.cbWndExtra    := 0;
    wc.hInstance     := hInstance;
    wc.hIcon         := LoadIcon( 0, IDI_APPLICATION);
    wc.hCursor       := LoadCursor( 0, IDC_ARROW);
    wc.hbrBackground := (COLOR_WINDOW + 2);
    wc.lpszMenuName  := nil;
    wc.lpszClassName := pAnsiChar( 'BzTutsApp');
    wc.hIconSm       := LoadIcon( 0, IDI_APPLICATION);

    if (RegisterClassExA(wc) = 0) then
    begin
        MessageBox( 0, 'Error registering class',
                    'Error', MB_OK or MB_ICONERROR);
        Exit;
    end;

    aHandle := CreateWindowA( pAnsiChar( 'BzTutsApp'),   // name of the window (not the title)
                              pAnsiChar( 'Bz Window'),   // title of the window
                              WS_OVERLAPPEDWINDOW,
                              CW_USEDEFAULT,
                              CW_USEDEFAULT,
                              Width,
                              Height,
                              0,
                              0,
                              hInstance,
                              nil);

    if (aHandle = 0) then
    begin
        MessageBox(0, 'Error creating window',
            'Error', MB_OK or MB_ICONERROR);
        Exit;
    end;

    if (fullscreen) then
    begin
        SetWindowLong( aHandle, GWL_STYLE, 0);
    end;

    ShowWindow( aHandle, ShowWnd);
    UpdateWindow( aHandle);

    Result := True;
end;


procedure mainloop();
var
    aMsg: TMSG;
begin
  ZeroMemory( @aMsg, sizeof( MSG));

  while (True) do
    begin
      if (PeekMessage( aMsg, 0, 0, 0, PM_REMOVE)) then
        begin
          if (aMsg.message = WM_QUIT) then
              break;

          TranslateMessage( @aMsg);
          DispatchMessage(@ aMsg);
        end
      else
        begin
            // run game code
        end;
    end;
end;



end.

