//
//  UIViewController+MainView.m
//  MINILOC
//
//  Created by Xiangyi Xu on 9/4/17.
//  Copyright © 2017 Xiangyi Xu. All rights reserved.
//

#import "MainView.h"
#import "SystemInfoBar.h"
#import "ToneGenerator.h"
#import "LineChartViewController.h"
#import "UdpSocket.h"
#import "SettingView.h"
#import "AudioParameters.h"
#import "SystemInfoBar.h"
#import "AudioParameters.h"
#import <AudioToolbox/AudioToolbox.h>

@interface MainView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button1X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button2X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button3X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button4X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button5X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button6X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button7X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button8X;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button9X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button10X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button11X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button12X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button13X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button14X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button15X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button16X;


@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *fixYButton;
@property (weak, nonatomic) IBOutlet UIButton *runStopButton;
@property (weak, nonatomic) IBOutlet UIButton *dspButton;


/** Timer */
@property (nonatomic, strong) NSTimer *timer;



@end


@implementation MainView


ToneGenerator *_generator;


/** Is UDP Connected */
extern bool isUDPConnected;

extern WIFIDATA receivedWifiData;

/** Sample Rate Number */
int rateNumber = 13;

/** Popup View Status */
bool measurePopupViewFlag = false;

/** Algorism Number */
extern  int algorismNumber;

/** rawData */
extern  int isRawdata;

/** Audio Volume Amplitue */
extern  int audioAmplitude;

/** Define Audio Parmeters */
extern AUDIOPARAMETER audioParameter;

/** ADC Sample Rate */
float adcSampleRate = 50e6;

/** Audio Total Duration Time(S) */
extern float audioTotalDurationTime;

/** Audio Frequency Multiply Number */
int audioFreqMultiply = 1;

/** Simulate Data */
float simulateData[1000] =
{
    0.998,1.001,1.001,0.998,0.996,1.001,0.998,0.999,1.003,1.003,0.999,0.996,0.997,0.999,0.997,0.997,0.998,0.999,0.999,0.996,
    1.004,0.999,1.001,0.998,0.997,1.004,0.997,1.001,0.997,1.002,0.998,0.998,0.996,0.999,0.997,0.999,0.999,0.998,0.998,0.999,
    1.001,0.995,0.998,0.998,0.997,0.998,1.002,1.001,0.999,0.999,1.003,0.997,0.996,0.997,0.996,1.001,0.997,0.999,1.001,0.998,
    0.999,0.996,0.998,0.995,0.996,1.001,0.998,0.998,0.997,0.996,0.998,0.997,0.993,0.998,0.996,0.999,0.997,1.001,0.999,0.998,
    0.997,0.998,0.997,0.995,0.996,0.999,1.001,1.001,0.999,0.998,0.998,0.995,0.997,0.998,0.998,1.001,0.997,0.995,0.994,0.998,
    0.997,1.001,0.998,0.998,1.001,0.998,0.999,0.997,0.998,0.998,1.001,0.997,0.999,0.997,0.995,1.002,0.998,0.997,0.995,1.002,
    0.998,0.996,0.998,0.998,1.003,0.998,0.998,0.997,0.998,0.996,0.997,0.997,0.995,0.999,0.997,1.002,0.999,1.001,0.999,0.998,
    0.999,0.998,1.001,0.996,0.997,0.998,0.997,0.994,0.997,0.996,0.998,0.997,0.995,0.999,0.999,0.995,1.002,0.997,0.997,0.999,
    1.001,0.997,0.995,0.998,0.997,0.997,0.996,0.997,0.996,0.998,0.997,0.998,0.997,0.996,0.998,0.997,0.997,0.999,0.999,0.998,
    0.998,0.999,0.998,0.997,0.996,0.995,0.998,0.995,0.992,0.989,0.972,0.956,0.945,0.945,0.935,0.937,0.932,0.930,0.927,0.916,
    0.914,0.912,0.914,0.911,0.914,0.916,0.912,0.909,0.907,0.905,0.902,0.900,0.903,0.904,0.898,0.896,0.902,0.900,0.903,0.894,
    0.898,0.890,0.904,0.898,0.901,0.906,0.901,0.896,0.887,0.877,0.872,0.881,0.864,0.882,0.873,0.869,0.879,0.875,0.866,0.875,
    0.892,0.891,0.871,0.854,0.855,0.852,0.864,0.860,0.870,0.873,0.866,0.857,0.877,0.894,0.873,0.845,0.849,0.837,0.843,0.847,
    0.854,0.860,0.858,0.842,0.855,0.883,0.862,0.833,0.834,0.819,0.825,0.834,0.840,0.843,0.833,0.830,0.898,0.844,0.791,0.809,
    0.793,0.827,0.822,0.854,0.823,0.819,0.895,0.805,0.785,0.819,0.772,0.831,0.789,0.843,0.793,0.819,0.898,0.820,0.786,0.820,
    0.778,0.817,0.804,0.845,0.821,0.812,0.899,0.811,0.774,0.802,0.776,0.810,0.807,0.841,0.804,0.818,0.891,0.785,0.785,0.811,
    0.784,0.826,0.811,0.841,0.786,0.828,0.865,0.768,0.799,0.793,0.786,0.819,0.795,0.845,0.786,0.820,0.875,0.772,0.793,0.812,
    0.796,0.821,0.806,0.846,0.791,0.811,0.892,0.799,0.786,0.809,0.775,0.808,0.788,0.832,0.786,0.812,0.878,0.784,0.778,0.806,
    0.765,0.805,0.785,0.827,0.779,0.801,0.877,0.789,0.775,0.799,0.770,0.789,0.786,0.818,0.797,0.791,0.872,0.791,0.745,0.780,
    0.744,0.771,0.771,0.807,0.792,0.771,0.830,0.805,0.727,0.775,0.765,0.767,0.782,0.778,0.802,0.755,0.786,0.858,0.768,0.736,
    0.766,0.747,0.751,0.750,0.780,0.788,0.749,0.800,0.811,0.746,0.731,0.759,0.729,0.741,0.754,0.788,0.779,0.818,0.762,0.735,
    0.757,0.763,0.744,0.752,0.770,0.808,0.756,0.714,0.744,0.754,0.737,0.731,0.750,0.782,0.788,0.726,0.731,0.735,0.749,0.716,
    0.746,0.765,0.792,0.733,0.716,0.739,0.743,0.730,0.719,0.755,0.760,0.784,0.736,0.698,0.737,0.733,0.746,0.704,0.735,0.731,
    0.784,0.734,0.707,0.709,0.724,0.744,0.695,0.743,0.737,0.786,0.706,0.718,0.726,0.726,0.723,0.702,0.744,0.740,0.798,0.697,
    0.715,0.709,0.719,0.730,0.696,0.756,0.721,0.798,0.675,0.721,0.714,0.708,0.726,0.702,0.758,0.718,0.762,0.682,0.722,0.712,
    0.702,0.727,0.693,0.746,0.692,0.803,0.683,0.715,0.718,0.689,0.743,0.652,0.764,0.663,0.805,0.688,0.700,0.703,0.660,0.730,
    0.631,0.788,0.630,0.801,0.666,0.665,0.719,0.604,0.757,0.609,0.749,0.606,0.740,0.688,0.621,0.700,0.621,0.674,0.676,0.603,
    0.676,0.583,0.771,0.574,0.721,0.646,0.630,0.731,0.554,0.745,0.579,0.769,0.607,0.698,0.737,0.624,0.751,0.587,0.744,0.671,
    0.681,0.714,0.623,0.813,0.635,0.699,0.639,0.681,0.717,0.620,0.726,0.631,0.705,0.702,0.604,0.766,0.646,0.680,0.630,0.651,
    0.665,0.613,0.685,0.563,0.713,0.640,0.568,0.650,0.583,0.641,0.604,0.593,0.611,0.582,0.698,0.511,0.683,0.609,0.595,0.680,
    0.550,0.684,0.576,0.714,0.601,0.643,0.705,0.597,0.709,0.579,0.679,0.635,0.620,0.676,0.578,0.702,0.623,0.587,0.620,0.591,
    0.645,0.587,0.610,0.563,0.617,0.653,0.521,0.639,0.569,0.613,0.609,0.555,0.618,0.558,0.668,0.553,0.626,0.610,0.587,0.656,
    0.551,0.653,0.572,0.678,0.604,0.581,0.657,0.584,0.600,0.589,0.579,0.597,0.565,0.650,0.527,0.639,0.583,0.564,0.613,0.540,
    0.610,0.550,0.657,0.572,0.601,0.621,0.561,0.642,0.536,0.625,0.575,0.621,0.612,0.550,0.657,0.561,0.593,0.562,0.581,0.590,
    0.550,0.633,0.506,0.621,0.559,0.557,0.592,0.524,0.589,0.530,0.626,0.524,0.591,0.577,0.558,0.607,0.529,0.604,0.544,0.594,
    0.576,0.551,0.627,0.552,0.589,0.536,0.589,0.578,0.543,0.599,0.513,0.598,0.575,0.515,0.557,0.523,0.561,0.527,0.560,0.525,
    0.566,0.566,0.506,0.563,0.508,0.556,0.542,0.549,0.549,0.524,0.597,0.538,0.539,0.516,0.550,0.566,0.517,0.550,0.503,0.576,
    0.559,0.486,0.544,0.509,0.548,0.509,0.521,0.514,0.513,0.587,0.486,0.531,0.509,0.525,0.528,0.508,0.529,0.490,0.566,0.532,
    0.496,0.520,0.496,0.513,0.494,0.529,0.499,0.518,0.543,0.482,0.524,0.486,0.515,0.509,0.498,0.530,0.484,0.541,0.508,0.489,
    0.491,0.492,0.518,0.480,0.525,0.473,0.528,0.497,0.491,0.511,0.471,0.497,0.475,0.498,0.481,0.493,0.528,0.469,0.499,0.483,
    0.495,0.478,0.494,0.497,0.461,0.515,0.472,0.473,0.484,0.470,0.488,0.467,0.499,0.455,0.482,0.493,0.457,0.478,0.461,0.474,
    0.469,0.470,0.478,0.460,0.487,0.463,0.458,0.460,0.472,0.471,0.455,0.465,0.454,0.477,0.461,0.454,0.462,0.459,0.457,0.446,
    0.465,0.448,0.459,0.452,0.441,0.450,0.453,0.452,0.440,0.446,0.450,0.447,0.454,0.445,0.439,0.438,0.439,0.879,0.990,0.991,
    0.995,0.993,0.994,0.994,0.991,0.994,0.992,0.993,0.993,0.994,0.993,0.995,0.995,0.994,0.992,0.995,0.995,0.993,0.992,0.997,
    0.997,0.995,0.995,0.995,0.993,0.994,0.993,0.996,0.997,0.997,0.995,0.997,0.995,0.999,0.994,0.997,0.994,0.995,0.997,0.995,
    0.997,0.997,0.994,0.994,0.995,0.994,0.996,0.995,0.993,0.997,0.995,0.994,0.993,0.994,0.995,0.996,0.994,0.996,0.995,0.997,
    0.995,0.993,0.995,0.994,0.992,0.995,0.994,0.993,0.994,0.993,0.996,0.995,0.996,0.993,0.997,0.994,0.995,0.996,0.997,0.995,
    0.996,0.993,0.993,0.996,0.996,0.996,0.996,0.994,1.001,0.996,0.995,0.997,0.995,0.997,0.994,0.996,0.995,0.996,0.996,0.995,
    0.995,0.997,0.992,0.994,0.994,0.994,0.996,0.996,0.995,0.994,0.993,0.995,0.995,0.995,0.993,0.994,0.995,0.995,0.993,0.994,
    0.993,0.995,0.993,0.991,0.994,0.993,0.996,0.997,0.997,0.998,0.992,0.994,0.993,0.996,0.994,0.997,0.992,0.995,0.996,0.995,
};

/** Singleton Mode */
SingletonM(MainView)

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initButton];
    self.view.backgroundColor = [UIColor whiteColor];
   
    [[UdpSocket sharedUdpSocket] initSocket];
    [[UdpSocket sharedUdpSocket] initFFT];
    
    _generator = [[ToneGenerator alloc] initChannels:2 amplitude:audioAmplitude];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self spectrumViewLoad];  
    [self audioParametersViewLoad];
    [self systemInfoBarViewLoad];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [[LineChartViewController sharedLineChartViewController] clearChart];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];  
}


- (void)dealloc
{
    [[UdpSocket sharedUdpSocket] releaseFFT];    
}

-(void)spectrumViewLoad
{
    LineChartViewController *spectrumView=[[LineChartViewController alloc] init];
    [self addChildViewController:spectrumView];
    spectrumView.view.frame = CGRectMake(58, 25, self.view.frame.size.width-58*2, (self.view.frame.size.height-30-75-25-2));
    [self.view addSubview:spectrumView.view];

}

/** Load audioParametersView */
-(void)audioParametersViewLoad
{
    AudioParameters *audioParametersView=[[AudioParameters alloc] init];
    [self addChildViewController:audioParametersView];
    audioParametersView.view.frame = CGRectMake(58, (self.view.frame.size.height-30-75), self.view.frame.size.width-58*2, 75-4);
    [self.view addSubview:audioParametersView.view];
}

/** Load systemInfoBarView */
-(void)systemInfoBarViewLoad
{
    SystemInfoBar *systemInfoBarView=[[SystemInfoBar alloc] init];
    [self addChildViewController:systemInfoBarView];
    systemInfoBarView.view.frame = CGRectMake(58, 3, self.view.frame.size.width-58*2, 25-5);
    [self.view addSubview:systemInfoBarView.view];
}

/** Update button constrains */
-(void)updateViewConstraints
{
    [self autoArrangeButtonHeightConstraints:@[self.button1X,
                                               self.button2X,
                                               self.button3X,
                                               self.button4X,
                                               self.button5X,
                                               self.button6X,
                                               self.button7X,
                                               self.button8X,]];
    
    [self autoArrangeButtonHeightConstraints:@[self.button9X,
                                               self.button10X,
                                               self.button11X,
                                               self.button12X,
                                               self.button13X,
                                               self.button14X,
                                               self.button15X,
                                               self.button16X,]];
    
    [super updateViewConstraints];
}

///** Auto set button height */
-(void)autoArrangeButtonHeightConstraints:(NSArray *)constraintArray
{
    CGFloat height=(self.view.frame.size.height-6-30-(3*(constraintArray.count-1)))/(constraintArray.count);
    for(int i=0;i<constraintArray.count;i++)
    {
        NSLayoutConstraint *constraint=constraintArray[i];
        constraint.constant=height;
    }
    
}

/** Init Button */
-(void)initButton
{
    _fixYButton.backgroundColor = [UIColor lightGrayColor];
    [_fixYButton setTitle:@"AutoY" forState:UIControlStateNormal];
    
    _connectButton.backgroundColor = [UIColor lightGrayColor];
    [_connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    
    _runStopButton.backgroundColor = [UIColor redColor];
    
    
    
}

/** check the function or unfunction of button */
- (BOOL) checkButtonStatus:(UIButton*)button unfunctionedColor:(UIColor*)unfunctionedColor functionedColor:(UIColor*)functionedColor
{
    bool function = false;
    
    if(CGColorGetNumberOfComponents(button.backgroundColor.CGColor) == CGColorGetNumberOfComponents(functionedColor.CGColor))
    {
        function = true;
        
    }
    else if(CGColorGetNumberOfComponents(button.backgroundColor.CGColor) == CGColorGetNumberOfComponents(unfunctionedColor.CGColor))
    {
        function = false;
    }
    
    else
    {
        
    }
    
    return function;
}

- (IBAction)connectToUDP:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    
    if([self checkButtonStatus:_connectButton unfunctionedColor:[UIColor lightGrayColor] functionedColor:[UIColor greenColor]])
    {
        [[UdpSocket sharedUdpSocket] udpDisconnect];
        _connectButton.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
        [[UdpSocket sharedUdpSocket] udpConnect];
        _connectButton.backgroundColor = [UIColor greenColor];
        
    }
    
    
    [[SystemInfoBar sharedSystemInfoBar] updateWifiStatus];  

    
}
- (IBAction)loadSimulateData:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    
    _runStopButton.backgroundColor  = [UIColor redColor];
    [self stopTimer];
    
    for(int i=0; i<1000; i++)
    {
        receivedWifiData.spectrumData[i] = simulateData[i];
    }
    
    [[LineChartViewController sharedLineChartViewController] updateChartData:1000 set1YData:receivedWifiData.spectrumData xCoefficient:(float)(1/(float)240000)];
    
    AudioServicesPlaySystemSound(1117);  //begin_video_record.caf
    
}

/** Update button status when losing UDP connection*/
- (void)updateButtonStatusUDPDisconnect
{
    _connectButton.backgroundColor = [UIColor lightGrayColor];
    [self stopTimer];
    _runStopButton.backgroundColor = [UIColor redColor];

}

/** Update DSP button status*/
- (void)updateDSPButtonStatus
{
    if(isRawdata)
    {
      _dspButton.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
      _dspButton.backgroundColor = [UIColor greenColor];
    }
    
}

/** Turn On or Off OMAPL138 DSP*/
- (IBAction)dspOnOff:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    
    if([self checkButtonStatus:_dspButton unfunctionedColor:[UIColor lightGrayColor] functionedColor:[UIColor greenColor]])
    {
        _dspButton.backgroundColor = [UIColor lightGrayColor];
        isRawdata = 1;
        [[SettingView sharedSettingView] setDefaultValue:isRawdata keyString:@"isRawdata"];
        [[UdpSocket sharedUdpSocket] sendMessage:@"XZDISALGOLY"];
        [[SettingView sharedSettingView] readAllSettingValues];
        AudioServicesPlaySystemSound(1114);  //end_record.caf
        
    }
    else
    {
        _dspButton.backgroundColor = [UIColor greenColor];
        isRawdata = 0;
        [[SettingView sharedSettingView] setDefaultValue:isRawdata keyString:@"isRawdata"];
        [[UdpSocket sharedUdpSocket] sendMessage:@"XZENALGOLY"];
        [[SettingView sharedSettingView] readAllSettingValues];
        AudioServicesPlaySystemSound(1113);  //begin_record.caf
        
    }
    
    [[SystemInfoBar sharedSystemInfoBar] updateDSPStatus];
    
}

/** Change DSP Algorism*/
- (IBAction)changeAlgorism:(id)sender
{
    if(algorismNumber == 2)
    {
        [[UdpSocket sharedUdpSocket] sendMessage:@"XZFIRLY"];
        algorismNumber = 1;
    }
    else
    {
        [[UdpSocket sharedUdpSocket] sendMessage:@"XZFFTLY"];
        algorismNumber = 2;
    }

    [[SettingView sharedSettingView] setDefaultValue: algorismNumber keyString:@"algorismNumber"];
    [[SystemInfoBar sharedSystemInfoBar] updateAlgorismInfo:algorismNumber];
    [[SettingView sharedSettingView] readAllSettingValues];
    AudioServicesPlaySystemSound(1113);  //begin_record.caf
    
}

/** Update button status when UDP is connected, including connect button */
- (void)updateButtonStatusUDPConnect
{
    _connectButton.backgroundColor = [UIColor greenColor];
    
}

/** Autoscale Chart */
- (IBAction)autoScaleChart:(id)sender
{
   [self closePopupView];
   [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
   [[LineChartViewController sharedLineChartViewController] autoScale];
}



/** Fix Y or Auto Y Axis for time domain Chart */
- (IBAction)yAxisOperate:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    
    if([self checkButtonStatus:_fixYButton unfunctionedColor:[UIColor lightGrayColor] functionedColor:[UIColor greenColor]])
    {
        [[LineChartViewController sharedLineChartViewController] autoAjustYScale];
        AudioServicesPlaySystemSound(1118);
        
    }
    else
    {
        [[LineChartViewController sharedLineChartViewController] fixYScale];
        AudioServicesPlaySystemSound(1117);
    }
    [self switchButtonStatus:_fixYButton unfunctionedColor:[UIColor lightGrayColor] functionedColor:[UIColor greenColor] unfunctionedTitleLabel:@"AutoY" functionedTitleLabel:@"FixY" ];
}



/** Start a timer to update the chart data continuously */
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/** Stop a timer to stop updating the chart data continuously */
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

/** Update the chart data*/
- (void)updateData
{
    //isRawdata = 0 Enable OMAPL138 DSP
    //isRawdata = 1 Disable OMAPL138 DSP
    //algorismNumber = 1 FIR
    //algorismNumber = 2 FFT

    //OMAPL138 DSP is enable and perform DSP FFT
    if((algorismNumber == 2)&(isRawdata == 0))
    {
      [[LineChartViewController sharedLineChartViewController] updateChartData:500 set1YData:receivedWifiData.spectrumData xCoefficient:adcSampleRate/1024];
    }
    
    else
    {
      [[LineChartViewController sharedLineChartViewController] updateChartData:1000 set1YData:receivedWifiData.spectrumData xCoefficient:1/adcSampleRate];
    }

}

/** Require single waveform */
- (IBAction)setAllSettingValues:(id)sender
{
    [[SettingView sharedSettingView] setAllValues];
    AudioServicesPlaySystemSound(1117);  //begin_video_record.caf
    
}

/** Require single waveform */
- (IBAction)acquireSingleFrame:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];

    if(_runStopButton.backgroundColor == [UIColor greenColor])
    {
        _runStopButton.backgroundColor = [UIColor redColor];
        [self stopTimer];
        
    }
    else if(isUDPConnected)
    {
        [self updateData];
    }
    
    AudioServicesPlaySystemSound(1117);  //begin_video_record.caf
    
}

/** Require continuous waveform */
- (IBAction)acquireContinuousFrame:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];

    if(_runStopButton.backgroundColor == [UIColor greenColor])
    {
        _runStopButton.backgroundColor = [UIColor redColor];
        [self stopTimer];
        
        AudioServicesPlaySystemSound(1118);  //end_video_record.caf
    }
    else if(isUDPConnected)
    {
        _runStopButton.backgroundColor = [UIColor greenColor];
        [self startTimer];
        AudioServicesPlaySystemSound(1117);  //begin_video_record.caf
    }
}

/** close all the popup view */
- (void)closePopupView
{
    NSInteger popupViewNumber=self.childViewControllers.count-3;
    if(popupViewNumber>0)
    {
        for(int i=0;i<popupViewNumber;i++)
        {
            UIViewController *vc = [self.childViewControllers lastObject];
            
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
        }
        
        measurePopupViewFlag = false;
        
    }
    
}


- (IBAction)increaseSampleRate:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    
    rateNumber++;
    if(rateNumber>=13) rateNumber = 13;
    else if(rateNumber<=1) rateNumber = 1;
    
    [self setADCSampleRate:rateNumber];
    
    AudioServicesPlaySystemSound(1117);  //begin_video_record.caf
}

- (IBAction)decreaseSampleRate:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    
    rateNumber--;
    if(rateNumber>=13) rateNumber = 13;
    else if(rateNumber<=1) rateNumber = 1;
    
    [self setADCSampleRate:rateNumber];
    
    AudioServicesPlaySystemSound(1118);  //end_video_record.caf   
}

- (IBAction)playAudio:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    
    _runStopButton.backgroundColor  = [UIColor redColor];
    [self stopTimer];
    
    if([self checkEmpty:receivedWifiData.spectrumData arraySize:1000]>0)
    {        
       [_generator playForDuration:audioTotalDurationTime];        
    }
}

- (int)checkEmpty:(float *) data arraySize: (int)size
{
    int empty = 0;
    for(int i=0; i<size;i++)
    {
        if(data[i]!=0) empty++;
    }
    
    return empty;
}
- (IBAction)audioFrequencyIncrease:(id)sender
{
    audioFreqMultiply++;
    if(audioFreqMultiply>=10) audioFreqMultiply = 10;
    else if(audioFreqMultiply<=1) audioFreqMultiply = 1;
    [[AudioParameters sharedAudioParameters] updateFrequencyMultiTimes:audioFreqMultiply];
    AudioServicesPlaySystemSound(1117);  //begin_video_record.caf
}
- (IBAction)audioFrequencyDecrease:(id)sender
{
    audioFreqMultiply--;
    if(audioFreqMultiply>=10) audioFreqMultiply = 10;
    else if(audioFreqMultiply<=1) audioFreqMultiply = 1;
    [[AudioParameters sharedAudioParameters] updateFrequencyMultiTimes:audioFreqMultiply];
    AudioServicesPlaySystemSound(1118);  //end_video_record.caf
}

- (void)setADCSampleRate: (int) number
{
    [[SettingView sharedSettingView] setDefaultValue:number keyString:@"rateNumber"];
    
    switch (number)
    {
        case 1:
            [[UdpSocket sharedUdpSocket] sendMessage:@"XZRATEALY"];
            adcSampleRate = 10e3;
            break;
        case 2:
            [[UdpSocket sharedUdpSocket] sendMessage:@"XZRATEBLY"];
            adcSampleRate = 20e3;
            break;
        case 3:
            [[UdpSocket sharedUdpSocket] sendMessage:@"XZRATECLY"];
            adcSampleRate = 50e3;
            break;
        case 4:
            [[UdpSocket sharedUdpSocket] sendMessage:@"XZRATEDLY"];
            adcSampleRate = 100e3;
            break;
        case 5:
            [[UdpSocket sharedUdpSocket] sendMessage:@"XZRATEELY"];
            adcSampleRate = 200e3;
            break;
        case 6:
            [[UdpSocket sharedUdpSocket] sendMessage:@"XZRATEFLY"];
            adcSampleRate = 500e3;
            break;
        case 7:
            [[UdpSocket sharedUdpSocket] sendMessage:@"XZRATEGLY"];
            adcSampleRate = 1e6;
            break;
        case 8:
            [[UdpSocket sharedUdpSocket] sendMessage:@"XZRATEHLY"];
            adcSampleRate = 2e6;
            break;
        case 9:
            [[UdpSocket sharedUdpSocket] sendMessage:@"XZRATEILY"];
            adcSampleRate = 5e6;
            break;
        case 10:
            [[UdpSocket sharedUdpSocket] sendMessage:@"XZRATEJLY"];
            adcSampleRate = 10e6;
            break;
        case 11:
            [[UdpSocket sharedUdpSocket] sendMessage:@"XZRATEKLY"];
            adcSampleRate = 20e6;
            break;
        case 12:
            [[UdpSocket sharedUdpSocket] sendMessage:@"XZRATELLY"];
            adcSampleRate = 25e6;
            break;
        case 13:
            [[UdpSocket sharedUdpSocket] sendMessage:@"XZRATEMLY"];
            adcSampleRate = 50e6;
            break;
            
        default:
            break;
    }
    
    [[SystemInfoBar sharedSystemInfoBar] updateSampleRate:number];
}


/** switch button status between the function and unfunction */
- (void) switchButtonStatus:(UIButton*)button unfunctionedColor:(UIColor*)unfunctionedColor functionedColor:(UIColor*)functionedColor unfunctionedTitleLabel:(NSString*)unfunctionedTitleLabel functionedTitleLabel:(NSString*)functionedTitleLabel
{
    if(CGColorGetNumberOfComponents(button.backgroundColor.CGColor) == CGColorGetNumberOfComponents(functionedColor.CGColor))
    {
        button.backgroundColor = unfunctionedColor;
        [button setTitle:unfunctionedTitleLabel forState:UIControlStateNormal];
        
    }
    
    else if(CGColorGetNumberOfComponents(button.backgroundColor.CGColor) == CGColorGetNumberOfComponents(unfunctionedColor.CGColor))
    {
        button.backgroundColor = functionedColor;
        [button setTitle:functionedTitleLabel forState:UIControlStateNormal];
        
    }
    
    else
    {
        
    }
    
}



@end
