%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UCLA Aerospace Engineerign: Senior Design
% Jordan Robertson
% Percent Cg_MAC Code
% Febraury 10, 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc;


%% Febraury 11, Prescott Update
% All Code updated with curret MTOW. 2 Engines still. 
% Estimates taken from similar aircraft for initial calcs. 
% %MAC_Cg looks good, cg stays constant through 4 loading conditions. 
% Need to potentially make adjustments and run number for supersonic case. 

%%

%%% Overall Aircraft Parameters 

MTOW            = 118000;                           % Max Take-Off Weight [lb]
PL              = 90;                               % Plane Length [ft]
WL              = 90;                               % Wing Loading [lb/ft^2]
w_fuel          = 70862;                            % total fuel weight
                                                    % Using Max Available fuel weight
                                                    % here: This is not the total
                                                    % weight required for range calcs. 
                                       
% Distances are measured from the nose of the aircraft
% to the leading edge (LE) of the component
% units=[ft]
L_nose          = 17.93;                            % length of nose
L_fusel         = 42.17;                            % length of fuselage
L_emp           = 29.9;                             % length of tail empennage
L_t_vert_root   = 2.18;                             % length of vertical tail surface root chord
L_t_horiz_root  = L_t_vert_root;                    % length of horizontal tail surface root chord
L_eng           = 13;                               % length of engine
L_nac           = 14;                               % length of nacelle
L_seat1         = 10;                               % length of seating section 1 (4 people)
L_seat2         = 10;                               % length of seating section 2 (4 people)
L_seat3         = 10;                               % length of seating section 3 (4 people)

x_wing          = 0.43*PL;                          % wing LE placement
x_eng           = 0.65*PL;                          % engine LE placement
x_nac           = x_eng;                            % nacelle LE placement
x_lg_front      = .04*PL;                           % front landing gear placement
x_lg_rear       = .45*PL;                           % rear landing gear placement
x_fusel         = L_nose;                           % fuselage LE placement                               
x_emp           = L_nose+L_fusel;                   % tail empennage LE placement
x_t_vert        = 0.90*PL;                          % vertical tail surface LE placement
x_t_horiz       = x_t_vert;                         % horizontal tail surface LE placement
x_seat_cp       = .1*PL;                           % placement of cockpit seating CG (2 pilots)
x_seat_js       = .2*PL;                          % placement of jump seat CG (1 steward(ess))
                                                    % cockpit seating should go around the end of the nose-
                                                    % fuselage just counts cabin in this code so you can put
                                                    % cockpit forward of that; jump seat can go in cabin or cockpit
x_seat1         = 0.3*PL;                           % placement of seating section 1 LE (4 people)
x_seat2         = 0.4*PL;                          % placement of seating section 2 LE (4 people)
x_seat3         = 0.5*PL;                          % placement of seating section 3 LE (4 people)
                                                    % seating sections 1-3 are each approx
                                                    % 10 ft long- section 1 CG must be at least 5ft into the
                                                    % fuselage and section 3 must be at
                                                    % least 5 feet from the end of the fuselage
                                         
% Weight Parameters: As found in Torenbeek estimates from similar aircraft
% Assumed using Aerospace Caravelle weight ratios.
% Units are in [lb]
w_1eng          =2445;                              % weight of an indivual engine
num_eng         =2;                                 % number of engines
w_engs          =num_eng*w_1eng;                    % total weight of all engines

fuelden         =49.943;                            % fuel density of jet fuel [lb/ft^3]
fuelvol         =w_fuel/fuelden;                    % volume of fuel tanks needed
                                                    % See below wing group info for
                                                    % fuel tank weights
w_wing          =.134*MTOW;                         % weight of wing group
w_tail          =.0178*MTOW;                        % weight of tail group
w_fusel         =.105*MTOW;                         % weight of fuselage
w_sc            =.0187*MTOW;                        % weight of surface controls
w_nac           =.0144*MTOW;                        % weight of nacelle
w_lg            =.0465*MTOW;                        % weight of landing gear

w_psngrseat     =45;                                % weight of luxury passenger seat
w_js            =30;                                % weight of jump seat 
w_pilotseat     =40;                                % weight of pilot seat
w_psngr         =200;                               % weight of passenger and their on-hand items

%%% Wing and Surface Controls Group Parameters

S               = MTOW/WL;                           % Wing Area [ft^2]
AR              = 7.2015;                            % Aspect Ration
Cr              = sqrt(AR*S)/5;                      % root chord length [ft]
Ct              = 0.3886*Cr;                         % tip chord length [ft]
MAC             = .73917*Cr;    
x_MAC           = x_wing+((1-.8037)*Cr);             % placement of LE of MAC
x_wing_cg       = x_wing+(.7*Cr);                    % placement of wing CG on aircraft
x_sc            = x_MAC+MAC;                         % surface controls CG placement

m_wing          = x_wing_cg*w_wing;
m_sc            = x_sc*w_sc;

%%% Fuel Tank Parameters 

w_centfuel      = .7*10.18*Cr*fuelden;               % weight of fuel in center fuel tank 
                                                    % 10.18=cross section surface area of cargo hold
                                                    % .7=percentage estimation of available volume
w_wingfuel      = w_fuel-w_centfuel;                 % total weight of fuel in both wings
x_centfuel_cg   = x_wing+(Cr/2);                     % position of CG for center fuel tank
x_wingfuel_cg   = (x_wing+.5)+(.7*.4*Cr);            % modeled as a mini-wing inside of main wing 
                                                    % offset back by 6in and with length of .4*Cr
m_centfuel      = x_centfuel_cg*w_centfuel;
m_wingfuel      = x_wingfuel_cg*w_wingfuel;
                                         
%%% Engine Group Parameters

x_eng_cg        = x_eng+(L_eng/2);

m_engs          = x_eng_cg*w_engs;

%%% Nacelle Group Parameters

x_nac_cg        = x_nac+(.4*L_nac);

m_nac           = x_nac_cg*w_nac;

%%% Tail Group Parameters

x_vert_cg       = x_t_vert+(.42*L_t_vert_root);
x_horiz_cg      = x_t_horiz+(.42*L_t_horiz_root);

m_tail          = x_horiz_cg*w_tail; 

%%% Fuselage Group Parameters

x_fusel_cg      = x_fusel+(.47*L_fusel);

m_fusel         = w_fusel*x_fusel_cg;
 
%%% Landing Gear Parameters

x_lg_cg         = x_lg_front+(((2/3)*x_lg_rear*w_lg)/w_lg);

m_lg            = w_lg*x_lg_cg;

%%% Payload+Pilot Parameters

x_seat1_cg      = x_seat1+(L_seat1/2);
x_seat2_cg      = x_seat2+(L_seat2/2);
x_seat3_cg      = x_seat3+(L_seat3/2);

w_seat1         = (4*w_psngrseat)+(4*w_psngr);
w_seat2         = (4*w_psngrseat)+(4*w_psngr);
w_seat3         = (4*w_psngrseat)+(4*w_psngr);
w_pilots        = (2*w_pilotseat)+(2*w_psngr);
w_js_total      = w_js+w_psngr;

m_js            = w_js_total*x_seat_js;
m_cp            = x_seat_cp*w_pilots;
m_seat1         = x_seat1_cg*w_seat1;
m_seat2         = x_seat2_cg*w_seat2;
m_seat3         = x_seat3_cg*w_seat3; 

%%% Sum Moments

sum_m           = m_js+m_cp+m_seat1+m_seat2+m_seat3+m_lg+m_fusel+m_tail+m_nac+m_engs+m_wingfuel+m_centfuel+m_wing+m_sc;

%%% Sum Weights

sum_w           = w_seat1+w_seat2+w_seat3+w_pilots+w_js_total+w_fuel+w_engs+w_wing+w_tail+w_fusel+w_sc+w_nac+w_lg;

%%% CG Calculation

CG              = sum_m./sum_w;

%%% Percent MAC Calculation

Percent_MAC     = (CG-x_MAC)./MAC;


% 
% plot(x_wing,Percent_MAC);
% xlabel('Wing Placement','FontSize',15)
% ylabel('Percent MAC','FontSize',15)
% title('Wing Placement vs. Percent MAC','FontSize',18)