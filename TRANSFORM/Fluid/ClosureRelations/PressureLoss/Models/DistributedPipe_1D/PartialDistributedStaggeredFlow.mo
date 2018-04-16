within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D;
partial model PartialDistributedStaggeredFlow
  import Modelica.Fluid.Types.Dynamics;

  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium properties"
    annotation (choicesAllMatching=true, Dialog(tab="Internal Interface"));

  parameter Integer nFM(min=1) = 1 "Number of discrete flow models"
    annotation (Dialog(tab="Internal Interface"));
  input SI.Acceleration g_n=Modelica.Constants.g_n "Gravitational acceleration"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));

  // Initialization
  parameter Dynamics momentumDynamics = Dynamics.DynamicFreeInitial "Formulation of momentum balance"
    annotation (Dialog(tab="Internal Interface", group="Initialization"));
  parameter SI.PressureDifference[nFM] dps_start
    "Pressure changes {p[2]-p[1],...,p[n+1]-p[n]}"
    annotation (Dialog(tab="Internal Interface", group="Initialization"));
  parameter SI.MassFlowRate[nFM] m_flows_start "Mass flow rates"
    annotation (Dialog(tab="Internal Interface", group="Initialization"));

  // State parameters
  input Medium.ThermodynamicState states[nFM + 1] "State at volumes"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.Velocity[nFM + 1] vs "Mean velocities of fluid flow"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.Temperature[nFM + 1] Ts_wall
    "Mean wall temperatures of heat transfer surface"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));

  // Geometry
  input SI.Length dimensions[nFM + 1]
    "Characteristic dimensions (e.g. hydraulic diameter)"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.Area crossAreas[nFM + 1] "Cross sectional area"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.Length perimeters[nFM + 1] "Wetted perimeter"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.Length dlengths[nFM] "Length of flow model"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.Height[nFM + 1] roughnesses "Average height of surface asperities"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));
  input SI.Length[nFM] dheights
    "Height(states[2:nFM+1]) - Height(states[1:nFM])"
    annotation (Dialog(group="Inputs", tab="Internal Interface"));

  parameter Boolean allowFlowReversal = true
"= true to allow flow reversal, false restricts to design direction (m_flows >= zeros(m))"
    annotation(Dialog(tab="Internal Interface", group="Advanced"), Evaluate=true);
  parameter SI.ReynoldsNumber Re_lam(max=Re_turb) = 2300
    "Laminar transition Reynolds number" annotation (Dialog(tab="Advanced"));
  parameter SI.ReynoldsNumber Re_turb(min=Re_lam) = 4000
    "Turbulent transition Reynolds number" annotation (Dialog(tab="Advanced"));
  parameter Boolean from_dp=momentumDynamics >= Modelica.Fluid.Types.Dynamics.SteadyStateInitial
    "= true, use m_flow = f(dp), otherwise dp = f(m_flow)"
    annotation (Dialog(tab="Advanced"), Evaluate=true);
  parameter SI.MassFlowRate m_flow_small=0.001 "Within regularization if |m_flows| < m_flow_small (may be wider for large discontinuities in static head)"
    annotation (Dialog(tab="Advanced",enable=not from_dp));
  parameter SI.AbsolutePressure dp_small = 1
    "Within regularization if |dp| < dp_small (may be wider for large discontinuities in static head)"
    annotation (Dialog(tab="Advanced",enable=from_dp));

//   parameter Boolean use_Ts_film = false "=true for Ts_film = 0.5*(Ts_wall + Ts_fluid) else Ts_fluid" annotation(Dialog(tab="Advanced"));

  // Variables defined by model
  SI.MassFlowRate m_flows[nFM](start=m_flows_start, each stateSelect=if
        momentumDynamics == Dynamics.SteadyState then StateSelect.default else
        StateSelect.prefer,each min=if allowFlowReversal then -Modelica.Constants.inf else 0) "Mass flow rate across interfaces";

  // Total quantities
  SI.Momentum[nFM] Is "Momenta of flow segments";

  // Source/Sink terms
  SI.Force[nFM] Ibs "Flow of momentum across boundaries and source/sink in volumes";

  // Base Properties
  SI.Temperature[nFM + 1] Ts_fluid=Medium.temperature(states)
    "Fluid temperature";
//   SI.Temperature[nFM + 1] Ts_film=if use_Ts_film then 0.5*(Ts_wall + Ts_fluid) else Ts_fluid "Film temperature";
//   Medium.ThermodynamicState[nFM + 1] states_film=Medium.setState_pTX(
//       Medium.pressure(states),
//       Ts_film,
//       Medium.X_default) "Film state";
  //Medium.X_default should be at leaste Medium.massFraction(state) but this doesn't seem to exist
  SI.ReynoldsNumber[nFM] Res "Reynolds number";
//   SI.ReynoldsNumber[nFM] Res_film
//     "Reynolds number with properties evaluated at film temperature";

protected
  final parameter SI.ReynoldsNumber Re_center=0.5*(Re_lam + Re_turb)
    "Re smoothing transition center";
  final parameter SI.ReynoldsNumber Re_width=Re_turb - Re_center
    "Re smoothing transition width";

initial equation
  if momentumDynamics == Dynamics.FixedInitial then
    m_flows = m_flows_start;
  elseif momentumDynamics == Dynamics.SteadyStateInitial then
    der(m_flows) = zeros(nFM);
  end if;

equation

  for i in 1:nFM loop
    assert(m_flows[i] > -m_flow_small or allowFlowReversal, "Reverting flow occurs in flowModel even though allowFlowReversal is false");
  end for;

  // Total quantities
  Is = {m_flows[i]*dlengths[i] for i in 1:nFM};

  // Momentum balances
  if momentumDynamics == Dynamics.SteadyState then
    for i in 1:nFM loop
      0 = Ibs[i];
    end for;
  else
    for i in 1:nFM loop
      der(Is[i]) = Ibs[i];
    end for;
  end if;

  annotation (Documentation(info="<html>
</html>"), Icon(graphics={Bitmap(extent={{-114,-100},{114,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/FlowModel_dps.jpg")}));
end PartialDistributedStaggeredFlow;
