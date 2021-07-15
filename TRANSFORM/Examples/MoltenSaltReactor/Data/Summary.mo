within TRANSFORM.Examples.MoltenSaltReactor.Data;
record Summary
  extends TRANSFORM.Icons.Record;
  replaceable package Medium_PFL =
      Modelica.Media.Interfaces.PartialMedium                              annotation(choicesAllMatching=true);
  replaceable package Medium_PCL =
      Modelica.Media.Interfaces.PartialMedium                              annotation(choicesAllMatching=true);
  replaceable package Medium_BOP =
      Modelica.Media.Interfaces.PartialMedium                              annotation(choicesAllMatching=true);
  replaceable package Medium_OffGas =
      Modelica.Media.Interfaces.PartialMedium                                 annotation(choicesAllMatching=true);
  replaceable package Material_Graphite =
      TRANSFORM.Media.Interfaces.Solids.PartialAlloy                                     annotation(choicesAllMatching=true);
  replaceable package Material_Vessel =
      TRANSFORM.Media.Interfaces.Solids.PartialAlloy                                   annotation(choicesAllMatching=true);
  parameter SI.Temperature Tref_PFL = 898.15 "ref temperature for volume calcs";
  parameter SI.Temperature Tref_PCL = 798.15 "ref temperature for volume calcs";
  parameter SI.Temperature Tref_BOP = 773.15 "ref temperature for volume calcs";
  parameter SI.Pressure pref_PFL = 1e5 "ref pressure for volume calcs";
  parameter SI.Pressure pref_PCL = 1e5 "ref pressure for volume calcs";
  parameter SI.Pressure pref_BOP = 260e5 "ref pressure for volume calcs";
  parameter SI.Density d_PFL = Medium_PFL.density(Medium_PFL.setState_pTX(pref_PFL,Tref_PFL));
  parameter SI.Density d_PCL = Medium_PCL.density(Medium_PCL.setState_pTX(pref_PCL,Tref_PCL));
  parameter SI.Density d_BOP = Medium_BOP.density(Medium_BOP.setState_pTX(pref_BOP,Tref_BOP));
  parameter SI.Density d_G = Material_Graphite.density_T(Tref_PFL);
  // Primary Fuel Loop
  // Axial Reflector
  Real nG_reflA_blocks "# of graphite blocks per fuel cell" annotation(Dialog(tab="PFL",group="Axial Reflector"));
  SI.Length dims_reflAG_1 "inner radius of graphite blocks" annotation(Dialog(tab="PFL",group="Axial Reflector"));
  SI.Length dims_reflAG_2 "outer radius of graphite blocks" annotation(Dialog(tab="PFL",group="Axial Reflector"));
  SI.Length dims_reflAG_3 "height of graphite blocks" annotation(Dialog(tab="PFL",group="Axial Reflector"));
  SI.Angle dims_reflAG_4 "swept angle of graphite blocks" annotation(Dialog(tab="PFL",group="Axial Reflector"));
  SI.Area crossArea_reflA "Cross sectional area of fuel" annotation(Dialog(tab="PFL",group="Axial Reflector"));
  SI.Length perimeter_reflA "wetted perimeter of fuel" annotation(Dialog(tab="PFL",group="Axial Reflector"));
  SI.CoefficientOfHeatTransfer alpha_reflA "heat transfer coefficient" annotation(Dialog(tab="PFL",group="Axial Reflector"));
  SI.Area surfaceArea_reflA "surface area of fuel to graphite" annotation(Dialog(tab="PFL",group="Axial Reflector"));
  SI.Mass m_reflAG "mass of graphite in core" annotation(Dialog(tab="PFL",group="Axial Reflector"));
  SI.Mass m_reflA "mass of fuel in core" annotation(Dialog(tab="PFL",group="Axial Reflector"));
  SI.Volume volume_reflAG = m_reflAG/d_G
    "volume of graphite in ax refl at Tref"                                            annotation(Dialog(tab="PFL",group="Axial Reflector"));
  SI.Volume volume_reflA = m_reflA/d_PFL
    "volume of fuel in ax refl at Tref"                                            annotation(Dialog(tab="PFL",group="Axial Reflector"));
  // Radial Reflector
  Real nG_reflR_blocks "# of graphite blocks per fuel cell" annotation(Dialog(tab="PFL",group="Radial Reflector"));
  SI.Length dims_reflRG_1 "length of graphite blocks" annotation(Dialog(tab="PFL",group="Radial Reflector"));
  SI.Length dims_reflRG_2 "width of graphite blocks" annotation(Dialog(tab="PFL",group="Radial Reflector"));
  SI.Length dims_reflRG_3 "height of graphite blocks" annotation(Dialog(tab="PFL",group="Radial Reflector"));
  SI.Area crossArea_reflR "Cross sectional area of fuel" annotation(Dialog(tab="PFL",group="Radial Reflector"));
  SI.Length perimeter_reflR "wetted perimeter of fuel" annotation(Dialog(tab="PFL",group="Radial Reflector"));
  SI.CoefficientOfHeatTransfer alpha_reflR "heat transfer coefficient" annotation(Dialog(tab="PFL",group="Radial Reflector"));
  SI.Area surfaceArea_reflR "surface area of fuel to graphite" annotation(Dialog(tab="PFL",group="Radial Reflector"));
  SI.Mass m_reflRG "mass of graphite in core" annotation(Dialog(tab="PFL",group="Radial Reflector"));
  SI.Mass m_reflR "mass of fuel in core" annotation(Dialog(tab="PFL",group="Radial Reflector"));
  SI.Volume volume_reflRG = m_reflRG/d_G
    "volume of graphite in rad refl at Tref"                                            annotation(Dialog(tab="PFL",group="Radial Reflector"));
  SI.Volume volume_reflR = m_reflR/d_PFL
    "volume of fuel in rad refl at Tref"                                            annotation(Dialog(tab="PFL",group="Radial Reflector"));
  // Core
  Real nG_fuelCell "# of graphite blocks per fuel cell" annotation(Dialog(tab="PFL",group="Core"));
  SI.Length dims_fuelG_1 "length of graphite blocks" annotation(Dialog(tab="PFL",group="Core"));
  SI.Length dims_fuelG_2 "width of graphite blocks" annotation(Dialog(tab="PFL",group="Core"));
  SI.Length dims_fuelG_3 "height of graphite blocks" annotation(Dialog(tab="PFL",group="Core"));
  SI.Area crossArea_fuel "Cross sectional area of fuel" annotation(Dialog(tab="PFL",group="Core"));
  SI.Length perimeter_fuel "wetted perimeter of fuel" annotation(Dialog(tab="PFL",group="Core"));
  SI.CoefficientOfHeatTransfer alpha_fuel "heat transfer coefficient" annotation(Dialog(tab="PFL",group="Core"));
  SI.Area surfaceArea_fuel "surface area of fuel to graphite" annotation(Dialog(tab="PFL",group="Core"));
  SI.Mass m_fuelG "mass of graphite in core" annotation(Dialog(tab="PFL",group="Core"));
  SI.Mass m_fuel "mass of fuel in core" annotation(Dialog(tab="PFL",group="Core"));
  SI.Volume volume_fuelG = m_fuelG/d_G
    "volume of graphite in core at Tref"                                          annotation(Dialog(tab="PFL",group="Core"));
  SI.Volume volume_fuel = m_fuel/d_PFL "volume of fuel in core at Tref" annotation(Dialog(tab="PFL",group="Core"));
  // Plenum
  SI.Mass m_plenum "mass of fuel in plenum" annotation(Dialog(tab="PFL",group="Plenum"));
  SI.Volume volume_plenum = m_plenum/d_PFL
    "volume of plenum in core at Tref"                                              annotation(Dialog(tab="PFL",group="Plenum"));
  SI.Mass m_tee_inlet "mass of fuel in tee inlet" annotation(Dialog(tab="PFL",group="Plenum"));
  SI.Volume volume_tee_inlet = m_tee_inlet/d_PFL
    "volume of tee inlet at Tref"                                                    annotation(Dialog(tab="PFL",group="Plenum"));
  // Pump Bowl
  SI.Length dims_pumpBowl_1 "diameter of pump bowl" annotation(Dialog(tab="PFL",group="Pump Bowl"));
  SI.Length dims_pumpBowl_2 "height of pump bowl" annotation(Dialog(tab="PFL",group="Pump Bowl"));
  SI.Length level_nom_pumpBowl "nominal salt level of pump bowl" annotation(Dialog(tab="PFL",group="Pump Bowl"));
  SI.Mass m_pumpBowl "mass of fuel in plenum" annotation(Dialog(tab="PFL",group="Pump Bowl"));
  SI.Volume volume_pumpBowl = m_pumpBowl/d_PFL
    "volume of plenum in core at Tref"                                                  annotation(Dialog(tab="PFL",group="Pump Bowl"));
  //Piping
  SI.Length dims_pipeToPHX_1 "diameter of pipeToPHX" annotation(Dialog(tab="PFL",group="Piping"));
  SI.Length dims_pipeToPHX_2 "length of pipeToPHX" annotation(Dialog(tab="PFL",group="Piping"));
  SI.Mass m_pipeToPHX_PFL "mass of fuel in plenum" annotation(Dialog(tab="PFL",group="Piping"));
  SI.Volume volume_pipeToPHX_PFL = m_pipeToPHX_PFL/d_PFL
    "volume of plenum in core at Tref"                                                            annotation(Dialog(tab="PFL",group="Piping"));
  SI.Length dims_pipeFromPHX_1 "diameter of pipeFromPHX" annotation(Dialog(tab="PFL",group="Piping"));
  SI.Length dims_pipeFromPHX_2 "length of pipeFromPHX" annotation(Dialog(tab="PFL",group="Piping"));
  SI.Mass m_pipeFromPHX_PFL "mass of fuel in plenum" annotation(Dialog(tab="PFL",group="Piping"));
  SI.Volume volume_pipeFromPHX_PFL = m_pipeFromPHX_PFL/d_PFL
    "volume of plenum in core at Tref"                                                                annotation(Dialog(tab="PFL",group="Piping"));
  // PHX
  SI.Temperature T_tube_inlet_PHX "inlet temp to PHX tube" annotation(Dialog(tab="PFL",group="PHX"));
  SI.Temperature T_tube_outlet_PHX "outlet temp to PHX tube" annotation(Dialog(tab="PFL",group="PHX"));
  SI.Pressure p_inlet_tube_PHX "inlet pressure PHX tube" annotation(Dialog(tab="PFL",group="PHX"));
  SI.PressureDifference dp_tube_PHX "pressure drop across PHX tube" annotation(Dialog(tab="PFL",group="PHX"));
  SI.MassFlowRate m_flow_tube_PHX "tube PHX mass flow rate" annotation(Dialog(tab="PFL",group="PHX"));
  SI.Temperature T_shell_inlet_PHX "inlet temp to PHX shell" annotation(Dialog(tab="PFL",group="PHX"));
  SI.Temperature T_shell_outlet_PHX "outlet temp to PHX shell" annotation(Dialog(tab="PFL",group="PHX"));
  SI.Pressure p_inlet_shell_PHX "inlet pressure PHX shell" annotation(Dialog(tab="PFL",group="PHX"));
  SI.PressureDifference dp_shell_PHX "pressure drop across PHX shell" annotation(Dialog(tab="PFL",group="PHX"));
  SI.MassFlowRate m_flow_shell_PHX "shell PHX mass flow rate" annotation(Dialog(tab="PFL",group="PHX"));
  Real nTubes_PHX "# tubes in PHX" annotation(Dialog(tab="PFL",group="PHX"));
  SI.Length diameter_outer_tube_PHX "outer diam tube PHX" annotation(Dialog(tab="PFL",group="PHX"));
  SI.Length th_tube_PHX "thickness tube PHX" annotation(Dialog(tab="PFL",group="PHX"));
  SI.Length length_tube_PHX "length tube PHX" annotation(Dialog(tab="PFL",group="PHX"));
  SI.Length tube_pitch_PHX "tube pitch PHX" annotation(Dialog(tab="PFL",group="PHX"));
  SI.CoefficientOfHeatTransfer alpha_tube_PHX "heat transfer coefficient" annotation(Dialog(tab="PFL",group="PHX"));
  SI.Area surfaceArea_tube_PHX "surfaceArea tube PHX" annotation(Dialog(tab="PFL",group="PHX"));
  SI.Mass m_tube_PHX "salt mass tube PHX" annotation(Dialog(tab="PFL",group="PHX"));
  SI.Volume volume_tube_PHX = m_tube_PHX/d_PFL "salt volume tube PHX" annotation(Dialog(tab="PFL",group="PHX"));
  SI.Area crossArea_shell_PHX "flow area shell PHX" annotation(Dialog(tab="PFL",group="PHX"));
  SI.Length perimeter_shell_PHX "wetted perimeter shell PHX" annotation(Dialog(tab="PFL",group="PHX"));
  SI.CoefficientOfHeatTransfer alpha_shell_PHX
    "heat transfer coefficient"                                                  annotation(Dialog(tab="PFL",group="PHX"));
  SI.Area surfaceArea_shell_PHX "surfaceArea shell PHX" annotation(Dialog(tab="PFL",group="PHX"));
  SI.Mass m_shell_PHX "salt mass shell PHX" annotation(Dialog(tab="PFL",group="PHX"));
  SI.Volume volume_shell_PHX = m_shell_PHX/d_PCL "salt volume shell PHX" annotation(Dialog(tab="PFL",group="PHX"));
  // Primary Coolant Loop
  // Pump Bowl
  SI.Length dims_pumpBowl_PCL_1 "diameter of pump bowl" annotation(Dialog(tab="PCL",group="Pump Bowl"));
  SI.Length dims_pumpBowl_PCL_2 "height of pump bowl" annotation(Dialog(tab="PCL",group="Pump Bowl"));
  SI.Length level_nom_pumpBowl_PCL "nominal salt level of pump bowl" annotation(Dialog(tab="PCL",group="Pump Bowl"));
  SI.Mass m_pumpBowl_PCL "mass " annotation(Dialog(tab="PCL",group="Pump Bowl"));
  SI.Volume volume_pumpBowl_PCL = m_pumpBowl_PCL/d_PCL
    "volume of at Tref"                                                          annotation(Dialog(tab="PCL",group="Pump Bowl"));
  //Piping
  SI.Length dims_pipePHXToPumpBowl_1 "diameter of " annotation(Dialog(tab="PCL",group="Piping"));
  SI.Length dims_pipePHXToPumpBowl_2 "length of " annotation(Dialog(tab="PCL",group="Piping"));
  SI.Mass m_pipePHXToPumpBowl_PCL "mass " annotation(Dialog(tab="PCL",group="Piping"));
  SI.Volume volume_pipePHXToPumpBowl_PCL = m_pipePHXToPumpBowl_PCL/d_PCL
    "volume of at Tref"                                                                            annotation(Dialog(tab="PCL",group="Piping"));
  SI.Length dims_pipePumpBowlToSHX_1 "diameter of " annotation(Dialog(tab="PCL",group="Piping"));
  SI.Length dims_pipePumpBowlToSHX_2 "length of " annotation(Dialog(tab="PCL",group="Piping"));
  SI.Mass m_pipePumpBowlToSHX_PCL "mass " annotation(Dialog(tab="PCL",group="Piping"));
  SI.Volume volume_pipePumpBowlToSHX_PCL = m_pipePumpBowlToSHX_PCL/d_PCL
    "volume of  at Tref"                                                                            annotation(Dialog(tab="PCL",group="Piping"));
  SI.Length dims_pipeSHXToPHX_1 "diameter of " annotation(Dialog(tab="PCL",group="Piping"));
  SI.Length dims_pipeSHXToPHX_2 "length of " annotation(Dialog(tab="PCL",group="Piping"));
  SI.Mass m_pipeSHXToPHX_PCL "mass " annotation(Dialog(tab="PCL",group="Piping"));
  SI.Volume volume_pipeSHXToPHX_PCL = m_pipeSHXToPHX_PCL/d_PCL
    "volume of  at Tref"                                                                  annotation(Dialog(tab="PCL",group="Piping"));
  // SHX
  SI.Temperature T_tube_inlet_SHX "inlet temp to SHX tube" annotation(Dialog(tab="PCL",group="SHX"));
  SI.Temperature T_tube_outlet_SHX "outlet temp to SHX tube" annotation(Dialog(tab="PCL",group="SHX"));
  SI.Pressure p_inlet_tube_SHX "inlet pressure SHX tube" annotation(Dialog(tab="PCL",group="SHX"));
  SI.PressureDifference dp_tube_SHX "pressure drop across SHX tube" annotation(Dialog(tab="PCL",group="SHX"));
  SI.MassFlowRate m_flow_tube_SHX "tube SHX mass flow rate" annotation(Dialog(tab="PCL",group="SHX"));
  SI.Temperature T_shell_inlet_SHX "inlet temp to SHX shell" annotation(Dialog(tab="PCL",group="SHX"));
  SI.Temperature T_shell_outlet_SHX "outlet temp to SHX shell" annotation(Dialog(tab="PCL",group="SHX"));
  SI.Pressure p_inlet_shell_SHX "inlet pressure SHX shell" annotation(Dialog(tab="PCL",group="SHX"));
  SI.PressureDifference dp_shell_SHX "pressure drop across SHX shell" annotation(Dialog(tab="PCL",group="SHX"));
  SI.MassFlowRate m_flow_shell_SHX "shell SHX mass flow rate" annotation(Dialog(tab="PCL",group="SHX"));
  Real nTubes_SHX "# tubes in SHX" annotation(Dialog(tab="PCL",group="SHX"));
  SI.Length diameter_outer_tube_SHX "outer diam tube SHX" annotation(Dialog(tab="PCL",group="SHX"));
  SI.Length th_tube_SHX "thickness tube SHX" annotation(Dialog(tab="PCL",group="SHX"));
  SI.Length length_tube_SHX "length tube SHX" annotation(Dialog(tab="PCL",group="SHX"));
  SI.Length tube_pitch_SHX "tube pitch SHX" annotation(Dialog(tab="PCL",group="SHX"));
  SI.CoefficientOfHeatTransfer alpha_tube_SHX "heat transfer coefficient" annotation(Dialog(tab="PCL",group="SHX"));
  SI.Area surfaceArea_tube_SHX "surfaceArea tube SHX" annotation(Dialog(tab="PCL",group="SHX"));
  SI.Mass m_tube_SHX "salt mass tube SHX" annotation(Dialog(tab="PCL",group="SHX"));
  SI.Volume volume_tube_SHX = m_tube_SHX/d_BOP "salt volume tube SHX" annotation(Dialog(tab="PCL",group="SHX"));
  SI.Area crossArea_shell_SHX "flow area shell SHX" annotation(Dialog(tab="PCL",group="SHX"));
  SI.Length perimeter_shell_SHX "wetted perimeter shell SHX" annotation(Dialog(tab="PCL",group="SHX"));
  SI.CoefficientOfHeatTransfer alpha_shell_SHX
    "heat transfer coefficient"                                                  annotation(Dialog(tab="PCL",group="SHX"));
  SI.Area surfaceArea_shell_SHX "surfaceArea shell SHX" annotation(Dialog(tab="PCL",group="SHX"));
  SI.Mass m_shell_SHX "salt mass shell SHX" annotation(Dialog(tab="PCL",group="SHX"));
  SI.Volume volume_shell_SHX = m_shell_SHX/d_PCL "salt volume shell SHX" annotation(Dialog(tab="PCL",group="SHX"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Summary;
