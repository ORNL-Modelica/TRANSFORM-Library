within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped;
partial model PartialHeatTransfer_setT "Base model"

  extends TRANSFORM.Fluid.Interfaces.Records.Medium_fluidInternal;

  parameter Real nParallel=1 "Number of parallel components" annotation(Dialog(tab="Internal Interface"));

  parameter Integer flagIdeal = 0 "Flag for models to handle ideal boundary" annotation (Dialog(tab="Internal Interface"));

  input Medium.ThermodynamicState state
    "Thermodynamic state of fluid"
    annotation (Dialog(tab="Internal Interface", group="Input Variables"));

  input SI.Velocity v "Fluid Velocity"
    annotation (Dialog(tab="Internal Interface", group="Input Variables"));
  input SI.Diameter dimension
    "Characteristic dimension (e.g. hydraulic diameter)"
    annotation (Dialog(tab="Internal Interface", group="Input Variables"));
  input SI.Area crossArea "Cross sectional flow area"
    annotation (Dialog(tab="Internal Interface", group="Input Variables"));
  input SI.Area surfaceArea "Surface area for heat transfer"
    annotation (Dialog(tab="Internal Interface", group="Input Variables"));

  parameter SI.ReynoldsNumber Re_lam(max=Re_turb) = 2300 "Laminar transition Reynolds number" annotation(Dialog(tab="Advanced"));
  parameter SI.ReynoldsNumber Re_turb(min=Re_lam) = 4000 "Turbulent transition Reynolds number" annotation(Dialog(tab="Advanced"));

  parameter Boolean use_T_film=false
    "=true for T_film = 0.5*(T_wall + T_fluid) else T_fluid"                                         annotation(Dialog(tab=
          "Advanced"));

  SI.Temperature T_fluid=Medium.temperature(state) "Fluid temperature";
  SI.Temperature T_wall=heatPort.T "Wall temperature";
//   SI.Temperature T_film=if use_T_film then 0.5*(T_wall + T_fluid) else T_fluid
//     "Film temperature";
//   Medium.ThermodynamicState state_film=
//       Medium.setState_pTX(
//       Medium.pressure(state),
//       T_film,
//       Medium.X_default) "Film state";  //Medium.X_default should be at leaste Medium.massFraction(state) but this doesn't seem to exist

  SI.MassFlowRate m_flow "Fluid mass flow rate";
  //SI.Velocity v_film "Velocity with properties evaluated at film temperature";
  SI.ReynoldsNumber Re "Reynolds number";
//   SI.ReynoldsNumber Re_film
//     "Reynolds number with properties evaluated at film temperature";
  SI.PrandtlNumber Pr "Prandtl number";
//   SI.PrandtlNumber Pr_film
//     "Prandtl number with properties evaluated at film temperature";

  SI.CoefficientOfHeatTransfer alpha "Coefficient of heat transfer";
  SI.NusseltNumber Nu "Nusselt number";
  SI.HeatFlowRate Q_flow=heatPort.Q_flow/nParallel "Heat flow rate";

  HeatAndMassTransfer.Interfaces.HeatPort_Flow heatPort annotation (Placement(
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent=
           {{90,-10},{110,10}})));

protected
  final parameter SI.ReynoldsNumber Re_center = 0.5*(Re_lam + Re_turb) "Re smoothing transition center";
  final parameter SI.ReynoldsNumber Re_width = Re_turb - Re_center "Re smoothing transition width";

  annotation (
    defaultComponentName="heatTransfer",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -124,-100},{124,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/HeatTransfer_alphas.jpg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialHeatTransfer_setT;
