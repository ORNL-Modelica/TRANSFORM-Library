within TRANSFORM.Examples.MoltenSaltReactor.Data.Tritium;
partial record PartialTritium

  extends TRANSFORM.Icons.Record;

  import Modelica.Constants.N_A;

  constant String[:] extraPropertiesNames= fill("", 0) "Names of transport tritium contributors";

  final constant Integer nC=size(extraPropertiesNames, 1) "# of tritium contributors (e.g., Li7/Li6)";
  constant Real C_nominal[nC] = fill(1e14,nC) "Default for the nominal values for the extra properties";

  // Data
  parameter SIadd.InverseTime[nC] lambdas "Half-life of tritium contributors";

  parameter SI.Area[nC] sigmaA = fill(0,nC) "Absorption cross-section for reactivity feedback";
  parameter SI.Area[nC] sigmaT = fill(0,nC) "Cross-section for tritium generation and reactivity feedback";

  constant Real[nC,nC] parents = fill(0,nC,nC) "Matrix of parent sources (sum(column) = 0 or 1) for each tritium contributor 'daughter'. Row is daughter, Column is parent.";

//   parameter SI.NumberDensityOfMolecules[nC] CN_start = fill(0,nC) "Number density of Li-7 atoms in flibe [atoms Li-7/m3]";
//
//   parameter SI.Mass MM = 1*N_A "# of atoms of per kg of fluid";
//   parameter SI.MoleFraction[nC] MM_frac = fill(1/nC,nC) "Mole fraction of substances";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialTritium;
