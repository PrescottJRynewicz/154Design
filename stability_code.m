%Define the constants
a_w =          ;   %3D Lift slope of wing (equal to CL_alpha_w)
a_t =          ;   %3D Lift slope of tail (equal to CL_alpha_w)
alpha_w_deg = [2 3 4 5 6 7];    %angle of attack of wing in degree
alpha_w =      ;   %angle of attack of wing
alpha_t =      ;   %angle of attack of tail
tau = 0;          %correction of coefficient
k1_f =         ;   %initial fineness ration of fuselage
k2_f =         ;   %final fineness ratio of fuselage
k1_n =         ;   %initial fineness ration of nacelle
k2_n =         ;   %final fineness ratio of nacelle
CL_w =         ;   %Lift coefficient of wing
CL_t =         ;   %Lift coefficient of tail
CM_ac =        ;   %Moment coefficient of aerodynamic center
b =            ;   %wing span
c_w =          ;   %mean aerodynamic chord of wing
c_t =          ;   %chord of horizontal tail
S_w =          ;   %Area of wing
S_t =          ;   %Area of horizontal tail
rho = 0.0023769;   %Density of Air [slug/cubic ft]
pi = 3.1412;       %pi number
v_inf =        ;   %velocity of the aircraft
q = 0.5*rho*v_inf^2;    %air parameter
Vol_f =        ;   %Volume of fuselage
Vol_n =        ;   %Volume of nacelle
n_t = 1;           %tail efficiency
l_w =          ;   %distance from wing to CG
l_t =          ;   %distance from CG to tail
l = l_w + l_t;     %distance from wing to tail
n =            ;   %number of nacelle

%Calculate aerodynamic constants
A = b^2/S_w;      %Aspect ratio
epsilon = (2* CL_w)*(1+tau)/(pi*A);     %downwash calculation
dev_epsilon = (2* a_w)*(1+tau)/(pi*A);  %differitial of downwash

%Calculate stability of aircraft
M_f = 2*q*(k2_f-k1_f)*Vol_f*alpha_w;    %Moment of fuselage
M_n = 2*q*(k2_n-k1_n)*Vol_n*alpha_w;    %Moment of nacelle

%Total moment coefficient
CM_cg = CL_w*(l_w/c) + CM_ac - CL_t*n_t*(S_t/S_w)*(l_t/c_w) + (M_f + 2*M_n)/(q*S_W*c_w);

%Differential of CM_cg with respect to alpha
CM_alpha = (a_w + a_t*(1 - dev_epsilon)*n_t*(S_t/S_w))*(l_w/c_w) - a_t*(1-dev_epsilon)*n_t*(S_t/S_w)*(l/c_w) + 2*(k2_f - k1_f)*(Vol_f/(c_w*S_w)) + 2*n*(k2_n - k1_n)*(Vol_n/(c_w*S_w));

%Plotting the CM_cg and dev_CM_cg(CM_alpha)
figure (1);     %Plot CM_cg
plot (alpha_w,CM_cg);
xlabel('Moment coefficient'); ylabel('Angle of attack');

figure (2);     %Plot CM_alpha
plot (l_w/c_w,CM_alpha);
xlabel('Moment coefficient in alpha'); ylabel('Wing_placement');














