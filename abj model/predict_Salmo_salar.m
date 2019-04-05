function [prdData, info] = predict_Salmo_salar(par, data, auxData)
  
  % unpack par, data, auxData
  cPar = parscomp_st(par); vars_pull(par); 
  vars_pull(cPar);  vars_pull(data);  vars_pull(auxData);
  
     filterChecks = E_Hh > E_Hb || E_Hh < 0;
%                      f1>1 || f1 <0 || ...
%                      f2>1 || f2 <0 || ...
%                      f3>1 || f3 <0 || ...
%                      s_shrink < 0 || s_shrink > 1e6 || ...
%                      L_init < 0 || L_init > L_m * 43 || L_init^3 > 0.9 * 0.35 || ...
%                      E_R_init < 0 || w_E/ mu_E/ d_E * E_R_init > 0.8 * 0.35; 
  
  if filterChecks  
    info = 0;
    prdData = {};
    return;
  end  

%   % customized filters for allowable parameters of the standard DEB model (std)
%   % for other models consult the appropriate filter function.
%   pars_tj = [g; k; l_T; v_Hb; v_Hj; v_Hp];
%   [t_j, t_p, t_b, l_j, l_p, l_b, l_i, rho_j, rho_B, info] = get_tj(pars_tj, f_tL);
%   if info ~= 1 % numerical procedure failed
%       fprintf('warning: invalid parameter value combination for get_tj \n')
%   end
%   s_M = l_j / l_b;
%   filterChecks = k * v_Hp >= f_tL ^3 * s_M^3  || ...         % constraint required for reaching puberty with f_tL
%   
%   if filterChecks  
%     info = 0;
%     prdData = {};
%     return;
%   end  

  % compute temperature correction factors
  TC_Tah = tempcorr(Tah(:,1), T_ref, T_A);
  TC_Tab = tempcorr(Tab(:,1), T_ref, T_A);
% TC_aj = tempcorr(temp.aj, T_ref, T_A);
% TC_as = tempcorr(temp.as, T_ref, T_A);
  TC_ap = tempcorr(temp.ap, T_ref, T_A);
  TC_am = tempcorr(temp.am, T_ref, T_A);
  TC_Ri = tempcorr(temp.Ri, T_ref, T_A);
  TC_tL = tempcorr(temp.tL, T_ref, T_A);
% TC_tL_f0 = tempcorr(temp.tL_f0, T_ref, T_A);
%   TC_tL_f25 = tempcorr(temp.tL_f25, T_ref, T_A);
%   TC_tL_f50 = tempcorr(temp.tL_f50, T_ref, T_A);
%   TC_tL_f75 = tempcorr(temp.tL_f75, T_ref, T_A);
%   TC_tL_f100 = tempcorr(temp.tL_f100, T_ref, T_A);
  
  % zero-variate data

  % life cycle
  pars_tj = [g; k; l_T; v_Hb; v_Hj; v_Hp];
  [tau_j, tau_p, tau_b, l_j, l_p, l_b, l_i, rho_j, rho_B, info] = get_tj(pars_tj, f);
  if info ~= 1 % numerical procedure failed
     fprintf('warning: invalid parameter value combination for get_tj \n')
  end
  
  % initial
  pars_UE0 = [V_Hb; g; k_J; k_M; v]; % compose parameter vector
  U_E0 = initial_scaled_reserve(f, pars_UE0); % d.cm^2, initial scaled reserve
  E_0 = p_Am * U_E0;            % J, initial energy content
  Wd_0 = E_0 * w_E/ mu_E;      % g, initial dry weight 
  V_0 = Wd_0/ d_E;             % cm^3, egg volume 
  
  % hatch   
  [U_H aUL] = ode45(@dget_aul, [0; U_Hh; U_Hb], [0 U_E0 1e-10], [], kap, v, k_J, g, L_m);
% a_h = aUL(2,1); aT_h = a_h/ TC_ah; % d, age at hatch at f and T
  L_h = aUL(2,3); % cm, structural length at hatch at f
  Lw_h = L_h / del_M;  % cm, structural length at hatch at f
  Ww_h = L_h^3 * (1 + f * ome);       % g, wet weight at hatch at f 

  % birth
  L_b = L_m * l_b;                  % cm, structural length at birth at f
  Lw_b = L_b/ del_M;                % cm, physical length at birth at f
  Ww_b = L_b^3 * (1 + f * ome);       % g, wet weight at birth at f 
% aT_b = tau_b/ k_M/ TC_ab;           % d, age at birth at f and T

  % metamorphosis
%   L_j = L_m * l_j;                  % cm, structural length at metam
%   Lw_j = L_j/ del_M;                % cm, physical length at metam at f
%   Ww_j = L_j^3 * (1 + f * ome);       % g, wet weight at metam
%   aT_j = tau_j/ k_M/ TC_aj;  % d, age at metam

  % smoltification   
%   Lw_s = L_slim;  % cm, physical length at smoltification at f
%   Ww_s = L_s^3 * (1 + f * ome);       % g, wet weight at smoltification at f 
%   F = f; 
%   [tau_j, tau_p, tau_b, l_j, l_p, l_b, l_i, rho_j, rho_B, info] = get_tj(pars_tj, F);
%   rT_B = TC_as * rho_B * k_M;  % 1/d, von Bert growth rate   
%   rT_j = TC_as * rho_j * k_M;  % 1/d, exponential growth rate
%   aT_b = tau_b/ k_M/ TC_as; aT_j = tau_j/ k_M/ TC_as;   
%   t_j = aT_j - aT_b; % time since birth at metamorphosis
%   L_j = L_m * l_j;
%   Lw_b = l_b * L_m/ del_M; 
%   Lw_j = l_j * L_m/ del_M; 
%   Lw_i = l_i * L_m/ del_M;
%   if L_s < L_j % select times between birth & metamorphosis   
%     t_s = log(Lw_s/Lw_b)*3/rT_j; % exponential growth as V1-morph
%     aT_s = aT_b + t_s;
%   else % selects times after metamorphosis
%     t_s = t_j - log((Lw_i - Lw_s)/(Lw_i - Lw_j))/rT_B ; % d, time since birth at smoltification
%     aT_s = aT_b + t_s;
%   end

  % puberty 
  L_p = L_m * l_p;                  % cm, structural length at puberty at f
  Lw_p = L_p/ del_M;                % cm, physical length at puberty at f
  Ww_p = L_p^3 *(1 + f * ome);        % g, wet weight at puberty 
  aT_p = tau_p / k_M/ TC_ap;   % d, age at puberty at f and T

  % ultimate
  L_i = L_m * l_i;                  % cm, ultimate structural length at f
  Lw_i = L_i/ del_M;                % cm, ultimate physical length at f
  Ww_i = L_i^3 * (1 + f * ome);       % g, ultimate wet weight 
 
  % reproduction
  pars_R = [kap, kap_R, g, k_J, k_M, L_T, v, U_Hb, U_Hj, U_Hp];
  [R_i, UE0, Lb, Lj, Lp, info]  =  reprod_rate_j(L_i, f, pars_R, L_b);
  RT_i = TC_Ri * R_i;% #/d, max reprod rate

  % life span
  pars_tm = [g; l_T; h_a/ k_M^2; s_G];  % compose parameter vector at T_ref
  t_m = get_tm_s(pars_tm, f, l_b);      % -, scaled mean life span at T_ref
  aT_m = t_m/ k_M/ TC_am;               % d, mean life span at T
  
  % pack to output
% prdData.ah = aT_h;
% prdData.ab = aT_b;
% prdData.tj = tT_j;
% prdData.aj = aT_j;
% prdData.as = aT_s;
% prdData.tp = tT_p;
  prdData.ap = aT_p;
  prdData.am = aT_m;
  prdData.Lh = Lw_h;
  prdData.Lb = Lw_b;
% prdData.Lj = Lw_j;
% prdData.Ls = Lw_s;
% prdData.Lp = Lw_p;
  prdData.Li = Lw_i;
  prdData.V0 = V_0;
  prdData.Wd0 = Wd_0;
  prdData.Wwh = Ww_h;
  prdData.Wwb = Ww_b;
% prdData.Wwj = Ww_j;
% prdData.Wws = Ww_s;
% prdData.Wwp = Ww_p;
  prdData.Wwi_F = Ww_i;
  prdData.E0 = E_0;
  prdData.Ri = RT_i;
  
  % uni-variate data
  
  % t-Wwe and t-WwVe
  % temperature 8°C
  % compute temperature correction factors
  TC8 = tempcorr(temp.tWwVe_T8, T_ref, T_A);
  vT8 = v * TC8; kT8_J = TC8 * k_J;% kT_M = TC * k_M; pT_M = p_M * TC;
  JT8_E_Am = TC8 * J_E_Am;
  UT8_E0 = TC8 * U_E0;
  
  % tW-data embryo witout yolk
  t = [0; tWwVe_T8(:,1)]; 
  [t LUH] = ode45(@dget_LUH, t, [1e-10 UT8_E0 0], [], kap, vT8, kT8_J, g, L_m); 
  LUH(1,:) = []; L = LUH(:,1); % cm, structural length
  EWw_e8 = L .^ 3 * (1 + f_tWeVe_tWeYe * w); % g, wet weight embryo minus vitellus
  % tWV-data yolk
  t = [0; tWwYe_T8(:,1)]; 
  [t LUH] = ode45(@dget_LUH, t, [1e-10 UT8_E0 0], [], kap, vT8, kT8_J, g, L_m); 
  LUH(1,:) = []; 
  L = LUH(:,1); L3 = L .^3; M_E = LUH(:,2) * JT8_E_Am;
  EV_e8 = max(0, M_E * w_E/ d_E - L3 * f_tWeVe_tWeYe * w); % g, wet weight vitellus
  
  % temperature 10°C
  % compute temperature correction factors
  TC10 = tempcorr(temp.tWwVe_T10, T_ref, T_A);
  vT10 = v * TC10; kT10_J = TC10 * k_J;% kT_M = TC * k_M; pT_M = p_M * TC;
  JT10_E_Am = TC10 * J_E_Am;
  UT10_E0 = TC10 * U_E0;
  
  % tW-data embryo without yolk
  t = [0; tWwVe_T10(:,1)]; 
  [t LUH] = ode45(@dget_LUH, t, [1e-10 UT10_E0 0], [], kap, vT10, kT10_J, g, L_m); 
  LUH(1,:) = []; L = LUH(:,1); % cm, structural length
  EWw_e10 = L .^ 3 * (1 + f_tWeVe_tWeYe * w); % g, wet weight embryo minus vitellus
  % tWV-data
  t = [0; tWwYe_T10(:,1)]; 
  [t LUH] = ode45(@dget_LUH, t, [1e-10 UT10_E0 0], [], kap, vT10, kT10_J, g, L_m); 
  LUH(1,:) = []; 
  L = LUH(:,1); L3 = L .^3; M_E = LUH(:,2) * JT10_E_Am;
  EV_e10 = max(0, M_E * w_E/ d_E - L3 * f_tWeVe_tWeYe * w); % g, wet weight vitellus
  
  % temperature 12°C
  % compute temperature correction factors
  TC12 = tempcorr(temp.tWwVe_T12, T_ref, T_A);
  vT12 = v * TC12; kT12_J = TC12 * k_J;% kT_M = TC * k_M; pT_M = p_M * TC;
  JT12_E_Am = TC12 * J_E_Am;
  UT12_E0 = TC12 * U_E0;
  
  % tW-data embryo witout yolk
  t = [0; tWwVe_T12(:,1)]; 
  [t LUH] = ode45(@dget_LUH, t, [1e-10 UT12_E0 0], [], kap, vT12, kT12_J, g, L_m); 
  LUH(1,:) = []; L = LUH(:,1); % cm, structural length
  EWw_e12 = L .^ 3 * (1 + f_tWeVe_tWeYe * w); % g, wet weight embryo minus vitellus
  % tWV-data
  t = [0; tWwYe_T12(:,1)]; 
  [t LUH] = ode45(@dget_LUH, t, [1e-10 UT12_E0 0], [], kap, vT12, kT12_J, g, L_m); 
  LUH(1,:) = []; 
  L = LUH(:,1); L3 = L .^3; M_E = LUH(:,2) * JT12_E_Am;
  EV_e12 = max(0, M_E * w_E/ d_E - L3 * f_tWeVe_tWeYe * w); % g, wet weight vitellus  
  
  % time-length 
  F = f_tL; 
  [tau_j, tau_p, tau_b, l_j, l_p, l_b, l_i, rho_j, rho_B, info] = get_tj(pars_tj, F);
  rT_B = TC_tL * rho_B * k_M;  % 1/d, von Bert growth rate   
  rT_j = TC_tL * rho_j * k_M;  % 1/d, exponential growth rate
  aT_b = tau_b/ k_M/ TC_tL; aT_j = tau_j/ k_M/ TC_tL;   
  t_j = aT_j - aT_b; % time since birth at metamorphosis
  t_bj = tL(tL(:,1) < t_j,1); % select times between birth & metamorphosis   
  Lw_b = l_b * L_m/ del_M; 
  Lw_j = l_j * L_m/ del_M; 
  Lw_i = l_i * L_m/ del_M;
  EL_bj = Lw_b * exp(t_bj * rT_j/3); % exponential growth as V1-morph
  t_ji = tL(tL(:,1) >= t_j,1); % selects times after metamorphosis
  EL_ji = Lw_i - (Lw_i - Lw_j) * exp( - rT_B * (t_ji - t_j)); % cm, expected length at time
  ELw = [EL_bj; EL_ji]; % catenate lengths
  
  % time-length and time-weight at different food levels
  % no food
%   F = f_tL_f0; 
%   [tau_j, tau_p, tau_b, l_j, l_p, l_b, l_i, rho_j, rho_B, info] = get_tj(pars_tj, F);
%   rT_B = TC_tL_f0 * rho_B * k_M;  % 1/d, von Bert growth rate   
%   rT_j = TC_tL_f0 * rho_j * k_M;  % 1/d, exponential growth rate
%   aT_b = tau_b/ k_M/ TC_tL_f0; aT_j = tau_j/ k_M/ TC_tL_f0;   
%   t_j = aT_j - aT_b; % time since birth at metamorphosis
%   t_bj = tL_f0(tL_f0(:,1) < t_j,1); % select times between birth & metamorphosis   
%   Lw_b = l_b * L_m/ del_M; 
%   Lw_j = l_j * L_m/ del_M; 
%   Lw_i = l_i * L_m/ del_M;
%   EL_bj = Lw_b * exp(t_bj * rT_j/3); % exponential growth as V1-morph
%   t_ji = tL_f0(tL_f0(:,1) >= t_j,1); % selects times after metamorphosis
%   EL_ji = Lw_i - (Lw_i - Lw_j) * exp( - rT_B * (t_ji - t_j)); % cm, expected length at time
%   ELw_f0 = [EL_bj; EL_ji]; % catenate lengths
%   EWw_f0 = (tL_f0(:,2) * del_M).^3 * (1 + F * ome); % g, wet weight

%   % 25 percent food
%   F = f_tL_f25; 
%   [tau_j, tau_p, tau_b, l_j, l_p, l_b, l_i, rho_j, rho_B, info] = get_tj(pars_tj, F);
%   rT_B = TC_tL_f25 * rho_B * k_M;  % 1/d, von Bert growth rate   
%   rT_j = TC_tL_f25 * rho_j * k_M;  % 1/d, exponential growth rate
%   aT_b = tau_b/ k_M/ TC_tL_f25; aT_j = tau_j/ k_M/ TC_tL_f25;   
%   t_j = aT_j - aT_b; % time since birth at metamorphosis
%   t_bj = tL_f25(tL_f25(:,1) + t0_tLWwf < t_j,1); % select times between birth & metamorphosis   
%   Lw_b = l_b * L_m/ del_M; 
%   Lw_j = l_j * L_m/ del_M; 
%   Lw_i = l_i * L_m/ del_M;
%   EL_bj = Lw_b * exp(t_bj * rT_j/3); % exponential growth as V1-morph
%   t_ji = tL_f25(tL_f25(:,1) >= t_j,1); % selects times after metamorphosis
%   EL_ji = Lw_i - (Lw_i - Lw_j) * exp( - rT_B * (t_ji - t_j)); % cm, expected length at time
%   ELw_f25 = [EL_bj; EL_ji]; % catenate lengths
% % EWw_f25 = (tL_f25(:,2) * del_M).^3 * (1 + F * ome); % g, wet weight
% 
%   % 50 percent food
%   F = f_tL_f50; 
%   [tau_j, tau_p, tau_b, l_j, l_p, l_b, l_i, rho_j, rho_B, info] = get_tj(pars_tj, F);
%   rT_B = TC_tL_f50 * rho_B * k_M;  % 1/d, von Bert growth rate   
%   rT_j = TC_tL_f50 * rho_j * k_M;  % 1/d, exponential growth rate
%   aT_b = tau_b/ k_M/ TC_tL_f50; aT_j = tau_j/ k_M/ TC_tL_f50;   
%   t_j = aT_j - aT_b; % time since birth at metamorphosis
%   t_bj = tL_f50(tL_f50(:,1) < t_j,1); % select times between birth & metamorphosis   
%   Lw_b = l_b * L_m/ del_M; 
%   Lw_j = l_j * L_m/ del_M; 
%   Lw_i = l_i * L_m/ del_M;
%   EL_bj = Lw_b * exp(t_bj * rT_j/3); % exponential growth as V1-morph
%   t_ji = tL_f50(tL_f50(:,1) >= t_j,1); % selects times after metamorphosis
%   EL_ji = Lw_i - (Lw_i - Lw_j) * exp( - rT_B * (t_ji - t_j)); % cm, expected length at time
%   ELw_f50 = [EL_bj; EL_ji]; % catenate lengths
% % EWw_f50 = (tL_f50(:,2) * del_M).^3 * (1 + F * ome); % g, wet weight
% 
%   % 75 percent food
%   F = f_tL_f75; 
%   [tau_j, tau_p, tau_b, l_j, l_p, l_b, l_i, rho_j, rho_B, info] = get_tj(pars_tj, F);
%   rT_B = TC_tL_f75 * rho_B * k_M;  % 1/d, von Bert growth rate   
%   rT_j = TC_tL_f75 * rho_j * k_M;  % 1/d, exponential growth rate
%   aT_b = tau_b/ k_M/ TC_tL_f75; aT_j = tau_j/ k_M/ TC_tL_f75;   
%   t_j = aT_j - aT_b; % time since birth at metamorphosis
%   t_bj = tL_f75(tL_f75(:,1) < t_j,1); % select times between birth & metamorphosis   
%   Lw_b = l_b * L_m/ del_M; 
%   Lw_j = l_j * L_m/ del_M; 
%   Lw_i = l_i * L_m/ del_M;
%   EL_bj = Lw_b * exp(t_bj * rT_j/3); % exponential growth as V1-morph
%   t_ji = tL_f75(tL_f75(:,1) >= t_j,1); % selects times after metamorphosis
%   EL_ji = Lw_i - (Lw_i - Lw_j) * exp( - rT_B * (t_ji - t_j)); % cm, expected length at time
%   ELw_f75 = [EL_bj; EL_ji]; % catenate lengths
% % EWw_f75 = (tL_f75(:,2) * del_M).^3 * (1 + F * ome); % g, wet weight
% 
%   % 100 percent food
%   F = f_tL_f100; 
%   [tau_j, tau_p, tau_b, l_j, l_p, l_b, l_i, rho_j, rho_B, info] = get_tj(pars_tj, F);
%   rT_B = TC_tL_f100 * rho_B * k_M;  % 1/d, von Bert growth rate   
%   rT_j = TC_tL_f100 * rho_j * k_M;  % 1/d, exponential growth rate
%   aT_b = tau_b/ k_M/ TC_tL_f75; aT_j = tau_j/ k_M/ TC_tL_f75;   
%   t_j = aT_j - aT_b; % time since birth at metamorphosis
%   t_bj = tL_f100(tL_f100(:,1) < t_j,1); % select times between birth & metamorphosis   
%   Lw_b = l_b * L_m/ del_M; 
%   Lw_j = l_j * L_m/ del_M; 
%   Lw_i = l_i * L_m/ del_M;
%   EL_bj = Lw_b * exp(t_bj * rT_j/3); % exponential growth as V1-morph
%   t_ji = tL_f100(tL_f100(:,1) >= t_j,1); % selects times after metamorphosis
%   EL_ji = Lw_i - (Lw_i - Lw_j) * exp( - rT_B * (t_ji - t_j)); % cm, expected length at time
%   ELw_f100 = [EL_bj; EL_ji]; % catenate lengths
% % EWw_f100 = (tL_f100(:,2) * del_M).^3 * (1 + F * ome); % g, wet weight

  % length-weight
  EWw_parrs = (LWw_parrs(:,1) * del_M).^3 * (1 + f_LWw_parrs * ome); % g, wet weight
  EWw_spawners = (LWw_spawners(:,1) * del_M).^3 * (1 + f_LWw_spawners * ome); % g, wet weight

  % temperature-age at hatching
  Eah = aUL(2,1) ./ TC_Tah; % d, time at hatch
  
  % temperature-age at birth
  Eab = tau_b/ k_M ./ TC_Tab;        % d, age at birth at f and T
  
  % L-N data for females
  
  
  % pack to output
  prdData.tL = ELw;
% prdData.tL_f0 = ELw_f0;
%   prdData.tL_f25 = ELw_f25;
%   prdData.tL_f50 = ELw_f50;
%   prdData.tL_f75 = ELw_f75;
%   prdData.tL_f100 = ELw_f100;
% prdData.tWw_f0 = EWw_f0;
%   prdData.tWw_f25 = EWw_f25;
%   prdData.tWw_f50 = EWw_f50;
%   prdData.tWw_f75 = EWw_f75;
%   prdData.tWw_f100 = EWw_f100;
  prdData.tWwVe_T8 = EWw_e8;
  prdData.tWwYe_T8 = EV_e8;
  prdData.tWwVe_T10 = EWw_e10;
  prdData.tWwYe_T10 = EV_e10;
  prdData.tWwVe_T12 = EWw_e12;
  prdData.tWwYe_T12 = EV_e12;
  prdData.LWw_parrs = EWw_parrs;
  prdData.LWw_spawners = EWw_spawners;
  prdData.Tah = Eah;
  prdData.Tab = Eab;
