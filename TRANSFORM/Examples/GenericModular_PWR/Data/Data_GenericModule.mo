within TRANSFORM.Examples.GenericModular_PWR.Data;
model Data_GenericModule

  extends BaseClasses.Record_Data;

  import TRANSFORM.Units.Conversions.Functions.Distance_m.from_inch;

  // Source 1 (s1):
  // Systems Summary of a Westinghouse Pressurized Water Reactor Nuclear Power Plant
  // 1984, Westinghouse Electric Corporation
  // http://www4.ncsu.edu/~doster/NE405/Manuals/PWR_Manual.pdf

  // Data from Source 1 (d*s1): 4-Loop basis
  // (d1s1) = Table 1-1 (pg. 3): Principal data for current Westinghouse NSSS Models
  // (d2s1) = Table 2-1 (pg. 14): Typical reactor core parameters (4-Loop Plant)
  // (d3s1) = Table 2-2 (pg. 19): Fuel rod parameters
  // (d4s1) = Table 3.1-1 (pg. --): Fuel rod parameters

  //Source 2: https://aris.iaea.org/PDF/NuScale.pdf

  //Source 3: https://doi.org/10.1016/j.desal.2014.02.023

  package Medium = Modelica.Media.Water.StandardWater;
  parameter Real nModules=12;

  //per module
  parameter SI.Power Q_total=160e6 "Total thermal output";
  parameter SI.Power Q_total_el=45e6 "Total electrical output";
  parameter Real eta=Q_total_el/Q_total "Net efficiency";

  parameter SI.Pressure p=12.76e6;
  parameter SI.Temperature T_hot=325 + 273.15 "estimate";
  parameter SI.Temperature T_cold=Medium.temperature_ph(p, h_cold);
  parameter SI.Temperature T_avg=0.5*(T_hot+T_cold);
  parameter SI.TemperatureDifference dT_core=T_hot - T_cold;
  parameter SI.SpecificEnthalpy h_hot=Medium.specificEnthalpy_pT(p, T_hot);
  parameter SI.SpecificEnthalpy h_cold=h_hot - Q_total/m_flow;
  parameter SI.MassFlowRate m_flow=700 "rough estimate from normalizing IRIS and rounded down";

  parameter SI.Length d_reactorVessel_outer=2.75;
  parameter SI.Length length_reactorVessel=20;

  parameter SI.Length length_inletPlenum=2;
  parameter SI.Length d_inletPlenum=d_reactorVessel_outer;

  parameter SI.Length length_core=2;
  parameter SI.Length d_core=1.5;
  parameter String Material_fuel="Uranium Oxide" "Fuel pellet material";
  parameter String Material_cladding="Zircaloy-4" "Cladding material";
  parameter SI.Length r_outer_fuelRod=0.5*from_inch(0.360) "Outside diameter of fuel rod (d3s1)";
  parameter SI.Length th_clad_fuelRod=from_inch(0.0225) "Cladding thickness of fuel rod (d3s1)";
  parameter SI.Length th_gap_fuelRod=0.5*from_inch(0.0062) "Gap thickness between pellet and cladding (d3s1)";
  parameter SI.Length r_pellet_fuelRod=0.5*from_inch(0.3088) "Pellet radius (d3s1)";
  parameter SI.Length pitch_fuelRod=from_inch(0.496) "Fuel rod pitch (d3s1)";
  parameter TRANSFORM.Units.NonDim sizeAssembly=17 "square size of assembly (e.g., 17 = 17x17)";
  parameter TRANSFORM.Units.NonDim nRodFuel_assembly=264 "# of fuel rods per assembly (d3s1)";
  parameter TRANSFORM.Units.NonDim nRodNonFuel_assembly=sizeAssembly^2 - 264 "# of non-fuel rods per assembly (d3s1)";
  parameter TRANSFORM.Units.NonDim nAssembly=floor(Modelica.Constants.pi*d_core^2/4/(pitch_fuelRod*sizeAssembly)^2);

  parameter SI.Length length_outletPlenum=3;
  parameter SI.Length d_outletPlenum=2;

  parameter SI.Length length_hotLeg=10.5;
  parameter SI.Length d_hotLeg=1.4;

  parameter SI.Length length_pressurizer=2.5;
  parameter SI.Length d_pressurizer=d_reactorVessel_outer;

  parameter SI.Length length_steamGenerator=5.5;
  parameter SI.Length d_steamGenerator_tube_outer=from_inch(0.5);
  parameter SI.Length th_steamGenerator_tube=from_inch(0.083) "Sch 10/20";
  parameter SI.Length d_steamGenerator_tube_inner=d_steamGenerator_tube_outer - 2*th_steamGenerator_tube;
  parameter SI.Length d_steamGenerator_shell_inner=d_hotLeg;
  parameter SI.Length d_steamGenerator_shell_outer=d_reactorVessel_outer;
  // nTubes and length calculation should have reductions based on spacing of tubes
  parameter Real ratioPD_steamGenerator_tube=1.5 "pitch to diameter ratio";
  // nTubes and length are intertwined. This calculation assumes some number of entry tubes that then coil around the entire cavity between the reactor vessel and outlet plenum/hot leg space
  parameter Real nPasses = 2;
  parameter Real nEntryPoint_steamGenerator=128;
  parameter Real nTubes_steamGenerator_perEntryPoint=floor(0.5*(d_steamGenerator_shell_outer - d_steamGenerator_shell_inner)/(d_steamGenerator_tube_outer*ratioPD_steamGenerator_tube));
  parameter Real nTubes_steamGenerator=nEntryPoint_steamGenerator*nTubes_steamGenerator_perEntryPoint/nPasses;
  // For nEntryPoint approach, length is taken as circumference of the average diameter between vessel and plenum. The length is then a calculation of the number of times the tubes can go around with each entry point reducing the length"
  parameter SI.Length length_steamGenerator_tube=Modelica.Constants.pi*0.5*(d_steamGenerator_shell_outer + d_steamGenerator_shell_inner)*floor(
      length_steamGenerator*nPasses/(nEntryPoint_steamGenerator*d_steamGenerator_tube_outer*ratioPD_steamGenerator_tube));
  //Solution for max tubes, min length
  //parameter Real nTubes_steamGenerator= floor(Modelica.Constants.pi*(d_steamGenerator_shell_outer^2/4 - d_steamGenerator_shell_inner^2/4)/(Modelica.Constants.pi*d_steamGenerator_tube_outer^2/4)/nPasses) "for single pass (maximum nTubes)";
  //parameter Real length_steamGenerator_tube = length_steamGenerator*nPasses "for max nTubes";

  parameter SI.Length length_coldLeg=12;
  parameter SI.Length d_coldLeg_inner=d_outletPlenum;
  parameter SI.Length d_coldLeg_outer=d_reactorVessel_outer;
  parameter SI.Length d_coldLeg=4*Modelica.Constants.pi*(d_coldLeg_outer^2/4 - d_coldLeg_inner^2/4)/Modelica.Constants.pi/(d_coldLeg_outer + d_coldLeg_inner);

  final parameter SI.Length lengths[2]={length_inletPlenum + length_core + length_outletPlenum + length_hotLeg,length_steamGenerator + length_coldLeg};

  parameter SI.Pressure p_steam = 3.5e6;
  parameter SI.Temperature T_steam_hot = 300+273.15;
  parameter SI.Temperature T_steam_cold=200+273.15;
  parameter SI.SpecificEnthalpy h_steam_hot=Medium.specificEnthalpy_pT(p_steam, T_steam_hot);
  parameter SI.SpecificEnthalpy h_steam_cold=Medium.specificEnthalpy_pT(p_steam, T_steam_cold);
  parameter SI.MassFlowRate m_flow_steam = Q_total/(h_steam_hot-h_steam_cold);

equation
  assert(abs(lengths[1] - lengths[2]) <= Modelica.Constants.eps, "Hot/cold leg lengths must be equal");
  assert(abs(length_reactorVessel - lengths[1] - length_pressurizer) <= Modelica.Constants.eps, "Hot leg and pressurizer must be equal to reactor vessel length");

  annotation (
    defaultComponentName="data",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          lineColor={0,0,0},
          extent={{-100,-90},{100,-70}},
          textString="GenericModule")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>"));
end Data_GenericModule;
