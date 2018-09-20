within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger;
model StraightPipeHX

  extends GenericHX(
    final dimensions_shell=fill(dimension_shell, nV),
    final crossAreas_shell=fill(crossArea_shell, nV),
    final perimeters_shell=fill(perimeter_shell, nV),
    final dlengths_shell=fill(length_shell/nV, nV),
    final roughnesses_shell=fill(roughness_shell, nV),
    final angles_shell=fill(angle_shell,nV),
    final dheights_shell=fill(dheight_shell/nV, nV),
    final surfaceAreas_shell=transpose({fill(surfaceArea_shell[i]/nV, nV) for i in
            1:nSurfaces_shell}),
    final dimensions_tube=fill(dimension_tube, nV),
    final crossAreas_tube=fill(crossArea_tube, nV),
    final perimeters_tube=fill(perimeter_tube, nV),
    final dlengths_tube=fill(length_tube/nV, nV),
    final roughnesses_tube=fill(roughness_tube, nV),
    final angles_tube=fill(angle_tube,nV),
    final dheights_tube=fill(dheight_tube/nV, nV),
    final surfaceAreas_tube=transpose({fill(surfaceArea_tube[i]/nV, nV) for i in
            1:nSurfaces_tube}),
    final ths_wall = fill(th_wall,nV),
    drs=fill(th_wall/nR,nR,nV));

  // Shell Side
  input SI.Length dimension_shell=4*crossArea_shell/perimeter_shell
    "Characteristic dimension (e.g., hydraulic diameter)"
    annotation (Dialog(tab="Shell Side", group="Inputs"));
  input SI.Area crossArea_shell=0.25*pi*dimension_shell*dimension_shell
    "Cross-sectional flow areas"
    annotation (Dialog(tab="Shell Side", group="Inputs"));
  input SI.Length perimeter_shell=4*crossArea_shell/dimension_shell
    "Wetted perimeters"
    annotation (Dialog(tab="Shell Side", group="Inputs"));
  input SI.Length length_shell=1.0 "Pipe length"
    annotation (Dialog(tab="Shell Side", group="Inputs"));
  input SI.Height roughness_shell=2.5e-5
    "Average heights of surface asperities"
    annotation (Dialog(tab="Shell Side", group="Inputs"));
  input SI.Area surfaceArea_shell[nSurfaces_shell]={if i == 1 then pi*D_o_tube*length_tube*nTubes else 0 for i in 1:nSurfaces_shell} "Outer surface area"
    annotation (Dialog(tab="Shell Side", group="Inputs"));

  // Static head
  input SI.Angle angle_shell=0.0 "Vertical angle from the horizontal  (-pi/2 < x <= pi/2)"
    annotation (Dialog(tab="Shell Side", group="Inputs Elevation"));
  input SI.Length dheight_shell= length_shell*sin(angle_shell)
    "Height(port_b) - Height(port_a) distributed by flow segment"
    annotation (Dialog(tab="Shell Side", group="Inputs Elevation"));

  // Tube Side
  input SI.Length dimension_tube=4*crossArea_tube/perimeter_tube
    "Characteristic dimension (e.g., hydraulic diameter)"
    annotation (Dialog(tab="Tube Side", group="Inputs"));
  input SI.Area crossArea_tube=0.25*pi*dimension_tube*dimension_tube
    "Cross-sectional flow areas"
    annotation (Dialog(tab="Tube Side", group="Inputs"));
  input SI.Length perimeter_tube=4*crossArea_tube/dimension_tube
    "Wetted perimeters"
    annotation (Dialog(tab="Tube Side", group="Inputs"));
  input SI.Length length_tube=1.0 "Pipe length"
    annotation (Dialog(tab="Tube Side", group="Inputs"));
  input SI.Height roughness_tube=2.5e-5 "Average heights of surface asperities"
    annotation (Dialog(tab="Tube Side", group="Inputs"));
  input SI.Area surfaceArea_tube[nSurfaces_tube]={if i ==1 then perimeter_tube*length_tube else 0 for i in 1:nSurfaces_tube} "Inner surface area"
    annotation (Dialog(tab="Tube Side", group="Inputs"));

  // Static head
  input SI.Angle angle_tube=0.0 "Vertical angle from the horizontal  (-pi/2 < x <= pi/2)"
    annotation (Dialog(tab="Tube Side", group="Inputs Elevation"));
  input SI.Length dheight_tube= length_tube*sin(angle_tube)
    "Height(port_b) - Height(port_a) distributed by flow segment"
    annotation (Dialog(tab="Tube Side", group="Inputs Elevation"));

  input SI.Length th_wall=0.001 "Tube wall thickness"
    annotation (Dialog(tab="Tube Side",group="Inputs: Tube Wall"));

  SI.Length dimension_tube_outer = sum(dimensions_tube_outer)/nV "Tube outer diameter";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StraightPipeHX;
