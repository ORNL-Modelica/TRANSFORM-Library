within TRANSFORM.Media.IdealGases.Common;
package SingleGasesData
  extends Modelica.Icons.Package;

  constant TRANSFORM.Media.IdealGases.Common.AdditionalDataRecord He(
    etalow={0.75015944,35.763243,-2212.1291,0.92126352},
    etahigh={0.83394166,220.82656,-52852.591,0.20809361},
    lambdalow={0.75007833,36.577987,-2363.6600,2.9766475},
    lambdahigh={0.83319259,221.57417,-53304.530,2.2684592});

  constant TRANSFORM.Media.IdealGases.Common.AdditionalDataRecord Xe(
    etalow={0.57988417,-188.06666,10508.723,2.6502107},
    etahigh={0.68506945,47.671749,-54767.718,1.7531546},
    lambdalow={0.57308328,-199.91432,12872.027,1.2718931},
    lambdahigh={0.68319650,40.020092,-52038.474,0.33623407});

  constant Modelica.Media.IdealGases.Common.DataRecord HeXe(
    name="HeXe",
    MM=0.040,
    Hf=0,
    H0=154935.8342,
    Tlimit=1000,
    alow={0,0,2.5,0,0,0,0},
    blow={-745.375,5.788701554},
    ahigh={3736.348237,-11.22704795,2.513137604,-7.65616E-06,2.34865E-09,-3.61299E-13,2.19104E-17},
    bhigh={-674.0914145,5.695188122},
    R=Modelica.Constants.R/HeXe.MM);

end SingleGasesData;
