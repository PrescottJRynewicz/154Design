%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UCLA Aerospace Engineerign: Senior Design
% Prescott Rynewicz
% TakeOff Calcs
% Febraury 14, 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc;


%% Variable Definition


MTOW        = 70000;                %[lb]  : Max Take Off
CL_Max      = 1.8;                  %[  ]  : Max CL, based on approximations from other aircraft
S           = 636.364;              %[ft^2]: Wing Area
rho         = .00238;               %[slug/ft^3]: Density at sea level
V_T0        = sqrt(2*MTOW/S...
    /CL_Max/rho);                   %[ft/s]: Velocity to be able to take off
a           = 1190.646;             %[ft/s]: speed of sound at sea level
q           = 0.5*rho*(0.7*V_T0)^2; %[
M           = 0.7*V_T0/a;           %[    ]: Mach at take off speed
t_r         = 3;                    %[s]   : roll time 
g           = 32.2;                 %[ft/s^2]: 
R           = V_T0^2/1.152/g;       %[ft]: Radius of takeoff
h           = 35;                   %[ft]: Clearing Height
C_D         = .2236;                %[  ]: Drag Coefficient
D           = q*S*C_D;              %[lb]: Drag at Takeoff
T           = 21900*2;              %[lb]: Thrust at Takeoff
gamma_cl    = asin((T-D)/MTOW);     %[ ] : Something
mu          = 0.03;                 %[ ] : Coefficient of Ground Friction
L           = q*S*CL_Max;           %[lb]: Average lift
T_e         = T-D-mu*(MTOW-L);      %[lb]: Excess thrust during takeoff
U           = 0.7*V_T0;             %[ft/s]: Average Speed
S           = 0.5*MTOW*V_T0^2/T_e/32.3 + V_T0*t_r + ...
    R*sin(gamma_cl) + h - R*(1 - cos(gamma_cl))/tan(gamma_cl);


