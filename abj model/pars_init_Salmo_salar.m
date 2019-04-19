function [par, metaPar, txtPar] = pars_init_Salmo_salar(metaData)

metaPar.model = 'abj'; 

%% reference parameter (not to be changed) 
par.T_ref = 293.15;   free.T_ref = 0;   units.T_ref = 'K';        label.T_ref = 'Reference temperature'; 

%% core primary parameters 
par.T_A = 10000;  free.T_A   = 0;   units.T_A = 'K';          label.T_A = 'Arrhenius temperature'; 
par.z = 9.5888;       free.z     = 1;   units.z = '-';            label.z = 'zoom factor'; 
par.F_m = 6.5;        free.F_m   = 0;   units.F_m = 'l/d.cm^2';   label.F_m = '{F_m}, max spec searching rate'; 
par.kap_X = 0.8;      free.kap_X = 0;   units.kap_X = '-';        label.kap_X = 'digestion efficiency of food to reserve'; 
par.kap_P = 0.1;      free.kap_P = 0;   units.kap_P = '-';        label.kap_P = 'faecation efficiency of food to faeces'; 
par.v = 0.0088671;    free.v     = 1;   units.v = 'cm/d';         label.v = 'energy conductance'; 
par.kap = 0.47264;    free.kap   = 1;   units.kap = '-';          label.kap = 'allocation fraction to soma'; 
par.kap_R = 0.95;     free.kap_R = 0;   units.kap_R = '-';        label.kap_R = 'reproduction efficiency'; 
par.p_M = 47.0073;    free.p_M   = 1;   units.p_M = 'J/d.cm^3';   label.p_M = '[p_M], vol-spec somatic maint'; 
par.p_T = 0;          free.p_T   = 0;   units.p_T = 'J/d.cm^2';   label.p_T = '{p_T}, surf-spec somatic maint'; 
par.k_J = 0.002;      free.k_J   = 0;   units.k_J = '1/d';        label.k_J = 'maturity maint rate coefficient'; 
par.E_G = 5200*2;  free.E_G   = 1;   units.E_G = 'J/cm^3';     label.E_G = '[E_G], spec cost for structure'; 
par.E_Hh = 5.212e+01; free.E_Hh  = 1;   units.E_Hh = 'J';         label.E_Hh = 'maturity at hatch'; 
par.E_Hb = 5.641e+01; free.E_Hb  = 1;   units.E_Hb = 'J';         label.E_Hb = 'maturity at birth'; 
par.E_Hj = 1.451e+02; free.E_Hj  = 1;   units.E_Hj = 'J';         label.E_Hj = 'maturity at metamorphosis'; 
par.E_Hp = 3.127e+05; free.E_Hp  = 1;   units.E_Hp = 'J';         label.E_Hp = 'maturity at puberty'; 
par.h_a = 1.976e-06;  free.h_a   = 1;   units.h_a = '1/d^2';      label.h_a = 'Weibull aging acceleration'; 
par.s_G = 1;          free.s_G   = 0;   units.s_G = '-';          label.s_G = 'Gompertz stress coefficient'; 

%% Auxiliary parameters 
par.L_slim = 12;      free.L_slim = 0;   units.L_slim = 'cm';      label.L_slim = 'length threshold for smoltification'; 
par.del_M = 0.084176;  free.del_M = 1;   units.del_M = '-';        label.del_M = 'shape coefficient'; 

%% Environmental parameters (excl. temperature)
par.f = 0.7;          free.f     = 0;   units.f = '-';            label.f = 'scaled functional response for 0-var data'; 
par.f_ah = par.f;         free.f_ah  = 0;   units.f_ah = '-';         label.f_ah = 'scaled functional response for age at hatching data'; 
par.f_ab = 1;         free.f_ab  = 0;   units.f_ab = '-';         label.f_ab = 'scaled functional response for age at birth data'; 
par.f_tL = 1;         free.f_tL  = 0;   units.f_tL = '-';         label.f_tL = 'scaled functional response for time-length data'; 
par.f_LWw_parrs = par.f;  free.f_LWw_parrs = 0;   units.f_LWw_parrs = '-';  label.f_LWw_parrs = 'scaled functional response for length-weight data'; 
par.f_LWw_spawners = par.f;  free.f_LWw_spawners = 0;   units.f_LWw_spawners = '-';  label.f_LWw_spawners = 'scaled functional response for length-weight data'; 
par.f_tL = 1;         free.f_tL  = 0;   units.f_tL = '-';         label.f_tL = 'scaled functional response for time-length data'; 
par.f_tLWw_f0 = 0;      free.f_tL_f0 = 0;   units.f_tL_f0 = '-';      label.f_tL_f0 = 'scaled functional response for growth data at different food levels'; 
par.f_tLWw_f100 = 1;    free.f_tL_f100 = 0;   units.f_tL_f100 = '-';    label.f_tL_f100 = 'scaled functional response for growth data at different food levels'; 
par.f_tLWw_f25 = 0.25;  free.f_tL_f25 = 0;   units.f_tL_f25 = '-';     label.f_tL_f25 = 'scaled functional response for growth data at different food levels'; 
par.f_tLWw_f50 = 0.5;   free.f_tL_f50 = 0;   units.f_tL_f50 = '-';     label.f_tL_f50 = 'scaled functional response for growth data at different food levels'; 
par.f_tLWw_f75 = 0.75;  free.f_tL_f75 = 0;   units.f_tL_f75 = '-';     label.f_tL_f75 = 'scaled functional response for growth data at different food levels'; 
% par.t0_tLWwf = 300;    free.t0_tLWwf   = 0;   units.t0_tLWwf = 'd';          label.t0_tLWwf = 'time since birth at 0 time for growth at different food levels'; 
par.f_tWeVe_tWeYe = 1;  free.f_tWeVe_tWeYe = 0;   units.f_tWeVe_tWeYe = '-';  label.f_tWeVe_tWeYe = 'scaled functional response for embryo growth'; 
par.f_tW = 1;         free.f_tW  = 0;   units.f_tW = '-';         label.f_tW = 'scaled functional response for time-weigth data'; 
par.W_0 = 81.9;       free.W_0   = 0;   units.W_0 = 'g';          label.W_0 = 'initial weigth in time-weigth data'; 
par.t0_tL = 20;    free.t0_tL   = 1;   units.t0_tL = 'd';          label.t0_tL = 'time since birth at 0 time in time-length data'; 

%% set chemical parameters from Kooy2010 
[par, units, label, free] = addchem(par, units, label, free, metaData.phylum, metaData.class); 
par.d_V = 0.25;        free.d_V   = 0;   units.d_V = 'g/cm^3';     label.d_V = 'specific density of structure'; 
par.d_E = 0.25;        free.d_E   = 0;   units.d_E = 'g/cm^3';     label.d_E = 'specific density of reserve'; 

%% Pack output: 
txtPar.units = units; txtPar.label = label; par.free = free; 
