within TRANSFORM.Examples.LightWaterReactor_PWR_Westinghouse.Data;
record Data_Basic

  // Source 1 (s1):
  // Systems Summary of a Westinghouse Pressurized Water Reactor Nuclear Power Plant
  // 1984, Westinghouse Electric Corporation
  // http://www4.ncsu.edu/~doster/NE405/Manuals/PWR_Manual.pdf

  // Data from Source 1 (d*s1): 4-Loop basis
  // (d1s1) = Table 1-1 (pg. 3): Principal data for current Westinghouse NSSS Models
  // (d2s1) = Table 2-1 (pg. 14): Typical reactor core parameters (4-Loop Plant)
  // (d3s1) = Table 2-2 (pg. 19): Fuel rod parameters
  // (d4s1) = Table 3.1-1 (pg. --): Fuel rod parameters
  // (d5s1) = Table 3.5-1 (pg. 54): Pressurizer principal design data

  extends BaseClasses.Record_Data;

  parameter SI.Length dimension_hotleg = Units.Conversions.Functions.Distance_m.from_inch(29) "Hot leg inner diameter (d1s1)";
  parameter SI.Length dimension_coldleg = Units.Conversions.Functions.Distance_m.from_inch(27.5) "Hot leg inner diameter (d1s1)";
  parameter SI.Length length_hotleg = Units.Conversions.Functions.Distance_m.from_feet(50) "Hot leg length";
  parameter SI.Length length_coldleg = Units.Conversions.Functions.Distance_m.from_feet(50) "Cold leg length";

  parameter SI.Power Q_total_th=3411e6 "Total thermal output (d2s1)";
  parameter SIadd.NonDim Q_frac = 0.974 "Fraction of heat generatated in fuel (d2s1)";
  parameter SI.Pressure p_nominal = Units.Conversions.Functions.Pressure_Pa.from_psi(2250) "Nominal system pressure (d2s1)";
  parameter SI.MassFlowRate m_flow_nominal = Units.Conversions.Functions.MassFlowRate_kg_s.from_lbm_hr(138.4e6) "Nominal total coolant flow rate (d2s1)";

  parameter SI.Temperature T_core_inlet_nominal = Units.Conversions.Functions.Temperature_K.from_degF(557.5) "Nominal core inlet temperature (d2s1)";
  parameter SI.Temperature T_core_outlet_nominal = Units.Conversions.Functions.Temperature_K.from_degF(618.5) "Nominal core inlet temperature (d2s1)";
  parameter SI.Temperature T_core_avgRise_nominal = T_core_outlet_nominal - T_core_inlet_nominal "Nominal core temperature rise (d2s1)";


  parameter SI.Length dimension_core = Units.Conversions.Functions.Distance_m.from_feet(11.06) "Equivalent core diameter (d2s1)";
  parameter SI.Length length_fuel = Units.Conversions.Functions.Distance_m.from_feet(12) "Core length between fuel ends (d2s1)";

  parameter SI.Mass m_uranium_1 = 81639 "Fuel weight of uranium (first core) (d2s1)";
  parameter SIadd.NonDim nAssembly = 193 "Number of assemblies - 17x17 (d2s1)";

  parameter String Material_fuel = "Uranium Oxide" "Fuel pellet material";
  parameter String Material_cladding = "Zircaloy-4" "Cladding material";
  parameter SI.Length r_outer_fuelRod = 0.5*Units.Conversions.Functions.Distance_m.from_inch(0.360) "Outside diameter of fuel rod (d3s1)";
  parameter SI.Length th_clad_fuelRod = Units.Conversions.Functions.Distance_m.from_inch(0.0225) "Cladding thickness of fuel rod (d3s1)";
  parameter SI.Length th_gap_fuelRod = 0.5*Units.Conversions.Functions.Distance_m.from_inch(0.0062) "Gap thickness between pellet and cladding (d3s1)";
  parameter SI.Length r_pellet_fuelRod = 0.5*Units.Conversions.Functions.Distance_m.from_inch(0.3088) "Pellet radius (d3s1)";
  parameter SI.Length pitch_fuelRod = Units.Conversions.Functions.Distance_m.from_inch(0.496) "Fuel rod pitch (d3s1)";
  parameter SIadd.NonDim sizeAssembly = 17 "square size of assembly (e.g., 17 = 17x17)";
  parameter SIadd.NonDim nRodFuel_assembly = 264 "# of fuel rods per assembly (d3s1)";
  parameter SIadd.NonDim nRodNonFuel_assembly = sizeAssembly^2 - 264 "# of non-fuel rods per assembly (d3s1)";

  // Guessed
  parameter SI.Length length_inlet_plenum = length_fuel "Length of core inlet plenum";
  parameter SI.Area crossArea_inlet_plenum = 0.25*Modelica.Constants.pi*dimension_core^2 "Cross area of inlet plenum";

  parameter SI.Length length_outlet_plenum = length_fuel "Length of core outlet plenum";
  parameter SI.Area crossArea_outlet_plenum = 0.25*Modelica.Constants.pi*dimension_core^2 "Cross area of outlet plenum";

  parameter SI.Length length_downcomer = length_inlet_plenum + length_fuel + length_outlet_plenum "Downcomer length";
  parameter SI.Area crossArea_downcomer = Modelica.Constants.pi*0.25*(Units.Conversions.Functions.Distance_m.from_inch(10*12+11)^2 - Units.Conversions.Functions.Distance_m.from_inch(10*12+3)^2) "Estimated flow area of downcomer from nozzle faces (d4s1)";
  parameter SI.Length perimeter_downcomer = Modelica.Constants.pi*(Units.Conversions.Functions.Distance_m.from_inch(10*12+11)+Units.Conversions.Functions.Distance_m.from_inch(10*12+3)) "Estimated perimeter of downcomer";
//   parameter SI.Height pressurizer_level=1.68 "nominal pressurizer level";
//   parameter Units.NonDim pressurizer_Vfrac_liquid=0.34
//     "nominal fraction of liquid in pressurizer";

  // Pressurizer
  parameter SI.Length dimension_pzr = Units.Conversions.Functions.Distance_m.from_inch(7*12+8) "Pressurizer diameter (d5s1)";
  parameter SI.Length th_pzr = Units.Conversions.Functions.Distance_m.from_inch(12) "Guess of pressurizer wall thickness";
  parameter SI.Length length_pzr = Units.Conversions.Functions.Distance_m.from_inch(52*12+9) "Pressurizer height (d5s1)";
  parameter SI.Volume V_pzr = 0.25*Modelica.Constants.pi*dimension_pzr^2*length_pzr "Empty volume of pressurizer (d5s1)";
  parameter SI.Volume V_water_pzr_nominal = Units.Conversions.Functions.Volume_m3.from_feet3(1080) "Pressurizer nominal water volume (d5s1)";
  parameter SI.Volume V_steam_pzr_nominal = V_pzr-V_water_pzr_nominal "Pressurizer nominal steam volume (d5s1)";
  parameter SIadd.NonDim Vfrac_liquid_pzr = V_water_pzr_nominal/V_pzr "Nominal volume fraction of pressurizer";

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
