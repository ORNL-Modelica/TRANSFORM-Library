within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Functions;
model Initial_FissionProducts_Test
  extends TRANSFORM.Icons.Function;
  extends TRANSFORM.Icons.UnderConstruction;

  // Fission products
  replaceable record Data =
      TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.FissionProducts.fissionProducts_null
                                                          constrainedby
    SparseMatrix.Data.FissionProducts.PartialFissionProduct
    "Fission Product Data" annotation (choicesAllMatching=true);
  Data data;

  parameter Integer nC=data.nC "# of fission products";

  parameter Units.NonDim nu_bar_start=2.4 "Neutrons per fission"
    annotation (Dialog(tab="Initialization", group="Fission Sources"));
  parameter SI.Energy w_f_start=200e6*1.6022e-19 "Energy released per fission"
    annotation (Dialog(tab="Initialization", group="Fission Sources"));
  parameter SI.MacroscopicCrossSection SigmaF_start=1
    "Macroscopic fission cross-section of fissile material"
    annotation (Dialog(tab="Initialization", group="Fission Sources"));
  parameter SI.Area sigmasA_start[nC]=data.sigmasA
    "Microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(tab="Initialization", group="Fission Products"));
  parameter Units.InverseTime lambdas_start[nC]=data.lambdas
    "Decay constants for each fission product"
    annotation (Dialog(tab="Initialization", group="Fission Products"));

  parameter SI.Power Q_fission_start=1e6
    "Power determined from kinetics. Does not include fission product decay heat"
    annotation (Dialog(tab="Initialization"));

    parameter SIadd.ExtraPropertyExtrinsic mCs_start[nC]=zeros(nC) "Number of fission product atoms per group"
      annotation (Dialog(tab="Initialization"));

   parameter SIadd.ExtraPropertyExtrinsic mCs_start2[nC]=
       Functions.Initial_FissionProducts(
       nC=nC,
       phi=Q_fission_start/(w_f_start*SigmaF_start)/0.1,
       lambdas=data.lambdas,
       l_lambdas_col=data.l_lambdas_col,
       l_lambdas_count=data.l_lambdas_count,
       l_lambdas=data.l_lambdas,
       sigmasA=data.sigmasA,
       f_sigmasA_col=data.f_sigmasA_col,
       f_sigmasA_count=data.f_sigmasA_count,
       f_sigmasA=data.f_sigmasA,
       mCs_guess=cat(1,fill(1e10,nC),{1.42e24}),
       i_noGen={4}) "Number of fission product atoms per group"
     annotation (Dialog(tab="Initialization"));

Real a[nC];
equation
  a = mCs_start2;

  annotation (defaultComponentName="fissionProducts", Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/BatemanEquations.jpg")}));
end Initial_FissionProducts_Test;
