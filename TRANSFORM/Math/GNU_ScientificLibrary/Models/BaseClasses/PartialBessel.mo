within TRANSFORM.Math.GNU_ScientificLibrary.Models.BaseClasses;
partial model PartialBessel
  extends Modelica.Blocks.Interfaces.SO;

  parameter Integer n = 0 "Order of the Bessel function";
  input Real x=1 "Value of interest" annotation(Dialog(group="Inputs"));

end PartialBessel;
