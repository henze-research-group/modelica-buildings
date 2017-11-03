within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints;
block Valve "Multizone VAV AHU coil valve positions"

  parameter Real uHeaMax(min=-0.9)=-0.25
    "Upper limit of controller signal when heating coil is off. Require -1 < uHeaMax < uCooMin < 1.";
  parameter Real uCooMin(max=0.9)=0.25
    "Lower limit of controller signal when cooling coil is off. Require -1 < uHeaMax < uCooMin < 1.";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
      Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for supply air temperature signal";
  parameter Real kPTSup=0.05
    "Gain of controller for supply air temperature signal";
  parameter Modelica.SIunits.Time TiTSup=300
    "Time constant of integrator block for supply temperature control signal";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Setpoint for supply air temperature"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
    final min=0,
    final max=1,
    final unit="1")
    "Control signal for heating"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Control signal for cooling"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
      iconTransformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput uTSup(
    final max=1,
    final unit="1",
    final min=-1)
    "Supply temperature control signal"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
      iconTransformation(extent={{100,30},{120,50}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTSup(
    final controllerType=controllerType,
    final k=kPTSup,
    final Ti=TiTSup,
    final yMax=1,
    final yMin=-1,
    final y_reset=0,
    final reverseAction=true,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
    "Controller for supply air temperature control signal (to be used by heating coil, cooling coil and economizer)"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{10,50},{30,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uHeaMaxCon(
    final k=uHeaMax)
    "Constant signal to map control action"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant negOne(final k=-1)
    "Negative unity signal"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uCooMinCon(
    final k=uCooMin)
    "Constant signal to map control action"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Zero control signal"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1)
    "Unity signal"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Line conSigCoo(
    final limitBelow=true,
    final limitAbove=false)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Line conSigHea(
    final limitBelow=false,
    final limitAbove=true)
    "Heating control signal"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

equation
  connect(zer.y,swi. u3)
    annotation (Line(points={{-59,-80},{-20,-80},{-20,52},{8,52}},
      color={0,0,127}));
  connect(TSup,conTSup. u_m)
    annotation (Line(points={{-120,-20},{-50,-20},{-50,48}}, color={0,0,127}));
  connect(negOne.y,conSigHea. x1)
    annotation (Line(points={{-59,-40},{-40,-40},{-40,40},{30,40},{30,28},{58,28}},
      color={0,0,127}));
  connect(one.y,conSigHea. f1)
    annotation (Line(points={{21,-80},{50,-80},{50,24},{58,24}},
      color={0,0,127}));
  connect(swi.y,conSigHea. u)
    annotation (Line(points={{31,60},{46,60},{46,20},{58,20}},
      color={0,0,127}));
  connect(swi.y,conSigCoo. u)
    annotation (Line(points={{31,60},{46,60},{46,-20},{58,-20}},
      color={0,0,127}));
  connect(uHeaMaxCon.y,conSigHea. x2)
    annotation (Line(points={{21,20},{30,20},{30,16},{58,16}},
      color={0,0,127}));
  connect(zer.y,conSigHea. f2)
    annotation (Line(points={{-59,-80},{-20,-80},{-20,-16},{30,-16},{30,12},
      {58,12}}, color={0,0,127}));
  connect(uCooMinCon.y,conSigCoo. x1)
    annotation (Line(points={{21,-40},{40,-40},{40,-12},{58,-12}},
      color={0,0,127}));
  connect(zer.y,conSigCoo. f1)
    annotation (Line(points={{-59,-80},{-20,-80},{-20,-16},{58,-16}},
      color={0,0,127}));
  connect(one.y,conSigCoo. x2)
    annotation (Line(points={{21,-80},{50,-80},{50,-24},{58,-24}},
      color={0,0,127}));
  connect(one.y,conSigCoo. f2)
    annotation (Line(points={{21,-80},{50,-80},{50,-28},{58,-28}},
      color={0,0,127}));
  connect(conSigHea.y,yHea)
    annotation (Line(points={{81,20},{110,20}},  color={0,0,127}));
  connect(conSigCoo.y,yCoo)
    annotation (Line(points={{81,-20},{110,-20}}, color={0,0,127}));
  connect(swi.y,uTSup)
    annotation (Line(points={{31,60},{110,60}},  color={0,0,127}));
  connect(TSetSup, conTSup.u_s)
    annotation (Line(points={{-120,30},{-90,30},{-90,60},{-62,60}},
      color={0,0,127}));
  connect(uSupFan, swi.u2)
    annotation (Line(points={{-120,80},{0,80},{0,60},{8,60}},
      color={255,0,255}));
  connect(conTSup.y, swi.u1)
    annotation (Line(points={{-39,60},{-20,60},{-20,68},{8,68}},
      color={0,0,127}));
  connect(uSupFan, conTSup.trigger)
    annotation (Line(points={{-120,80},{-80,80},{-80,40},{-58,40},{-58,48}},
      color={255,0,255}));

annotation (
  defaultComponentName = "AHUValve",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,8},{-64,-6}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-94,-38},{-48,-62}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uSupFan"),
        Text(
          extent={{76,8},{96,-2}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yHea"),
        Text(
          extent={{74,46},{96,34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uTSup"),
        Text(
          extent={{76,-34},{96,-44}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCoo"),
        Text(
          extent={{-96,56},{-56,42}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSetSup"),
        Text(
          extent={{-124,146},{96,108}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
Block that outputs the coil valve postions for VAV system with multiple zones, 
implemented according to the ASHRAE Guideline G36, PART5.N.2 
(Supply air temperature control).
</p>
<h4>Valves control</h4>
<p>
Supply air temperature shall be controlled to setpoint using a control loop whose
output is mapped to sequence the hot water valve or modulating electric heating
coil (if applicable), chilled water valves.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Valve;
