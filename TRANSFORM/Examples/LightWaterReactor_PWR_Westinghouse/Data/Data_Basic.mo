within TRANSFORM.Examples.LightWaterReactor_PWR_Westinghouse.Data;
record Data_Basic
  // Source 1 (s1):
  // Systems Summary of a Westinghouse Pressurized Water Reactor Nuclear Power Plant
  // 1984, Westinghouse Electric Corporation
  // http://www4.ncsu.edu/~doster/NE405/Manuals/PWR_Manual.pdf
  // Source 2 (s2):
  // https://ocw.mit.edu/courses/nuclear-engineering/22-06-engineering-of-nuclear-systems-fall-2010/lectures-and-readings/MIT22_06F10_lec06a.pdf
  // Data from Source 1 (d*s1): 4-Loop basis
  // (d1s1) = Table 1-1 (pg. 3): Principal data for current Westinghouse NSSS Models
  // (d2s1) = Table 2-1 (pg. 14): Typical reactor core parameters (4-Loop Plant)
  // (d3s1) = Table 2-2 (pg. 19): Fuel rod parameters
  // (d4s1) = Table 3.1-1 (pg. --): Fuel rod parameters
  // (d5s1) = Table 3.5-1 (pg. 54): Pressurizer principal design data
  // (d6s1) = Table 3.4-1 (pg. 50): Steam generator principal design data
  // Data from Source 2 (d*s2):
  // (d1s2) = slide 30: Typical design data for steam generators
  import from_inch =
         TRANSFORM.Units.Conversions.Functions.Distance_m.from_in;
  import from_feet =
         TRANSFORM.Units.Conversions.Functions.Distance_m.from_ft;
  import TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degF;
  import from_feet3 =
         TRANSFORM.Units.Conversions.Functions.Volume_m3.from_ft3;
  import TRANSFORM.Units.Conversions.Functions.Pressure_Pa.from_psi;
  import TRANSFORM.Units.Conversions.Functions.MassFlowRate_kg_s.from_lbm_hr;
   extends BaseClasses.Record_Data;
   parameter SI.Length dimension_hotleg = from_inch(29) "Hot leg inner diameter (d1s1)";
   parameter SI.Length dimension_coldleg = from_inch(27.5) "Hot leg inner diameter (d1s1)";
   parameter SI.Length length_hotleg = from_feet(50) "Hot leg length";
   parameter SI.Length length_coldleg = from_feet(50) "Cold leg length";
   parameter SI.Power Q_total_th=3411e6 "Total thermal output (d2s1)";
   parameter SIadd.NonDim Q_frac = 0.974 "Fraction of heat generatated in fuel (d2s1)";
   parameter SI.Pressure p_nominal = from_psi(2250) "Nominal system pressure (d2s1)";
   parameter SI.MassFlowRate m_flow_nominal = from_lbm_hr(138.4e6) "Nominal total coolant flow rate (d2s1)";
   parameter SI.Temperature T_core_inlet_nominal = from_degF(557.5) "Nominal core inlet temperature (d2s1)";
   parameter SI.Temperature T_core_outlet_nominal = from_degF(618.5) "Nominal core inlet temperature (d2s1)";
   parameter SI.TemperatureDifference T_core_avgRise_nominal = T_core_outlet_nominal - T_core_inlet_nominal "Nominal core temperature rise (d2s1)";
   parameter SI.Temperature T_core_avg = 0.5*(T_core_outlet_nominal+T_core_inlet_nominal) "Average temperature of core";
   parameter SI.Length dimension_core = from_feet(11.06) "Equivalent core diameter (d2s1)";
   parameter SI.Length length_fuel = from_feet(12) "Core length between fuel ends (d2s1)";
   parameter SI.Mass m_uranium_1 = 81639 "Fuel weight of uranium (first core) (d2s1)";
   parameter SIadd.NonDim nAssembly = 193 "Number of assemblies - 17x17 (d2s1)";
   parameter String Material_fuel = "Uranium Oxide" "Fuel pellet material";
   parameter String Material_cladding = "Zircaloy-4" "Cladding material";
   parameter SI.Length r_outer_fuelRod = 0.5*from_inch(0.360) "Outside diameter of fuel rod (d3s1)";
   parameter SI.Length th_clad_fuelRod = from_inch(0.0225) "Cladding thickness of fuel rod (d3s1)";
   parameter SI.Length th_gap_fuelRod = 0.5*from_inch(0.0062) "Gap thickness between pellet and cladding (d3s1)";
   parameter SI.Length r_pellet_fuelRod = 0.5*from_inch(0.3088) "Pellet radius (d3s1)";
   parameter SI.Length pitch_fuelRod = from_inch(0.496) "Fuel rod pitch (d3s1)";
   parameter SIadd.NonDim sizeAssembly = 17 "square size of assembly (e.g., 17 = 17x17)";
   parameter SIadd.NonDim nRodFuel_assembly = 264 "# of fuel rods per assembly (d3s1)";
   parameter SIadd.NonDim nRodNonFuel_assembly = sizeAssembly^2 - 264 "# of non-fuel rods per assembly (d3s1)";
   // Guessed
   parameter SI.Length length_inlet_plenum = length_fuel "Length of core inlet plenum";
   parameter SI.Area crossArea_inlet_plenum = 0.25*Modelica.Constants.pi*dimension_core^2 "Cross area of inlet plenum";
   parameter SI.Length length_outlet_plenum = length_fuel "Length of core outlet plenum";
   parameter SI.Area crossArea_outlet_plenum = 0.25*Modelica.Constants.pi*dimension_core^2 "Cross area of outlet plenum";
   parameter SI.Length length_downcomer = length_inlet_plenum + length_fuel + length_outlet_plenum "Downcomer length";
   parameter SI.Area crossArea_downcomer = Modelica.Constants.pi*0.25*(from_inch(10*12+11)^2 - from_inch(10*12+3)^2) "Estimated flow area of downcomer from nozzle faces (d4s1)";
   parameter SI.Length perimeter_downcomer = Modelica.Constants.pi*(from_inch(10*12+11)+from_inch(10*12+3)) "Estimated perimeter of downcomer";
   parameter SI.Height pressurizer_level=1.68 "nominal pressurizer level";
   parameter Units.NonDim pressurizer_Vfrac_liquid=0.34
     "nominal fraction of liquid in pressurizer";
   // Pressurizer
   parameter SI.Length dimension_pzr = from_inch(7*12+8) "Pressurizer diameter (d5s1)";
   parameter SI.Length th_pzr = from_inch(12) "Guess of pressurizer wall thickness";
   parameter SI.Length length_pzr = from_inch(52*12+9) "Pressurizer height (d5s1)";
   parameter SI.Volume V_pzr = 0.25*Modelica.Constants.pi*dimension_pzr^2*length_pzr "Empty volume of pressurizer (d5s1)";
   parameter SI.Volume V_water_pzr_nominal = from_feet3(1080) "Pressurizer nominal water volume (d5s1)";
   parameter SI.Volume V_steam_pzr_nominal = V_pzr-V_water_pzr_nominal "Pressurizer nominal steam volume (d5s1)";
   parameter SIadd.NonDim Vfrac_liquid_pzr = V_water_pzr_nominal/V_pzr "Nominal volume fraction of pressurizer";
   // Steam Generator
   // 2 sections: lower section with tubes and upper section with moisture sepeartor/boiler level
   // 1 SG per loop: 4 loops
   parameter Real nSG = 4 "Total number of steam generators (i.e., 4 loops and 1 per loop)";
   parameter String Material_SGtube = "Inconel (d6s1)";
   parameter SI.Pressure p_shellSide = from_psi(1000) "Shell side full load pressure (d6s1)";
   parameter SI.Temperature T_inlet_shell = sat.Tsat - 100 "Guess at inlet shell temperature from FWH";
   parameter SI.SpecificEnthalpy h_inlet_shell = Medium.specificEnthalpy_pT(p_shellSide,T_inlet_shell) "Guess at inlet shell temperature from FWH";
   parameter SI.MassFlowRate m_flow_shellSide_per = from_lbm_hr(3.813e6) "Steam flow per steam generator (d6s1)";
   parameter SI.MassFlowRate m_flow_shellSide_total = m_flow_shellSide_per*nSG "Total Steam flow to steam generators";
   parameter SI.Length length_SGshell = from_inch(67*12+8) "Overall height of steam generator (d6s2)";
   parameter SI.Length length_lowerShell = 0.67*length_SGshell "Estimate of vertical length of lower shell";
   parameter SI.Length length_upperShell = length_SGshell-length_lowerShell "Estimate of vertical length of upper shell";
   parameter SI.Length diameter_outer_lowerShell = from_inch(11*12+3) "Lower shell outer diameter (d6s1)";
   parameter SI.Length diameter_outer_upperShell = from_inch(14*12+7.75) "Upper shell outer diameter (d6s1)";
   parameter SI.Length r_outer_upperShell_eff = 0.5*diameter_outer_upperShell*sqrt(nSG) "Upper shell outer radius effective based on nSG steam generators lumped together";
   parameter SI.Length th_shell = from_inch(8) "Estimate of shell thickness (s2 picture)";
   parameter SI.Length diameter_inner_lowerShell = diameter_outer_lowerShell-2*th_shell "Lower shell inner diameter (d6s1)";
   parameter SI.Length diameter_inner_upperShell = diameter_outer_upperShell-2*th_shell "Upper shell inner diameter (d6s1)";
   parameter SI.Area crossArea_SG_downcomer = 0.2*nSG*0.25*Modelica.Constants.pi*(diameter_outer_lowerShell^2 - diameter_outer_SGtube^2*nTubes) "Estimate of SG downcomer cross area (0.2 of available)";
   parameter SI.Volume volume_SG_downcomer = crossArea_SG_downcomer*length_lowerShell "Estimate of volume for SG downcomer";
   parameter Real nTubes = 6500 "# of tubes in SG, estimate based on available area";
   parameter SI.Length length_SGtube = 2*length_lowerShell "Estimate of SG tube length";
   parameter SI.Length diameter_outer_SGtube = 0.0222 "SG tube outer diameter (d1s2)";
   parameter SI.Length th_SGtube = 0.00127 "SG tube thickness (d1s2)";
   parameter SI.Length diameter_inner_SGtube = diameter_outer_SGtube-2*th_SGtube "SG tube inner diameter";
   // For SG conditions
   package Medium=Modelica.Media.Water.StandardWater;
  parameter Medium.SaturationProperties sat=Medium.setSat_p(p_shellSide) "Properties of saturated fluid";
   parameter Medium.ThermodynamicState bubble=Medium.setBubbleState(sat, 1) "Bubble point state";
   parameter Medium.ThermodynamicState dew=Medium.setDewState(sat, 1) "Dew point state";
   parameter Medium.SpecificEnthalpy h_lsat=bubble.h "Saturated liquid temperature";
   parameter Medium.SpecificEnthalpy h_vsat=dew.h "Saturated vapour temperature";
//   parameter Medium.SpecificEnthalpy h_lv=h_vsat - h_lsat "Latent heat of vaporization";
//
//   parameter SI.Density rho_lsat=bubble.d "Saturated liquid density";
//   parameter Medium.DynamicViscosity mu_lsat=Medium.dynamicViscosity(bubble) "Dynamic viscosity at bubble point";
//   parameter Medium.ThermalConductivity lambda_lsat=Medium.thermalConductivity(bubble) "Thermal conductivity at bubble point";
//   parameter Medium.SpecificHeatCapacity cp_lsat=Medium.heatCapacity_cp(bubble)
//     "Specific heat capacity at bubble point";
//
//   parameter SI.Density rho_vsat=dew.d "Saturated vapour density";
//   parameter Medium.DynamicViscosity mu_vsat=Medium.dynamicViscosity(dew) "Dynamic viscosity at dew point";
//   parameter Medium.ThermalConductivity lambda_vsat=Medium.thermalConductivity(dew) "Thermal conductivity at dew point";
//   parameter Medium.SpecificHeatCapacity cp_vsat=Medium.heatCapacity_cp(dew) "Specific heat capacity at dew point";
//
//   parameter SI.SpecificHeatCapacity cp_tubeSide = Medium.specificHeatCapacityCp(Medium.setState_pT(p_nominal,0.5*(T_core_inlet_nominal+T_core_outlet_nominal)));
//   parameter SI.HeatFlowRate Q_flow_tubeSide = cp_tubeSide*m_flow_nominal*(T_core_outlet_nominal-T_core_inlet_nominal);
  annotation (
    defaultComponentName="data",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          lineColor={0,0,0},
          extent={{-100,-90},{100,-70}},
          textString="Basic")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>"));
end Data_Basic;
