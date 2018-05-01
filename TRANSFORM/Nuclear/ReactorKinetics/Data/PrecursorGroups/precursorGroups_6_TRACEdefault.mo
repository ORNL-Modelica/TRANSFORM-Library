within TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups;
record precursorGroups_6_TRACEdefault
  "Default delayed-neutron groups from TRACE Manual Table 9-1"

  extends PartialPrecursorGroup(
  extraPropertiesNames={"PreGroup_1","PreGroup_2","PreGroup_3","PreGroup_4","PreGroup_5","PreGroup_6"},
  C_nominal=fill(1e14, nC),
  lambdas={3.87,1.40,0.311,0.115,0.0317,0.0127},
  alphas={0.026048,0.128237,0.406905,0.188039,0.212700,0.038070},
  Beta=0.006488);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info=""));
end precursorGroups_6_TRACEdefault;
