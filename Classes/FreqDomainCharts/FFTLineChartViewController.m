//
//  LineChartViewController.m
//
//  Created by Xiangyi Xu on 31/7/16.
//  https://github.com/danielgindi/Charts
//

#import "FFTLineChartViewController.h"
#import "MINILOC-Bridging-Header.h"
#import "MINILOC-Swift.h"
#import "UdpSocket.h"
#import <CoreLocation/CoreLocation.h>

@interface FFTLineChartViewController () <ChartViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet LineChartView *chartView;


@end

@implementation FFTLineChartViewController

/** Singleton Mode */
SingletonM(FFTLineChartViewController)


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.options = @[
                     @{@"key": @"toggleFilled", @"label": @"Toggle Filled"},
                     @{@"key": @"clearChart", @"label": @"Clear Chart"},
                     @{@"key": @"animateXY", @"label": @"Animate XY"},
                     @{@"key": @"animateX", @"label": @"Animate X"},
                     @{@"key": @"animateY", @"label": @"Animate Y"},
                     ];
    _chartView.legend.enabled = NO;
    _chartView.delegate = self;
    _chartView.chartDescription.enabled = NO;
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = YES;
    _chartView.drawGridBackgroundEnabled = NO;
    
    ChartXAxis *xAxisDown = _chartView.xAxis;
    xAxisDown.gridLineWidth = 0.8;
    xAxisDown.gridLineDashLengths = @[@1.f, @1.f];
    xAxisDown.labelPosition = XAxisLabelPositionBottomInside;
    xAxisDown.labelTextColor= UIColor.whiteColor;
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.gridLineWidth = 0.8;
    leftAxis.gridLineDashLengths = @[@1.f, @1.f];
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.labelTextColor = UIColor.whiteColor;
    

    _chartView.rightAxis.enabled = NO;

    _chartView.highlightPerTapEnabled = YES;
    
    //Init Chart Data
    float initData[500];
    for(int i=0; i<500;i++)
    {
        initData[i] = 0;
    }
    [self updateChartData:500 set1YData:initData xCoefficient:1];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateChartData:(int)count set1YData:(float *)data xCoefficient: (float) coefficient
{
    if (self.shouldHideData)
    {
        _chartView.data = nil;
        return;
    }
    
    [self set1DataCount:count yData:data xCoefficient:coefficient];
    
}

- (void)set1DataCount:(int)count yData:(float *)data xCoefficient: (float) coefficient
{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < count; i++)
    {
        float valX,valY;
        
        valX = i*coefficient;
        valY = data[i];
        
        [values addObject:[[ChartDataEntry alloc] initWithX:valX y:valY]];
    }
    
    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.values = values;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:values  label:@"FFT Spectrum"];
        [set1 setColor:UIColor.blueColor alpha:1];
        [set1 setCircleColor:UIColor.redColor];
        set1.lineWidth = 2.0;
        set1.circleRadius = 3.0;
        set1.drawCircleHoleEnabled = NO;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        
        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        
        set1.fillAlpha = 1.f;
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        set1.drawFilledEnabled = NO;
        
        set1.drawCirclesEnabled =NO;
        set1.drawValuesEnabled=NO;
        set1.drawCirclesEnabled =NO;
        
        [set1 setDrawHighlightIndicators:NO];
        
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        
        _chartView.data = data;
    }
    
}


- (void)optionTapped:(NSString *)key
{

    if ([key isEqualToString:@"toggleCoordinate"])
    {
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"toggleFilled"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawFilledEnabled = !set.isDrawFilledEnabled;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"toggleCircles"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawCirclesEnabled = !set.isDrawCirclesEnabled;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"toggleCubic"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawCubicEnabled = !set.isDrawCubicEnabled;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }

    if ([key isEqualToString:@"toggleStepped"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawSteppedEnabled = !set.isDrawSteppedEnabled;
        }

        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleHorizontalCubic"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.mode = set.mode == LineChartModeCubicBezier ? LineChartModeHorizontalBezier : LineChartModeCubicBezier;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }

    [super handleOption:key forChartView:_chartView];
}

#pragma mark - Actions

- (void)autoScale
{
    [_chartView fitScreen];
    [_chartView setNeedsDisplay];
}

- (void)autoAjustYScale
{
    [_chartView.leftAxis resetCustomAxisMax];
    [_chartView.leftAxis resetCustomAxisMin];
    [_chartView setNeedsDisplay];
}

- (void)fixYScale
{
    [_chartView.leftAxis setAxisMinValue:_chartView.leftAxis.axisMinimum ];
    [_chartView.leftAxis setAxisMaxValue:_chartView.leftAxis.axisMaximum ];
    [_chartView setNeedsDisplay];
}

- (void)clearChart
{
    [_chartView clearValues];
}


#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
//    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
//    NSLog(@"chartValueNothingSelected");
}

@end
