within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Examples;
model PointKinetics_Test_specifiedFuelMass
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.PointKinetics_L1_powerBased_sparseMatrix
    kinetics(
    Q_nominal=Q_total,
    specifyPower=true,
    redeclare record Data =
        TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.precursorGroups_6_TRACEdefault,
    toggle_Reactivity=true,
    redeclare model Reactivity =
        TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Reactivity.Isotopes.Lumped.Isotopes_sparseMatrix
        (redeclare record Data =
            TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.Isotopes_TeIXeU,
          mCs_start=mCs_start))
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));

  parameter Real mCs_start[kinetics.reactivity.data.nC]={if i == i_actinide[1]
       then mCs_start_actinide[1] else 0 for i in 1:kinetics.reactivity.data.nC};

  parameter SI.Power Q_total=25e6;
  parameter SI.Mass m_actinide=1e3;
  constant String actinide[:]={"u-235"};
  constant Integer i_actinide[:]={4};
  constant Integer nA=size(actinide, 1);
  parameter SI.MassFraction x_actinide[nA]={1.0};
  parameter SI.MolarMass MW[nA]={kinetics.reactivity.data.molarMass[i_actinide[i]]
      for i in 1:nA};
  final parameter Real mCs_start_actinide[nA]={m_actinide*x_actinide[i]/MW[i]*
      Modelica.Constants.N_A for i in 1:nA};

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    experiment(
      StopTime=31536000,
      __Dymola_NumberOfIntervals=365,
      __Dymola_Algorithm="Esdirk45a"),
    __Dymola_experimentSetupOutput);
end PointKinetics_Test_specifiedFuelMass;
