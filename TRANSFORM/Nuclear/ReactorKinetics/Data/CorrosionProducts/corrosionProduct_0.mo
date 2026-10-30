within TRANSFORM.Nuclear.ReactorKinetics.Data.CorrosionProducts;
record corrosionProduct_0
  extends PartialCorrosionProduct(
  extraPropertiesNames=fill("", 0),
  C_nominal=fill(1e-6, nC));
  annotation (defaultComponentName="data",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info=""));
end corrosionProduct_0;
