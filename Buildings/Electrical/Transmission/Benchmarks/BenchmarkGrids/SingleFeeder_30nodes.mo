within Buildings.Electrical.Transmission.Benchmarks.BenchmarkGrids;
record SingleFeeder_30nodes
  "Grid with single feder and 30 nodes for benchmark (29 nodes for the loads)"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    nNodes = 30,
    nLinks = nNodes-1,
    L = Utilities.LineFeederLengths(nLinks, 200, 16),
    FromTo = Utilities.LineFeederConnections(nLinks),
    cables = Utilities.LineFeederCables(
             nLinks,
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120(),
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl70()));

  annotation (Documentation(info="<html>
</html>"));
end SingleFeeder_30nodes;