within TRANSFORM.Examples.MoltenSaltReactor.Data;
model data_traceSubstances
  extends TRANSFORM.Icons.Record;

  // All values
  constant String[:] extraPropertiesNames={"PreGroup_1","PreGroup_2","PreGroup_3","PreGroup_4","PreGroup_5","PreGroup_6"} "Names of the additional (extra) transported properties";

  final constant Integer nC=size(extraPropertiesNames, 1)
    "Number of extra (outside of standard mass-balance) transported properties";
  constant Real C_nominal[nC] = fill(1e14,6) "Default for the nominal values for the extra properties";

  // Indexing of trace substances by category


  // Neutron Kinetics
  parameter Integer nI = 6 "# of delayed-neutron precursors groups" annotation(Dialog(tab="Kinetics"));
  input TRANSFORM.Units.InverseTime[nI] lambda_i={0.0125,0.0318,0.109,0.317,1.35,8.64}
    "Decay constants for each precursor group"
    annotation (Dialog(tab="Kinetics",group="Input Variables: Neutron Kinetics"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end data_traceSubstances;
