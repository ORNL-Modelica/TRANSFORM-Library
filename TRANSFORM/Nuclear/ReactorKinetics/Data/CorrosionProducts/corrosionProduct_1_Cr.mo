within TRANSFORM.Nuclear.ReactorKinetics.Data.CorrosionProducts;
record corrosionProduct_1_Cr

  extends PartialCorrosionProduct(
  extraPropertiesNames={"Chromium"},
  C_nominal=fill(1e-6, nC));

  annotation (defaultComponentName="data",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info=""));
end corrosionProduct_1_Cr;
