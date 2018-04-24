within TRANSFORM.Nuclear.Data.Tritium;
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

  parameter SI.Energy[nC] w_decay = fill(0,nC) "Energy release (near field - beta) per fission product decay per type";
  parameter SI.Energy[nC] wG_decay = fill(0,nC) "Energy release (far field - gamma) per fission product decay per type";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialTritium;
