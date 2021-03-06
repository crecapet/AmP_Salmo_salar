function [par, metaPar, txtPar] = pars_init_Salmo_salar(metaData)

metaPar.model = 'std'; 

%% reference parameter (not to be changed) 
par.T_ref = 293.15;   free.T_ref = 0;   units.T_ref = 'K';        label.T_ref = 'Reference temperature'; 

%% core primary parameters 
par.z    = 14.48;      free.z     = 1;   units.z     = '-';        label.z     = 'zoom factor';
par.F_m   = 6.5;   free.F_m   = 0;   units.F_m   = 'l/d.cm^2'; label.F_m   = '{F_m}, max spec searching rate';
par.kap_X = 0.8;   free.kap_X = 0;   units.kap_X = '-';        label.kap_X = 'digestion efficiency of food to reserve';
par.kap_P = 0.1;   free.kap_P = 0;   units.kap_P = '-';        label.kap_P = 'faecation efficiency of food to faeces';
par.v     = 0.02;  free.v     = 1;   units.v     = 'cm/d';     label.v     = 'energy conductance';
par.kap   = 0.9;   free.kap   = 1;   units.kap   = '-';        label.kap   = 'allocation fraction to soma';
par.kap_R = 0.95;  free.kap_R = 0;   units.kap_R = '-';        label.kap_R = 'reproduction efficiency';
par.p_M   = 18;    free.p_M   = 1;   units.p_M   = 'J/d.cm^3'; label.p_M   = '[p_M], vol-spec somatic maint';
par.p_T   = 0;    free.p_T   = 0;   units.p_T   = 'J/d.cm^2'; label.p_T   = '{p_T}, surf-spec somatic maint';
par.k_J   = 0.002; free.k_J   = 0;   units.k_J   = '1/d';      label.k_J   = 'maturity maint rate coefficient';
par.E_G   = 5200;  free.E_G   = 1;   units.E_G   = 'J/cm^3';   label.E_G   = '[E_G], spec cost for structure';
par.E_Hh  = 50;  free.E_Hh  = 1;   units.E_Hh  = 'J';        label.E_Hh  = 'maturity at hatch';
par.E_Hb  = 60;  free.E_Hb  = 1;   units.E_Hb  = 'J';        label.E_Hb  = 'maturity at birth';
% par.E_Hs  = 1000;  free.E_Hb  = 1;   units.E_Hb  = 'J';        label.E_Hb  = 'maturity at smoltification';
par.E_Hp  = 10000;    free.E_Hp  = 1;   units.E_Hp  = 'J';        label.E_Hp  = 'maturity at puberty';
par.h_a   = 1e-6;  free.h_a   = 1;   units.h_a   = '1/d^2';    label.h_a   = 'Weibull aging acceleration';
par.s_G   = 1e-4;  free.s_G   = 0;   units.s_G   = '-';        label.s_G   = 'Gompertz stress coefficient';

%% auxiliary parameters
par.T_A   = 8000;   free.T_A   = 1;    units.T_A = 'K';        label.T_A = 'Arrhenius temperature';
par.del_M = 0.16;   free.del_M = 1;    units.del_M = '-';      label.del_M = 'shape coefficient';

%% environmental parameters (temperatures are in auxData)
par.f = 0.7;        free.f     = 0;    units.f = '-';          label.f    = 'scaled functional response for 0-var data';
par.f_Tah = 1;     free.f_Tah  = 0;    units.f_Tah = '-';       label.f_Tah = 'scaled functional response for temperature-age at hatching data';
par.f_Tab = 1;     free.f_Tab  = 0;    units.f_Tab = '-';       label.f_Tab = 'scaled functional response for temperature-age at hatching data';
par.f_tL = 1;     free.f_tL  = 0;    units.f_tL = '-';       label.f_tL = 'scaled functional response for time-length data';
par.f_LWw_parrs = 0.7;    free.f_LWw_parrs  = 0;   units.f_LWw_parrs = '-';      label.f_LWw_parrs = 'scaled functional response for length-weight data';
par.f_LWw_spawners = 0.7;    free.f_LWw_spawners  = 0;   units.f_LWw_spawners = '-';      label.f_LWw_spawners = 'scaled functional response for length-weight data';
par.f_tWeVe_tWeYe = 1;  free.f_tWeVe_tWeYe = 0; units.f_tWeVe_tWeYe = '-';  label.f_tWeVe_tWeYe = 'scaled functional response for embryo growth';
par.t0_tL = 10;    free.t0_tL   = 1;   units.t0_tL = 'd';          label.t0_tL = 'time since birth at start of growth data (Einum 2000)'; 

%% set chemical parameters from Kooy2010 
[par, units, label, free] = addchem(par, units, label, free, metaData.phylum, metaData.class);

%% Pack output: 
txtPar.units = units; txtPar.label = label; par.free = free; 
