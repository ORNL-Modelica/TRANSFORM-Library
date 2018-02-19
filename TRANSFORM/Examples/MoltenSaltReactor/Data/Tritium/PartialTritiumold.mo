within TRANSFORM.Examples.MoltenSaltReactor.Data.Tritium;
model PartialTritiumold

// function [Birth] = TritiumProductionCalculation(Vol_1, Core_coolant_vol, , , flux, t, ,,,,)

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// % Calculates the tritium birth rate due to neutron transmutation in flibe
// % as function of the average system temperature, the one-group flux,
// % and the salt composition (initial Li-7 enrichment).
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

import Modelica.Constants.N_A;

//Inputs
SI.MassFraction Li7_enrichment = 0.99995 "mass fraction Li-7 enrichment in flibe.  Baseline is 99.995%";
SI.Temperature T = 951 "flibe temperature";
Integer nComponents = 2 "Number of components in salt (e.g., 2 = {LiF, BeF2})";
SI.MoleFraction MMFrac_LiF = 0.67 "Mole fraction of LiF";

SI.Area sig_T_Li7 = 0.001e-28 "(n,T) cross section in Li-7 [m2]";
SI.Area sig_T_Li6 = 148.026e-28 "(n,T) cross section in Li-6 [m2]";
SI.Area sig_abs_Li6 = 148.032e-28 "(n,abs) cross section in Li-6 [m2]";
SI.Area sig_alpha_Be9 = 0.00363e-28 "(n,alpha) in Be-9 [m2]";
// birth = atoms/s
// Real flux;
// Real t;
// Real Core_coolant_vol;
// Real Vol_1;

  SI.MolarMass Flibe_MM = 0.0328931 "Molar mass of flibe [kg/mol] from doing 0.67*MM_LiF + 0.33*MM_BeF2";
  SI.Density d_flibe = 2415.6-0.49072*T "Flibe density from Janz correlation in Sohal 2010 [kg/m^3]";
  SI.MolarDensity d_MM_flibe = d_flibe/Flibe_MM "Molar density of flibe [mol flibe/m3]";

SI.MolarMass Li7_MM = 0.00701600455 "[kg/mol]";
SI.MolarMass Li6_MM = 0.006015122795 "[kg/mol]";

SI.MoleFraction Li7_molefrac = (Li7_enrichment/Li7_MM)/((Li7_enrichment/Li7_MM)+((1.0-Li7_enrichment)/Li6_MM)) "Mole fraction of lithium in flibe that is Li-7";
SI.MoleFraction Li6_molefrac = 1.0-Li7_molefrac "Mole fraction of lithium in flibe that is Li-6";

SI.MoleFraction d_MM_Li = 0.67*d_MM_flibe "Molar density of total lithium in flibe [mol Li/m3]";
SI.MoleFraction d_MM_Be = 0.33*d_MM_flibe "Molar density of total beryllium in flibe [mol Be/m3]";

SI.NumberDensityOfMolecules d_N_Li7 = d_MM_Li*Li7_molefrac*N_A "Number density of Li-7 atoms in flibe [atoms Li-7/m3]";
SI.NumberDensityOfMolecules d_N_Li6 = d_MM_Li*Li6_molefrac*N_A "Number density of Li-7 atoms in flibe [atoms Li-6/m3]";
SI.NumberDensityOfMolecules d_N_Be9 = d_MM_Be*N_A "Number density of Be-9 atoms in flibe [atoms Be-9/m3]";

SI.MacroscopicCrossSection Sigma_Li7 = sig_T_Li7*d_N_Li7;
SI.MacroscopicCrossSection Sigma_Li6 = 1;
SI.MacroscopicCrossSection Sigma_Be9 = sig_alpha_Be9*d_N_Be9;

// Real a1 = flux*Sigma_Li7 "Source of tritium from Li7 neutron absorbption [atoms/(m3-s)]";
// Real a2 = flux*sig_T_Li6*(b1+b2*b3);
// Real a3 = Core_coolant_vol/6.022E23;
// Real b1 = d_N_Li6*c1;
// Real b2 = flux*Sigma_Be9/(flux*sig_abs_Li6);
// Real b3 = 1-c1;
// Real c1 = exp((-Core_coolant_vol/Vol_1)*flux*sig_abs_Li6*t);
//
// Real Birth = (a1+a2)*a3 "[mol T/s] Equation comes from Cisneros, 2013 Thesis";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialTritiumold;
