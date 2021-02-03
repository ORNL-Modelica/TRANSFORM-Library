within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.FissionProducts;
partial record PartialFissionProduct
  extends TRANSFORM.Icons.Record;
  constant String[:] extraPropertiesNames= fill("", 0) "Names of transport fission products" annotation(Evaluate=true, HideArray=true);

  final constant Integer nC=size(extraPropertiesNames, 1) "# of fission products (e.g., I/Xe)" annotation(Evaluate=true, HideArray=true);
  constant Real C_nominal[nC] = fill(1e14,nC) "Default for the nominal values for the extra properties" annotation(Evaluate=true, HideArray=true);

  constant Integer actinideIndex[:] "Index of actinides" annotation(Evaluate=true, HideArray=true);
  parameter SIadd.InverseTime[nC] lambdas "Half-life of fission product" annotation(Evaluate=true, HideArray=true);
  constant Integer l_lambdas_col[:] annotation(Evaluate=true, HideArray=true);
  constant Integer l_lambdas_count[nC] annotation(Evaluate=true, HideArray=true);
  parameter Real l_lambdas[size(l_lambdas_col,1)] = fill(0,size(l_lambdas_col,1)) "need to correct uni - Matrix of parent sources (e.g., sum(column) = 0, 1, or 2)*lambdas for each fission product 'daughter'. Row is daughter, Column is parent." annotation(Evaluate=true, HideArray=true);

  parameter SI.Area sigmasA[nC]=fill(0, nC)
    "Microscopic absorption cross-section for reactivity feedback" annotation(Evaluate=true, HideArray=true);
  constant Integer f_sigmasA_col[:] annotation(Evaluate=true, HideArray=true);
  constant Integer f_sigmasA_count[nC] annotation(Evaluate=true, HideArray=true);
  parameter Real f_sigmasA[size(f_sigmasA_col,1)] = fill(0,size(f_sigmasA_col,1)) "need to correct units" annotation(Evaluate=true, HideArray=true);

  parameter SI.Energy w_near_decay[nC]=fill(0, nC)
    "Energy release (near field - beta) per fission product decay" annotation(Evaluate=true, HideArray=true);
  parameter SI.Energy w_far_decay[nC]=fill(0, nC)
    "Energy release (far field - gamma) per fission product decay" annotation(Evaluate=true, HideArray=true);

  annotation (defaultComponentName="data",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialFissionProduct;
