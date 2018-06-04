within TRANSFORM.HeatAndMassTransfer.Volumes;
model UnitVolume_wTraceMass_withMedia
  extends Volumes.UnitVolume_withMedia;

  import Modelica.Fluid.Types.Dynamics;

  parameter Integer nC=1 "Number of substances";

  parameter Dynamics traceDynamics=Dynamics.DynamicFreeInitial
    "Formulation of trace substance balances"
    annotation (Dialog(tab="Initialization", group="Dynamics"));

  parameter SI.Concentration C_start[nC]=zeros(nC) "Concentration" annotation (Dialog(
        tab="Initialization", group="Start Value: Trace Substance"));

  input SI.MolarFlowRate nC_gen[nC]=zeros(nC) "Internal trace substance generation"
    annotation (Dialog(group="Inputs"));

  parameter Units.NonDim C_nominal[nC] = fill(1e-6,nC) "Nominal concentration [mol/m3] for improved numeric stability" annotation(Dialog(tab="Advanced"));

  Units.Mole nCs[nC] "Trace substance moles";
  Units.Mole[nC] nCs_scaled "Scaled trace substance moles for improved numerical stability";

  SI.Concentration C[nC](stateSelect=StateSelect.prefer, start=C_start)
    "Trace substance concentration";

  Interfaces.MolePort_State portM(nC=nC) "Trace flow across boundary"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}}),
        iconTransformation(extent={{30,-110},{50,-90}})));

initial equation
  if traceDynamics == Dynamics.SteadyStateInitial then
    der(nCs) = zeros(nC);
  elseif traceDynamics == Dynamics.FixedInitial then
    C = C_start;
  end if;

equation

  // Total Quantities
  nCs = V.*C;

  // Trace Balance
  if traceDynamics == Dynamics.SteadyState then
    zeros(nC) = portM.n_flow + nC_gen;
  else
    der(nCs_scaled)  = (portM.n_flow + nC_gen)./C_nominal;
    nCs = nCs_scaled.*C_nominal;
  end if;

  // Port Definitions
  portM.C = C;

  annotation (defaultComponentName="volume",
Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end UnitVolume_wTraceMass_withMedia;
