


a1 = h/2 - y_c;
a2 = h/2 + y_c;
y1_rivet=(H_corner-S_corner)/2+S_corner;
h1_rivet=h_wall1-2*y1_rivet;
I_wall = delta_wall * h_wall1^3 / 12 ;
I_covering=b0*delta_covering^3/ 12+delta_covering * b0 * (h_wall1/2 + delta_covering/2)^2;
I_corner=4*(Ix_corner+F0*(h_wall1/2-y0_corner)^2);
I_rivet= 2 * (d1_rivet^3 * (delta_wall+2*S_corner) / 12+d1_rivet*(delta_wall+2*S_corner) * (h1_rivet/2)^2)...
+2 * (d2_rivet*(delta_covering+S_corner)^3 / 12+ d2_rivet*(delta_covering+S_corner)*(h_wall1/2 +delta_covering-(delta_covering+S_corner)/2))^2;
I = I_wall + I_covering +I_corner- I_rivet-F*y_c^2;

[~, idx] =max(theta(:,2));N_coor1=N(idx);
[M_min, idx] =min(theta(:,2));N_coor2=N(idx);

sigma_p_A2 = (M_min / I) * (h/2 - c) + (N*1e3 / F);
sigma_p_B2 = (M_min / I) * (h/2 + c) + (N*1e3 / F);

sigma_p_tensile= max(sigma_p_A, sigma_p_B);
sigma_p_compressive= min(sigma_p_A, sigma_p_B);
%从这边开始算----------------------------------------------------------
k_buckle_B = 0.8; % Buckling coefficient for point B
sigma_b = 440; % Ultimate or yield stress in MPa
eta_buckle = k_buckle_B * sigma_b / sigma_p_tensile;
eta_stability = sigma_kp1 / sigma_p_compressive;

b0 = 150.9; % Base width of the section, in mm
F2 = 121.2; % Area or force parameter related to flanges, check context, in mm^2 (example value)
d1 = 7.325; % Distance to the flange or similar, in mm (example value)
delta = 2*delta_0; % Twice the thickness parameter, in mm (example value)

% S0 calculation
S0 = (1/2) * ((b0*((h/2 - c)^2)) + (b0*delta*((h/2 - c - delta/2)^2)) + (2*F2*((h/2 - c - y0)^2)) - (d1*(delta + 2*S)*(h/2 - c - 2*d1 + delta/2)^2));


% Maximum shear stress (tau_p_max)
tau_p_max = (Q_l_max * S_0) / (I * delta); % in MPa

% Calculation based on Hooke's law (tau_0_kp)
E = 4.8e7; % Modulus of elasticity in MPa
h_1 = 141.8; % Dimension in mm
tau_0_kp = (4.8 * E * delta^2) / (h_1^2); % in MPa

% Shear stress limit of proportionality (tau_m)
sigma_m = 190; % Material's yield stress in MPa
tau_m = sigma_m / sqrt(3); % in MPa

% Refinement of tau_kp according to equation (3.79)
tau_star = tau_0_kp / sqrt(3); % in MPa

% Calculation of corrected tau_kp
tau_kp = tau_star / (tau_0_kp + tau_star - tau_m); % in MPa

% Safety factor for wall stability from shear stress (eta)
tau_p_max_val = 70.9; % Maximum shear stress in MPa (from previous calculations or given)
eta = tau_kp / tau_p_max_val;
% Given values
h = 170; % Height dimension in mm
c = 21.88; % Distance from the neutral axis to the outer fiber in mm
b0 = 150.9; % Width dimension in mm
delta_0 = 3.2; % First delta value in mm
delta = 7.325; % Second delta value in mm (possibly the total thickness)
F2 = 141.8; 
S0 = (1/2) * ((b0*((h/2 - c)^2)) + (b0*delta_0*((h/2 - c - delta_0/2)^2)) ...
     + (2*F2*((h/2 - c - y0)^2)) - (d1*(delta + 2*delta_0)*(h/2 - c - d1 + delta_0/2)^2));
 % Given values and equations as per the image
Q_l_max = 32.1e3; % Shear force in N (converted from kN)
S_1 = 3.673e4; % Static moment S1 in mm^3 (may need to be calculated based on your problem)
I = 6334e6; % Moment of inertia in mm^4
t_1 = 30; % Thickness in mm

% Force on a rivet determined by formula (3.81)
P_r1 = (Q_l_max * S_1) / (I * t_1); % in Newtons

% Shear force on a rivet according to equation (3.82)
d_1 = 4; % Diameter of the rivet in mm
P_lcp = (pi * d_1^2) / 4 * (t_1/245); % in Newtons, 245 could be the shear strength in MPa, confirm this from context

% Safety factor for shear on the rivet
eta_shear = (2 * P_lcp) / P_r1;

% The force taken by a rivet in the connection joint may be different
P_r2 = 780; % Force on the second rivet in N, given value

% Safety factor for the second rivet
d_2 = 3; % Diameter of the second rivet in mm
P_2cp = (pi * d_2^2) / 4 * (t_1/245); % in Newtons, similar calculation as P_lcp
eta_2 = P_2cp / P_r2;

% Display results
disp(['Force on rivet 1 (P_r1): ' num2str(P_r1) ' N']);
disp(['Safety factor for rivet 1 (eta_shear): ' num2str(eta_shear)]);
disp(['Force on rivet 2 (P_2cp): ' num2str(P_2cp) ' N']);
disp(['Safety factor for rivet 2 (eta_2): ' num2str(eta_2)]);
    % Rivet force and geometric parameters
P_r1 = 5567; % Force on rivet 1 in N
d_1 = 4; % Diameter of rivet 1 in mm
delta_1 = 3; % Wall thickness in mm (possibly delta_1)

% Stress on the wall from rivet 1
sigma_p_cm = P_r1 / (d_1 * delta_1); % in MPa

% Allowable stress based on material properties

safety_factor_b = 1.3; % Safety factor for material stress
sigma_cm_allow = safety_factor_b * sigma_b; % in MPa

% Safety factor for the wall compression stress
eta_wall = sigma_cm_allow / sigma_p_cm;

% Stress on the flange from rivet 2
P_r2 = 780; % Force on rivet 2 in N
d_2 = 3; % Diameter of rivet 2 in mm
delta_2 = 3; % Wall thickness in mm (possibly delta_2)
sigma_p_cm_flange = P_r2 / (d_2 * delta_2); % in MPa

% Safety factor for the flange compression stress
eta_flange = sigma_cm_allow / sigma_p_cm_flange;

% Display results
disp(['Compression stress on wall (sigma_p_cm): ' num2str(sigma_p_cm) ' MPa']);
disp(['Safety factor for wall (eta_wall): ' num2str(eta_wall)]);
disp(['Compression stress on flange (sigma_p_cm_flange): ' num2str(sigma_p_cm_flange) ' MPa']);
disp(['Safety factor for flange (eta_flange): ' num2str(eta_flange)]);

