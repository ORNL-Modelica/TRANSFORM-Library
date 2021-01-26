within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.FissionProducts;
record fissionProducts_0
  extends PartialFissionProduct(
    extraPropertiesNames=fill("", 0),
    C_nominal=fill(1e26, nC),
    lambdas=fill(0, nC),
    l_lambdas_col={0},
    l_lambdas_count=fill(0, nC),
    l_lambdas={0},
    sigmasA=fill(0, nC),
    f_sigmasA_col={0},
    f_sigmasA_count=fill(0, nC),
    f_sigmasA={0},
    w_near_decay=fill(0, nC),
    w_far_decay=fill(0, nC));

end fissionProducts_0;
