//
//  UIViewController+MainView.h
//  MINILOC
//
//  Created by Xiangyi Xu on 9/4/17.
//  Copyright © 2017 Xiangyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface MainView : UIViewController



/** Singleton Mode */
SingletonH(MainView)

- (void)updateButtonStatusUDPDisconnect;
- (void)updateButtonStatusUDPConnect;
- (void)setADCSampleRate: (int) number;
- (void)updateDSPButtonStatus;

@end
