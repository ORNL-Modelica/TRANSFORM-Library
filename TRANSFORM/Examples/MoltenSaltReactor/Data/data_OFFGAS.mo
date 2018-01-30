within TRANSFORM.Examples.MoltenSaltReactor.Data;
model data_OFFGAS

  extends TRANSFORM.Icons.Record;

  import TRANSFORM.Units.Conversions.Functions.VolumeFlowRate_m3_s.from_gpm;
  import TRANSFORM.Units.Conversions.Functions.Pressure_Pa.from_psi;
  import TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degF;
  import TRANSFORM.Units.Conversions.Functions.Time_s.from_hr;
  import TRANSFORM.Units.Conversions.Functions.Time_s.from_day;
  import TRANSFORM.Units.Conversions.Functions.Distance_m.from_inch;
  import TRANSFORM.Units.Conversions.Functions.Density_kg_m3.from_lb_feet3;
  import TRANSFORM.Units.Conversions.Functions.SpecificHeatCapacity_J_kgK.from_btu_lbdegF;

  package Medium_OffGas = Modelica.Media.IdealGases.SingleGases.He;

  parameter Integer nSep = 3 "number of separators";
  parameter Real frac_gasSplit = 0.5 "Fraction of gas which goes to bubbler vs holdup";

  parameter Real Vratio_sep_SG = 2 "# of volumes of salt for every volume of gas removed in each separator";
  parameter SI.VolumeFlowRate V_flow_sep_salt = from_gpm(10) "Volume flow rate of salt removed in each separator";
  parameter SI.VolumeFlowRate V_flow_sep_He = V_flow_sep_salt/Vratio_sep_SG "Volume flow rate of Helium removed in each separator";
  parameter SI.VolumeFlowRate V_flow_sep_He_total = nSep*V_flow_sep_He "Total volume flow rate of Helium removed from all separators";
  parameter SI.VolumeFlowRate V_flow_sep_salt_total = nSep*V_flow_sep_salt "Total volume flow rate of salt removed from all separators";

  parameter SI.Temperature T_sep_ref = from_degF(1250) "Reference temperature of salt removed at separator";
  parameter SI.Pressure p_sep_ref = from_psi(180) "Reference temperature of salt removed at separator";
  parameter SI.Density d_sep_ref = Medium_OffGas.density_pT(p_sep_ref,T_sep_ref) "Reference density at separator";
  parameter SI.Temperature T_drainTank = from_degF(1000) "Reference temperature of drain tank";
  parameter SI.Pressure p_drainTank = from_psi(40+14.7) "Drain tank gas volume pressure";
  parameter SI.MolarMass MM_He = 0.004 "Molar mass of helium";

  parameter SI.MolarFlowRate n_flow_sep_He =  V_flow_sep_He*p_sep_ref/(Modelica.Constants.R*T_sep_ref) "Molar flow rate of He from each separator";
  parameter SI.MassFlowRate m_flow_sep_He = n_flow_sep_He*MM_He "Mass flow rate of helium from each separator";

  parameter SI.MolarFlowRate n_flow_sep_He_total =  nSep*n_flow_sep_He "Total molar flow rate of He from all separators";
  parameter SI.MassFlowRate m_flow_sep_He_total = nSep*m_flow_sep_He "Total mass flow rate of helium from all separators";
  parameter SI.MassFlowRate m_flow_He_bubbler = 0.5*m_flow_sep_He_total "Total mass flow rate of helium to bubbler";
  parameter SI.MassFlowRate m_flow_He_adsorber = 0.5*m_flow_sep_He_total "Total mass flow rate of helium to adsorber bed";

  parameter SI.Time delay_drainTank = from_hr(6) "Gas holdup time in drain tank";
  parameter SI.Time delay_charcoalBed = from_day(90) "Gas holdup time in charcoal bed based on Xe-135";

  parameter SI.Density d_carbon = from_lb_feet3(30) "Density of charcoal bed";
  parameter SI.SpecificHeatCapacity cp_carbon = from_btu_lbdegF(0.3) "Specific heat capacit of charcoal bed";
  parameter SI.Temperature T_carbon = from_degF(340) "Average temperature of charcoal bed";
  parameter SI.Temperature T_carbon_wall = from_degF(250) "Average temperature of charcoal bed duct wall";
  parameter SI.PressureDifference dp_carbon = from_psi(5) "Approximate pressure drop across charcoal bed";
  // k(Xe) = 3.2e-4*exp(5880/T(Roentgen)) ft3/lb valid between 32-140 F but extended above


  parameter Integer nThimbles = 360 "# of thimbles in drain tank";
  parameter SI.Length D_thimbles = from_inch(3) "outer diameter of thimbles in drain tank";
  parameter SI.Length length_thimbles = from_inch(204) "length of thimbles in drain tank";
  parameter SI.Length D_drainTank_inner = from_inch(130) "Inner diameter of drain tank";
  parameter SI.Length length_drainTank_inner = from_inch(210) "Approximate inner vertical length of drain tank";
  parameter SI.Area crossArea_thimbles_outer = 0.25*pi*D_thimbles^2 "Outer cross-sectional area of each thimble";
  parameter SI.Area crossArea_drainTank_innerEmpty = 0.25*pi*D_drainTank_inner^2 "Inner cross-sectional area of an empty drain tank";
  parameter SI.Area crossArea_drainTank_inner = crossArea_drainTank_innerEmpty - crossArea_thimbles_outer*nThimbles "Inner cross-sectional area of drain tank with area of thimbles removed";
  parameter SI.Volume volume_thimble_outer = crossArea_thimbles_outer*length_thimbles "Outer volume of each thimble";
  parameter SI.Volume volume_drainTank_innerEmpty = crossArea_drainTank_innerEmpty*length_drainTank_inner "Inner volume of an empty drain tank";
  parameter SI.Volume volume_drainTank_inner = volume_drainTank_innerEmpty - volume_thimble_outer*nThimbles "Inner volume of drain tank with volume of thimbles removed";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end data_OFFGAS;
