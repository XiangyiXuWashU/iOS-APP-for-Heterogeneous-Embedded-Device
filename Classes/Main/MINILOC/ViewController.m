//
//  ViewController.m
//  MINILOC
//
//  Created by Xiangyi Xu on 9/3/17.
//  Copyright © 2017 Xiangyi Xu. All rights reserved.
//

#import "ViewController.h"
#import "MINILOCTabBarController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
