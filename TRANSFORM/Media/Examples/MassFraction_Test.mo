within TRANSFORM.Media.Examples;
model MassFraction_Test
  "Calls massFraction (added to Modelica.Media in MSL 4.1.0) on TRANSFORM media"
  extends TRANSFORM.Icons.Example;
  package Medium_table =
      TRANSFORM.Media.Fluids.Therminol_66.TableBasedTherminol66
    "Medium based on TRANSFORM.Media.Interfaces.Fluids.TableBased";
  package Medium_linear = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_pT
    "Medium based on TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid";
  Medium_table.ThermodynamicState state_table=Medium_table.setState_pT(1e5,
      275 + 273.15);
  Medium_linear.ThermodynamicState state_linear=Medium_linear.setState_pT(1e5,
      900 + 273.15);
  Medium_table.MassFraction Xi_table[Medium_table.nXi]=Medium_table.massFraction(
      state_table) "Independent mass fractions (none for a pure substance)";
  Medium_linear.MassFraction Xi_linear[Medium_linear.nXi]=Medium_linear.massFraction(
      state_linear) "Independent mass fractions (none for a pure substance)";
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(
    n=4,
    x={size(Xi_table, 1),size(Xi_linear, 1),sum(Xi_table),sum(Xi_linear)},
    x_reference={0,0,0,0})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1));
end MassFraction_Test;
