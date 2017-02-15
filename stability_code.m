%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UCLA Aerospace Engineering: Senior Design
% Stability and Control Cm_alpha Calcs
% Developed by Quang, February 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc;

%% Febraury 11 : Updates, Prescott
% Added all values from initial CG estimates, given values in appendix B. 
% Assumed M = 0.8. 
% Made many assumptions stated in comments. 
% Initial values all look good with negative CM_cg slope and 17% stability
% margin. 

%% Calculations
%Define the constants
a_cruise        = 573.4;                    %good: Speed of sound at cruise alt. Nmi/hr                      %3D Lift slope of tail (equal to CL_alpha_w)
alpha_w_deg     = [2.96 3.94 4.91];         %vary: angle of attack of wing in degree
alpha_w         = alpha_w_deg.*pi/180;      %vary: angle of attack of wing
alpha_t         = alpha_w;                  %vary: angle of attack of tail
tau             = 0;                        %vary: correction of coefficient
k1_f            = .0591;                    %good: initial fineness ration of fuselage
k2_f            = .8943;                    %good: final fineness ratio of fuselage
k1_n            = .0985;                    %redo: initial fineness ration of nacelle
k2_n            = .8354;                    %redo: final fineness ratio of nacelle
CL_w            = [0.3 0.4 0.5];            %vary: Assume CL_0 to be small. 
CL_t            = [0.3 0.4 0.5];            %vary: Lift coefficient of tail
a_w             = CL_w./alpha_w;
a_t             = a_w;
x_cp            = 45;                       %good: 
CM_ac           = 0;                        %vary: Moment coefficient of aerodynamic center
                                            % Assume zero initially b/c
                                            % x_cp = x_ac. 
                                            % Typically between
                                            % .008-.025 [150B Text, pg. 254]
b               = 97.16;                    %good: wing span
c_w             = 14.36;                    %good: mean aerodynamic chord of wing
c_t             = 1.89;                     %good: chord of horizontal tail
S_w             = 1311.11;                  %good: Area of wing
Vh              = 1.0;                      %Tail Area Ratio: 1.0 initial estimate 
x_t             = 81;                       %good: Nose to tail leading edge initial estimate
x_t_MAC         = x_t+(1-0.8037)*c_t;       %good: Location of tail MAC. 
x_cg            = 46;                       %good: initial estimate from cg calcs. 
l_t             = x_t_MAC - x_cg;           %good: Distance between cg and tail MAC.
S_t             = Vh*S_w*c_w/(l_t);         %Area of horizontal tail
rho             = 0.0023769;                %good: Density of Air [slug/cubic ft]
pi              = 3.1412;                   %good: pi number
v_inf           = 0.8*a_cruise;             %good: velocity of the aircraft
q               = 0.5*rho*v_inf^2;          %good: air parameter
Vol_f           = pi*4.25^2*42.17;          %good: Volume of fuselage
Vol_n           = pi*4.25^2*29.9;           %need: Volume of nacelle
n_t             = 1;                        %tail efficiency
l_w             = 3.65;                     %distance from wing to CG : From CG Calcs. 
l_t             = l_t;             
l               = l_w + l_t;                %distance from wing to tail
n               = 1;                        %number of nacelle

%Calculate aerodynamic constants
A               = b^2/S_w;                          %Aspect ratio
epsilon         = (2* CL_w)*(1+tau)/(pi*A);         %downwash calculation
dev_epsilon     = (2* a_w)*(1+tau)/(pi*A);          %differitial of downwash

%Calculate stability of aircraft
M_f             = 2*q*(k2_f-k1_f)*Vol_f*alpha_w;    %Moment of fuselage
M_n             = 2*q*(k2_n-k1_n)*Vol_n*alpha_w;    %Moment of nacelle

%Total moment coefficient
CM_cg           = CL_w*(l_w/c_w) + CM_ac - CL_t*n_t*Vh + (M_f + 2*M_n)/(q*S_w*c_w);

%Differential of CM_cg with respect to alpha
CM_alpha        = (a_w + a_t.*(1 - dev_epsilon).*n_t.*(S_t./S_w)).*(l_w./c_w) - ...
    a_t.*(1-dev_epsilon).*n_t.*Vh + 2.*(k2_f - k1_f).*(Vol_f./(c_w.*S_w)) + ...
    2.*n.*(k2_n - k1_n).*(Vol_n./(c_w.*S_w));

%Plotting the CM_cg and dev_CM_cg(CM_alpha)
figure (1);     %Plot CM_cg
plot (alpha_w,CM_cg);
xlabel('Angle Of Attack'); ylabel('Moment Coefficient'); 

figure (2);     %Plot CM_alpha
plot (alpha_w/c_w,CM_alpha);
xlabel('Angle Of Attack'); ylabel('Moment coefficient in alpha');


 











