within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface;
partial model PartialMassTransfer_setC "Base model"
  parameter Real nParallel=1 "Number of parallel components"
    annotation (Dialog(tab="Internal Interface"));
  replaceable package Medium = Modelica.Media.Air.MoistAir constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation (choicesAllMatching=true, Dialog(tab="Internal Interface"));
  parameter Integer nMT=1 "Number of mass transfer segments"
    annotation (Dialog(tab="Internal Interface"));
  parameter Integer nSurfaces=1 "Number of mass transfer surfaces"
    annotation (Dialog(tab="Internal Interface"));
  parameter Integer flagIdeal=0 "Flag for models to handle ideal boundary"
    annotation (Dialog(tab="Internal Interface"));
  input Medium.ThermodynamicState states[nMT] "Thermodynamic state of fluid"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Temperature Ts_wall[nMT,nSurfaces] "Wall temperature"
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
  input SI.Area surfaceAreas[nMT,nSurfaces] "Surface area for transfer"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  parameter SIadd.ExtraProperty CsM_start[nMT,Medium.nC]
    "Initial Trace substance mass-specific value"
    annotation (Dialog(tab="Internal Interface", group="Initialization"));
  parameter Integer iC[:]= {i for i in 1:Medium.nC}
    "Fluid index of transfered substances from fluid to massPort. This sets nC in traceMassTransfer." annotation(Evaluate=true);
  final parameter Integer nC = size(iC,1);
  parameter Real MMs[nC]=fill(1, nC)
    "Conversion from fluid mass-specific value to moles (e.g., molar mass [kg/mol] or Avogadro's number [atoms/mol])";
  replaceable model DiffusionCoeff =
      TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.GenericCoefficient
    constrainedby
    TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.PartialMassDiffusionCoefficient
    "Fluid Diffusion Coefficient" annotation (Dialog(group="Closure Models"),
      choicesAllMatching=true);
  DiffusionCoeff diffusionCoeff[nMT](each final nC=nC, final T=Ts_fluid)
    "Fluid Diffusion Coefficient" annotation (Placement(transformation(extent={{-78,82},
            {-62,98}}, rotation=0)));
  parameter SI.ReynoldsNumber Re_lam(max=Re_turb) = 2300
    "Laminar transition Reynolds number" annotation (Dialog(tab="Advanced"));
  parameter SI.ReynoldsNumber Re_turb(min=Re_lam) = 4000
    "Turbulent transition Reynolds number" annotation (Dialog(tab="Advanced"));
  SI.Temperature Ts_fluid[nMT]=Medium.temperature(states) "Fluid temperature";
  SI.Concentration Cs_fluid[nMT,nC]
    "Fluid trace substance  concentration";
  SI.Concentration Cs_wall[nMT,nSurfaces,nC]=massPorts.C
    "Wall trace substance  concentration";
  SI.MassFlowRate m_flows[nMT] "Fluid mass flow rate";
  SI.ReynoldsNumber Res[nMT] "Reynolds number";
  SI.SchmidtNumber Scs[nMT,nC] "Schmidt number";
  SI.Length xs[nMT] "Position of local mass transfer calculation";
  Units.CoefficientOfMassTransfer alphasM[nMT,nSurfaces,nC]
    "Coefficient of mass transfer";
  Units.SherwoodNumber Shs[nMT,nSurfaces,nC] "Sherwood number";
  SI.MolarFlowRate nC_flows[nMT,nSurfaces,nC]=massPorts.n_flow/nParallel
    "Molar flow rate";
  SIadd.ExtraPropertyFlowRate mC_flows[nMT,nSurfaces,Medium.nC] "Mass flow rate";
  HeatAndMassTransfer.Interfaces.MolePort_Flow massPorts[nMT,nSurfaces](each nC=
       nC) annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
protected
  constant SIadd.Mole toMole_unitConv = 1;
  final parameter SI.ReynoldsNumber Re_center=0.5*(Re_lam + Re_turb)
    "Re smoothing transition center";
  final parameter SI.ReynoldsNumber Re_width=Re_turb - Re_center
    "Re smoothing transition width";
  final parameter Integer iC_fluid[Medium.nC] = {i for i in 1:Medium.nC};
  final parameter Integer nC_noT = Medium.nC - nC "# of species not transfered from fluid";
  final parameter Integer iC_noT[nC_noT] = if nC_noT > 0 then TRANSFORM.Math.indexFilter(iC_fluid,iC,false) else fill(0,nC_noT) "Index of species not transfered from fluid";
equation
   for i in 1:nMT loop
     for k in 1:nC loop
     Cs_fluid[i, k] =CsM_fluid[i, iC[k]] .* Medium.density(states[i]) ./ MMs[k]
         .* toMole_unitConv;
     end for;
   end for;
   for i in 1:nMT loop
     for j in 1:nSurfaces loop
       for k in 1:nC loop
           mC_flows[i, j, iC[k]] =nC_flows[i, j, k] .* MMs[k] .*
          toMole_unitConv;
       end for;
       for k in 1:nC_noT loop
         mC_flows[i, j, iC_noT[k]] = 0;
       end for;
     end for;
   end for;
//  for i in 1:nMT loop
//    Cs_fluid[i, :] = CsM_fluid[i, :] .* Medium.density(states[i]) ./ MMs[:].*toMole_unitConv;
//     for j in 1:nSurfaces loop
//       for k in 1:nC loop
//           mC_flows[i, j, iC[k]] = nC_flows[i, j, k] .* MMs[k].*toMole_unitConv;
//       end for;
//     end for;
//  end for;
  for i in 1:nMT loop
    xs[i] = noEvent(if vs[i] >= 0 then (if i == 1 then 0.5*dlengths[i] else sum(
       dlengths[1:i - 1]) + 0.5*dlengths[i]) else (if i == nMT then 0.5*
      dlengths[nMT] else sum(dlengths[i + 1:nMT]) + 0.5*dlengths[i]));
  end for;
  annotation (
    defaultComponentName="massTransfer",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -124,-100},{124,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/MassTransfer_alphas.jpg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialMassTransfer_setC;
