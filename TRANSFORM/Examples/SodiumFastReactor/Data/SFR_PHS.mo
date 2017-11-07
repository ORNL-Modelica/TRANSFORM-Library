within TRANSFORM.Examples.SodiumFastReactor.Data;
record SFR_PHS

  extends BaseClasses.Record_Data;

  //Source 1: Fast Spectrum Reactors by Alan Waltar, Donald Todd, and Pavel Tsvetkov

  replaceable package Medium_primary =
      TRANSFORM.Media.Fluids.Sodium.ConstantPropertyLiquidSodium constrainedby
    Modelica.Media.Interfaces.PartialMedium
    "Primary system medium: Sodium change/add temp dependent sodium!"
    annotation (choicesAllMatching=true);
  replaceable package Material_bond = TRANSFORM.Media.Solids.Sodium
    constrainedby TRANSFORM.Media.Interfaces.PartialAlloy
    "Fuel-Cladding Bond material: Sodium change/add liquid sodium!" annotation (
     choicesAllMatching=true);
  replaceable package Material_duct = TRANSFORM.Media.Solids.SS316
    constrainedby TRANSFORM.Media.Interfaces.PartialAlloy
    "Duct material: SS316 or HT9" annotation (choicesAllMatching=true);
  replaceable package Material_clad = TRANSFORM.Media.Solids.SS316
    constrainedby TRANSFORM.Media.Interfaces.PartialAlloy
    "Cladding material: SS316 or HT9" annotation (choicesAllMatching=true);

  parameter Integer nShield = 126;
  parameter Integer nReflector = 180;
  parameter Integer nOuterCore = 42;
  parameter Integer nInnerCore = 30;
  parameter Integer nPrimarCR = 6;
  parameter Integer nSecondaryCR = 3;
  parameter Integer nTestLoop = 4;

  parameter SI.Length pitch_subassembly=0.12 "Subassembly pitch";
  parameter SI.Length th_duct=0.003 "Subassembly duct thickness";
  parameter SI.Length gap_subassembly=0.003 "Gap between subassemblies";
  parameter SI.Length width_duct_inside=pitch_subassembly - 2*th_duct - gap_subassembly
    "Subassembly duct inside flat-to-flat. Default 0.111";
  parameter Integer nPins_perSub=271 "# pins per subassembly";
  parameter SI.Length D_pin=0.0053 "Pin diameter";
  parameter SI.Length th_clad=0.00037 "Cladding thickness";
  parameter SI.Length D_wireWrap=0.00126 "Wire wrap diameter";
  parameter SIadd.nonDim PD_ratio=1.248 "Pin pitch to diameter ratio p/d";

  parameter SI.Length length_subassembly_out = 0.60 "Length of subassembly above gas plenum region";
  parameter SI.Length length_subassembly_gasplenum = 1.50 "Length of subassembly gas plenum length after active region";
  parameter SI.Length length_subassembly_active = 0.80 "Length of subassembly active core";
  parameter SI.Length length_subassembly_shielding = 0.95 "Length of subassembly shielding before active region";
  parameter SI.Length length_subassembly_in = 0.32 "Length of subassembly before shielding";

  parameter SI.Length length_in = length_subassembly_shielding+length_subassembly_in;
  parameter SI.Length length_out = length_subassembly_out+length_subassembly_gasplenum;
  parameter SI.Length length_total = length_in+length_subassembly_active+length_out;

  // Initialization
  parameter SI.Pressure p_start = 1e5;
  parameter SI.Temperature T_start_hot = T_IHX_inletPHTS;
  parameter SI.Temperature T_start_cold = T_IHX_oultetPHTS;
  parameter SI.MassFlowRate m_flow_start = m_flow_PHTS;
  parameter SI.SpecificEnthalpy h_start_hot = Medium_primary.specificEnthalpy_pT(p_start,T_start_hot);

  parameter Real R_m_flows[4] = {0.5,0.3,0.1,0.1} "Fraction of total flow per assembly type";
  parameter SI.MassFlowRate m_flow_outer = R_m_flows[1]*m_flow_PHTS;
  parameter SI.MassFlowRate m_flow_inner = R_m_flows[2]*m_flow_PHTS;
  parameter SI.MassFlowRate m_flow_reflector = R_m_flows[3]*m_flow_PHTS;
  parameter SI.MassFlowRate m_flow_shield = R_m_flows[4]*m_flow_PHTS;
  // Kinetics - source 1 pg. 125 Table 6.2
  parameter SIadd.TempFeedbackCoeff alpha_outer = 0.5*(0.0011+0.0013);
  parameter SIadd.TempFeedbackCoeff alpha_inner = 0.5*(0.0034 + 0.0037);

  // Nominal Conditions
  parameter SI.Power Qth_nominal = 300e6 "Nominal thermal power";
  parameter SIadd.nonDim Q_outer_nominal = 0.6*Qth_nominal "Nominal power in region";
  parameter SIadd.nonDim Q_inner_nominal = 0.4*Qth_nominal "Nominal power in region";
  parameter SI.MassFlowRate m_flow_PHTS = 1570 "Sodium flow rate in PHTS";
  parameter SI.MassFlowRate m_flow_IHX_PHTS = m_flow_PHTS/nIHXs "Sodium flow rate per IHX on PHTS side";
  parameter SI.MassFlowRate m_flow_IHX_IHTS = m_flow_PHTS/nIHXs "Sodium flow rate per IHX on IHTS side";
  parameter SI.Temperature T_IHX_inletPHTS = TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degC(510) "PHTS side inlet temperature to IHX";
  parameter SI.Temperature T_IHX_oultetPHTS = TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degC(360) "PHTS side outlet temperature to IHX";
  parameter SI.Temperature T_IHX_inletIHTS = TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degC(334) "IHTS side inlet temperature to IHX";
  parameter SI.Temperature T_IHX_outletIHTS = TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degC(483) "IHTS side outlet temperature to IHX";
  parameter SI.PressureDifference dp_IHX_shell = 16805 "Shell (primary) side pressure drop";
  parameter SI.PressureDifference dp_IHX_tube = 39250 "Tube (secondary) side pressure drop";

  /// Geometry Calculations
  final parameter SI.Length a_inner = width_duct_inside/sqrt(3) "Inner length of hexagonol subassembly duct";
  final parameter SI.Area crossArea_duct_empty = 0.5*3*sqrt(3)*a_inner^2 "Empty duct cross sectional flow area";
  final parameter SI.Area crossArea_pin = 0.25*Modelica.Constants.pi*D_pin^2 "Cross sectional area of pin";
  final parameter SI.Area crossArea_pins = crossArea_pin*nPins_perSub "Total cross sectional area of pins";
  final parameter SI.Area crossArea_duct = crossArea_duct_empty - crossArea_pins "Cross sectional flow area of duct";
  final parameter SI.Area crossArea_pinflow = crossArea_duct/nPins_perSub "Cross sectional flow area per pin";

  // Vessel
  parameter SI.Length height_primaryVessel = 14.67;
  parameter SI.Length D_inner_primaryVessel = 9.91;
  parameter SI.Length D_inner_guardVessel = 10.42;
  parameter Real frac_emptytopprimaryVessel = 0.5 "Fraction of primary vessel cross sectional area empty above core region";
  final parameter SI.Length th_primaryVessel = 0.5*(D_inner_guardVessel-D_inner_primaryVessel);
  final parameter SI.Length th_guardVessel = th_primaryVessel;
  final parameter SI.Length level_coldNa = 11.23-th_primaryVessel;
  final parameter SI.Length level_hotNa = 13.46-th_primaryVessel;
  final parameter SI.Area crossArea_topprimaryVessel = frac_emptytopprimaryVessel*0.25*pi*D_inner_primaryVessel^2;
  final parameter SI.Length height_topprimaryVessel = height_primaryVessel-5;
  final parameter SI.Length level_start_topcold = level_coldNa-5;
  final parameter SI.Length level_start_tophot = level_hotNa-5;
  final parameter SI.Length dlevel_start = level_start_tophot-level_start_topcold;
  final parameter SI.Area crossArea_upperplenum = 5^2*pi/4 + pi/8*(crossArea_topprimaryVessel^2-5^2) "rough estimate based on drawing";
  final parameter SI.Length height_upperplenum = 3.5 "distance from core exit to midpoint of IHX inlet";
  final parameter SI.Area crossArea_expansionVolume = crossArea_topprimaryVessel;
  final parameter SI.Length level_start_cold_expanstionTank = level_start_topcold-height_upperplenum;
  final parameter SI.Length level_start_hot_expanstionTank = level_hotNa-height_upperplenum;
  final parameter SI.Area crossArea_bottomprimaryVessel = 0.25*pi*D_inner_primaryVessel^2 - 0.25*pi*5^2;
  final parameter SI.Length height_bottomprimaryVessel = 5;

  // IHX
  //Shell side is primary and tube side is secondary
  replaceable package Material_IHX_tubewall = TRANSFORM.Media.Solids.SS304
    constrainedby TRANSFORM.Media.Interfaces.PartialAlloy
    "Cladding material: SS304H" annotation (choicesAllMatching=true);
  parameter Integer nIHXs = 3 "Number of IHXs";
  parameter SI.Length D_tube_outer = 0.0159 "Tube outer diameter";
  parameter SI.Length th_tubewall = 0.889e-3 "Tube wall thickness";
  final parameter SI.Length D_tube_inner = D_tube_outer-2*th_tubewall;
  parameter SI.Length pitch_tube = 0.025 "Tube pitch";
  parameter SI.Length length_tube = 4.03 "tube length";
  parameter Integer nTubes = 2248 "Number of tubes";
  parameter SI.Length th_tubesheet = 0.137 "Tube sheet thickness";
  parameter SI.Length height_shell = 5.32 "Shell height";
  parameter SI.Length D_shell_outer = 1.41 "Shell outer diameter 1.41/1.50";
  parameter SI.Length th_shellwall = 0.01905 "Shell wall thickness";
  final parameter SI.Area surfaceArea = Modelica.Constants.pi*D_tube_outer*length_tube*nTubes "Heat transfer area. Should = 466.5";
  parameter SI.Power Qth_nominal_IHXs = Qth_nominal/nIHXs "Nominal design capacity per IHX";
  parameter SI.Length D_downcomerIHX = 0.36 "downcomer diameter";
  parameter SI.Length D_riserIHX = 0.5 "ihx riser diameter";

  annotation (
    defaultComponentName="data",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          lineColor={0,0,0},
          extent={{-100,-90},{100,-70}},
          textString="PHS")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>"));
end SFR_PHS;
