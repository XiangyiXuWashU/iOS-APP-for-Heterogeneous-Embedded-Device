//
//  LineChartViewController.h
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 17/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

#import <UIKit/UIKit.h>
#import "DemoBaseViewController.h"
#import <Charts/Charts.h>
#import "MINILOC-Bridging-Header.h"
#import "MINILOC-Swift.h"
#import "Singleton.h"

@interface LineChartViewController : DemoBaseViewController

SingletonH(LineChartViewController)

- (void)autoScale;
- (void)autoAjustYScale;
- (void)fixYScale;
- (void)clearChart;
- (void)updateChartData:(int)count set1YData:(float *)data xCoefficient: (float) coefficient;
- (float)readInViewStart;
- (float)readInViewStop;
- (int)extractDataInView;

@end
