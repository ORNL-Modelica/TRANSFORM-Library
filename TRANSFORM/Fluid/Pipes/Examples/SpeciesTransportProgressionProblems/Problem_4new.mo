within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems;
model Problem_4new "I-135 Decay with Non-uniform concentration"
  extends TRANSFORM.Icons.Example;
  extends TRANSFORM.Icons.UnderConstruction;
  import Modelica.ComplexMath.atanh;
  import Modelica_LinearSystems2.Math.Complex;
  import TRANSFORM.Math.hypergeometric2F1;

  package Medium = Modelica.Media.Water.StandardWater (extraPropertiesNames=fill("a", nC), C_nominal=fill(1.0,
          nC));

  constant Integer nC=1;
  parameter Integer nV=10;
  parameter SI.Length length=1.0;
  parameter SI.Length dimension=0.01;
  parameter SI.Temperature T_start=20 + 273.15;
  parameter SI.Pressure p_start=1e5;

  parameter SI.Velocity v=0.025;
  final parameter SI.MassFlowRate m_flow=Medium.density_pT(p_start, T_start)*Modelica.Constants.pi*dimension^2/4
      *v;

  parameter TRANSFORM.Units.InverseTime lambda_i[nC]={0.0127};
  final parameter SI.Time time_half[nC]={log(2)/lambda_i[i] for i in 1:nC};
  final parameter SIadd.ExtraPropertyConcentration C_i_start[nV,nC]=zeros(nV, nC);
  parameter Real phi_0=1e10;
  parameter Real beta_i[nC]={0.0006};

  final parameter SIadd.ExtraProperty Cs_start[nV,nC]={{C_i_start[i, j]/Medium.density_pT(p_start, T_start)
      for j in 1:nC} for i in 1:nV};
  final parameter SI.Length x[nV]=linspace(
      0,
      length,
      nV);

  SIadd.ExtraPropertyConcentration C_i[nV,nC];
  SIadd.ExtraPropertyConcentration C_i_analytical[nV,nC];

  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens={{-lambda_i[j]*pipe.mCs[i, j]*pipe.nParallel + beta_i[j]*phi_0*sin(
       Modelica.Constants.pi*pipe.summary.xpos_norm[j]) for j in 1:nC} for i in 1:nV};

       Real cool[nV] = {if x[j] < v*time then 1 else 0 for j in 1:nV};
  Pipes.GenericPipe_MultiTransferSurface pipe(
    redeclare package Medium = Medium,
    Cs_start=Cs_start,
    p_a_start=p_start,
    T_a_start=T_start,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=dimension,
        length=length,
        nV=nV),
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens)) annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  BoundaryConditions.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    use_C_in=true,
    m_flow=m_flow,
    T=T_start,
    nPorts=1) annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));

  BoundaryConditions.Boundary_pT boundary1(
    redeclare package Medium = Medium,
    p=p_start,
    T=T_start,
    nPorts=1) annotation (Placement(transformation(extent={{60,-10},{40,10}})));

  Sensors.TraceSubstancesTwoPort_multi sensor_C(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{10,10},{30,-10}})));
equation

  // Create variable for volume based concentration
  for j in 1:nV loop
    for i in 1:nC loop
      C_i[j, i] = pipe.Cs[j, i]*pipe.mediums[j].d;
    end for;
  end for;

  // Analytical Solution
  for j in 1:nV loop

    for i in 1:nC loop
      C_i_analytical[j, i] = (beta_i[i]*(Modelica.Constants.pi*v*cos(Modelica.Constants.pi*time*v - Modelica.Constants.pi*x[j]) + sin(Modelica.Constants.pi*time*v - Modelica.Constants.pi*x[j])*lambda_i[i] +
      exp(time*lambda_i[i])*(-(Modelica.Constants.pi*v*cos(Modelica.Constants.pi*x[j])) + sin(Modelica.Constants.pi*x[j])*lambda_i[i]))*phi_0)/
    (exp(time*lambda_i[i])*(Modelica.Constants.pi^2*v^2 + lambda_i[i]^2));
    end for;

     // for i in 1:nC loop
        //C_i_analytical[j, i] = 1;
//             C_i_analytical[j, i] = (beta_i[i]*phi_0*(2*
//         (if sin(Modelica.Constants.pi*(-(time*v) + x[j])) >= 0 then ((exp(((-(time*v) + x[j])*lambda_i[i])/v)*v*(Modelica.Constants.pi*v*cos(Modelica.Constants.pi*(-(time*v) + x[j])) + sin(Modelica.Constants.pi*time*v - Modelica.Constants.pi*x[j])*
//                 lambda_i[i]))/(Modelica.Constants.pi^2*v^2 + lambda_i[i]^2)) else 0)*
//        (Modelica.Constants.pi^2*v^2 + lambda_i[i]^2) - exp(((-(time*v) + x[j])*lambda_i[i])/v)*v*(Modelica.Constants.pi*v*cos(Modelica.Constants.pi*(time*v - x[j])) +
//         sin(Modelica.Constants.pi*(time*v - x[j]))*lambda_i[i] + exp(time*lambda_i[i])*(-(Modelica.Constants.pi*v*cos(Modelica.Constants.pi*x[j])) + sin(Modelica.Constants.pi*x[j])*lambda_i[i]))))/(exp((x[j]*lambda_i[i])/v)*v*(Modelica.Constants.pi^2*v^2 + lambda_i[i]^2));
 // if sin(Modelica.Constants.pi*(-(time*v) + x[j])) < 0 then

//  if x[j] < v*time then
//  for i in 1:nC loop
//     C_i_analytical[j, i]=-((beta_i[i]*(Modelica.Constants.pi*v*cos(Modelica.Constants.pi*time*v - Modelica.Constants.pi*x[j]) + sin(Modelica.Constants.pi*time*v - Modelica.Constants.pi*x[j])*lambda_i[i] +
//           exp(time*lambda_i[i])*(Modelica.Constants.pi*v*cos(Modelica.Constants.pi*x[j]) - sin(Modelica.Constants.pi*x[j])*lambda_i[i]))*phi_0)/
//         (exp(time*lambda_i[i])*(Modelica.Constants.pi^2*v^2 + lambda_i[i]^2)));
//  end for;
//  else
//    for i in 1:nC loop
//     C_i_analytical[j, i]=(beta_i[i]*(Modelica.Constants.pi*v*cos(Modelica.Constants.pi*time*v - Modelica.Constants.pi*x[j]) + sin(Modelica.Constants.pi*time*v - Modelica.Constants.pi*x[j])*lambda_i[i] +
//        exp(time*lambda_i[i])*(-(Modelica.Constants.pi*v*cos(Modelica.Constants.pi*x[j])) + sin(Modelica.Constants.pi*x[j])*lambda_i[i]))*phi_0)/
//      (exp(time*lambda_i[i])*(Modelica.Constants.pi^2*v^2 + lambda_i[i]^2));
//    end for;
//   end if;
  end for;

// (exp((-3*I)*Pi*time*v - (x[j]*lambda_i[i])/v)*beta_i[i]*
//     ((2*I)*exp((3*I)*Pi*time*v + (2*I)*Pi*x[j] + (x[j]*((-2*I)*Pi*v + lambda_i[i]))/v)*Pi^2*v^2 -
//      (2*I)*exp(I*Pi*time*v + (2*I)*Pi*x[j] + ((-(time*v) + x[j])*((-2*I)*Pi*v + lambda_i[i]))/v)*Pi^2*v^2 -
//      (2*I)*exp((3*I)*Pi*time*v + I*Pi*x[j] + (x[j]*((-2*I)*Pi*v + lambda_i[i]))/v)*Pi^2*v^2*atanh(exp((-I)*Pi*x[j])) -
//      (2*I)*exp((3*I)*Pi*time*v + (3*I)*Pi*x[j] + (x[j]*((-2*I)*Pi*v + lambda_i[i]))/v)*Pi^2*v^2*atanh(exp((-I)*Pi*x[j])) +
//      (2*I)*exp((2*I)*Pi*time*v + I*Pi*x[j] + ((-(time*v) + x[j])*((-2*I)*Pi*v + lambda_i[i]))/v)*Pi^2*v^2*
//       atanh(exp(I*Pi*time*v - I*Pi*x[j])) + (2*I)*exp((3*I)*Pi*x[j] + ((-(time*v) + x[j])*((-2*I)*Pi*v + lambda_i[i]))/v)*Pi^2*v^2*
//       atanh(exp(I*Pi*time*v - I*Pi*x[j])) + (2*I)*exp((3*I)*Pi*time*v + (x[j]*((-2*I)*Pi*v + lambda_i[i]))/v)*Pi^2*v^2*
//       hypergeometric2F1(1, 1 + ((I/2)*lambda_i[i])/(Pi*v), 2 + ((I/2)*lambda_i[i])/(Pi*v), exp((-2*I)*Pi*x[j])) -
//      (2*I)*exp((3*I)*Pi*time*v + ((-(time*v) + x[j])*((-2*I)*Pi*v + lambda_i[i]))/v)*Pi^2*v^2*
//       hypergeometric2F1(1, 1 + ((I/2)*lambda_i[i])/(Pi*v), 2 + ((I/2)*lambda_i[i])/(Pi*v),
//        exp((2*I)*Pi*time*v - (2*I)*Pi*x[j])) - 3*exp((3*I)*Pi*time*v + (2*I)*Pi*x[j] + (x[j]*((-2*I)*Pi*v + lambda_i[i]))/v)*Pi*v*
//       lambda_i[i] + 3*exp(I*Pi*time*v + (2*I)*Pi*x[j] + ((-(time*v) + x[j])*((-2*I)*Pi*v + lambda_i[i]))/v)*Pi*v*
//       lambda_i[i] - exp((3*I)*Pi*time*v + I*Pi*x[j] + (x[j]*((-2*I)*Pi*v + lambda_i[i]))/v)*Pi*v*atanh(exp((-I)*Pi*x[j]))*
//       lambda_i[i] + 3*exp((3*I)*Pi*time*v + (3*I)*Pi*x[j] + (x[j]*((-2*I)*Pi*v + lambda_i[i]))/v)*Pi*v*
//       atanh(exp((-I)*Pi*x[j]))*lambda_i[i] +
//      exp((2*I)*Pi*time*v + I*Pi*x[j] + ((-(time*v) + x[j])*((-2*I)*Pi*v + lambda_i[i]))/v)*Pi*v*atanh(exp(I*Pi*time*v - I*Pi*x[j]))*
//       lambda_i[i] - 3*exp((3*I)*Pi*x[j] + ((-(time*v) + x[j])*((-2*I)*Pi*v + lambda_i[i]))/v)*Pi*v*
//       atanh(exp(I*Pi*time*v - I*Pi*x[j]))*lambda_i[i] -
//      I*exp((3*I)*Pi*time*v + (2*I)*Pi*x[j] + (x[j]*((-2*I)*Pi*v + lambda_i[i]))/v)*lambda_i[i]^2 +
//      I*exp(I*Pi*time*v + (2*I)*Pi*x[j] + ((-(time*v) + x[j])*((-2*I)*Pi*v + lambda_i[i]))/v)*lambda_i[i]^2 -
//      I*exp((3*I)*Pi*time*v + I*Pi*x[j] + (x[j]*((-2*I)*Pi*v + lambda_i[i]))/v)*atanh(exp((-I)*Pi*x[j]))*lambda_i[i]^2 +
//      I*exp((3*I)*Pi*time*v + (3*I)*Pi*x[j] + (x[j]*((-2*I)*Pi*v + lambda_i[i]))/v)*atanh(exp((-I)*Pi*x[j]))*
//       lambda_i[i]^2 + I*exp((2*I)*Pi*time*v + I*Pi*x[j] + ((-(time*v) + x[j])*((-2*I)*Pi*v + lambda_i[i]))/v)*
//       atanh(exp(I*Pi*time*v - I*Pi*x[j]))*lambda_i[i]^2 -
//      I*exp((3*I)*Pi*x[j] + ((-(time*v) + x[j])*((-2*I)*Pi*v + lambda_i[i]))/v)*atanh(exp(I*Pi*time*v - I*Pi*x[j]))*
//       lambda_i[i]^2)*Subscript[\[Psi], 0])/(Pi*(Pi*v - I*lambda_i[i])*(Pi*v + I*lambda_i[i])*
//     (2*Pi*v + I*lambda_i[i])) + (2*exp((-I)*Pi*x[j] - (x[j]*lambda_i[i])/v)*Subscript[\[Beta], i]*
//     (exp(I*Pi*x[j] + (x[j]*lambda_i[i])/v)*Pi^2*v^2*hypergeometric2F1(1, ((-I/2)*lambda_i[i])/(Pi*v),
//        1 - ((I/2)*lambda_i[i])/(Pi*v), exp((2*I)*Pi*x[j])) - exp(I*Pi*x[j] + ((-(time*v) + x[j])*lambda_i[i])/v)*Pi^2*v^2*
//       hypergeometric2F1(1, ((-I/2)*lambda_i[i])/(Pi*v), 1 - ((I/2)*lambda_i[i])/(Pi*v),
//        exp((-2*I)*Pi*time*v + (2*I)*Pi*x[j])) + I*exp((x[j]*lambda_i[i])/v)*Pi*v*atanh(exp(I*Pi*x[j]))*lambda_i[i] -
//      I*exp(I*Pi*time*v + ((-(time*v) + x[j])*lambda_i[i])/v)*Pi*v*atanh(exp((-I)*Pi*time*v + I*Pi*x[j]))*lambda_i[i] -
//      I*exp(I*Pi*x[j] + (x[j]*lambda_i[i])/v)*Pi*v*hypergeometric2F1(-1/2, 1, 3/2, exp((2*I)*Pi*x[j]))*lambda_i[i] +
//      I*exp(I*Pi*x[j] + ((-(time*v) + x[j])*lambda_i[i])/v)*Pi*v*hypergeometric2F1(-1/2, 1, 3/2,
//        exp((-2*I)*Pi*time*v + (2*I)*Pi*x[j]))*lambda_i[i] + exp(I*Pi*x[j] + (x[j]*lambda_i[i])/v)*
//       hypergeometric2F1(-1/2, 1, 3/2, exp((2*I)*Pi*x[j]))*lambda_i[i]^2 -
//      exp(I*Pi*x[j] + ((-(time*v) + x[j])*lambda_i[i])/v)*hypergeometric2F1(-1/2, 1, 3/2, exp((-2*I)*Pi*time*v + (2*I)*Pi*x[j]))*
//       lambda_i[i]^2)*phi_0)/(Pi*(Pi*v - I*lambda_i[i])*(Pi*v + I*lambda_i[i])*
//     lambda_i[i])


  connect(boundary.ports[1], pipe.port_a) annotation (Line(points={{-48,0},{-30,0}}, color={0,127,255}));
  connect(sensor_C.port_b, boundary1.ports[1]) annotation (Line(points={{30,0},{40,0}}, color={0,127,255}));
  connect(pipe.port_b, sensor_C.port_a) annotation (Line(points={{-10,0},{10,0}}, color={0,127,255}));
  connect(sensor_C.C, boundary.C_in)
    annotation (Line(points={{20,-3.6},{20,-20},{-80,-20},{-80,-8},{-68,-8}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=1000,
      __Dymola_NumberOfIntervals=4800,
      __Dymola_Algorithm="Dassl"));
end Problem_4new;
