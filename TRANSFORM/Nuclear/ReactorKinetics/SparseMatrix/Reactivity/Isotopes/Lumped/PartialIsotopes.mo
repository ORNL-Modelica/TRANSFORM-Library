within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Reactivity.Isotopes.Lumped;
partial model PartialIsotopes
import Modelica.Fluid.Types.Dynamics;

  replaceable record Data =
      TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.Isotopes_null
                                                          constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.PartialIsotopes
    "Data" annotation (choicesAllMatching=true);
  Data data;

  constant Integer nC=data.nC "# of istotopes";

   parameter SI.Power Q_fission_start=1e6
     "Power determined from kinetics. Does not include decay heat"
     annotation (Dialog(tab="Internal Interface",group="Initialization"));
   input SI.Power Q_fission=Q_fission_start
     "Power determined from kinetics. Does not include decay heat"
     annotation (Dialog(tab="Internal Interface",group="Inputs"));

   parameter SIadd.ExtraPropertyExtrinsic mCs_start[nC]=zeros(nC)
     "Number of isotope atoms per group"
     annotation (Dialog(tab="Initialization"));
   parameter Dynamics traceDynamics=Dynamics.DynamicFreeInitial
     "Formulation of trace substance balances"
     annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));

  parameter Integer nC_ext=0
    "# of externally tracked substances (e.g., boron as a trace substance)" annotation (Dialog(group="Inputs: External Substances"));
  input SIadd.ExtraPropertyExtrinsic mCs_ext[nC_ext]=fill(0, nC_ext)
    "# externally tracked atoms" annotation (Dialog(group="Inputs: External Substances"));
  input SI.Area sigmasA_ext[nC_ext]=fill(0, nC_ext)
    "Microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(group="Inputs: External Substances"));

  SIadd.NeutronFlux phi "Neutron flux";
  SIadd.ExtraPropertyFlowRate mC_gens[nC]
    "Generation rate of isotopes [atoms/s]";
  SIadd.ExtraPropertyExtrinsic mCs[nC](each stateSelect=StateSelect.prefer,
      start=mCs_start) "Number of isotope atoms";
  SIadd.NonDim rhos[nC] "Reactivity feedback (not including rhos_ext)";

  SIadd.ExtraPropertyFlowRate[nC_ext] mC_gens_ext
    "Generation rate of external substances [atoms/s]";
  SIadd.NonDim rhos_ext[nC_ext]
    "External subtances reactivity feedback";

protected
  SIadd.ExtraPropertyExtrinsic mCs_scaled[nC]
    "Scaled number of isotope atoms for improved numerical stability";

initial equation
  if traceDynamics == Dynamics.FixedInitial then
    mCs = mCs_start;
  elseif traceDynamics == Dynamics.SteadyStateInitial then
    der(mCs) = zeros(nC);
  end if;
equation

  phi = Q_fission/sum(data.w_f[k]*data.sigmasF[k]*mCs[data.actinideIndex[k]]  for k in 1:data.nA);

  // Mass Balance
  if traceDynamics == Dynamics.SteadyState then
    zeros(nC) = mC_gens[:];
  else
    der(mCs_scaled[:]) = mC_gens[:] ./ data.C_nominal;
    mCs[:] = mCs_scaled[:] .* data.C_nominal;
  end if;

  // Externaly tracked substances
  for j in 1:nC_ext loop
    mC_gens_ext[j] = -sigmasA_ext[j]*mCs_ext[j]*phi;
    rhos_ext[j] = -sigmasA_ext[j]*mCs_ext[j]/sum(data.nus[1]*data.sigmasF[k]*mCs[data.actinideIndex[k]] for k in 1:data.nA);
  end for;

  annotation (defaultComponentName="reactivity",Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/BatemanEquations.jpg")}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialIsotopes;
