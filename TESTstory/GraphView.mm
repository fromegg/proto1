#import "GraphVC.h"

@implementation GraphView


- (void)generateLayout
{
    
    int x_axis_width = (*_channels)["red"].size();
    
	_graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	[_graph applyTheme:[CPTTheme themeNamed:kCPTStocksTheme]];
	self.hostedGraph                    = _graph;
    _graph.plotAreaFrame.masksToBorder   = NO;
    
    _graph.paddingLeft                   = 0.0f;
    _graph.paddingTop                    = 0.0f;
	_graph.paddingRight                  = 0.0f;
	_graph.paddingBottom                 = 0.0f;
    
    CPTMutableLineStyle *borderLineStyle    = [CPTMutableLineStyle lineStyle];
	borderLineStyle.lineColor               = [CPTColor whiteColor];
	borderLineStyle.lineWidth               = .7f;
	_graph.plotAreaFrame.borderLineStyle     = borderLineStyle;
	_graph.plotAreaFrame.paddingTop          = 80.0;
	_graph.plotAreaFrame.paddingRight        = 30.0;
	_graph.plotAreaFrame.paddingBottom       = 50.0;
	_graph.plotAreaFrame.paddingLeft         = 50.0;
    
	//Add plot space
	CPTXYPlotSpace *plotSpace       = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.delegate              = self;
	plotSpace.yRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0)
                                                                   length:CPTDecimalFromInt(255)];
	plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0)
                                                                   length:CPTDecimalFromInt(x_axis_width)];
    
    //Grid line styles
	CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
	majorGridLineStyle.lineWidth            = 0.75;
	majorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
	minorGridLineStyle.lineWidth            = 0.25;
	minorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    
    //Axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    
    //X axis
    CPTXYAxis *x    = axisSet.xAxis;
    {
        x.title                 = @"";
        x.titleOffset           = 25.0f;
        x.orthogonalCoordinateDecimal   = CPTDecimalFromInt(0);
        x.majorIntervalLength           = CPTDecimalFromInt(1);
        x.minorTicksPerInterval         = 0;
        x.labelingPolicy                = CPTAxisLabelingPolicyNone;
        x.majorGridLineStyle            = majorGridLineStyle;
        x.axisConstraints               = [CPTConstraints constraintWithLowerOffset:0.0];
        
        
//        NSArray *customTickLocations = [NSArray arrayWithObjects:
//                                        [NSDecimalNumber numberWithInt:0],
//                                        [NSDecimalNumber numberWithInt:127],
//                                        [NSDecimalNumber numberWithInt:255],
//                                        nil];
//        
//        NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[customTickLocations count]];
//        for ( NSNumber *tickLocation in customTickLocations )
//        {
//            CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[tickLocation stringValue] textStyle:x.labelTextStyle];
//            newLabel.tickLocation = [tickLocation decimalValue];
//            newLabel.offset       = x.labelOffset + x.majorTickLength;
//            [customLabels addObject:newLabel];
//        }
        
//        x.axisLabels = [NSSet setWithArray:customLabels];
    }
    //Y axis
    
    
    
	CPTXYAxis *y            = axisSet.yAxis;
    {
        y.title                 = @"Pixel Intensity";
        y.titleOffset           = 15.0f;
        y.labelingPolicy        = CPTAxisLabelingPolicyNone;
        y.majorGridLineStyle    = majorGridLineStyle;
        y.minorGridLineStyle    = minorGridLineStyle;
        y.axisConstraints       = [CPTConstraints constraintWithLowerOffset:0.0];
//        y.preferredNumberOfMajorTicks = 5;
        
#pragma message("why cant work with mutableCopy")
//        CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
//        textStyle.color = [CPTColor whiteColor];
//        textStyle.fontSize = 12;
//        
//        y.labelTextStyle = textStyle;
        
        
//        NSNumberFormatter *newFormatter = [[NSNumberFormatter alloc] init];
//        newFormatter.minimumIntegerDigits = 1;
//        newFormatter.positiveSuffix = @"%";
//        y.labelFormatter = newFormatter;
        
    }
    
    
    //Create a bar line style
    CPTMutableLineStyle *barLineStyle   = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineWidth              = 1.0;
    barLineStyle.lineColor              = [CPTColor whiteColor];
    CPTMutableTextStyle *whiteTextStyle = [CPTMutableTextStyle textStyle];
	whiteTextStyle.color                = [CPTColor whiteColor];
    
    
    // My Plot
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] initWithFrame:_graph.bounds];
    dataSourceLinePlot.identifier = @"Positive"; // hack for legend
    dataSourceLinePlot.dataSource = self;
    
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 2.f;
    lineStyle.lineColor              = [CPTColor greenColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    [_graph addPlot:dataSourceLinePlot];
    
//    CPTScatterPlot *BluePot = [[CPTScatterPlot alloc] init];
//    BluePot.identifier = @"Blue Channel";
//    BluePot.dataSource = self;
//    
//    CPTMutableLineStyle *blueLine = [lineStyle mutableCopy];
//    blueLine.lineColor = [CPTColor blueColor];
//    BluePot.dataLineStyle = blueLine;
//    [_graph addPlot:BluePot];
//    
//    CPTScatterPlot *GreenPlot = [[CPTScatterPlot alloc] init];
//    GreenPlot.identifier = @"Green Channel";
//    GreenPlot.dataSource = self;
//    
//    CPTMutableLineStyle *greenLIne = [lineStyle mutableCopy];
//    greenLIne.lineColor = [CPTColor greenColor];
//    GreenPlot.dataLineStyle = greenLIne;
//    [_graph addPlot:GreenPlot];
    
    
    //Add legend
	CPTLegend *theLegend      = [CPTLegend legendWithGraph:_graph];
	theLegend.numberOfRows	  = sets.count;
	theLegend.fill			  = [CPTFill fillWithColor:[CPTColor colorWithGenericGray:0.15]];
	theLegend.borderLineStyle = barLineStyle;
	theLegend.cornerRadius	  = 10.0;
	theLegend.swatchSize	  = CGSizeMake(15.0, 15.0);
	whiteTextStyle.fontSize	  = 20.0;
	theLegend.textStyle		  = whiteTextStyle;
	theLegend.rowMargin		  = 5.0;
	theLegend.paddingLeft	  = 10.0;
	theLegend.paddingTop	  = 10.0;
	theLegend.paddingRight	  = 10.0;
	theLegend.paddingBottom	  = 10.0;
	_graph.legend              = theLegend;
    _graph.legendAnchor        = CPTRectAnchorTopLeft;
    _graph.legendDisplacement  = CGPointMake(115.0, -10.0);
}

- (void)createGraph:(THistoChannels*) channels;
{
    _channels = channels;
    
    //Generate layout
    [self generateLayout];
}

#pragma mark - CPTPlotDataSource methods

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 255;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{    
    NSNumber *num = [[NSNumber alloc] init];
    if ( fieldEnum == CPTScatterPlotFieldX )
    {
        num = [NSNumber numberWithInt:index + 1];
    }
    else
    {
        std::string channelName("red");
        if([plot.identifier isEqual: @"Blue Channel"])
        {
            channelName = "blue";
            std::cout << index << ")" << (*_channels)[channelName][index] << std::endl;
        }
        else if([plot.identifier isEqual: @"Green Channel"])
        {
            channelName = "green";
        }
            
        num = [NSNumber numberWithFloat:(*_channels)[channelName][index]];
    }
    return num;
}


@end
