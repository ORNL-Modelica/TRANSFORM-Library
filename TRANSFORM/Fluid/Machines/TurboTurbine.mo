within TRANSFORM.Fluid.Machines;
model TurboTurbine

  extends BaseClasses.PartialTurboPump;
extends TRANSFORM.Icons.UnderConstruction;
  SIadd.NonDim theta;
  SIadd.NonDim v;
  SIadd.NonDim n;
  SIadd.NonDim h;
  SIadd.NonDim beta;
  SIadd.NonDim n2v2;
  SIadd.NonDim a_tan;
  final parameter SI.Torque tau_nominal = Modelica.Constants.g_n*d_nominal*head_nominal*V_flow_nominal*eta_nominal/(omega_nominal) "Rated or design torque";
  final parameter SI.AngularVelocity omega_nominal = N_nominal*2*Modelica.Constants.pi/60;
  parameter SI.Efficiency eta_nominal = 0.8 "Rated or design efficiency";

  Modelica.Blocks.Tables.CombiTable1D h_table(                                                                           table=
        nonDimCurve.table_h, smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Tables.CombiTable1D beta_table(                                                                           table=
        nonDimCurve.table_beta, smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));

  replaceable model NonDimCurve =
      TRANSFORM.Fluid.Machines.BaseClasses.TurbineCharacteristics.NondimensionalCurves.Sine
                                                                                                     constrainedby
    TRANSFORM.Fluid.Machines.BaseClasses.TurbineCharacteristics.NondimensionalCurves.PartialNonDimCurve
                                                                                                                                                                                                            annotation(choicesAllMatching=true);

    NonDimCurve nonDimCurve;
equation

a_tan = TRANSFORM.Math.atan22(n,v);
theta = Modelica.Constants.pi + a_tan;
n2v2 = n^2+v^2;

v = V_flow/V_flow_nominal;
n = N/N_nominal;

h = head/head_nominal/n2v2;

theta = h_table.u[1];
h = h_table.y[1];

beta = tau/tau_nominal/n2v2;

theta = beta_table.u[1];
beta = beta_table.y[1];

    annotation (Placement(transformation(extent={{-98,82},{-82,98}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TurboTurbine;
