within TRANSFORM.UsersGuide;
model DiscretizedModels "Discretized Models"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<p>Discretized models are organized in a consistent numbering format. When selecting a particular geometry, pay particular attention to the dimensions being specified as this dicates the corresponding dimenions in all underlying variables.</p>
<p>For example.</p>
<ul>
<li>1D - Cylinder_1d: r = 1; therefore variables such as crossAreas_1[nR+1] corrseponds to the interface between variable in the first dimension path &quot;r&quot;.</li>
<li>2D - Cylinder_2D_theta_z: theta = 1 and z = 2; therefore variables such as crossAreas_1[nTheta+1,nZ] corrseponds to the interface between variable in the first dimension path &quot;theta&quot;.</li>
<li>3D - Cylinder_3D: r = 1, theta = 2, and z = 3; Note the 3d components do not contain a specified dimension association. Consistent order is then assumed:</li>
<li><ul>
<li>Planar - x,y,z</li>
<li>Cylinder - r, theta, z</li>
<li>Sphere - r, theta, phil</li>
</ul></li>
</ul>
<h4>Note on crossAreas and surfaceAreas</h4>
<ul>
<li>The crossAreas* variables represents the area between disretized nodes. It therefore exists only for the discretized dimensions.</li>
<li>The surfaceAreas* variables represent the outer areas of the body in non-discretized dimensions only. This permits interaction with the body in these additional areas which may be important for a particular problem.</li>
</ul>
<h4>Illustrations to help orient the user</h4>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/discretizedModels_1D.jpg\"/></p>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/discretizedModels_2D.jpg\"/></p>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/discretizedModels_3D.jpg\"/></p>
</html>"));
end DiscretizedModels;
