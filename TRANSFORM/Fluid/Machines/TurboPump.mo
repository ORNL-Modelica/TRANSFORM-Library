within TRANSFORM.Fluid.Machines;
model TurboPump

  extends BaseClasses.PartialTurboPump;
extends TRANSFORM.Icons.UnderConstruction;
  SI.Angle theta;
  SIadd.NonDim v;
  SIadd.NonDim alpha;
  SIadd.NonDim h;
  SIadd.NonDim beta;
  SIadd.NonDim alpha2v2;
  SIadd.NonDim gamma;
  SI.Angle a_tan;
  SI.AngularFrequency deratan = der(a_tan);
  final parameter SI.Torque tau_nominal = Modelica.Constants.g_n*d_nominal*head_nominal*V_flow_nominal/(eta_nominal*omega_nominal) "Rated or design torque";
  parameter SI.Efficiency eta_nominal = 0.8 "Rated or design efficiency";
  SI.Efficiency eta_actual;
  SI.Efficiency eta_curve;
  Integer region;

  Modelica.Blocks.Tables.CombiTable1D h_table(                                                                           table=
        nonDimCurve.table_h,
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Tables.CombiTable1D beta_table(                                                                           table=
        nonDimCurve.table_beta, smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));

  replaceable model
    NonDimCurve =
      TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.NondimensionalCurves.Radial
                                                                                                     constrainedby
    TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.NondimensionalCurves.PartialNonDimCurve
                                                                                                                                                                                                            annotation(choicesAllMatching=true);

    NonDimCurve nonDimCurve;

equation

a_tan = Modelica.Math.atan2(v,alpha);

theta = Modelica.Constants.pi + a_tan;
alpha2v2 = alpha^2+v^2;

v = V_flow_a/V_flow_nominal;
alpha = omega/omega_nominal;

h = head/head_nominal;

theta = h_table.u[1];
h/alpha2v2 = h_table.y[1]/nonDimCurve.hCCF;

beta = tau/tau_nominal;

theta = beta_table.u[1];
beta/alpha2v2 = beta_table.y[1]/nonDimCurve.tCCF;

gamma = d_a/d_nominal;

eta_actual*tau*omega = V_flow_a*dp;
eta_curve*alpha*beta = v*h*gamma*eta_nominal;

region = integer(a_tan*4/Modelica.Constants.pi)+1;

    annotation (Placement(transformation(extent={{-98,82},{-82,98}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TurboPump;
