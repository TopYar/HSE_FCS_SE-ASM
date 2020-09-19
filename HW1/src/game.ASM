


;
; controls:
;
; keyboard    gamepad           action
;----------------------------------------
; enter       right bummper     pause
; 1           left bummper      change camera mode
; 2           dpad right        change final shader
; 3           dpad up           increase bloom effects
; 4           dpad down         decrease bloom effects
; wasd        left stick        move
; arrows      right stick       shoot
; left mouse                    shoot
; space       a                 bomb
;
; camera motion:
;   tg : move forward / backward
;   fh : move left / right
;   yn : move up / down
;
; camera rotation:
;   uo : rotate about view direction
;   jl : rotate left / right
;   ik : rotate up / down
;
; camera.inc has more details on the camera modes



format PE GUI 4.0
entry start

include 'win32ax.inc'

include 'opengl.inc'



; controler input
XINPUT_GAMEPAD_DPAD_UP         fix  0x00001
XINPUT_GAMEPAD_DPAD_DOWN       fix  0x00002
XINPUT_GAMEPAD_DPAD_LEFT       fix  0x00004
XINPUT_GAMEPAD_DPAD_RIGHT      fix  0x00008
XINPUT_GAMEPAD_START           fix  0x00010
XINPUT_GAMEPAD_BACK            fix  0x00020
XINPUT_GAMEPAD_LEFT_THUMB      fix  0x00040
XINPUT_GAMEPAD_RIGHT_THUMB     fix  0x00080
XINPUT_GAMEPAD_LEFT_SHOULDER   fix  0x00100
XINPUT_GAMEPAD_RIGHT_SHOULDER  fix  0x00200
XINPUT_GAMEPAD_A               fix  0x01000
XINPUT_GAMEPAD_B               fix  0x02000
XINPUT_GAMEPAD_X               fix  0x04000
XINPUT_GAMEPAD_Y               fix  0x08000

; keyboard input
; buttons
KEYBOARD_PLAYER_MOVE_RIGHT   fix 0x00000001
KEYBOARD_PLAYER_MOVE_LEFT    fix 0x00000002
KEYBOARD_PLAYER_MOVE_UP      fix 0x00000004
KEYBOARD_PLAYER_MOVE_DOWN    fix 0x00000008
KEYBOARD_PLAYER_FIRE_RIGHT   fix 0x00000010
KEYBOARD_PLAYER_FIRE_LEFT    fix 0x00000020
KEYBOARD_PLAYER_FIRE_UP      fix 0x00000040
KEYBOARD_PLAYER_FIRE_DOWN    fix 0x00000080
KEYBOARD_PLAYER_BOMB         fix 0x00000100
KEYBOARD_CAMERA_MOVE_RIGHT   fix 0x00010000
KEYBOARD_CAMERA_MOVE_LEFT    fix 0x00020000
KEYBOARD_CAMERA_MOVE_UP      fix 0x00040000
KEYBOARD_CAMERA_MOVE_DOWN    fix 0x00080000
KEYBOARD_CAMERA_MOVE_BACK    fix 0x00100000
KEYBOARD_CAMERA_MOVE_FORWARD fix 0x00200000
KEYBOARD_CAMERA_ROT_UP       fix 0x01000000
KEYBOARD_CAMERA_ROT_DOWN     fix 0x02000000
KEYBOARD_CAMERA_ROT_LEFT     fix 0x04000000
KEYBOARD_CAMERA_ROT_RIGHT    fix 0x08000000
KEYBOARD_CAMERA_ROT_CCW      fix 0x10000000
KEYBOARD_CAMERA_ROT_CW       fix 0x20000000
; numbers
KEYBOARD_KEY_1               fix 0x00000002
KEYBOARD_KEY_2               fix 0x00000004
KEYBOARD_KEY_3               fix 0x00000008
KEYBOARD_KEY_4               fix 0x00000010
; misc
KEYBOARD_KEY_RETURN          fix 0x00000001

; mouse input
MOUSE_LBUTTON                fix 0x00000001
MOUSE_RBUTTON                fix 0x00000002




GAMEMODE_START     fix 1
GAMEMODE_PLAY      fix 2
GAMEMODE_COLLISION fix 3

CAMERA_MODE_ABOVE fix 0
CAMERA_MODE_FREE  fix 1
CAMERA_MODE_FIRST fix 2




;; these can be changed within reason ;;;;;;;;
FPS               fix 64.0
WINDOW_WIDTH      fix 900
WINDOW_HEIGHT     fix 600
WINDOW_WIDTH_FP   fix '900.0'
WINDOW_HEIGHT_FP  fix '600.0'
PLAY_WIDTH        fix 16*8*16
PLAY_HEIGHT       fix 16*8*12
GRID_SPACING      fix 16
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




GRID_WIDTH  = PLAY_WIDTH/GRID_SPACING
GRID_HEIGHT = PLAY_HEIGHT/GRID_SPACING

AA_LEVEL          fix 2




; particles

PAR_DAMPING       fix 0.96
PAR_CHOP          fix 0.5
PAR_MAXCOUNT      fix 4096*2
EXP_MAXCOUNT      fix 256
TAILPAR_MAXCOUNT  fix 256


; grid

;GRID_Z              fix  -40.0
GRID_MDAMPING       fix +0.980; +0.950
GRID_MK             fix -0.001; -0.004
GRID_SDAMPING       fix +0.005; +0.150
GRID_SSTIFFNESS     fix -1.000; -0.450
GRID_EDAMPING       fix +0.900; +0.900
GRID_COLOR_DAMPING  fix +0.80

ENEMY_HEIGHT        fix  32.0




; dep

DEP_MAXCOUNT    fix 64

; player

START_PAR_MINR     fix 128.0
START_PAR_DELTAR   fix 0.001
START_PAR_MINS     fix 15.0
START_PAR_DELTAS   fix 0.0005
START_PAR_COUNT    fix 48

PLAYER_SHIELD_R     fix 40008.0
PLAYER_SPEED        fix 7.0
PLAYER_HR           fix 1000.0
PLAYER_GR                    fix 32.0
PLAYER_TURN_SPEED            fix -0.01
PLAYER_TURN_SPEED_CONTROLER  fix -0.0000015
PLAYER_CAMERA_FIRST_D        fix +0.0007


PLAYER_EXP_MINS     fix 0.5
PLAYER_EXP_DELTAS   fix 00.0001
PLAYER_EXP_COUNT    fix 96
PLAYER_EXP_MAXCOUNT fix 128

PLAYER_PAR_MINR     fix 10.0
PLAYER_PAR_DELTAR   fix 0.00001
PLAYER_PAR_MINS     fix 20.0
PLAYER_PAR_DELTAS   fix 0.0005
PLAYER_PAR_COUNT    fix 2000


; shot

SHOT_MAXCOUNT  fix 2560

SHOT_SPEED        fix 1200.0
SHOT_HR           fix 80.0
SHOT_GR           fix 16.0

SHOT_EXP_MINR     fix 0.0
SHOT_EXP_DELTAR   fix 00.0012
SHOT_EXP_MINS     fix 05.0
SHOT_EXP_DELTAS   fix 00.00001
SHOT_EXP_COUNT    fix 8

; geom

GEOM_MAXCOUNT fix 256
GEOM_HR       fix 200.0


; windmill

WINDMILL_COLOR             fix 45
WINDMILL_COLOR_AVOID       fix 10
WINDMILL_COLOR_AVOID_WIDTH fix 3

WINDMILL_SPEED           fix 3.0
WINDMILL_GR              fix 64.0
WINDMILL_HR              fix 250.0
WINDMILL_MAXCOUNT        fix 128
WINDMILL_SPAWN_MAXCOUNT  fix 128

WINDMILL_PAR_MINR     fix 3.0
WINDMILL_PAR_DELTAR   fix 0.0001
WINDMILL_PAR_MINS     fix 18.0
WINDMILL_PAR_DELTAS   fix 0.0001
WINDMILL_PAR_COUNT    fix 400

WINDMILL_EXP_MINS     fix 0.5
WINDMILL_EXP_DELTAS   fix 00.0001
WINDMILL_EXP_COUNT    fix 32
WINDMILL_EXP_MAXCOUNT fix 1024

WINDMILL_POINTS       fix 1

; diamond

DIAMOND_COLOR             fix 37
DIAMOND_COLOR_AVOID       fix 8
DIAMOND_COLOR_AVOID_WIDTH fix 3

DIAMOND_SPEED            fix 3.0
DIAMOND_GR               fix 64.0
DIAMOND_HR               fix 250.0
DIAMOND_MAXCOUNT         fix 512
DIAMOND_SPAWN_MAXCOUNT   fix 32

DIAMOND_PAR_MINR     fix 0.0
DIAMOND_PAR_DELTAR   fix 0.0000
DIAMOND_PAR_MINS     fix 20.0
DIAMOND_PAR_DELTAS   fix 0.00008
DIAMOND_PAR_COUNT    fix 400

DIAMOND_EXP_MINS     fix 1.5
DIAMOND_EXP_DELTAS   fix 00.0001
DIAMOND_EXP_COUNT    fix 24
DIAMOND_EXP_MAXCOUNT fix 512

DIAMOND_POINTS       fix 2

; weaver

WEAVER_COLOR             fix 20
WEAVER_COLOR_AVOID       fix 5
WEAVER_COLOR_AVOID_WIDTH fix 3

WEAVER_SPEED           fix 4.5
WEAVER_GR              fix 64.0
WEAVER_HR              fix 250.0
WEAVER_MAXCOUNT        fix 256
WEAVER_SPAWN_MAXCOUNT  fix 32

WEAVER_PAR_MINR     fix 0.0
WEAVER_PAR_DELTAR   fix 0.0000
WEAVER_PAR_MINS     fix 18.0
WEAVER_PAR_DELTAS   fix 0.00015
WEAVER_PAR_COUNT    fix 400

WEAVER_EXP_MINS     fix 0.5
WEAVER_EXP_DELTAS   fix 00.0001
WEAVER_EXP_COUNT    fix 24
WEAVER_EXP_MAXCOUNT fix 512

WEAVER_POINTS       fix 4

; wander

WANDER_COLOR             fix 59
WANDER_COLOR_AVOID       fix 59
WANDER_COLOR_AVOID_WIDTH fix 32

WANDER_SPEED           fix 3.0
WANDER_GR              fix 64.0
WANDER_HR              fix 250.0
WANDER_MAXCOUNT        fix 128
WANDER_SPAWN_MAXCOUNT  fix 32

WANDER_PAR_MINR     fix 3.0
WANDER_PAR_DELTAR   fix 0.0001
WANDER_PAR_MINS     fix 20.0
WANDER_PAR_DELTAS   fix 0.00005
WANDER_PAR_COUNT    fix 400

WANDER_EXP_MINS     fix 1.5
WANDER_EXP_DELTAS   fix 00.0001
WANDER_EXP_COUNT    fix 32
WANDER_EXP_MAXCOUNT fix 512

WANDER_POINTS       fix 3


; snake

SNAKE_COLOR        fix 41
SNAKETAIL_COLOR    fix 7

SNAKE_COLOR_AVOID       fix 1
SNAKE_COLOR_AVOID_WIDTH fix 3

SNAKE_SPEED           fix 5.0
SNAKE_GR              fix 64.0
SNAKE_HR              fix 200.0
SNAKE_MAXCOUNT        fix 32
SNAKE_SPAWN_MAXCOUNT  fix 4

SNAKE_PAR_MINR     fix 3.0
SNAKE_PAR_DELTAR   fix 0.0002
SNAKE_PAR_MINS     fix 18.0
SNAKE_PAR_DELTAS   fix 0.0001
SNAKE_PAR_COUNT    fix 300

SNAKE_EXP_MINS     fix 0.5
SNAKE_EXP_DELTAS   fix 00.0001
SNAKE_EXP_COUNT    fix 32
SNAKEHEAD_EXP_MAXCOUNT fix 128
SNAKETAIL_EXP_MAXCOUNT fix 512

SNAKE_POINTS       fix 3

SNAKETAIL_PAR_MINR     fix 3.0
SNAKETAIL_PAR_DELTAR   fix 0.0002
SNAKETAIL_PAR_MINS     fix 6.0
SNAKETAIL_PAR_DELTAS   fix 0.0001
SNAKETAIL_PAR_COUNT    fix 24

SNAKETAIL_EXP_MINS     fix 0.5
SNAKETAIL_EXP_DELTAS   fix 00.0001
SNAKETAIL_EXP_COUNT    fix 4




; gate

GATE_MAXCOUNT         fix 32
GATE_SPAWN_MAXCOUNT   fix 16
GATE_EXP_MAXCOUNT     fix 256
GATE_HR               fix 200.0

GATE_PAR_MINR         fix 0.0
GATE_PAR_DELTAR       fix 0.0
GATE_PAR_MINS         fix 10.0
GATE_PAR_DELTAS       fix 0.000005
GATE_PAR_COUNT        fix 320



; bomb

BOMB_MAXCOUNT         fix 16


; blackhole

BLACKHOLE_PAR_MINR        fix 16.0
BLACKHOLE_PAR_DELTAR      fix 00.0012
BLACKHOLE_PAR_MINS        fix 10.0
BLACKHOLE_PAR_DELTAS      fix 0.0001
BLACKHOLE_PAR_COUNT       fix 256

BLACKHOLE_SCALE1          fix 0.000370
BLACKHOLE_SCALE2          fix 0.000015
BLACKHOLE_ANGLEOFFSET     fix 60
BLACKHOLE_MAXHEALTH       fix 10
BLACKHOLE_ORBIT_COUNT     fix 8
BLACKHOLE_GR              fix 32.0
BLACKHOLE_MAXCOUNT        fix 16
BLACKHOLE_SPAWN_MAXCOUNT  fix 4
BLACKHOLE_EXP_MAXCOUNT    fix 64



struct OBJ1     ; must be 32 bytes
   px   dd ?
   py   dd ?
   nx   dd ?    ; normalized
   ny   dd ?    ;
   vx   dd ?      ; velocity
   vy   dd ?      ;
   hr   dd ?
   gr   dd ?
ends

struct OBJ2     ; must be 32 bytes
   px   dd ?
   py   dd ?
   nx   dd ?
   ny   dd ?
   vx   dd ?
   vy   dd ?
   ct   dd ?     ; ticks to remain alive
   gr   dd ?
ends




section '.text' code readable executable

  start:
                        mov  eax,1
                      cpuid
                       test  ecx,0x00000001
                        jnz  @f
                     invoke  MessageBox,0,NoSSE3ErrorMessage,0,MB_OK
                     invoke  ExitProcess,0
              @@:


                       push  WINDOW_WIDTH
                       fild  dword[esp]
                       fstp  dword[WindowWidth]

                       push  WINDOW_HEIGHT
                       fild  dword[esp]
                       fstp  dword[WindowHeight]

                       push  PLAY_WIDTH
                       fild  dword[esp]
                        fst  dword[Corner.x]
                       fstp  dword[PlayWidth]

                       push  PLAY_HEIGHT
                       fild  dword[esp]
                        fst  dword[Corner.y]
                       fstp  dword[PlayHeight]

                       push  WINDOW_WIDTH
                       fild  dword[esp]
                       push  WINDOW_HEIGHT
                       fild  dword[esp]
                     fdivrp  st1,st0
                       fmul  dword[CameraField.x]
                       fstp  dword[CameraField.x]
                        add  esp,4*4

                      rdtsc
                         or  edx,1
                        mov  dword[RandSeed+4*2],eax
                        mov  dword[RandSeed+4*3],edx


                       push  PLAY_HEIGHT
                       fild  dword[esp]
                       fmul  dword[const_f4_1d2]
                       push  PLAY_WIDTH
                       fild  dword[esp]
                       fmul  dword[const_f4_1d2]
                        add  esp,8
                       fstp  dword[Player.px]
                       fstp  dword[Player.py]
                        mov  dword[Player.nx],0.0
                        mov  dword[Player.ny],-1.0
                        mov  dword[Player.vx],PLAYER_SPEED
                        mov  dword[Player.vy],PLAYER_SPEED
                        mov  dword[Player.hr],PLAYER_HR
                        mov  dword[Player.gr],PLAYER_GR

                        mov  dword[GameMode],GAMEMODE_START
                        mov  dword[GameModeStartCount],100
                        mov  dword[CameraMode],CAMERA_MODE_ABOVE



                     invoke  GetModuleHandle,0
                        mov  [wc.hInstance],eax
                     invoke  LoadIcon,0,IDI_APPLICATION
                        mov  [wc.hIcon],eax
                     invoke  LoadCursor,0,IDC_ARROW
                        mov  [wc.hCursor],eax
                     invoke  RegisterClass,wc
                     invoke  CreateWindowEx,0,_class,_title,WS_VISIBLE+WS_OVERLAPPEDWINDOW+WS_CLIPCHILDREN+WS_CLIPSIBLINGS,16,16,432,432,NULL,NULL,[wc.hInstance],NULL
                        mov  [hwnd],eax
                       call  CorrectMainWindowSize


                     invoke  LoadLibraryA,'XINPUT9_1_0.dll'
                       test  eax,eax
                         jz  @f
                     invoke  GetProcAddress,eax,'XInputGetState'
                       test  eax,eax
                         jz  @f
                        mov  [XInputGetState],eax
                @@:



                     invoke  QueryPerformanceFrequency,Frequency
                       call  SetTargetFPS

                       call  Grid_Initialize
                       call  GLInit

                       test  eax,eax
                        jnz  @f
                     invoke  SendMessage,[hwnd],WM_DESTROY,NULL,NULL
                        jmp  .EndLoop
                @@:


                     invoke  CreateEvent,NULL,FALSE,FALSE,NULL
                        mov  dword[Worker1Start],eax
                     invoke  CreateThread,NULL,0,Worker1,NULL,0,NULL
                        mov  dword[Worker1Handle],eax

                     invoke  CreateEvent,NULL,FALSE,FALSE,NULL
                        mov  dword[Worker2Start],eax
                     invoke  CreateThread,NULL,0,Worker2,NULL,0,NULL
                        mov  dword[Worker2Handle],eax


.SetAffinities:
                     invoke  GetCurrentProcess
                     invoke  GetProcessAffinityMask,eax,ProcessAffinityMask,SystemAffinityMask


                        mov  eax,[ProcessAffinityMask]
                       test  eax,eax
                         jz  .done

                        mov  ebx,eax
                        sub  eax,1
                        and  eax,ebx
                        xor  ebx,eax
                        mov  [Pro1Mask],eax
                       test  eax,eax
                         jz  .done

                        mov  ebx,eax
                        sub  eax,1
                        and  eax,ebx
                        xor  ebx,eax
                        mov  [Pro2Mask],eax
                       test  eax,eax
                         jz  .done

                        mov  ebx,eax
                        sub  eax,1
                        and  eax,ebx
                        xor  ebx,eax
                        mov  [Pro3Mask],eax

                      invoke  SetThreadAffinityMask,[Worker2Handle],[Pro1Mask]
                      invoke  SetThreadAffinityMask,[Worker1Handle],[Pro3Mask]

.done:




  .MsgLoop:          invoke  PeekMessage,msg,NULL,0,0,PM_REMOVE
                       test  eax,eax
                         jz  .DoRender
  .DoMsg:               cmp  [msg.message],WM_QUIT
                         je  .EndLoop
                     invoke  TranslateMessage,msg
                     invoke  DispatchMessage,msg
  .DoRender:
                     invoke  QueryPerformanceCounter,Tick
                        mov  ebx,dword[Tick+4*0]
                        mov  edx,dword[Tick+4*1]
                        mov  eax,ebx
                        mov  ecx,edx
                        sub  ebx,dword[ExpectedTick+4*0]
                        sbb  edx,dword[ExpectedTick+4*1]
                         jb  .MsgLoop
                        add  eax,dword[TickIncrement+4*0]
                        adc  ecx,dword[TickIncrement+4*1]
                        mov  dword[ExpectedTick+4*0],eax
                        mov  dword[ExpectedTick+4*1],ecx


                        mov  ecx,(StateEnd-State+64)/64
                        mov  esi,State
                        mov  edi,StateCopy
                @@:  movaps  xmm0,[esi+16*0]
                     movaps  xmm1,[esi+16*1]
                     movaps  xmm2,[esi+16*2]
                     movaps  xmm3,[esi+16*3]
                     movaps  [edi+16*0],xmm0
                     movaps  [edi+16*1],xmm1
                     movaps  [edi+16*2],xmm2
                     movaps  [edi+16*3],xmm3
                        add  esi,64
                        add  edi,64
                        sub  ecx,1
                        jnz  @b

                     movaps  xmm0,dqword[xstate]
                     movaps  dqword[xstate2],xmm0
                     invoke  XInputGetState,0,xstate

                        cmp  dword[PausedQ],0
                        jne  .paused

                        add  dword[FrameCount],1

                        cmp  [GameMode],GAMEMODE_PLAY
                         je  GameModePlay
                        cmp  [GameMode],GAMEMODE_START
                         je  GameModeStart
                        cmp  [GameMode],GAMEMODE_COLLISION
                         je  GameModeCollision

                     invoke  Sleep,10
                        jmp  start.MsgLoop

        .paused:
                       call  DrawGame
                       call  HandlePauseButton
                       call  HandleShaderButton
                       call  HandleBloomButton
                        jmp  start.MsgLoop



  .EndLoop:

                     invoke  ExitProcess,[msg.wParam]

EmptyFunction:
                        ret







GameModePlay:
GameModeStart:
GameModeCollision:
                     invoke  SetEvent,[Worker1Start]
                     invoke  SetEvent,[Worker2Start]
                       call  DrawGame
                       call  HandlePauseButton
                       call  HandleShaderButton
                       call  HandleBloomButton
                        jmp  start.MsgLoop







Worker1:
                     invoke  WaitForSingleObject,[Worker1Start],-1
                     invoke  QueryPerformanceCounter,Worker1Time1

                        mov  eax,EmptyFunction
                        mov  ecx,Worker1_GameModePlay
                        cmp  dword[GameMode],GAMEMODE_PLAY
                      cmove  eax,ecx
                        mov  ecx,Worker1_GameModeStart
                        cmp  dword[GameMode],GAMEMODE_START
                      cmove  eax,ecx
                        mov  ecx,Worker1_GameModeCollision
                        cmp  dword[GameMode],GAMEMODE_COLLISION
                      cmove  eax,ecx
                       call  eax

                     invoke  QueryPerformanceCounter,Worker1Time2
                       push  eax
                       fild  qword[Frequency]
                       fild  qword[Worker1Time2]
                       fild  qword[Worker1Time1]
                      fsubp  st1,st0
                      fdivp  st1,st0
                      fistp  dword[esp]
                        pop  eax
                        mov  [PhysicsRate],eax

                        jmp  Worker1




Worker1_GameModePlay:

                       call  Par_Update
                       call  Dep_Update
                       call  Bomb_Update
                       call  Shot_Update
                       call  Geom_Update

                       push  PlayerExpCount
                       push  PlayerExpTable
                       call  Exp_Update


              ;         call  Windmill_Spawn
                       call  Windmill_Update
                       call  WindmillSpawn_Update
                       push  WindmillExpCount
                       push  WindmillExpTable
                       call  Exp_Update

                       call  Diamond_Spawn
                       call  Diamond_Update
                       call  DiamondSpawn_Update
                       push  DiamondExpCount
                       push  DiamondExpTable
                       call  Exp_Update

              ;         call  Weaver_Spawn
                       call  Weaver_Update
                       call  WeaverSpawn_Update
                       push  WeaverExpCount
                       push  WeaverExpTable
                       call  Exp_Update

              ;         call  Wander_Spawn
                       call  Wander_Update
                       call  WanderSpawn_Update
                       push  WanderExpCount
                       push  WanderExpTable
                       call  Exp_Update

                       call  Snake_Spawn
                       call  Snake_Update
                       call  SnakeSpawn_Update
                       push  SnakeHeadExpCount
                       push  SnakeHeadExpTable
                       call  Exp_Update
                       push  SnakeTailExpCount
                       push  SnakeTailExpTable
                       call  Exp_Update

                       call  Gate_Spawn
                       call  Gate_Update
                       call  GateSpawn_Update


                       call  PlayerFire_Update
                       call  Player_Update



                       call  GetRand.word
                        xor  ecx,ecx
                       test  eax,0x03F
                       setz  cl
                        add  ecx,dword[ParColor]
                        and  ecx,15
                        mov  dword[ParColor],ecx



                        mov  eax,[FrameCount]
                        shr  eax,4
                        and  eax,64-1
                        mov  [ParColorCount],eax


                        cmp  dword[PlayerAliveQ],0
                         je  .ToCollision

                        mov  dword[GameMode],GAMEMODE_PLAY
                        ret

              .ToCollision:

                        mov  dword[GameMode],GAMEMODE_COLLISION
                        mov  dword[GameModeCollisionCount],128
                        ret



Worker1_GameModeStart:
                       push  dword[ParColorCount]
                        mov  dword[ParColorCount],-1
                      movsd  xmm4,qword[Player.px]
                       push  0.0
                       push  10
                       push  0 0 0 0 0 0
                       push  START_PAR_MINR
                       push  START_PAR_DELTAR
                       push  START_PAR_MINS
                       push  START_PAR_DELTAS
                       push  START_PAR_COUNT
                       call  ReleaseExplosion
                        pop  dword[ParColorCount]

                       push  WindmillExpCount
                       push  WindmillExpTable
                       call  Exp_Update

                       push  DiamondExpCount
                       push  DiamondExpTable
                       call  Exp_Update

                       push  WeaverExpCount
                       push  WeaverExpTable
                       call  Exp_Update

                       push  WanderExpCount
                       push  WanderExpTable
                       call  Exp_Update

                       call  SnakeDead_Update
                       push  SnakeHeadExpCount
                       push  SnakeHeadExpTable
                       call  Exp_Update
                       push  SnakeTailExpCount
                       push  SnakeTailExpTable
                       call  Exp_Update

                       call  Par_Update
                       call  Dep_Update
                       call  Bomb_Update
                       call  Shot_Update
                       call  Geom_Update

                        mov  eax,[GameModeStartCount]
                        sub  eax,1
                         js  .ToPlay
                        mov  dword[GameMode],GAMEMODE_START
                        mov  dword[GameModeStartCount],eax
                        ret
      .ToPlay:
                        mov  dword[GameMode],GAMEMODE_PLAY
                        ret



Worker1_GameModeCollision:

                       push  PlayerExpCount
                       push  PlayerExpTable
                       call  Exp_Update

                       call  WindmillSpawn_Update
                       push  WindmillExpCount
                       push  WindmillExpTable
                       call  Exp_Update

                       call  DiamondSpawn_Update
                       push  DiamondExpCount
                       push  DiamondExpTable
                       call  Exp_Update

                       call  WeaverSpawn_Update
                       push  WeaverExpCount
                       push  WeaverExpTable
                       call  Exp_Update

                       call  WanderSpawn_Update
                       push  WanderExpCount
                       push  WanderExpTable
                       call  Exp_Update

                       call  SnakeDead_Update
                       push  SnakeHeadExpCount
                       push  SnakeHeadExpTable
                       call  Exp_Update
                       push  SnakeTailExpCount
                       push  SnakeTailExpTable
                       call  Exp_Update

                       call  Par_Update
                       call  Dep_Update
                       call  Bomb_Update
                       call  Shot_Update
                       call  Geom_Update

                        mov  eax,[GameModeCollisionCount]
                        sub  eax,1
                         js  .ToPlay
                        mov  dword[GameMode],GAMEMODE_COLLISION
                        mov  dword[GameModeCollisionCount],eax
                        ret
      .ToPlay:
                        mov  dword[PlayerAliveQ],-1
                        mov  dword[PlayerShieldCount],256
                        mov  dword[GameMode],GAMEMODE_PLAY
                        ret



Worker2:
                     invoke  WaitForSingleObject,[Worker2Start],-1
                     invoke  QueryPerformanceCounter,Worker2Time1
                       call  GridBackgroundColors
                       call  Grid_Update
                     invoke  QueryPerformanceCounter,Worker2Time2
                       push  eax
                       fild  qword[Frequency]
                       fild  qword[Worker2Time2]
                       fild  qword[Worker2Time1]
                      fsubp  st1,st0
                      fdivp  st1,st0
                      fistp  dword[esp]
                        pop  eax
                        mov  [GridRate],eax
                        jmp  Worker2








DrawGame:
                     invoke  glEnable,GL_TEXTURE_2D
                     invoke  glUseProgram,0

                     invoke  QueryPerformanceCounter,Time1


; camera matrices
                     invoke  glViewport,0,0,AA_LEVEL*WINDOW_WIDTH,AA_LEVEL*WINDOW_HEIGHT
                       call  SetCameraMatrices
                     invoke  glColor4f,1.0,1.0,1.0,1.0

                      ; fb = objects
                     invoke  glBindTexture,GL_TEXTURE_2D,0
                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,[FBOB2]
                     invoke  glClear,GL_COLOR_BUFFER_BIT

                     invoke  glBlendFunc,GL_ONE,GL_ONE
                       call  Geom_Draw

                     invoke  glBindTexture,GL_TEXTURE_2D,[WindmillExpTexture]
                       push  [WindmillExpCount+CopyOffset]
                       push  WindmillExpTable+CopyOffset
                       call  Exp_Draw

                     invoke  glBindTexture,GL_TEXTURE_2D,[DiamondExpTexture]
                       push  [DiamondExpCount+CopyOffset]
                       push  DiamondExpTable+CopyOffset
                       call  Exp_Draw

                     invoke  glBindTexture,GL_TEXTURE_2D,[WeaverExpTexture]
                       push  [WeaverExpCount+CopyOffset]
                       push  WeaverExpTable+CopyOffset
                       call  Exp_Draw

                     invoke  glBindTexture,GL_TEXTURE_2D,[WanderExpTexture]
                       push  [WanderExpCount+CopyOffset]
                       push  WanderExpTable+CopyOffset
                       call  Exp_Draw

                     invoke  glBindTexture,GL_TEXTURE_2D,[SnakeHeadExpTexture]
                       push  [SnakeHeadExpCount+CopyOffset]
                       push  SnakeHeadExpTable+CopyOffset
                       call  Exp_Draw

                     invoke  glBindTexture,GL_TEXTURE_2D,[SnakeTailExpTexture]
                       push  [SnakeTailExpCount+CopyOffset]
                       push  SnakeTailExpTable+CopyOffset
                       call  Exp_Draw

                     invoke  glBindTexture,GL_TEXTURE_2D,[PlayerExpTexture]
                       push  [PlayerExpCount+CopyOffset]
                       push  PlayerExpTable+CopyOffset
                       call  Exp_Draw


                       call  Bomb_Draw
                       call  Shot_Draw

                       call  WindmillSpawn_Draw
                       call  DiamondSpawn_Draw
                       call  WeaverSpawn_Draw
                       call  WanderSpawn_Draw
                       call  SnakeSpawn_Draw
                       call  GateSpawn_Draw

                       call  Windmill_Draw
                       call  Diamond_Draw
                       call  Weaver_Draw
                       call  Wander_Draw
                       call  Snake_Draw
                       call  Gate_Draw

                       call  Player_Draw


                      ; fa = particles
                     invoke  glBindTexture,GL_TEXTURE_2D,0
                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,[FBOA2]
                     invoke  glClear,GL_COLOR_BUFFER_BIT
                     invoke  glBlendFunc,GL_ONE,GL_ONE

                       call  Par_Draw_VBO
                       call  TailPar_Draw_VBO

                       call  Grid_Draw_VBO
                       call  GridBackground_Draw


; identity matrices
                     invoke  glMatrixMode, GL_PROJECTION
                     invoke  glLoadIdentity
                     invoke  glMatrixMode,GL_MODELVIEW
                     invoke  glLoadIdentity

                     invoke  glViewport,0,0,WINDOW_WIDTH,WINDOW_HEIGHT

                     invoke  glColor4f,1.0,1.0,1.0,1.0

                     invoke  glUseProgram,[AAProgram]

                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,[FBOA]
                     invoke  glBindTexture,GL_TEXTURE_2D,[TexA2]
                     invoke  glBlendFunc,GL_ONE,GL_ZERO
                       call  FullScreenQuad

                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,[FBOB]
                     invoke  glBindTexture,GL_TEXTURE_2D,[TexB2]
                     invoke  glBlendFunc,GL_ONE,GL_ZERO
                       call  FullScreenQuad



     ; lets bloom the objects

                        cmp  byte[ObjectBloomLevel],0
                         je  .ObjectBloomDone

                  ; fc = blurV(fb)
                     invoke  glUseProgram,[BVerProgram]
                     invoke  glBlendFunc,GL_ONE,GL_ZERO
                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,[FBOC]
                     invoke  glBindTexture,GL_TEXTURE_2D,[TexB]
                       call  FullScreenQuad

                  ; fd = blurH(fc)
                     invoke  glUseProgram,[BHorProgram]
                     invoke  glBlendFunc,GL_ONE,GL_ZERO
                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,[FBOD]
                     invoke  glBindTexture,GL_TEXTURE_2D,[TexC]
                       call  FullScreenQuad

                        cmp  byte[ObjectBloomLevel],1
                         je  .ObjectBloomAdd

                  ; fc = blurV(fd)
                     invoke  glUseProgram,[bBVerProgram]
                     invoke  glBlendFunc,GL_ONE,GL_ZERO
                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,[FBOC]
                     invoke  glBindTexture,GL_TEXTURE_2D,[TexD]
                       call  FullScreenQuad

                  ; fd = fd + blurH(fc)
                     invoke  glUseProgram,[bBHorProgram]
                     invoke  glBlendFunc,GL_ONE,GL_ONE
                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,[FBOD]
                     invoke  glBindTexture,GL_TEXTURE_2D,[TexC]
                       call  FullScreenQuad

    .ObjectBloomAdd:
                  ; fb = fb + fd
                     invoke  glUseProgram,0
                     invoke  glBlendFunc,GL_ONE,GL_ONE
                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,[FBOB]
                     invoke  glBindTexture,GL_TEXTURE_2D,[TexD]
                       call  FullScreenQuad

    .ObjectBloomDone:





     ; lets bloom the particles

                        cmp  byte[ParticleBloomLevel],0
                         je  .ParticleBloomDone

                  ; fd = fa * alpha
                     invoke  glUseProgram,[ClipAProgram]
                     invoke  glBlendFunc,GL_SRC_ALPHA,GL_ZERO
                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,[FBOD]
                     invoke  glBindTexture,GL_TEXTURE_2D,[TexA]
                       call  FullScreenQuad

                  ; fc = blurV(fd)
                     invoke  glUseProgram,[VerProgram]
                     invoke  glBlendFunc,GL_ONE,GL_ZERO
                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,[FBOC]
                     invoke  glBindTexture,GL_TEXTURE_2D,[TexD]
                       call  FullScreenQuad

                        cmp  byte[ParticleBloomLevel],1
                         je  .ParticleBloomAdd

                  ; fd = blurH(fc)
                     invoke  glUseProgram,[HorProgram]
                     invoke  glBlendFunc,GL_ONE,GL_ZERO
                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,[FBOD]
                     invoke  glBindTexture,GL_TEXTURE_2D,[TexC]
                       call  FullScreenQuad

                  ; fc = blurV(fd)
                     invoke  glUseProgram,[bVerProgram]
                     invoke  glBlendFunc,GL_ONE,GL_ZERO
                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,[FBOC]
                     invoke  glBindTexture,GL_TEXTURE_2D,[TexD]
                       call  FullScreenQuad

                  ; fd = fd + blurH(fc)
                     invoke  glUseProgram,[bHorProgram]
                     invoke  glBlendFunc,GL_ONE,GL_ONE
                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,[FBOD]
                     invoke  glBindTexture,GL_TEXTURE_2D,[TexC]
                       call  FullScreenQuad

    .ParticleBloomAdd:

                  ; fa = fa + fd
                     invoke  glUseProgram,0
                     invoke  glBlendFunc,GL_ONE,GL_ONE
                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,[FBOA]
                     invoke  glBindTexture,GL_TEXTURE_2D,[TexD]
                       call  FullScreenQuad

    .ParticleBloomDone:





                  ; fa = fb + (1-alpha) fa
                     invoke  glUseProgram,[ClipAProgram]
                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,[FBOA]
                     invoke  glBlendFunc,GL_ONE,GL_ONE_MINUS_SRC_ALPHA
                     invoke  glBindTexture,GL_TEXTURE_2D,[TexB]
                       call  FullScreenQuad

                     invoke  glUseProgram,0
                     invoke  glBlendFunc,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA
                       call  PrintStats

                  ; f0 =  fa + f0
                        mov  eax,dword[ShaderMode]
                        mov  eax,dword[ShaderModes+4*eax]
                     invoke  glUseProgram,dword[eax]
                     invoke  glBindFramebuffer,GL_FRAMEBUFFER,0
                     invoke  glEnable,GL_TEXTURE_2D
                     invoke  glBlendFunc,GL_ONE,GL_ZERO
                     invoke  glBindTexture,GL_TEXTURE_2D,[TexA]
                       call  FullScreenQuad


                     invoke  SwapBuffers,[hdc]
                     invoke  QueryPerformanceCounter,Time2

                       push  eax
                       fild  qword[Frequency]
                       fild  qword[Time2]
                       fild  qword[Time1]
                      fsubp  st1,st0
                      fdivp  st1,st0
                      fistp  dword[esp]
                        pop  eax
                        mov  [RenderRate],eax

                        ret


FullScreenQuad:
                     invoke  glBegin,GL_QUADS
                     invoke  glTexCoord2f,0.0,0.0
                     invoke  glVertex2f,-1.0,-1.0;[Ortho.left]
                     invoke  glTexCoord2f,0.0,1.0
                     invoke  glVertex2f,-1.0,+1.0;[Ortho.left],[Ortho.top]
                     invoke  glTexCoord2f,1.0,1.0
                     invoke  glVertex2f,+1.0,+1.0;[Ortho.right],[Ortho.top]
                     invoke  glTexCoord2f,1.0,0.0
                     invoke  glVertex2f,+1.0,-1.0;[Ortho.right],[Ortho.bottom]
                     invoke  glEnd
                        ret







                      align  16
PrintOBJ1:
                     invoke  glTexCoord2f,0.0,0.0
                        sub  esp,4*2
                       fldz
                       fsub  dword[edi+4*0]
                       fsub  dword[edi+4*1]
                       fmul  dword[esi+OBJ1.gr]
                       fadd  dword[esi+OBJ1.px]
                       fstp  dword[esp+4*0]
                       fldz
                       fadd  dword[edi+4*0]
                       fsub  dword[edi+4*1]
                       fmul  dword[esi+OBJ1.gr]
                       fadd  dword[esi+OBJ1.py]
                       fstp  dword[esp+4*1]
                     invoke  glVertex2f

                     invoke  glTexCoord2f,1.0,0.0
                        sub  esp,4*2
                       fldz
                       fsub  dword[edi+4*0]
                       fadd  dword[edi+4*1]
                       fmul  dword[esi+OBJ1.gr]
                       fadd  dword[esi+OBJ1.px]
                       fstp  dword[esp+4*0]
                       fldz
                       fsub  dword[edi+4*0]
                       fsub  dword[edi+4*1]
                       fmul  dword[esi+OBJ1.gr]
                       fadd  dword[esi+OBJ1.py]
                       fstp  dword[esp+4*1]
                     invoke  glVertex2f


                     invoke  glTexCoord2f,1.0,1.0
                        sub  esp,4*2
                       fldz
                       fadd  dword[edi+4*0]
                       fadd  dword[edi+4*1]
                       fmul  dword[esi+OBJ1.gr]
                       fadd  dword[esi+OBJ1.px]
                       fstp  dword[esp+4*0]
                       fldz
                       fsub  dword[edi+4*0]
                       fadd  dword[edi+4*1]
                       fmul  dword[esi+OBJ1.gr]
                       fadd  dword[esi+OBJ1.py]
                       fstp  dword[esp+4*1]
                     invoke  glVertex2f


                     invoke  glTexCoord2f,0.0,1.0
                        sub  esp,4*2
                       fldz
                       fadd  dword[edi+4*0]
                       fsub  dword[edi+4*1]
                       fmul  dword[esi+OBJ1.gr]
                       fadd  dword[esi+OBJ1.px]
                       fstp  dword[esp+4*0]
                       fldz
                       fadd  dword[edi+4*0]
                       fadd  dword[edi+4*1]
                       fmul  dword[esi+OBJ1.gr]
                       fadd  dword[esi+OBJ1.py]
                       fstp  dword[esp+4*1]
                     invoke  glVertex2f

                        ret


include 'player.inc'
include 'shot.inc'
include 'geom.inc'
include 'particle.inc'
include 'windmill.inc'
include 'diamond.inc'
include 'weaver.inc'
include 'wander.inc'
include 'snake.inc'
include 'gate.inc'
include 'grid.inc'
include 'misc.inc'
include 'camera.inc'
include 'input.inc'

include 'models.inc'



proc WindowProc hwnd,wmsg,wparam,lparam
                       push  ebp ebx esi edi
                        mov  eax,[wmsg]
                        cmp  eax,WM_CREATE
                         je  .wmcreate
                        cmp  eax,WM_SIZE
                         je  .wmsize
                        cmp  eax,WM_PAINT
                         je  .wmpaint
                        cmp  eax,WM_KEYDOWN
                         je  .wmkeydown
                        cmp  eax,WM_KEYUP
                         je  .wmkeyup
                        cmp  eax,WM_MOUSEMOVE
                         je  .wmmousemove
                        cmp  eax,WM_LBUTTONDOWN
                         je  .wmlbuttondown
                        cmp  eax,WM_LBUTTONUP
                         je  .wmlbuttonup
                        cmp  eax,WM_RBUTTONDOWN
                         je  .wmrbuttondown
                        cmp  eax,WM_RBUTTONUP
                         je  .wmrbuttonup
                        cmp  eax,WM_DESTROY
                         je  .wmdestroy
  .defwndproc:
                     invoke  DefWindowProc,[hwnd],[wmsg],[wparam],[lparam]
                        jmp  .finish
  .wmcreate:
                     invoke  GetDC,[hwnd]
                        mov  [hdc],eax
                        mov  edi,pfd
                        mov  ecx,sizeof.PIXELFORMATDESCRIPTOR shr 2
                        xor  eax,eax
                  rep stosd
                        mov  [pfd.nSize],sizeof.PIXELFORMATDESCRIPTOR
                        mov  [pfd.nVersion],1
                        mov  [pfd.dwFlags],PFD_SUPPORT_OPENGL+PFD_DOUBLEBUFFER+PFD_DRAW_TO_WINDOW
                        mov  [pfd.iLayerType],PFD_MAIN_PLANE
                        mov  [pfd.iPixelType],PFD_TYPE_RGBA
                        mov  [pfd.cColorBits],16
                        mov  [pfd.cDepthBits],16
                        mov  [pfd.cAccumBits],0
                        mov  [pfd.cStencilBits],0
                     invoke  ChoosePixelFormat,[hdc],pfd
                     invoke  SetPixelFormat,[hdc],eax,pfd
                     invoke  wglCreateContext,[hdc]
                        mov  [hrc],eax
                     invoke  wglMakeCurrent,[hdc],[hrc]
                     invoke  GetClientRect,[hwnd],rc
                            jmp  .zfinish

  .wmsize:
                  ;   invoke  GetClientRect,[hwnd],rc
                  ;   invoke  glViewport,0,0,[rc.right],[rc.bottom]
                  ;     fild  dword[rc.right]
                  ;     fstp  dword[WindowWidth]
                  ;     fild  dword[rc.bottom]
                  ;     fstp  dword[WindowHeight]
                        jmp  .zfinish

  .wmpaint:          invoke  ValidateRect,[hwnd],NULL
                        jmp  .zfinish


  .wmmousemove:       movzx  eax,word[lparam+2*0]
                        mov  [MouseState.x],eax
                      movzx  eax,word[lparam+2*1]
                        mov  [MouseState.y],eax
                        jmp  .zfinish
  .wmlbuttondown:        or  [MouseState.Buttons],MOUSE_LBUTTON
                        jmp  .wmmousemove
  .wmrbuttondown:        or  [MouseState.Buttons],MOUSE_RBUTTON
                        jmp  .wmmousemove
  .wmlbuttonup:         and  [MouseState.Buttons],not MOUSE_LBUTTON
                        jmp  .wmmousemove
  .wmrbuttonup:         and  [MouseState.Buttons],not MOUSE_RBUTTON
                        jmp  .wmmousemove


  .wmkeydown:         rdtsc
                        mov  dword[RandSeed+4*0],eax
                        mov  eax,[wparam]

                        cmp  eax,VK_F1
                         je  .kd_F1

                        cmp  eax,'S'
                         je  .kd_s
                        cmp  eax,'W'
                         je  .kd_w
                        cmp  eax,'A'
                         je  .kd_a
                        cmp  eax,'D'
                         je  .kd_d

                        cmp  eax,'T'
                         je  .kd_t
                        cmp  eax,'Y'
                         je  .kd_y
                        cmp  eax,'F'
                         je  .kd_f
                        cmp  eax,'G'
                         je  .kd_g
                        cmp  eax,'H'
                         je  .kd_h
                        cmp  eax,'N'
                         je  .kd_n

                        cmp  eax,'U'
                         je  .kd_u
                        cmp  eax,'I'
                         je  .kd_i
                        cmp  eax,'O'
                         je  .kd_o
                        cmp  eax,'J'
                         je  .kd_j
                        cmp  eax,'K'
                         je  .kd_k
                        cmp  eax,'L'
                         je  .kd_l

                        cmp  eax,'1'
                         je  .kd_1
                        cmp  eax,'2'
                         je  .kd_2
                        cmp  eax,'3'
                         je  .kd_3

                        cmp  eax,VK_DOWN
                         je  .kd_down
                        cmp  eax,VK_UP
                         je  .kd_up
                        cmp  eax,VK_LEFT
                         je  .kd_left
                        cmp  eax,VK_RIGHT
                         je  .kd_right

                        cmp  eax,VK_RETURN
                         je  .kd_return

                        cmp  eax,VK_SPACE
                         je  .kd_space

                        cmp  eax,VK_ESCAPE
                         je  .wmdestroy

                        cmp  eax,'1'
                         je  .kd_1
                        cmp  eax,'2'
                         je  .kd_2
                        cmp  eax,'3'
                         je  .kd_3
                        cmp  eax,'4'
                         je  .kd_4
                        jmp  .zfinish

    .kd_F1:          invoke  MessageBoxA,HWND_DESKTOP,HelpMessage,HelpCaption,MB_OK
                        jmp  .zfinish


    .kd_1:               or  dword[KeyboardState.Numbers],KEYBOARD_KEY_1
                        jmp  .zfinish
    .kd_2:               or  dword[KeyboardState.Numbers],KEYBOARD_KEY_2
                        jmp  .zfinish
    .kd_3:               or  dword[KeyboardState.Numbers],KEYBOARD_KEY_3
                        jmp  .zfinish
    .kd_4:               or  dword[KeyboardState.Numbers],KEYBOARD_KEY_4
                        jmp  .zfinish

    .kd_return:          or  dword[KeyboardState.Misc],KEYBOARD_KEY_RETURN
                        jmp  .zfinish

    .kd_space:           or  dword[KeyboardState.Buttons],KEYBOARD_PLAYER_BOMB
                        jmp  .zfinish
    .kd_s:               or  dword[KeyboardState.Buttons],KEYBOARD_PLAYER_MOVE_DOWN
                        jmp  .zfinish
    .kd_w:               or  dword[KeyboardState.Buttons],KEYBOARD_PLAYER_MOVE_UP
                        jmp  .zfinish
    .kd_a:               or  dword[KeyboardState.Buttons],KEYBOARD_PLAYER_MOVE_LEFT
                        jmp  .zfinish
    .kd_d:               or  dword[KeyboardState.Buttons],KEYBOARD_PLAYER_MOVE_RIGHT
                        jmp  .zfinish
    .kd_down:            or  dword[KeyboardState.Buttons],KEYBOARD_PLAYER_FIRE_DOWN
                        jmp  .zfinish
    .kd_up:              or  dword[KeyboardState.Buttons],KEYBOARD_PLAYER_FIRE_UP
                        jmp  .zfinish
    .kd_left:            or  dword[KeyboardState.Buttons],KEYBOARD_PLAYER_FIRE_LEFT
                        jmp  .zfinish
    .kd_right:           or  dword[KeyboardState.Buttons],KEYBOARD_PLAYER_FIRE_RIGHT
                        jmp  .zfinish

    .kd_t:               or  dword[KeyboardState.Buttons],KEYBOARD_CAMERA_MOVE_FORWARD
                        jmp  .zfinish
    .kd_f:               or  dword[KeyboardState.Buttons],KEYBOARD_CAMERA_MOVE_LEFT
                        jmp  .zfinish
    .kd_g:               or  dword[KeyboardState.Buttons],KEYBOARD_CAMERA_MOVE_BACK
                        jmp  .zfinish
    .kd_h:               or  dword[KeyboardState.Buttons],KEYBOARD_CAMERA_MOVE_RIGHT
                        jmp  .zfinish
    .kd_y:               or  dword[KeyboardState.Buttons],KEYBOARD_CAMERA_MOVE_UP
                        jmp  .zfinish
    .kd_n:               or  dword[KeyboardState.Buttons],KEYBOARD_CAMERA_MOVE_DOWN
                        jmp  .zfinish

    .kd_u:               or  dword[KeyboardState.Buttons],KEYBOARD_CAMERA_ROT_CCW
                        jmp  .zfinish
    .kd_i:               or  dword[KeyboardState.Buttons],KEYBOARD_CAMERA_ROT_UP
                        jmp  .zfinish
    .kd_o:               or  dword[KeyboardState.Buttons],KEYBOARD_CAMERA_ROT_CW
                        jmp  .zfinish
    .kd_j:               or  dword[KeyboardState.Buttons],KEYBOARD_CAMERA_ROT_LEFT
                        jmp  .zfinish
    .kd_k:               or  dword[KeyboardState.Buttons],KEYBOARD_CAMERA_ROT_DOWN
                        jmp  .zfinish
    .kd_l:               or  dword[KeyboardState.Buttons],KEYBOARD_CAMERA_ROT_RIGHT
                        jmp  .zfinish

  .wmkeyup:             mov  eax,[wparam]
                        cmp  eax,'S'
                         je  .ku_s
                        cmp  eax,'W'
                         je  .ku_w
                        cmp  eax,'A'
                         je  .ku_a
                        cmp  eax,'D'
                         je  .ku_d

                        cmp  eax,'T'
                         je  .ku_t
                        cmp  eax,'Y'
                         je  .ku_y
                        cmp  eax,'F'
                         je  .ku_f
                        cmp  eax,'G'
                         je  .ku_g
                        cmp  eax,'H'
                         je  .ku_h
                        cmp  eax,'N'
                         je  .ku_n

                        cmp  eax,'U'
                         je  .ku_u
                        cmp  eax,'I'
                         je  .ku_i
                        cmp  eax,'O'
                         je  .ku_o
                        cmp  eax,'J'
                         je  .ku_j
                        cmp  eax,'K'
                         je  .ku_k
                        cmp  eax,'L'
                         je  .ku_l

                        cmp  eax,VK_RETURN
                         je  .ku_return

                        cmp  eax,'1'
                         je  .ku_1
                        cmp  eax,'2'
                         je  .ku_2
                        cmp  eax,'3'
                         je  .ku_3
                        cmp  eax,'4'
                         je  .ku_4

                        cmp  eax,VK_DOWN
                         je  .ku_down
                        cmp  eax,VK_UP
                         je  .ku_up
                        cmp  eax,VK_LEFT
                         je  .ku_left
                        cmp  eax,VK_RIGHT
                         je  .ku_right
                        jmp  .zfinish
                        cmp  eax,VK_SPACE
                         je  .ku_space
                        jmp  .zfinish

    .ku_1:              and  dword[KeyboardState.Numbers],not KEYBOARD_KEY_1
                        jmp  .zfinish
    .ku_2:              and  dword[KeyboardState.Numbers],not KEYBOARD_KEY_2
                        jmp  .zfinish
    .ku_3:              and  dword[KeyboardState.Numbers],not KEYBOARD_KEY_3
                        jmp  .zfinish
    .ku_4:              and  dword[KeyboardState.Numbers],not KEYBOARD_KEY_4
                        jmp  .zfinish

    .ku_return:         and  dword[KeyboardState.Misc],not KEYBOARD_KEY_RETURN
                        jmp  .zfinish

    .ku_space:          and  dword[KeyboardState.Buttons],not KEYBOARD_PLAYER_BOMB
                        jmp  .zfinish
    .ku_s:              and  dword[KeyboardState.Buttons],not KEYBOARD_PLAYER_MOVE_DOWN
                        jmp  .zfinish
    .ku_w:              and  dword[KeyboardState.Buttons],not KEYBOARD_PLAYER_MOVE_UP
                        jmp  .zfinish
    .ku_a:              and  dword[KeyboardState.Buttons],not KEYBOARD_PLAYER_MOVE_LEFT
                        jmp  .zfinish
    .ku_d:              and  dword[KeyboardState.Buttons],not KEYBOARD_PLAYER_MOVE_RIGHT
                        jmp  .zfinish
    .ku_down:           and  dword[KeyboardState.Buttons],not KEYBOARD_PLAYER_FIRE_DOWN
                        jmp  .zfinish
    .ku_up:             and  dword[KeyboardState.Buttons],not KEYBOARD_PLAYER_FIRE_UP
                        jmp  .zfinish
    .ku_left:           and  dword[KeyboardState.Buttons],not KEYBOARD_PLAYER_FIRE_LEFT
                        jmp  .zfinish
    .ku_right:          and  dword[KeyboardState.Buttons],not KEYBOARD_PLAYER_FIRE_RIGHT
                        jmp  .zfinish

    .ku_t:              and  dword[KeyboardState.Buttons],not KEYBOARD_CAMERA_MOVE_FORWARD
                        jmp  .zfinish
    .ku_f:              and  dword[KeyboardState.Buttons],not KEYBOARD_CAMERA_MOVE_LEFT
                        jmp  .zfinish
    .ku_g:              and  dword[KeyboardState.Buttons],not KEYBOARD_CAMERA_MOVE_BACK
                        jmp  .zfinish
    .ku_h:              and  dword[KeyboardState.Buttons],not KEYBOARD_CAMERA_MOVE_RIGHT
                        jmp  .zfinish
    .ku_y:              and  dword[KeyboardState.Buttons],not KEYBOARD_CAMERA_MOVE_UP
                        jmp  .zfinish
    .ku_n:              and  dword[KeyboardState.Buttons],not KEYBOARD_CAMERA_MOVE_DOWN
                        jmp  .zfinish

    .ku_u:              and  dword[KeyboardState.Buttons],not KEYBOARD_CAMERA_ROT_CCW
                        jmp  .zfinish
    .ku_i:              and  dword[KeyboardState.Buttons],not KEYBOARD_CAMERA_ROT_UP
                        jmp  .zfinish
    .ku_o:              and  dword[KeyboardState.Buttons],not KEYBOARD_CAMERA_ROT_CW
                        jmp  .zfinish
    .ku_j:              and  dword[KeyboardState.Buttons],not KEYBOARD_CAMERA_ROT_LEFT
                        jmp  .zfinish
    .ku_k:              and  dword[KeyboardState.Buttons],not KEYBOARD_CAMERA_ROT_DOWN
                        jmp  .zfinish
    .ku_l:              and  dword[KeyboardState.Buttons],not KEYBOARD_CAMERA_ROT_RIGHT
                        jmp  .zfinish




  .wmdestroy:
                       call  GLCleanup
                     invoke  wglMakeCurrent,0,0
                     invoke  wglDeleteContext,[hrc]
                     invoke  ReleaseDC,[hwnd],[hdc]
                     invoke  PostQuitMessage,0
  .zfinish:
                        xor  eax,eax
  .finish:
                        pop  edi esi ebx ebp
                        ret
endp









section '.data' data readable writeable

include 'textures.inc'
include 'shaders.inc'




ShaderModes:
     dd Final1Program
     dd Final2Program
     dd Final3Program
ShaderModesEnd:




align 16


; camera data

CameraPosition:
 .x  dd 600.0
 .y  dd 500.0
 .z  dd 400.0
     dd ?   ; not used

CameraQuat:                   ; x*x+y*y+z*z+w*w should be 1
 .w  dd 1.0
 .x  dd 0.0
 .y  dd 0.0
 .z  dd 0.0

CameraField:
 .x  dd 1.8
 .y  dd 1.8
 .n  dd 10.0     ; near
 .f  dd 2000.0   ; far

CameraModeAbove:
 .d  dd 800.0
     dd 0
     dd 0
     dd 0

CameraModeFirst:
 .x  dd 1.0
 .y  dd 0.0
 .d  dd 100.0
 .a  dd -0.3


Lookup:
dd  0.0
dd +4.0
dd -4.0
dd  0.0


const_f4v4_1d6 dd 0.50,0.40,0.40,0.40
const_f4v4_1d4 dd 0.25,0.25,0.25,0.25
const_f4v4_1d2 dd 0.5,0.5,0.5,0.5
const_f4v4_1   dd 1.0,1.0,1.0,1.0
const_k: dd 0.5,0.5,0.5,0.5
const_c: dd 0.7,0.7,0.7,0.7
const_f4x4_signmask.xyzw: dd 0x80000000,0x80000000,0x80000000,0x80000000
const_f4x4_absmask.xyzw:  dd 0x7FFFFFFF,0x7FFFFFFF,0x7FFFFFFF,0x7FFFFFFF
const_f4x4_signmask.xy:   dd 0x80000000,0x80000000,0x00000000,0x00000000
const_f4x4_absmask.xy:    dd 0x7FFFFFFF,0x7FFFFFFF,0xFFFFFFFF,0xFFFFFFFF
const_f4x4_signmask.x:    dd 0x80000000,0x00000000,0x00000000,0x00000000
const_f4x4_mask.xyz:      dd 0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0x00000000



align 16
Diamond_Update_const:
.a: dd 0.9375,0.9375,0.9375,0.9375
.b: dd 0.0625,0.0625,0.0625,0.0625
.e: dd 1.00,1.00,1.00,1.00
.s: dd DIAMOND_SPEED,DIAMOND_SPEED,DIAMOND_SPEED,DIAMOND_SPEED
.r: dd 200.0,200.0,200.0,200.0

align 16
Gate_Update_const:
.a: dd 80.0,80.0,0,0
.n:  dd 2500.0
.u1: dd 0.0
.u2: dd 25600.0

align 16
Snake_Update_const:
.s: dd SNAKE_SPEED,SNAKE_SPEED,SNAKE_SPEED,SNAKE_SPEED

align 16
Player_Draw_const:
.shieldmin dd 26.0,26.0,26.0,26.0
.shieldmax dd 32.0,32.0,32.0,32.0

align 16
CharLineDrawNoEnd_const:
.n:  dd +0.015,+0.015,0.0,0.0
.np: dd -0.015,+0.015,0.0,0.0
.e:  dd 0.0001,0.0001,0.0001,0.0001

align 16
Geom_Update_const:
.f  dd 0.90,0.90,0.90,0.90
.cf dd 0.10,0.10,0.10,0.10
.f2  dd 0.80,0.80,0.80,0.80
.cf2 dd 0.20,0.20,0.20,0.20

align 16
ReleaseGeom_const:
.m dd 0.5,0.5,0.5,0.5

align  16
Geom_Draw_const:
.r dd 10.0,10.0,10.0,10.0

align 16
ReleaseExplosion_const:
.h dd 0.0,0.0,ENEMY_HEIGHT,0.0
.a dd 0.00004

align 16
LineDrawNoEnd_const:
.n:  dd +8.0,+8.0,0.0,0.0
.np: dd -8.0,+8.0,0.0,0.0
.e:  dd 0.0001,0.0001,0.0001,0.0001

align 16
Par_Draw_VBO_const:
.vs   dd +03.00,+03.00,+01.0,+1.00
.us   dd +0.75,+0.75,+0.00,+0.00
.ns   dd -0.75,+0.75,+0.00,+0.00
.nmax dd 3.0,3.0,3.0,3.0
.nmin dd -0.75,+0.75,+0.00,+0.00

align 16
Par_Draw_const:
.b    dd 0.250,0.000
.c    dd 0.000,0.250
.d    dd 0.250,0.250

.tab  dd 0.00,0.00
      dd 0.25,0.00
      dd 0.50,0.00
      dd 0.75,0.00

      dd 0.00,0.25
      dd 0.25,0.25
      dd 0.50,0.25
      dd 0.75,0.25

      dd 0.00,0.50
      dd 0.25,0.50
      dd 0.50,0.50
      dd 0.75,0.50

      dd 0.00,0.75
      dd 0.25,0.75
      dd 0.50,0.75
      dd 0.75,0.75




align 16
TailPar_Draw_VBO_const:
.vs   dd +01.50,+01.50,+00.40,+1.00
.us   dd +000.50,+000.50,+00.00,+0.00
.ns   dd -000.40,+000.40,+0.00,+0.00
.nmax  dd 4.0,4.0,4.0,4.0
.nmin   dd -0.25,+000.25,+0.00,+0.00

align 16
Bomb_Draw_const:
.style dd 0.0,0.0,1.0,1.0
       dd 1.0,0.0,0.0,1.0
.width dd 6.0

align 16
PrintExp_const:
.a: dd +20.0,+20.0,0.0,0.0
.n: dd +04.5,-04.5,0.0,0.0

align 16
GridBackgroundColors_Blend_Fix_const:
.a dd 0.25,0.25,0.25,0.25
.b dd 0.875,0.875,0.875,0.875
.c dd 0.001,0.001,0.001,0.001


align 16
GridBackground_Draw_const:
.A: dd 0.5,0.5,0.5,0.5
.B: dd 0.5,0.5,0.5,0.5

align 16
Minus16Stiffness: dd GRID_SSTIFFNESS,GRID_SSTIFFNESS,GRID_SSTIFFNESS,GRID_SSTIFFNESS
Damping:          dd GRID_SDAMPING,GRID_SDAMPING,GRID_SDAMPING,GRID_SDAMPING
EDamping:         dd GRID_EDAMPING,GRID_EDAMPING,GRID_EDAMPING,GRID_EDAMPING





dist0 fix 0.37920343
dist1 fix 0.22029711
dist2 fix 0.07323522
dist3 fix 0.01686595

dist4 fix 0.01198487

dist5 fix 0.00931539
dist6 fix 0.0212096
dist7 fix 0.0113901
dist8 fix 0.00563723


align 16
dd dist8,dist8,dist8,dist8
dd dist7,dist7,dist7,dist7
dd dist6,dist6,dist6,dist6
dd dist5,dist5,dist5,dist5
dd dist4,dist4,dist4,dist4
dd dist3,dist3,dist3,dist3
dd dist2,dist2,dist2,dist2
dd dist1,dist1,dist1,dist1
Weights:
dd dist0,dist0,dist0,dist0
dd dist1,dist1,dist1,dist1
dd dist2,dist2,dist2,dist2
dd dist3,dist3,dist3,dist3
dd dist4,dist4,dist4,dist4
dd dist5,dist5,dist5,dist5
dd dist6,dist6,dist6,dist6
dd dist7,dist7,dist7,dist7
dd dist8,dist8,dist8,dist8





align 8
 const_f4x2_8   dd 8.0,8.0



align 4
const_f4_1d2p16 dd 0.0000152587890625
const_f4_1d2p15 dd 0.00003051757813
const_f4_1d2p10 dd 0.000976563
const_f4_1d64   dd 0.015625
const_f4_1d48   dd 0.0208333333333333333
const_f4_1d8    dd 0.125
const_f4_1d16   dd 0.0625
const_f4_1dl    dd 0.07
const_f4_1d2    dd 0.5
const_f4_1      dd 1.0
const_f4_m1     dd -1.0
const_f4_3d2    dd 1.5
const_f4_2      dd 2.0
const_f4_3      dd 3.0
const_f4_4      dd 4.0
const_f4_2pi    dd 6.2831853071795864769
const_f4_18     dd 18.0


align 4
DiamondSpawn_Draw_const:
.a  dd 0.03


align 4
Gate_Spawn_const:
  .80 dd 80.0

align 4
GridBackgroundColors_ReflectPar_const:
.a dd  0.000005


align 4
Weapon1:   dd Weapon1
           dd Weapon1
           dd 5
           dd 3

           dd 35.0,+06.0    ; position
           dd 22.0,+0.5     ; velocity

           dd 35.0,-06.0
           dd 22.0,-0.5

           dd 45.0,0.0
           dd 23.0,0.0

           dd 35.0,+12.0
           dd 22.0,+1.0

           dd 35.0,-12.0
           dd 22.0,-1.0

align 4

  XInputGetState  dd EmptyFunction
  TargetFPS       dd FPS

  ParDamping      dd PAR_DAMPING



  GridScale       dd 2.0e-2
  TailScale       dd 3.0e-5
  ParChop         dd PAR_CHOP
  SelectedWeapon  dd Weapon1


  wc WNDCLASS 0,WindowProc,0,0,NULL,NULL,NULL,NULL,NULL,_class


align 2
BloomLevelTable db 0,0
                db 1,0
                db 2,0
                db 0,1
                db 1,1
                db 2,1
                db 1,2
                db 2,2

align 1
  BloomLevel          db 1
  ObjectBloomLevel    db 1
  ParticleBloomLevel  db 0
                      db 0
  HelpCaption         db 'controls ',0
  HelpMessage:
db ' keyboard        gamepad               action',0x0d,0x0a
db '----------------------------------------',0x0d,0x0a
db ' enter           right bummper       pause',0x0d,0x0a
db ' 1                  left bummper        change camera mode',0x0d,0x0a
db ' 2                  dpad right              change final shader',0x0d,0x0a
db ' 3                  dpad up                  increase bloom effects        ',0x0d,0x0a
db ' 4                  dpad down             decrease bloom effects',0x0d,0x0a
db ' wasd            left stick                 move',0x0d,0x0a
db ' arrows          right stick              shoot',0x0d,0x0a
db ' left mouse                                  shoot',0x0d,0x0a
db ' space              a                           bomb',0x0d,0x0a
db 0x0d,0x0a
db ' camera motion:',0x0d,0x0a
db '   tg : move forward / backward',0x0d,0x0a
db '   fh : move left / right',0x0d,0x0a
db '   yn : move up / down',0x0d,0x0a
db 0x0d,0x0a
db ' camera rotation:',0x0d,0x0a
db '   uo : rotate about view direction',0x0d,0x0a
db '   jl : rotate left / right',0x0d,0x0a
db '   ik : rotate up / down',0x0d,0x0a
db 0x0d,0x0a
db ' camera.inc has more details on the camera modes',0x0d,0x0a
db 0


  NoSSE3ErrorMessage  db 'no sse3 detected: code relies upon on haddps',0
  _title              db 'gw2 pacifism mode    F1: view controls',0
  _class              db 'FASMOPENGL32',0










align 16
ProjectionMatrix rd 16
ViewMatrix       rd 16

 RotationMatrix:
   .x: dd ?,?,?,?
   .y  dd ?,?,?,?

 RandSeed dd ?,?,?,?

 xstate:
   .PacketNumber dd ?
   .Buttons      dw ?
   .LeftTrigger  db ?
   .RightTrigger db ?
   .ThumbLX      dw ?
   .ThumbLY      dw ?
   .ThumbRX      dw ?
   .ThumbRY      dw ?

 xstate2:
   .PacketNumber dd ?
   .Buttons      dw ?
   .LeftTrigger  db ?
   .RightTrigger db ?
   .ThumbLX      dw ?
   .ThumbLY      dw ?
   .ThumbRX      dw ?
   .ThumbRY      dw ?

 KeyboardState:
   .Buttons      dd ?
   .Numbers      dd ?
   .Misc         dd ?
                 dd ?

 MouseState:
   .Buttons      dd ?
                 dd ?
   .x            dd ?
   .y            dd ?





align 8
  msg    MSG
  rc     RECT
  pfd    PIXELFORMATDESCRIPTOR


align 8
  TextureTable:
  GridTexture           dd ?
  PlayerTexture         dd ?
  ShotTexture           dd ?
  GeomTexture           dd ?
  TailParTexture        dd ?
  ParTexture            dd ?
  DiamondTexture        dd ?
  DiamondExpTexture     dd ?
  WindmillTexture       dd ?
  WindmillExpTexture    dd ?
  WanderTexture         dd ?
  WanderExpTexture      dd ?
  WeaverTexture         dd ?
  WeaverExpTexture      dd ?
  SnakeTailTexture      dd ?
  SnakeHeadTexture      dd ?
  SnakeTailExpTexture   dd ?
  SnakeHeadExpTexture   dd ?
  GateTexture           dd ?
  GateBarTexture        dd ?
  PlayerExpTexture      dd ?
  LineTexture           dd ?
  BorderTexture         dd ?
  BombTexture           dd ?
  StarTexture           dd ?
  TexA        dd ?
  TexB        dd ?
  TexC        dd ?
  TexD        dd ?
  TexE        dd ?
  TexA2       dd ?
  TexB2       dd ?
  TexE2       dd ?
TextureTableEnd:

FBOTable:
  FBOA        dd ?
  FBOB        dd ?
  FBOC        dd ?
  FBOD        dd ?
  FBOE        dd ?
  FBOA2       dd ?
  FBOB2       dd ?
  FBOE2       dd ?
FBOTableEnd:

GridVBO  dd ?
ParVBO   dd ?


DiamondDspList       dd ?
DiamondSpawnDspList  dd ?

WindmillDspList       dd ?
WindmillSpawnDspList  dd ?

WanderDspList       dd ?
WanderSpawnDspList  dd ?

WeaverDspList       dd ?
WeaverSpawnDspList  dd ?

SnakeTail0DspList  dd ?
SnakeTail1DspList  dd ?
SnakeTail2DspList  dd ?
SnakeTail3DspList  dd ?
SnakeHeadDspList   dd ?
SnakeSpawnDspList   dd ?

GateDspList     dd ?

align 8
ProcessAffinityMask dd ?
SystemAffinityMask  dd ?
Pro1Mask            dd ?
Pro2Mask            dd ?
Pro3Mask            dd ?


  Frequency     dq ?
  Tick          dq ?
  TickIncrement dq ?
  ExpectedTick  dq ?
  Time1         dq ?
  Time2         dq ?
  Worker1Time1  dq ?
  Worker1Time2  dq ?
  Worker2Time1  dq ?
  Worker2Time2  dq ?
  Time12        dq ?

  Offset:
    .x: dd ?
    .y: dd ?
  Corner:
   .x   dd ?
   .y   dd ?
  Mouse:
    .x  dd ?
    .y  dd ?
  PlayerVel:
    .x  dd ?
    .y  dd ?


QuatMatrix:
        dq ?,?,?
        dq ?,?,?
        dq ?,?,?

Quat:
  .w dd ?
  .x dd ?
  .y dd ?
  .z dd ?

align 4

glGenBuffers     dd ?
glBindBuffer     dd ?
glDeleteBuffers  dd ?
glBufferData     dd ?
glBufferSubData  dd ?


glEnableVertexAttribArray   dd ?
glVertexAttribPointer       dd ?
glDisableVertexAttribArray  dd ?




  glGenRenderbuffers       dd ?
  glDeleteRenderbuffers    dd ?
  glBindRenderbuffer       dd ?
  glGenFramebuffers        dd ?
  glDeleteFramebuffers     dd ?
  glBindFramebuffer        dd ?
  glFramebufferTexture2D   dd ?
  glCheckFramebufferStatus dd ?
  glRenderbufferStorage    dd ?
  glFramebufferRenderbuffer dd ?
  glCreateShader            dd ?
  glDeleteShader            dd ?
  glShaderSource            dd ?
  glGetObjectParameteriv    dd ?
  glCompileShader           dd ?
  glGetShaderiv             dd ?
  glGetShaderInfoLog        dd ?
  glCreateProgram        dd ?
  glDeleteProgram        dd ?
  glAttachShader         dd ?
  glLinkProgram          dd ?
  glGetProgramiv         dd ?
  glUseProgram           dd ?



  hwnd            dd ?
  hdc             dd ?
  hrc             dd ?
  Worker1Handle   dd ?
  Worker1Start    dd ?
  Worker2Handle   dd ?
  Worker2Start    dd ?
  FrameCount      dd ?
  Sound           dd ?
  FireRecharge    dd ?
  PlayWidth       dd ?
  PlayHeight      dd ?
  WindowWidth     dd ?
  WindowHeight    dd ?
  CompiledQ       dd ?
  RenderRate      dd ?
  PhysicsRate            dd ?
  GridRate               dd ?
  ParColorCount          dd ?
  PlayerShieldCount      dd ?
  PlayerAliveQ           dd ?
  Multiplier             dd ?,?
  Score                  dd ?,?
  GameMode               dd ?
  GameModeStartCount     dd ?
  GameModeCollisionCount dd ?
  CameraMode             dd ?
  ShaderMode             dd ?

  PausedQ       dd ?

  ParColor            dd ?
  PlayerParColor      dd ?



align 32
State:


  ShotCount           dd ?
  GeomCount           dd ?

  WindmillCount       dd ?
  WindmillSpawnCount  dd ?
  WindmillExpCount    dd ?

  DiamondCount        dd ?
  DiamondSpawnCount   dd ?
  DiamondExpCount     dd ?

  WeaverCount         dd ?
  WeaverSpawnCount    dd ?
  WeaverExpCount      dd ?

  WanderCount         dd ?
  WanderSpawnCount    dd ?
  WanderExpCount      dd ?

  SnakeCount          dd ?
  SnakeSpawnCount     dd ?
  SnakeHeadExpCount   dd ?
  SnakeTailExpCount   dd ?

  BlackholeCount      dd ?
  BlackholeSpawnCount dd ?
  BlackholeExpCount   dd ?

  GateCount           dd ?
  GateSpawnCount      dd ?
  GateExpCount        dd ?

  PlayerExpCount      dd ?

  BombCount           dd ?
  DepCount            dd ?
  TailParCount        dd ?
  ParCount            dd ?
  ExpCount            dd ?


  Bomb:
   .px: dd ?
   .py: dd ?
   .r:  dd ?
   .ct: dd ?



align 32
  Player OBJ1

align 32
  ShotTable             rb 32*SHOT_MAXCOUNT
  GeomTable             rb 32*GEOM_MAXCOUNT

  WindmillTable         rb 32*WINDMILL_MAXCOUNT
  WindmillSpawnTable    rb 16*WINDMILL_SPAWN_MAXCOUNT
  WindmillExpTable      rb 32*WINDMILL_EXP_MAXCOUNT

  DiamondTable          rb 32*DIAMOND_MAXCOUNT
  DiamondSpawnTable     rb 16*DIAMOND_SPAWN_MAXCOUNT
  DiamondExpTable       rb 32*DIAMOND_EXP_MAXCOUNT

  WeaverTable           rb 32*WEAVER_MAXCOUNT
  WeaverSpawnTable      rb 16*WEAVER_SPAWN_MAXCOUNT
  WeaverExpTable        rb 32*WEAVER_EXP_MAXCOUNT

  WanderTable           rb 32*WANDER_MAXCOUNT
  WanderSpawnTable      rb 16*WANDER_SPAWN_MAXCOUNT
  WanderExpTable        rb 32*WANDER_EXP_MAXCOUNT

  SnakeTable            rb (sizeof.SNAKE)*SNAKE_MAXCOUNT
  SnakeSpawnTable       rb 16*SNAKE_SPAWN_MAXCOUNT
  SnakeHeadExpTable     rb 32*SNAKEHEAD_EXP_MAXCOUNT
  SnakeTailExpTable     rb 32*SNAKETAIL_EXP_MAXCOUNT

  GateTable             rb 32*GATE_MAXCOUNT
  GateSpawnTable        rb 32*GATE_SPAWN_MAXCOUNT
  GateExpTable          rb 32*GATE_EXP_MAXCOUNT

  BombTable             rb 16*BOMB_MAXCOUNT

  PlayerExpTable        rb 32*PLAYER_EXP_MAXCOUNT

  DepTable              rb (sizeof.DEP)*DEP_MAXCOUNT
  TailParTable          rb 32*TAILPAR_MAXCOUNT
  ParTable              rb 32*PAR_MAXCOUNT
  GridTable             rb 32*((PLAY_WIDTH/GRID_SPACING)+1)*((PLAY_HEIGHT/GRID_SPACING)+1)+32*3
  GridColorTable        rb 16*((PLAY_WIDTH/GRID_SPACING)+1)*((PLAY_HEIGHT/GRID_SPACING)+1)

StateEnd:


align 4
GridVertexBufferData:
   rb 20*1000+20*(GRID_HEIGHT*(2*(GRID_WIDTH+1)+2)+2*(GRID_WIDTH+1))+20*2+20*(GRID_WIDTH*(2*(GRID_HEIGHT+1)+2)+2*(GRID_HEIGHT+1))
ParVertexBufferData:
   rb 32*6*PAR_MAXCOUNT


align 32
StateCopy:
    rb StateEnd-State

CopyOffset = StateCopy-State



align 32
text rb 1024

section '.idata' import data readable writeable

  library kernel32,'KERNEL32.DLL',\
          user32,'USER32.DLL',\
          gdi32,'GDI32.DLL' ,\
          opengl32,'OPENGL32.DLL',\
          glu32,'GLU32.DLL'

include 'opengl_api.inc'
include 'api/kernel32.inc'
include 'api/user32.inc'
include 'api/gdi32.inc'