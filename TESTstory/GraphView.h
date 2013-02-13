#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

typedef std::map<std::string,std::vector<int>> THistoChannels;

@interface GraphView : CPTGraphHostingView <CPTPlotDataSource, CPTPlotSpaceDelegate>
{    
    NSDictionary *data;
    NSDictionary *sets;
    
    THistoChannels *_channels;
}

@property (nonatomic) CPTXYGraph* graph;
- (void)createGraph:(THistoChannels*) channels;

@end