within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Models.Flow;
model TableBasedInterpolation_old
  extends PartialFlowChar;

   parameter Real flowChar[:,:]=fill(
       0.0,
       0,
       2);

   Modelica.Blocks.Tables.CombiTable1D FlowChar(table=flowChar, smoothness=
         Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
     annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation

  V_flow*N = FlowChar.y[1];
  FlowChar.u[1]*N^2 = head;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TableBasedInterpolation_old;
