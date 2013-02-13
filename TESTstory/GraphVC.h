//
//  GraphVC.h
//  TESTstory
//
//  Created by igor on 2/7/13.
//  Copyright (c) 2013 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphVC : UIViewController<TestInfoHolder>
{
    THistoChannels histograms;
}
@property (nonatomic) IBOutlet GraphView *graphView;
@end
