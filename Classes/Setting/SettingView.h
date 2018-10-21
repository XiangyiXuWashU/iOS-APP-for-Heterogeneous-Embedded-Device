//
//  UIViewController+SettingView.h
//  MINILOC
//
//  Created by Xiangyi Xu on 9/4/17.
//  Copyright © 2017 Xiangyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface  SettingView : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *channel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *algorismenable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *algorismnumber;

@property (weak, nonatomic) IBOutlet UILabel *H0Value;
@property (weak, nonatomic) IBOutlet UILabel *H1Value;
@property (weak, nonatomic) IBOutlet UILabel *H2Value;
@property (weak, nonatomic) IBOutlet UILabel *H3Value;

@property (weak, nonatomic) IBOutlet UISlider *H0Slider;
@property (weak, nonatomic) IBOutlet UISlider *H1Slider;
@property (weak, nonatomic) IBOutlet UISlider *H2Slider;
@property (weak, nonatomic) IBOutlet UISlider *H3Slider;

@property (weak, nonatomic) IBOutlet UIStepper *H0StepperValue;
@property (weak, nonatomic) IBOutlet UIStepper *H1StepperValue;
@property (weak, nonatomic) IBOutlet UIStepper *H2StepperValue;
@property (weak, nonatomic) IBOutlet UIStepper *H3StepperValue;
@property (weak, nonatomic) IBOutlet UISlider *audioTotalDurationSlider;
@property (weak, nonatomic) IBOutlet UIStepper *audioTotalDurationStepper;
@property (weak, nonatomic) IBOutlet UILabel *audioTotalDurationValue;

/** Singleton Mode */
SingletonH(SettingView)

- (void)setAllValues;
- (void)readAllSettingValues;
- (void)setDefaultValue: (float) value keyString: (NSString *) key;
- (float)readDefaultValue: (NSString *) key;


@end
