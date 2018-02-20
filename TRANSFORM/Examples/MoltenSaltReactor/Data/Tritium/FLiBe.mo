within TRANSFORM.Examples.MoltenSaltReactor.Data.Tritium;
record FLiBe

  extends TRANSFORM.Examples.MoltenSaltReactor.Data.Tritium.PartialTritium(
extraPropertiesNames={"Li-6","Li-7","Be-9","He-6"},
C_nominal=fill(1e14, nC),
lambdas={0,0,0,log(2)/0.8},
sigmaA = 1e-28*{148.032,0,3.63e-3,0},
sigmaT = 1e-28*{148.026,1e-3,0,0},
parents=[[0,0,0,1];
         [0,0,0,0];
         [0,0,0,0];
         [0,0,0,0]]);

    // extraPropertiesNames={"Li-6","Li-7","Be-9"},
    // C_nominal=fill(1e14, nC),
    // lambdas={0,0,0},
    // sigmaA = 1e-28*{148.032,0,3.63e-3},
    // sigmaT = 1e-28*{148.026,1e-3,0},
    // parents=[[0,0,1];
    //          [0,0,0];
    //          [0,0,0]]);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FLiBe;
