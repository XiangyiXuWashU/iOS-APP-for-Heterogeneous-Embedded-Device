//
//  UIViewController+SettingView.m
//  MINILOC
//
//  Created by Xiangyi Xu on 9/4/17.
//  Copyright © 2017 Xiangyi Xu. All rights reserved.
//

#import "SettingView.h"
#import "MainView.h"
#import "SystemInfoBar.h"
#import "LineChartViewController.h"
#import "UdpSocket.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SettingView ()


@end


@implementation SettingView

/** Algorism Number */
int algorismNumber = 1;

/** rawData */
int isRawdata = 0;

/** Audio Total Duration Time(S) */
float audioTotalDurationTime = 0.5;

/** Sample Rate Number */
extern int rateNumber;


/** Singleton Mode */
SingletonM(SettingView)

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self readAllSettingValues];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
 
}


- (void)readAllSettingValues
{
    _channel.selectedSegmentIndex = [self readDefaultValue:@"channel"];
    _algorismenable.selectedSegmentIndex = [self readDefaultValue:@"isRawdata"];
    isRawdata = [self readDefaultValue:@"isRawdata"];
    _algorismnumber.selectedSegmentIndex = [self readDefaultValue:@"algorismNumber"]-1;
    algorismNumber = [self readDefaultValue:@"algorismNumber"];
    
    _H0Slider.value = [self readDefaultValue:@"H0Slider"];
    _H1Slider.value = [self readDefaultValue:@"H1Slider"];
    _H2Slider.value = [self readDefaultValue:@"H2Slider"];
    _H3Slider.value = [self readDefaultValue:@"H3Slider"];
    
    _H0StepperValue.value = [self readDefaultValue:@"H0Slider"];
    _H1StepperValue.value = [self readDefaultValue:@"H1Slider"];
    _H2StepperValue.value = [self readDefaultValue:@"H2Slider"];
    _H3StepperValue.value = [self readDefaultValue:@"H3Slider"];
    
    _H0Value.text = [NSString stringWithFormat:@"%0.2f",_H0Slider.value];
    _H1Value.text = [NSString stringWithFormat:@"%0.2f",_H1Slider.value];
    _H2Value.text = [NSString stringWithFormat:@"%0.2f",_H2Slider.value];
    _H3Value.text = [NSString stringWithFormat:@"%0.2f",_H3Slider.value];
    
    rateNumber = [self readDefaultValue:@"rateNumber"];
    
    if([self readDefaultValue:@"audioTotalDuration"]<0.1) audioTotalDurationTime = 0.1;
    else audioTotalDurationTime = [self readDefaultValue:@"audioTotalDuration"];
    _audioTotalDurationSlider.value = audioTotalDurationTime;
    _audioTotalDurationStepper.value = audioTotalDurationTime;
    _audioTotalDurationValue.text = [NSString stringWithFormat:@"%0.1f",audioTotalDurationTime];
        
    
    [[MainView sharedMainView] updateDSPButtonStatus];
    [[SystemInfoBar sharedSystemInfoBar] updateDSPStatus];
}



/** Select ADC Channel */
- (IBAction)channelSelect:(id)sender
{
    if(_channel.selectedSegmentIndex == 0)
    {
     [[UdpSocket sharedUdpSocket] sendMessage:@"XZCHALY"];
    }
    else
    {
     [[UdpSocket sharedUdpSocket] sendMessage:@"XZCHBLY"];
    }
    
    [self setDefaultValue:_channel.selectedSegmentIndex keyString:@"channel"];

}

- (IBAction)algorismEnable:(id)sender
{
    if(_algorismenable.selectedSegmentIndex == 0)
    {
        [[UdpSocket sharedUdpSocket] sendMessage:@"XZENALGOLY"];
        isRawdata = 0;
    }
    else
    {
        [[UdpSocket sharedUdpSocket] sendMessage:@"XZDISALGOLY"];
        isRawdata = 1;
    }
    
    [self setDefaultValue:isRawdata keyString:@"isRawdata"];
    [[MainView sharedMainView] updateDSPButtonStatus];
    [[SystemInfoBar sharedSystemInfoBar] updateDSPStatus];
}

- (IBAction)algorismSelect:(id)sender
{
    if(_algorismnumber.selectedSegmentIndex == 0)
    {
        [[UdpSocket sharedUdpSocket] sendMessage:@"XZFIRLY"];
        algorismNumber = 1;
    }
    else
    {
        [[UdpSocket sharedUdpSocket] sendMessage:@"XZFFTLY"];
        algorismNumber = 2;
    }
    
   [[SystemInfoBar sharedSystemInfoBar] updateAlgorismInfo:algorismNumber];
   [self setDefaultValue: algorismNumber keyString:@"algorismNumber"];
}

//Set FIR Filter Cofficents
- (IBAction)setH0:(id)sender
{
  _H0Value.text = [NSString stringWithFormat:@"%0.2f",_H0Slider.value];
  _H0StepperValue.value = [_H0Value.text floatValue];
  _H0Slider.value = [_H0Value.text floatValue];
    
  [[UdpSocket sharedUdpSocket] sendMessage:[NSString stringWithFormat:@"XZH0:%.0fLY",_H0Slider.value*100]];
  [self setDefaultValue: _H0Slider.value keyString:@"H0Slider"];
    
}

- (IBAction)setH1:(id)sender
{
  _H1Value.text = [NSString stringWithFormat:@"%0.2f",_H1Slider.value];
  _H1StepperValue.value = [_H1Value.text floatValue];
  _H1Slider.value = [_H1Value.text floatValue];
    
  [[UdpSocket sharedUdpSocket] sendMessage:[NSString stringWithFormat:@"XZH1:%.0fLY",_H1Slider.value*100]];
  [self setDefaultValue: _H1Slider.value keyString:@"H1Slider"];
    
}

- (IBAction)setH2:(id)sender
{
  _H2Value.text = [NSString stringWithFormat:@"%0.2f",_H2Slider.value];
  _H2StepperValue.value = [_H2Value.text floatValue];
  _H2Slider.value = [_H2Value.text floatValue];
    
  [[UdpSocket sharedUdpSocket] sendMessage:[NSString stringWithFormat:@"XZH2:%.0fLY",_H2Slider.value*100]];
  [self setDefaultValue: _H2Slider.value keyString:@"H2Slider"];}

- (IBAction)setH3:(id)sender
{
  _H3Value.text = [NSString stringWithFormat:@"%0.2f",_H3Slider.value];
  _H3StepperValue.value = [_H3Value.text floatValue];
  _H3Slider.value = [_H3Value.text floatValue];
    
  [[UdpSocket sharedUdpSocket] sendMessage:[NSString stringWithFormat:@"XZH3:%.0fLY",_H3Slider.value*100]];
  [self setDefaultValue: _H3Slider.value keyString:@"H3Slider"];
    
}

- (IBAction)adjustH0:(id)sender
{
  _H0Value.text = [NSString stringWithFormat:@"%0.2f",_H0StepperValue.value];
  _H0Slider.value = [_H0Value.text floatValue];
    
  [[UdpSocket sharedUdpSocket] sendMessage:[NSString stringWithFormat:@"XZH0:%.0fLY",_H0Slider.value*100]];
  [self setDefaultValue: _H0Slider.value keyString:@"H0Slider"];
    
}

- (IBAction)adjustH1:(id)sender
{
  _H1Value.text = [NSString stringWithFormat:@"%0.2f",_H1StepperValue.value];
  _H1Slider.value = [_H1Value.text floatValue];
    
  [[UdpSocket sharedUdpSocket] sendMessage:[NSString stringWithFormat:@"XZH1:%.0fLY",_H1Slider.value*100]];
  [self setDefaultValue: _H1Slider.value keyString:@"H1Slider"];
    
}

- (IBAction)adjustH2:(id)sender
{
  _H2Value.text = [NSString stringWithFormat:@"%0.2f",_H2StepperValue.value];
  _H2Slider.value = [_H2Value.text floatValue];
    
  [[UdpSocket sharedUdpSocket] sendMessage:[NSString stringWithFormat:@"XZH2:%.0fLY",_H2Slider.value*100]];
  [self setDefaultValue: _H2Slider.value keyString:@"H2Slider"];
    
}

- (IBAction)adjustH3:(id)sender
{
  _H3Value.text = [NSString stringWithFormat:@"%0.2f",_H3StepperValue.value];
  _H3Slider.value = [_H3Value.text floatValue];
    
  [[UdpSocket sharedUdpSocket] sendMessage:[NSString stringWithFormat:@"XZH3:%.0fLY",_H3Slider.value*100]];
   
  [self setDefaultValue: _H3Slider.value keyString:@"H3Slider"];
}

- (void)setAllValues
{
    [self channelSelect:_channel];
    [NSThread sleepForTimeInterval:0.05];
    [self algorismEnable:_algorismenable];
    [NSThread sleepForTimeInterval:0.05];
    [self algorismSelect:_algorismnumber];
    [NSThread sleepForTimeInterval:0.05];
    [self setH0:_H0Slider];
    [NSThread sleepForTimeInterval:0.05];
    [self setH1:_H1Slider];
    [NSThread sleepForTimeInterval:0.05];
    [self setH2:_H2Slider];
    [NSThread sleepForTimeInterval:0.05];    
    [self setH3:_H3Slider];
    [NSThread sleepForTimeInterval:0.05];
    [self changeAudioTotalDurationTime:_audioTotalDurationSlider];
    [[MainView sharedMainView] setADCSampleRate:rateNumber];
    
}
- (IBAction)changeAudioTotalDurationTime:(id)sender
{
    _audioTotalDurationValue.text = [NSString stringWithFormat:@"%0.1f",_audioTotalDurationSlider.value];
    _audioTotalDurationStepper.value = [_audioTotalDurationValue.text floatValue];
    _audioTotalDurationSlider.value = [_audioTotalDurationValue.text floatValue];
    audioTotalDurationTime = _audioTotalDurationSlider.value;

    [self setDefaultValue: _audioTotalDurationSlider.value keyString:@"audioTotalDuration"];
}


- (IBAction)adjustAudioTotalDurationTime:(id)sender
{
    _audioTotalDurationValue.text = [NSString stringWithFormat:@"%0.1f",_audioTotalDurationStepper.value];
    _audioTotalDurationSlider.value = [_audioTotalDurationValue.text floatValue];
    audioTotalDurationTime = _audioTotalDurationSlider.value;
    
    [self setDefaultValue: _audioTotalDurationSlider.value keyString:@"audioTotalDuration"];
}


- (void)setDefaultValue: (float) value keyString: (NSString *) key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setFloat:value forKey:key];
    [defaults synchronize];
}

- (float)readDefaultValue: (NSString *) key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults floatForKey:key];
}


@end
