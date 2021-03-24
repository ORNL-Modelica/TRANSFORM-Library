within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.FissionProducts;
record fissionProducts_null
  extends PartialFissionProduct(
    extraPropertiesNames=fill("", 1),
    SIZZZAAA= fill(0, nC),
    C_nominal=fill(1e26, nC),
    molarMass=fill(0,nC),
    actinideIndex = {1},
    lambdas=fill(0, nC),
    sigmasA=fill(0, nC),
    w_c=fill(0,nC),
    sigmasF=fill(1, nA),
    w_f=fill(1,nA),
    nus={1.0},
    w_near_decay=fill(0, nC),
    w_far_decay=fill(0, nC),
    l_lambdas_col={0},
    l_lambdas_count=fill(0, nC),
    l_lambdas=fill(0,size(l_lambdas_col,1)),
    f_sigmasA_col={0},
    f_sigmasA_count=fill(0, nC),
    f_sigmasA=fill(0,size(f_sigmasA_col,1)),
    transitionMT=fill(0,size(f_sigmasA_col,1)));

end fissionProducts_null;
