within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.HeatExchangers;
package BellDelawareSTHX_ShellSide
annotation (Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">The Bell-Delaware shell and tube heat exchanger model is based on the method presented by Edward S. Gaddis and Volker Gnielinski in the VDI Heat Atlas 2nd Edition (2010). This method is based off of the extensive work performed at the University of Delaware. The Bell-Delaware method consists of breaking down the pressure drop (dP) model into various sections of the heat exchanger (see Figure 1) while the heat transfer correlation model is more of a lumped parameter type approach. The traditional Bell-Delaware method employs diagrams while the Gaddis Gnielinski version has translated the information to equations. The tube side of the shell and tube heat exchanger is independent of the Bell-Delaware method and thus can be exchanged with any appropriate pipe model, dP model, and/or heat transfer model.</span></p>
<p><img src=\"modelica://TRANSFORM//Resources/Images/NonPowerPoint/BellDelaware/BellDelaware_dPlayout.PNG\"/></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Figure 1: Pressure drop model breakdown into repeated sections</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">Notes: </span></b></p>
<ol>
<li><span style=\"font-family: MS Shell Dlg 2;\">The pipe models for nozzle_a/b do NOT account for long lengths where dP_friction may be important. For this reason a nozzle_pipe has been added to nozzle_a/b which enables long entrance regions to have frictional dP and static head contributions to be accounted.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Variables noted in the literature are the same as in this model. They have been kept identical as possible as to facililate reference to the source material to improve error catching, ability to reference the source material, and interpretation of the results.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Figures identifying each of the variables is given below. If additional information is needed, the source material provides two excellent examples.</span></li>
</ol>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">Application:</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This method was developed for use with single phase (shell side - oil/water), cylindrical, single baffle segmented, shell and tube heat exchangers. The range of reported validity (+/- 35&percnt;) for the pressure drop and heat transfer correlation models are as follows:</span></p>
<p><u><i><span style=\"font-family: MS Shell Dlg 2;\">Pressure Drop Model (pgs. 1092 - 1105):</span></i></u></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">1 &LT; Re &LT; 5*10^4</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">3 &LT;= Pr &LT;= 10^3</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">0.2 &LT;= S/D_i &LT;= 1.0</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">0.15 &LT;= H/D_i &LT;= 0.4</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">R_B &LT;= 0.5</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">1.2 &LT;= t/d_o &LT;= 2.0</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">D_i/d_o &GT; 10</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">f_L &GT;= 0.4</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">f_B &GT;= 0.4</span></p>
<p><u><i><span style=\"font-family: MS Shell Dlg 2;\">Heat Transfer Model (pgs. 731 - 741)</span></i></u></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">10 &LT; Re_psil &LT; 10^5</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">3 &LT; Pr &LT; 10^3</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">0.2 &LT;= S/D_i &LT;= 1</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">R_G &LT;= 0.8</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">R_L &LT;= 0.8</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">R_B &LT;= 0.5</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">1.2 &LT;= t/d_o &LT;= 2.2</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">f_w &GT;= 0.3</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"><img src=\"modelica://TRANSFORM//Resources/Images/NonPowerPoint/BellDelaware/BellDelaware_nMR.PNG\"/></span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Figure 2: Definition of S_1, S_2, d_o, and n_MR. </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Note: In these examples -&GT;</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">n_tubes = a) 69, b) 73, and c) 73. (n_bs assumed = 0). Total number tubes</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">n_MRE = a) 7, b) 9, and c) 13. Number of main resistances in end cross flow section.</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">n_W_tubes = a) 12, b) 7, and c) 12. (n_W_bs assumed = 0). Number of tubes in a window section.</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">n_RW = a) 2, b) 2, and c) 2. Number of tube rows in a window section.</span></b></p>
<p><br><img src=\"modelica://TRANSFORM//Resources/Images/NonPowerPoint/BellDelaware/BellDelaware_e.PNG\"/></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Figure 3: Definition of e and e_1 ( a, b, and L_E are internall calculated). </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">S_1, S_2, and d_o are identical to what is presented in Figure 2. </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Note: nes for these examples are a) 8, b) 8, c) 10.</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"><img src=\"modelica://TRANSFORM//Resources/Images/NonPowerPoint/BellDelaware/BellDelaware_S_E.PNG\"/></span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Figure 4: Definition of d_N, S_E, and S. Specific values are just examples. In this example n_B (number of baffles)= 8 and nPasses = 2. </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Note: S_E_a/d_N_a is tubesheet to baffle spacing/nozzle diameter on the port_a side. </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">S_E_b/d_N_b is tubesheet to baffle spacing/nozzle diameter on the port_b side. </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">height_ab_shell is evenly distributed between windows as a simple means of capturing static pressure. </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">In this example height_ab_shell = D_i while nozzle elevation changes can be assigned with height_ab_nozzle_a/b.</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"><img src=\"modelica://TRANSFORM//Resources/Images/NonPowerPoint/BellDelaware/BellDelaware_Ds.PNG\"/></span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Figure 5: Definition of H, D_i, D_l, and D_B. Specific values are just examples.</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">Note: D_BE is not shown as it is often equal to D_B for most heat exchanger layouts.</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">DB is the diameter of a circle, which touches the outermost tubes in the space between the upper and lower edges of adjacent baffles</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #0000ff;\">D_BE is the diameter of a circle, which touches the outermost tubes of all tubes in the shell of the heat exchanger</span></b></p>
</html>"));
end BellDelawareSTHX_ShellSide;
