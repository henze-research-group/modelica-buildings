within Buildings.Controls.OBC.ASHRAE.G36.Constants;
package DemandLimitLevel
  extends Modelica.Icons.Package;
  constant Integer cooDemLimLev0 = 0 "Cooling demand limit level 0";
  constant Integer cooDemLimLev1 = 1 "Cooling demand limit level 1";
  constant Integer cooDemLimLev2 = 2 "Cooling demand limit level 2";
  constant Integer cooDemLimLev3 = 3 "Cooling demand limit level 3";
  constant Integer heaDemLimLev0 = 0 "Heating demand limit level 0";
  constant Integer heaDemLimLev1 = 1 "Heating demand limit level 1";
  constant Integer heaDemLimLev2 = 2 "Heating demand limit level 2";
  constant Integer heaDemLimLev3 = 3 "Heating demand limit level 3";

  annotation (
  Documentation(info="<html>
<p>
This package provides constants for indicating different cooling or heating
demand limit level for zone setpoint adjustment, Part5.B.3.
</p>
</html>", revisions="<html>
<ul>
<li>
August 16, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DemandLimitLevel;
