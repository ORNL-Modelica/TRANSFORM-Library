within TRANSFORM.Media.LookupTableMedia2;
model test

  constant String tablePath="modelica://TRANSFORM/Resources/data/lookupTables/" + "ParaHydrogen/pT/";

   constant Real table[:, :] = fill(0.0, 0, 2);
  constant String tableName="table2D_1"
    "Table name on file or in function usertab (see docu)";
  constant String fileName=Modelica.Utilities.Files.loadResource(tablePath + "test2.txt")
    "File where matrix is stored";
  constant Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation";
  constant Boolean verboseRead=true
    "= true, if info message that file is loading is to be printed";
   constant Real tableOnFileRead = TRANSFORM.Math.Interpolation.MSL.readTableData(tableID, false, verboseRead);

  constant Modelica.Blocks.Types.ExternalCombiTable2D tableID=
      Modelica.Blocks.Types.ExternalCombiTable2D(
        tableName,
        fileName,
        table,
        smoothness) "External table object";

  function specificEnthalpy_pT
    "Return thermodynamic state record from p and T"
    extends Modelica.Icons.Function;
    input SI.AbsolutePressure p "pressure";
    input SI.Temperature T "temperature";
    output SI.SpecificEnthalpy h;
  algorithm
      h:=TRANSFORM.Math.Interpolation.MSL.getTableValue(
        tableID,
        T,
        p,
        tableOnFileRead);
        annotation(Inline=true);
  end specificEnthalpy_pT;

end test;
