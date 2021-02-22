within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes;
partial record PartialIsotopes
  extends TRANSFORM.Icons.Record;
  constant String[:] extraPropertiesNames= fill("", 0) "Names of isotopes" annotation(Evaluate=true, HideArray=true);

  final constant Integer nC=size(extraPropertiesNames, 1) "# of isotopes (e.g., I/Xe)" annotation(Evaluate=true, HideArray=true);
  parameter Real[nC] SIZZZAAA= fill(0, nC) annotation(Evaluate=true, HideArray=true);

  constant Real C_nominal[nC] = fill(1e14,nC) "Default for the nominal values for the extra properties" annotation(Evaluate=true, HideArray=true);
  constant SI.MolarMass molarMass[nC] "Molar mass";

  constant Integer actinideIndex[:] "Index of actinides or fissile isotopes 42" annotation(Evaluate=true, HideArray=true);
  constant Integer nA = size(actinideIndex,1);

  parameter SIadd.InverseTime[nC] lambdas "Half-life of isotope" annotation(Evaluate=true, HideArray=true);
  parameter SI.Area sigmasA[nC]
    "Microscopic absorption cross-section" annotation(Evaluate=true, HideArray=true);
  parameter SI.Energy w_c[nC] "Energy released per cross-section capture" annotation(Evaluate=true, HideArray=true);

  parameter SI.Area sigmasF[nA]
    "Microscopic fission cross-section" annotation(Evaluate=true, HideArray=true);
  parameter SI.Energy w_f[nA] "Energy released per cross-section capture" annotation(Evaluate=true, HideArray=true);
  parameter TRANSFORM.Units.NonDim nus[1] "Neutrons per fission"; // todo: need to check this value with and length as length != nA right now

  parameter SI.Energy w_near_decay[nC]=fill(0, nC)
    "Energy release (near field - e.g., alpha/beta) per isotope decay" annotation(Evaluate=true, HideArray=true);
  parameter SI.Energy w_far_decay[nC]=fill(0, nC)
    "Energy release (far field - e.g., gamma) per isotope decay" annotation(Evaluate=true, HideArray=true);

  constant Integer l_lambdas_col[:] annotation(Evaluate=true, HideArray=true);
  constant Integer l_lambdas_count[nC] annotation(Evaluate=true, HideArray=true);
  parameter Real l_lambdas[size(l_lambdas_col,1)] "need to correct uni - Matrix of parent sources (e.g., sum(column) = 0, 1, or 2)*lambdas for each fission product 'daughter'. Row is daughter, Column is parent." annotation(Evaluate=true, HideArray=true);

  constant Integer f_sigmasA_col[:] annotation(Evaluate=true, HideArray=true);
  constant Integer f_sigmasA_count[nC] annotation(Evaluate=true, HideArray=true);
  parameter Real f_sigmasA[size(f_sigmasA_col,1)] annotation(Evaluate=true, HideArray=true);
  constant Integer transitionMT[size(f_sigmasA_col,1)] "https://t2.lanl.gov/nis/endf/mts.html" annotation(Evaluate=true, HideArray=true);

  annotation (defaultComponentName="data",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialIsotopes;
