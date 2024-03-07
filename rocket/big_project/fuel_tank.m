clc;clear all ;close all;dbclear all
%% 2 基本参数确定  https://en.wikipedia.org/wiki/Long_March_2E
H=14.22/3;D=3.35;
% Assuming necessary variables are defined
V = sqrt(2 * q / rho); % q is dynamic pressure, rho is density
% Assuming necessary variables are defined
alpha = atan2(W, U); % W is vertical velocity, U is horizontal velocity
% Assuming necessary variables and coefficients are defined
F_shear = 0.5 * rho * V^2 * A * C_shear; % C_shear is the coefficient of shear force
F_longitudinal = 0.5 * rho * V^2 * A * C_longitudinal; % C_longitudinal is the coefficient of longitudinal force
% Assuming necessary variables are defined
Q_t = m_fuel * g * sin(theta); % m_fuel is the mass of the fuel, g is acceleration due to gravity, theta is the angle
M_t = Q_t * d; % d is the distance from the base to the CG of the bottom
% Assuming necessary variables are defined
n_transverse = (T * sin(delta)) / (m_rocket * g); % T is thrust, delta is the thrust deviation angle, m_rocket is the mass of the rocket
% Assuming necessary variables are defined
F_axial = P_press * pi * r^2 - m_fuel * g; % P_press is pressurization pressure, r is the tank radius
%% 3
p_ne = p0 + rho * g * n * x * H; % Operational internal pressure
h = R_n - sqrt(R_n^2 - R^2); % Depth of the bottom
p_maxe = p0 + rho * g * n * (H + h); % Max operational pressure
delta = (f * p_ne * R) / (k_sw * sigma_B); % Shell thickness
delta_0n = (f * p_maxe * R_n^2) / (k_sw * sigma_B); % Bottom thickness
% Assuming N_e and M_e are defined (external loads)
sigma_11Pmaxmin = (f * N_e) / (2 * pi * R * delta) ± (M_e) / (pi * R^2 * delta); % Stress calculation
sigma_ekv = sqrt(sigma_11p^2 - sigma_11p * sigma_22p + sigma_22p^2 + 3 * (tau_p)^2); % Equivalent stress
eta = (k_sw * sigma_B) / sigma_ekv; % Strength margin


