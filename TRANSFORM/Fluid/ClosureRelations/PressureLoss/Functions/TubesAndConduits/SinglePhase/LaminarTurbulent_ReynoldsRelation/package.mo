within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase;
package LaminarTurbulent_ReynoldsRelation "Adapted from MSL WallFriction.Detailed"
  annotation (Documentation(info="<html>
<p>This component defines the complete regime of wall friction. The details are described in the <a href=\"modelica://Modelica.Fluid.UsersGuide.ComponentDefinition.WallFriction\">UsersGuide</a>. The functional relationship of the friction loss factor &lambda; is displayed in the next figure. Function dp_DP() defines the &QUOT;red curve&QUOT; (&QUOT;Swamee and Jain&QUOT;), where as function dp_MFLOW() defines the &QUOT;blue curve&QUOT; (&QUOT;Colebrook-White&QUOT;). The two functions are inverses from each other and give slightly different results in the transition region between Re = 1500 .. 4000, in order to get explicit equations without solving a non-linear equation. </p>
<p><img src=\"modelica://Modelica/Resources/Images/Fluid/Components/PipeFriction1.png\" alt=\"PipeFriction1.png\"/> </p>
<p>Additionally to wall friction, this component properly implements static head. With respect to the latter, two cases can be distinguished. In the case shown next, the change of elevation with the path from a to b has the opposite sign of the change of density. </p>
<p><img src=\"modelica://Modelica/Resources/Images/Fluid/Components/PipeFrictionStaticHead_case-a.png\" alt=\"PipeFrictionStaticHead_case-a.png\"/> </p>
<p>In the case illustrated second, the change of elevation with the path from a to b has the same sign of the change of density. </p>
<p><img src=\"modelica://Modelica/Resources/Images/Fluid/Components/PipeFrictionStaticHead_case-b.png\" alt=\"PipeFrictionStaticHead_case-b.png\"/> </p>
</html>"));
end LaminarTurbulent_ReynoldsRelation;
