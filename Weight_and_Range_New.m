clc; clear all; close all;

%% Define Maximum Gross Takeoff Weight

MTOW = 118000;

%% Calculate Group Weights

% group weights were calculated by referencing Torenbeek ch. 8 pg. 280, Aerospace Caravelle VIR

% the Aerospace Caraveller was chosen because its MTOW of 110,230 lbs is closest 
% to our MTOW of 112,000 lbs

% airframe structure includes: wing group, tail group, fuselage group,
% landing gear, surface controls group, nacelle group

WingGroup = 0.134*MTOW;
TailGroup = 0.0177*MTOW;
FuselageGroup = 0.105*MTOW;
LandingGear = 0.0463*MTOW;
SurfaceControlsGroup = 0.0187*MTOW;
NacelleGroup = 0.0143*MTOW;
AirframeStructure = WingGroup + TailGroup + FuselageGroup + LandingGear + SurfaceControlsGroup + NacelleGroup;

% propulsion group includes: engines

PropulsionSystem = 2*2445;                                  % [lbs] there are 2 engines, each weighing in at 2445 lbs

%% Define and Calculate Parameters

Wempty = AirframeStructure + PropulsionSystem;
Empty_2_MTOW_Ratio = Wempty / MTOW;                         % [unitless] this is the ratio of the Empty Weight of the aircraft to the MTOW of the aircraft
Wleftover = MTOW - Wempty;                                  % [lbs] this is what's available to be split b/w fuel and payload
Payload = 13*200;                                           % [lbs] 12 passengers + 1 stewardess, each w/ combined body and luggage weight of 200 lbs as suggested by McCormick, ch. 7, pg. 407
WingLoading = 90;                                           % [lb/ft^2]
WingArea = (1/WingLoading)*MTOW;                            % [ft^2]
AspectRatio = 7.2015;                                       % [unitless]
WingSpan = sqrt(WingArea*AspectRatio);                      % [ft] span of just one wing
C_r = sqrt(AspectRatio*WingArea)/5;                         % [ft] root chord length
MAC = 0.73917*C_r;                                          % [ft] mean aerodynamic chord
CL_CD = 4.289;                                              % [unitless] lift to drag ratio for at M = 1.6, alpha = 2 deg
a = 573.3502;                                               % [nmi/hr] speed of sound at altitude 45,000 ft
M = 1.6;                                                    % [unitless] Mach number
V = M*a;                                                    % [nmi/hr] aircraft cruise speed
Range = 4500;                                               % [nmi] specified range
Ctsfc = 0.8766;                                             % [1/hr] thrust specific fuel consumption based off of BJ205 at 45000 ft and Mach 1.6

%% Load Condition 1 - Max Payload & Max Fuel

Waircraft1 = MTOW;                                          % [lbs]

%% Load Condition 2 - Max Payload & Min Fuel

% FAA Regulations state that an aircraft must maintain a minumum 45 minute
% fuel reserve, so use the endurance equation to calculate how many lbs of
% fuel that would take

E = 0.75;                                                   % [hr]
Wfuel45min = MTOW - (MTOW/(exp(E/((1/Ctsfc)*(CL_CD)))));    % [lbs]
Waircraft2 = Wempty + Wfuel45min + Payload;                 % [lbs]

%% Load Condition 3 - Min Payload & Max Fuel

% Min payload can be assumed to be 0 since the 2 pilots are included in the
% dry weight of the aircraft

Waircraft3 = MTOW - Payload;

%% Load Condition 4 - Min Payload & Min Fuel

Waircraft4 = Wempty + Wfuel45min;                           % [lbs]

%% Calculate weight of fuel needed to satisfy range

W0 = MTOW;                                                  % [lbs] MTOW
R = 4500;                                                   % [nmi] range
a0 = 661.47;                                                % [nmi/hr] speed of sound @ sea level
M = 1.6;                                                    % [unitless] mach number
L_D = 4.289;                                                % [unitless] lift to drag ratio
Ctsfc = 0.8766;                                             % [1/hr] thrust specific fuel consumption
Ta = 216.65;                                                % [K] ambient temp @ cruising altitude
T0 = 288.15;                                                % [K] std atmospheric temp

% using eq 2.130 from O. O. Bendiksen lecture 2 slides

W1 = W0/exp((R/a0)/((M*(L_D))/(Ctsfc / sqrt(Ta/T0))));
Wfuelneeded = W0 - W1;

%% Error in fuel prediction

Wfuelmax = MTOW - (Wempty + Payload);                       % [lbs] this should be all that is theoretically available
                                                            % based on volume constraints
x = Wfuelmax - Wfuelneeded;
if x < 0
    x = abs(x);
    disp(['We are over weight limits for fuel by ' num2str(x)])
else
    disp(['We are under weight limits for fuel by ' num2str(x)])
end