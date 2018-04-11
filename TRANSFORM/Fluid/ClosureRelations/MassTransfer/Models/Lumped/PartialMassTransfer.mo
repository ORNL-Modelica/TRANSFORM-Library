within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped;
partial model PartialMassTransfer

  extends TRANSFORM.Fluid.Interfaces.Records.Medium_fluidInternal;

  parameter Integer flagIdeal = 0 "Flag for models to handle ideal mass transfer" annotation (Dialog(tab="Internal Interface"));

  input Medium.ThermodynamicState state "Thermodynamic state"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));

   parameter SI.ReynoldsNumber Re_lam(max=Re_turb) = 2300
     "Laminar transition Reynolds number" annotation (Dialog(tab="Advanced"));
   parameter SI.ReynoldsNumber Re_turb(min=Re_lam) = 4000
     "Turbulent transition Reynolds number" annotation (Dialog(tab="Advanced"));

  SI.MassFlowRate m_flow "Mass flow rate";

protected
  final parameter SI.ReynoldsNumber Re_center=0.5*(Re_lam + Re_turb)
    "Re smoothing transition center";
  final parameter SI.ReynoldsNumber Re_width=Re_turb - Re_center
    "Re smoothing transition width";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                                Bitmap(extent={{
              -124,-100},{124,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/MassTransfer_alphas.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialMassTransfer;
