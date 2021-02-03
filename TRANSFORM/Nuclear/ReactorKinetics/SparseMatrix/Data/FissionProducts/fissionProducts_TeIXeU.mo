within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.FissionProducts;
record fissionProducts_TeIXeU
  extends PartialFissionProduct(
    extraPropertiesNames={"te135","i135","xe135","u235"},
    actinideIndex = {4},
    C_nominal=fill(1e26, nC),
    lambdas={log(2)/19,log(2)/23760,log(2)/32760,0},
    l_lambdas_col={1,2},
    l_lambdas_count={0,1,1,0},
    l_lambdas={1.0*log(2)/19,1.0*log(2)/23760},
    sigmasA=1e-28*{0,0,2.6e6,698.9},
    f_sigmasA_col={4,4},
    f_sigmasA_count={1,0,1,0},
    f_sigmasA={0.061*698.9e-28,0.003*698.9e-28},
    w_near_decay=1.6022e-16*{6000,1300,910,0},
    w_far_decay=1.6022e-16*{603.5,1260.4,249.8,0});

end fissionProducts_TeIXeU;
