within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D;
partial model PartialMassTransfer_setC "Base model"
  parameter Real nParallel=1 "Number of parallel components" annotation(Dialog(tab="Internal Interface"));
  replaceable package Medium = Modelica.Media.Air.MoistAir constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation (choicesAllMatching=true, Dialog(tab="Internal Interface"));
  parameter Integer nMT=1 "Number of mass transfer segments"
    annotation (Dialog(tab="Internal Interface"));
  parameter Integer flagIdeal = 0 "Flag for models to handle ideal boundary" annotation (Dialog(tab="Internal Interface"));
  input Medium.ThermodynamicState states[nMT] "Thermodynamic state of fluid"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Temperature Ts_wall[nMT] "Wall temperature"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SIadd.ExtraProperty CsM_fluid[nMT,Medium.nC]
    "Fluid trace substance mass fraction"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Velocity vs[nMT] "Fluid Velocity"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Diameter dimensions[nMT]
    "Characteristic dimension (e.g. hydraulic diameter)"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Area crossAreas[nMT] "Cross sectional flow area"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Length dlengths[nMT] "Characteristic length of transfer segment"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Height roughnesses[nMT] "Average height of surface asperities"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Area surfaceAreas[nMT] "Surface area for transfer"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  parameter SIadd.ExtraProperty CsM_start[nMT,Medium.nC]
    "Initial Trace substance mass-specific value"
    annotation (Dialog(tab="Internal Interface", group="Initialization"));
  parameter SI.MolarMass MMs[Medium.nC]=fill(1, Medium.nC)
    "Trace substances molar mass";
  replaceable model DiffusionCoeff =
      TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.GenericCoefficient
    constrainedby
    TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.PartialMassDiffusionCoefficient
    "Diffusion Coefficient" annotation (Dialog(group="Closure Models"),
      choicesAllMatching=true);
  DiffusionCoeff diffusionCoeff[nMT](each final nC=Medium.nC, final T=Ts_fluid)
    "Diffusion Coefficient" annotation (Placement(transformation(extent={{-78,
            82},{-62,98}}, rotation=0)));
  parameter SI.ReynoldsNumber Re_lam(max=Re_turb) = 2300
    "Laminar transition Reynolds number" annotation (Dialog(tab="Advanced"));
  parameter SI.ReynoldsNumber Re_turb(min=Re_lam) = 4000
    "Turbulent transition Reynolds number" annotation (Dialog(tab="Advanced"));
  SI.Temperature Ts_fluid[nMT]=Medium.temperature(states) "Fluid temperature";
  SI.Concentration Cs_fluid[nMT,Medium.nC]
    "Fluid trace substance  concentration";
  SI.Concentration Cs_wall[nMT,Medium.nC]=massPorts.C
    "Wall trace substance  concentration";
  SI.MassFlowRate m_flows[nMT] "Fluid mass flow rate";
  SI.ReynoldsNumber Res[nMT] "Reynolds number";
  SI.SchmidtNumber Scs[nMT,Medium.nC] "Schmidt number";
  SI.Length xs[nMT] "Position of local mass transfer calculation";
  Units.CoefficientOfMassTransfer alphasM[nMT,Medium.nC]
    "Coefficient of mass transfer";
  Units.SherwoodNumber Shs[nMT,Medium.nC] "Sherwood number";
  SI.MolarFlowRate nC_flows[nMT,Medium.nC]= massPorts.n_flow/nParallel "Molar flow rate";
  SIadd.ExtraPropertyFlowRate mC_flows[nMT,Medium.nC] "Mass flow rate";
  HeatAndMassTransfer.Interfaces.MolePort_Flow massPorts[nMT](each nC=Medium.nC)
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
protected
  final parameter SI.ReynoldsNumber Re_center=0.5*(Re_lam + Re_turb)
    "Re smoothing transition center";
  final parameter SI.ReynoldsNumber Re_width=Re_turb - Re_center
    "Re smoothing transition width";
equation
  for i in 1:nMT loop
    Cs_fluid[i, :] = CsM_fluid[i, :] .* Medium.density(states[i]) ./ MMs[:];
    mC_flows[i, :] = nC_flows[i, :] .* MMs[:];
  end for;
  for i in 1:nMT loop
    xs[i] = noEvent(if vs[i] >= 0 then (if i == 1 then 0.5*dlengths[i] else sum(
      dlengths[1:i - 1]) + 0.5*dlengths[i]) else (if i == nMT then 0.5*dlengths[
      nMT] else sum(dlengths[i + 1:nMT]) + 0.5*dlengths[i]));
  end for;
  annotation (
    defaultComponentName="massTransfer",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={
              {-124,-100},{124,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/MassTransfer_alphas.jpg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialMassTransfer_setC;
