within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Reactivity.Isotopes.Distributed;
partial model PartialIsotopesExternal

  parameter Integer nV=1 "# of discrete volumes"
annotation (Dialog(tab="Internal Interface", group="Inputs"));

  replaceable record Data =
      TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.Isotopes_null
    constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.PartialIsotopes
    "Data" annotation (choicesAllMatching=true);
  Data data;

  constant Integer nC=data.nC "# of istotopes";

  parameter SI.Power Q_fission_start=1e6
    "Power determined from kinetics. Does not include decay heat"
    annotation (Dialog(tab="Internal Interface", group="Initialization"));
  input SI.Power Q_fission=Q_fission_start
    "Power determined from kinetics. Does not include decay heat"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SIadd.NonDim SF_Q_fission[nV]=fill(1/nV, nV)
    "Shape factor for Q_fission, sum() = 1"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SIadd.ExtraPropertyExtrinsic[nV,nC] mCs={{0 for j in 1:nC} for i in 1:nV}
    "# of isotope atoms per volume [atoms]"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));

  SIadd.NeutronFlux phi[nV] "Neutron flux";
  SIadd.ExtraPropertyFlowRate mC_gens[nV,nC]
    "Generation rate of isotopes [atoms/s]";
  SIadd.NonDim rhos[nV,nC] "Reactivity feedback (not including rhos_ext)";

  SI.Power Qs_near[nV] = zeros(nV)
    "Near field (e.g, beta) power released from isotope decay";
  SI.Power Qs_far[nV] = zeros(nV)
    "Far field (e.g., gamma) power released from isotope decay";

equation
  for i in 1:nV loop
    phi[i] = Q_fission*SF_Q_fission[i]/sum(data.w_f[k]*data.sigmasF[k]*mCs[i,
      data.actinideIndex[k]] for k in 1:data.nA);
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/BatemanEquations.jpg")}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialIsotopesExternal;
