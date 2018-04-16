within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models;
partial model PartialHeatTransfer
  "Base model"

  replaceable package Medium = Modelica.Media.Air.MoistAir constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation (choicesAllMatching=true, Dialog(tab="Internal Interface"));

  parameter Integer nHT=1 "Number of heat transfer segments"
    annotation (Dialog(tab="Internal Interface"));

  parameter Integer flagIdeal = 0 "Flag for models to handle ideal heat transfer" annotation (Dialog(tab="Internal Interface"));

  input Medium.ThermodynamicState states[nHT] "Thermodynamic state of fluid"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));

  input SI.Temperature Ts_wall[nHT] "Wall temperature"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Temperature Ts_fluid[nHT] "Fluid temperature"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));

  input SI.Velocity vs[nHT] "Fluid Velocity"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));

  input SI.Diameter dimensions[nHT]
    "Characteristic dimension (e.g. hydraulic diameter)"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));

  input SI.Area crossAreas[nHT] "Cross sectional flow area"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Length dlengths[nHT]
    "Characteristic length of heat transfer segment"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Height roughnesses[nHT] "Average height of surface asperities"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));

   parameter SI.ReynoldsNumber Re_lam(max=Re_turb) = 2300
     "Laminar transition Reynolds number" annotation (Dialog(tab="Advanced"));
   parameter SI.ReynoldsNumber Re_turb(min=Re_lam) = 4000
     "Turbulent transition Reynolds number" annotation (Dialog(tab="Advanced"));

  SI.Temperature Ts_film[nHT]=0.5*(Ts_wall + Ts_fluid) "Film temperature";
  Medium.ThermodynamicState states_film[nHT]=Medium.setState_pTX(
      Medium.pressure(states),
      Ts_film,
      Medium.X_default) "Film state";

  SI.MassFlowRate m_flows[nHT] "Fluid mass flow rate";
  SI.Velocity vs_film[nHT]
    "Velocity with properties evaluated at film temperature";
  SI.ReynoldsNumber Res[nHT] "Reynolds number";
  SI.ReynoldsNumber Res_film[nHT]
    "Reynolds number with properties evaluated at film temperature";
  SI.PrandtlNumber Prs[nHT] "Prandtl number";
  SI.PrandtlNumber Prs_film[nHT]
    "Prandtl number with properties evaluated at film temperature";
  SI.Length xs[nHT] "Position of local heat transfer calculation";

  SI.CoefficientOfHeatTransfer alphas[nHT] "Coefficient of heat transfer";
  SI.NusseltNumber Nus[nHT] "Nusselt number";

protected
  final parameter SI.ReynoldsNumber Re_center=0.5*(Re_lam + Re_turb)
    "Re smoothing transition center";
  final parameter SI.ReynoldsNumber Re_width=Re_turb - Re_center
    "Re smoothing transition width";

equation

  for i in 1:nHT loop
    xs[i] =noEvent(if vs[i] >= 0 then (if i == 1 then 0.5*dlengths[i] else sum(
      dlengths[1:i - 1]) + 0.5*dlengths[i]) else (if i == nHT then 0.5*dlengths[
      nHT] else sum(dlengths[i + 1:nHT]) + 0.5*dlengths[i]));
  end for;

  annotation (
    defaultComponentName="heatTransfer",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -124,-100},{124,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/HeatTransfer_alphas.jpg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialHeatTransfer;
