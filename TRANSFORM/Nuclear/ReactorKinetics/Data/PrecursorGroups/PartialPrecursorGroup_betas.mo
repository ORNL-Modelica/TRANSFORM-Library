within TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups;
partial record PartialPrecursorGroup_betas
  "Allows input of betas instead of alphas"

  parameter TRANSFORM.Units.NonDim[nC] betas "Precursor group delayed neutron fraction";
  extends PartialPrecursorGroup(final alphas = betas/Beta);

end PartialPrecursorGroup_betas;
