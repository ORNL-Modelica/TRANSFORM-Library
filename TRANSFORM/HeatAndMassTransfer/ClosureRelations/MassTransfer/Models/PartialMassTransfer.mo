within TRANSFORM.HeatAndMassTransfer.ClosureRelations.MassTransfer.Models;
partial model PartialMassTransfer "Base model"
  replaceable package Medium = Modelica.Media.Air.MoistAir constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation (choicesAllMatching=true, Dialog(tab="Internal Interface"));
  parameter Integer nMT=1 "Number of mass transfer segments"
    annotation (Dialog(tab="Internal Interface"));
  parameter Integer nC = 1 "Number of substances"
    annotation (Dialog(tab="Internal Interface"));
  parameter Integer flagIdeal = 0 "Flag for models to handle ideal heat transfer" annotation (Dialog(tab="Internal Interface"));
  input Medium.ThermodynamicState states[nMT] "Thermodynamic state of fluid"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Temperature Ts_wall[nMT] "Wall temperature"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Concentration Cs_wall[nMT,nC] "Wall concentration"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Concentration Cs_fluid[nMT,nC] "Fluid concentration"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Velocity vs[nMT] "Fluid Velocity"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Diameter dimensions[nMT]
    "Characteristic dimension (e.g. hydraulic diameter)"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Area crossAreas[nMT] "Cross sectional flow area"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Length dlengths[nMT]
    "Characteristic length of heat transfer segment"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Height roughnesses[nMT] "Average height of surface asperities"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.DiffusionCoefficient Ds_ab[nMT,nC]
    "Diffusion coefficient in fluid"
    annotation (Dialog(group="Inputs"));
   parameter SI.ReynoldsNumber Re_lam(max=Re_turb) = 2300
     "Laminar transition Reynolds number" annotation (Dialog(tab="Advanced"));
   parameter SI.ReynoldsNumber Re_turb(min=Re_lam) = 4000
     "Turbulent transition Reynolds number" annotation (Dialog(tab="Advanced"));
  SI.MassFlowRate m_flows[nMT] "Fluid mass flow rate";
  SI.ReynoldsNumber Res[nMT] "Reynolds number";
  SI.SchmidtNumber Scs[nMT,nC] "Schmidt number";
  SI.Length xs[nMT] "Position of local mass transfer calculation";
  Units.CoefficientOfMassTransfer alphasM[nMT,nC]
    "Coefficient of mass transfer";
  Units.SherwoodNumber Shs[nMT,nC] "Sherwood number";
protected
  final parameter SI.ReynoldsNumber Re_center=0.5*(Re_lam + Re_turb)
    "Re smoothing transition center";
  final parameter SI.ReynoldsNumber Re_width=Re_turb - Re_center
    "Re smoothing transition width";
equation
  for i in 1:nMT loop
    xs[i] =noEvent(if vs[i] >= 0 then (if i == 1 then 0.5*dlengths[i] else sum(
      dlengths[1:i - 1]) + 0.5*dlengths[i]) else (if i == nMT then 0.5*dlengths[
      nMT] else sum(dlengths[i + 1:nMT]) + 0.5*dlengths[i]));
  end for;
  annotation (
    defaultComponentName="massTransfer",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -124,-100},{124,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/MassTransfer_alphas.jpg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialMassTransfer;
