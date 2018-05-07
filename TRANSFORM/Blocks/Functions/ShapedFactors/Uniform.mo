within TRANSFORM.Blocks.Functions.ShapedFactors;
function Uniform
  extends PartialShapeFactor;

protected
  Real SF[n] = fill(1/n,n);

algorithm

  y :=u*SF;

end Uniform;
