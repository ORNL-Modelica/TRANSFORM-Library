within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger;
model GenericHX

  import TRANSFORM.Math.fillArray_1D;

  parameter Integer nV(min=1) = 1 "Number of volume nodes";

  parameter Integer nSurfaces_shell=1 "Number of transfer (heat/mass) surfaces"
  annotation (Dialog(tab="Shell Side",enable=false));
  input SI.Length dimensions_shell[nV]= 4*crossAreas_shell ./ perimeters_shell
    "Characteristic dimension (e.g., hydraulic diameter)"
    annotation (Dialog(tab="Shell Side",group="Inputs"));
  input SI.Area crossAreas_shell[nV]=0.25*pi*dimensions_shell .* dimensions_shell
    "Cross sectional area of unit volumes"
    annotation (Dialog(tab="Shell Side",group="Inputs"));
  input SI.Length perimeters_shell[nV]=4*crossAreas_shell ./ dimensions_shell
    "Wetted perimeter of unit volumes"
    annotation (Dialog(tab="Shell Side",group="Inputs"));
  input SI.Length dlengths_shell[nV]=ones(nV) "Unit cell length"
    annotation (Dialog(tab="Shell Side",group="Inputs"));
  input SI.Height[nV] roughnesses_shell=fill(2.5e-5, nV)
    "Average heights of surface asperities"
    annotation (Dialog(tab="Shell Side",group="Inputs"));
  input SI.Area surfaceAreas_shell[nV,nSurfaces_shell]=[pi*dimensions_tube_outer.*dlengths_tube*nTubes]
    "Discretized area per transfer surface"
    annotation (Dialog(tab="Shell Side",group="Inputs"));

  // Elevation
  input SI.Angle[nV] angles_shell=fill(0,nV) "Vertical angle from the horizontal  (-pi/2 < x <= pi/2)"
    annotation (Dialog(tab="Shell Side",group="Inputs Elevation"));
  input SI.Length[nV] dheights_shell=dlengths_shell.*sin(angles_shell)  "Height(port_b) - Height(port_a)"
    annotation (Dialog(tab="Shell Side",group="Inputs Elevation"));
  input SI.Length height_a_shell=0
    "Elevation at port_a: Reference value only. No impact on calculations."
    annotation (Dialog(tab="Shell Side",group="Inputs Elevation"));
  output SI.Length height_b_shell=height_a_shell + sum(dheights_shell)
    "Elevation at port_b: Reference value only. No impact on calculations."
    annotation (Dialog(tab="Shell Side",group="Inputs Elevation", enable=false));

  // Tube Side
  parameter Real nTubes=1 "# of tubes per heat exchanger" annotation (Dialog(tab="Tube Side"));
  parameter Integer nR(min=1) = 1 "Number of radial nodes in wall (r-direction)" annotation(Dialog(tab="Tube Side"));
  parameter Integer nSurfaces_tube=1 "Number of transfer (heat/mass) surfaces"
  annotation (Dialog(tab="Tube Side",enable=false));
  input SI.Length dimensions_tube[nV]= 4*crossAreas_tube ./ perimeters_tube
    "Characteristic dimension (e.g., hydraulic diameter)"
    annotation (Dialog(tab="Tube Side",group="Inputs"));
  input SI.Area crossAreas_tube[nV]=0.25*pi*dimensions_tube .* dimensions_tube
    "Cross sectional area of unit volumes"
    annotation (Dialog(tab="Tube Side",group="Inputs"));
  input SI.Length perimeters_tube[nV]=4*crossAreas_tube ./ dimensions_tube
    "Wetted perimeter of unit volumes"
    annotation (Dialog(tab="Tube Side",group="Inputs"));
  input SI.Length dlengths_tube[nV]=ones(nV) "Unit cell length"
    annotation (Dialog(tab="Tube Side",group="Inputs"));
  input SI.Height[nV] roughnesses_tube=fill(2.5e-5, nV)
    "Average heights of surface asperities"
    annotation (Dialog(tab="Tube Side",group="Inputs"));
  input SI.Area surfaceAreas_tube[nV,nSurfaces_tube]=[perimeters_tube .* dlengths_tube]
    "Discretized area per transfer surface"
    annotation (Dialog(tab="Tube Side",group="Inputs"));

  // Elevation
  input SI.Angle[nV] angles_tube=fill(0,nV) "Vertical angle from the horizontal  (-pi/2 < x <= pi/2)"
    annotation (Dialog(tab="Tube Side",group="Inputs Elevation"));
  input SI.Length[nV] dheights_tube=dlengths_tube.*sin(angles_tube)  "Height(port_b) - Height(port_a)"
    annotation (Dialog(tab="Tube Side",group="Inputs Elevation"));
  input SI.Length height_a_tube=0
    "Elevation at port_a: Reference value only. No impact on calculations."
    annotation (Dialog(tab="Tube Side",group="Inputs Elevation"));
  output SI.Length height_b_tube=height_a_tube + sum(dheights_tube)
    "Elevation at port_b: Reference value only. No impact on calculations."
    annotation (Dialog(tab="Tube Side",group="Inputs Elevation", enable=false));

  // Tube Wall
  input SI.Length ths_wall[nV]=fill(0.001, nV)
    "Tube wall thickness"
    annotation (Dialog(tab="Tube Side",group="Inputs: Tube Wall"));
  input SI.Length drs[nR,nV](min=0) = fillArray_1D(ths_wall/nR, nR) "Tube unit volume lengths of r-dimension"
    annotation (Dialog(tab="Tube Side", group="Inputs: Tube Wall"));
  SI.Length dimensions_tube_outer[nV] = {dimensions_tube[i] + 2*sum(drs[:,i]) for i in 1:nV} "Tube outer diameter";
  SI.Length D_o_tube = sum(dimensions_tube_outer)/nV "Tube outer average diameter";

equation
  for i in 1:nV loop
    assert(dimensions_shell[i] > 0, "Characteristic dimension must be > 0");
    assert(dlengths_shell[i] >= abs(dheights_shell[i]), "Geometry dlengths_shell must be greater or equal to abs(dheights_shell)");
    assert(dimensions_shell[i] > 0, "Characteristic dimension must be > 0");
    assert(dlengths_shell[i] >= abs(dheights_shell[i]), "Geometry dlengths_shell must be greater or equal to abs(dheights_shell)");
    assert(dimensions_tube[i] > 0, "Characteristic dimension must be > 0");
    assert(dlengths_tube[i] >= abs(dheights_tube[i]), "Geometry dlengths_tube must be greater or equal to abs(dheights_tube)");
    assert(dimensions_tube[i] > 0, "Characteristic dimension must be > 0");
    assert(dlengths_tube[i] >= abs(dheights_tube[i]), "Geometry dlengths_tube must be greater or equal to abs(dheights_tube)");
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                                Bitmap(extent={{
              -100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/Geometry_genericVolume.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericHX;
