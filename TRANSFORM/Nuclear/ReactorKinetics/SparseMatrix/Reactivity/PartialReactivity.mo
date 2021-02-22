within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Reactivity;
partial model PartialReactivity

  replaceable record Data =
      TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.Isotopes_null
                                                          constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.PartialIsotopes
    "Data" annotation (choicesAllMatching=true);
  Data data;

  constant Integer nC=data.nC "# of istotopes";

//   parameter SI.Power Q_fission_start=1e6
//     "Power determined from kinetics. Does not include decay heat"
//     annotation (Dialog(tab="Initialization"));
//   input SI.Power Q_fission=Q_fission_start
//     "Power determined from kinetics. Does not include decay heat"
//     annotation (Dialog(group="Inputs"));
//
//   parameter SIadd.ExtraPropertyExtrinsic mCs_start[nC]=zeros(nC)
//     "Number of isotope atoms per group"
//     annotation (Dialog(tab="Initialization"));
//
//   parameter Dynamics traceDynamics=Dynamics.DynamicFreeInitial
//     "Formulation of trace substance balances"
//     annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));

  parameter Integer nC_add=0
    "# of additional substances (i.e., trace fluid substances)" annotation (Dialog(tab="Additional Reactivity"));
  input SIadd.ExtraPropertyExtrinsic mCs_add[nC_add]=fill(0, nC_add)
    "Number of atoms" annotation (Dialog(tab="Additional Reactivity",group="Inputs"));
  input SI.Area sigmasA_add[nC_add]=fill(0, nC_add)
    "Microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(tab="Additional Reactivity",group="Inputs"));

  output SIadd.NonDim rhos[nC] "Reactivity feedback (not including rhos_add)"
    annotation (Dialog(tab="Outputs", enable=false));
  output SIadd.ExtraPropertyFlowRate[nC_add] mC_gens_add
    "Generation rate of additional substances [atoms/s] (e.g., Boron in fluid)"
    annotation (Dialog(
      group="Additional Reactivity",
      tab="Outputs",
      enable=false));
  output SIadd.NonDim rhos_add[nC_add]
    "Additional subtances reactivity feedback" annotation (Dialog(
      group="Additional Reactivity",
      tab="Outputs",
      enable=false));


  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialReactivity;
