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
#import "FFTDemoBaseViewController.h"
#import <Charts/Charts.h>
#import "MINILOC-Bridging-Header.h"
#import "MINILOC-Swift.h"
#import "Singleton.h"

@interface FFTLineChartViewController : FFTDemoBaseViewController

SingletonH(FFTLineChartViewController)

- (void)autoScale;
- (void)autoAjustYScale;
- (void)fixYScale;
- (void)clearChart;
- (void)updateChartData:(int)count set1YData:(float *)data xCoefficient: (float) coefficient;

@end
