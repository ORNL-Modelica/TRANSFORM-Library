within TRANSFORM.Utilities.Visualizers;
model IconColorMap_1D

  parameter Integer n = 1 "# of colored items (e.g., n = pipe.geometry.nV)";

  parameter Boolean showColors = false "Toggle dynamic color display"  annotation(Dialog(tab="Visualization",group="Color Coding"));
  input Real val[n] "Color map variable" annotation(Dialog(tab="Visualization",group="Color Coding",enable=showColors));
  input Real val_min "val <= val_min is mapped to colorMap[1,:]" annotation(Dialog(tab="Visualization",group="Color Coding",enable=showColors));
  input Real val_max "val >= val_max is mapped to colorMap[end,:]" annotation(Dialog(tab="Visualization",group="Color Coding",enable=showColors));
  parameter Integer n_colors=64 "Number of colors in the colorMap, multiples of 4 is best" annotation(Dialog(tab="Visualization",group="Color Coding",enable=showColors));
  replaceable function colorMap =
      Modelica.Mechanics.MultiBody.Visualizers.Colors.ColorMaps.jet
          constrainedby Modelica.Mechanics.MultiBody.Interfaces.partialColorMap
      "Function defining the color map"
            annotation(choicesAllMatching=true, Dialog(enable=showColors,tab="Visualization",group="Color Coding"));

  Real dynColor[n,3];

equation
   for i in 1:n loop
     dynColor[i,:] = Modelica.Mechanics.MultiBody.Visualizers.Colors.scalarToColor(val[1], val_min, val_max, colorMap(n_colors));
   end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IconColorMap_1D;
