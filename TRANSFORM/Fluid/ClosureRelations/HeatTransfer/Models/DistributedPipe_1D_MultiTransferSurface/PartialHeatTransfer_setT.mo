within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
partial model PartialHeatTransfer_setT "Base model"
  parameter Real nParallel=1 "Number of parallel components" annotation(Dialog(tab="Internal Interface"));

  replaceable package Medium = Modelica.Media.Water.StandardWater constrainedby Modelica.Media.Interfaces.PartialMedium
                                            "Medium in the component"
    annotation (choicesAllMatching=true, Dialog(tab="Internal Interface"));
  parameter Integer nHT=1 "Number of heat transfer segments"
    annotation (Dialog(tab="Internal Interface"));
  parameter Integer nSurfaces=1 "Number of heat transfer surfaces"
  annotation (Dialog(tab="Internal Interface"));
  parameter Integer flagIdeal = 0 "Flag for models to handle ideal boundary" annotation (Dialog(tab="Internal Interface"));
  input Medium.ThermodynamicState states[nHT] "Thermodynamic state of fluid"
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
  input SI.Area surfaceAreas[nHT,nSurfaces] "Surface area for heat transfer"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  parameter SI.Temperature Ts_start[nHT] annotation (Dialog(tab="Internal Interface", group="Initialization"));
  parameter SI.ReynoldsNumber Re_lam(max=Re_turb) = 2300 "Laminar transition Reynolds number" annotation(Dialog(tab="Advanced"));
  parameter SI.ReynoldsNumber Re_turb(min=Re_lam) = 4000 "Turbulent transition Reynolds number" annotation(Dialog(tab="Advanced"));
  input Units.NonDim CF=1.0 "Correction Factor: Q = CF*alpha*A*dT" annotation(Dialog(tab="Advanced",group="Inputs"));
  input Units.NonDim CFs[nHT,nSurfaces]=fill(
      CF,
      nHT,
      nSurfaces) "if non-uniform then set"  annotation(Dialog(tab="Advanced",group="Inputs"));

  Medium.ThermodynamicState states_wall[nHT,nSurfaces] = Medium.setState_pTX(transpose({Medium.pressure(states) for i in 1:nSurfaces}), Ts_wall, Medium.X_default);

  //parameter Boolean use_Ts_film = false "=true for Ts_film = 0.5*(Ts_wall + Ts_fluid) else Ts_fluid" annotation(Dialog(tab="Advanced"));
  SI.Temperature Ts_fluid[nHT] = Medium.temperature(states) "Fluid temperature";
  SI.Temperature Ts_wall[nHT,nSurfaces] = heatPorts.T "Wall temperature";
  //SI.Temperature Ts_film[nHT,nSurfaces]=if use_Ts_film then {{0.5*(Ts_wall[i,j] + Ts_fluid[i]) for j in 1:nSurfaces} for i in 1:nHT} else transpose({Ts_fluid for i in 1:nSurfaces}) "Film temperature";
//   Medium.ThermodynamicState states_film[nHT,nSurfaces]=Medium.setState_pTX(
//        transpose({Medium.pressure(states) for i in 1:nSurfaces}),
//        Ts_film,
//        Medium.X_default) "Film state"; //Medium.X_default should be at leaste Medium.massFraction(state) but this doesn't seem to exist
  SI.MassFlowRate m_flows[nHT] "Fluid mass flow rate";
//   SI.Velocity vs_film[nHT,nSurfaces]
//     "Velocity with properties evaluated at film temperature";
  SI.ReynoldsNumber Res[nHT] "Reynolds number";
//   SI.ReynoldsNumber Res_film[nHT,nSurfaces]
//     "Reynolds number with properties evaluated at film temperature";
  SI.PrandtlNumber Prs[nHT] "Prandtl number";
//   SI.PrandtlNumber Prs_film[nHT,nSurfaces]
//     "Prandtl number with properties evaluated at film temperature";
//   SI.Length xs[nHT] "Position of local heat transfer calculation";
  SI.CoefficientOfHeatTransfer alphas[nHT,nSurfaces] "Coefficient of heat transfer";
  SI.NusseltNumber Nus[nHT,nSurfaces] "Nusselt number";
  SI.HeatFlowRate Q_flows[nHT,nSurfaces] = heatPorts.Q_flow/nParallel "Heat flow rate";

  HeatAndMassTransfer.Interfaces.HeatPort_Flow heatPorts[nHT,nSurfaces] annotation (Placement(
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{
            90,-10},{110,10}})));
protected
  final parameter SI.ReynoldsNumber Re_center = 0.5*(Re_lam + Re_turb) "Re smoothing transition center";
  final parameter SI.ReynoldsNumber Re_width = Re_turb - Re_center "Re smoothing transition width";
equation
  // Believe this local position overly complicates for the current limitations of Modelica models
//   for i in 1:nHT loop
//     xs[i] =noEvent(if m_flows[i] >= 0 then (if i == 1 then 0.5*dlengths[i] else sum(
//       dlengths[1:i - 1]) + 0.5*dlengths[i]) else (if i == nHT then 0.5*dlengths[
//       nHT] else sum(dlengths[i + 1:nHT]) + 0.5*dlengths[i]));
//   end for;
  annotation (
    defaultComponentName="heatTransfer",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -124,-100},{124,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/HeatTransfer_alphas.jpg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialHeatTransfer_setT;
