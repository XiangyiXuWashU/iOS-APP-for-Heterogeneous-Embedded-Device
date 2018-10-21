//
//  UITabBarController+MINILOCTabBarController.m
//  MINILOC
//
//  Created by Xiangyi Xu on 9/4/17.
//  Copyright © 2017 Xiangyi Xu. All rights reserved.
//

#import "MINILOCTabBarController.h"
#import "MainView.h"
#import "SettingView.h"


@interface MINILOCTabBarController()



@end

@implementation MINILOCTabBarController

+ (void)initialize
{  
    //Set the attributes of the TabBar
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    //Set TabBar
    [self setupChildVc:[[MainView alloc] init] title:@"" image:@"main_icon" selectedImage:@"main_click_icon"];
    [self setupChildVc:[[SettingView alloc] init]  title:@"" image:@"setting-icon" selectedImage:@"setting-icon-click"];
  
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    //Fix the height of TabBar to 30
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 30;
    tabFrame.origin.y = self.view.frame.size.height - tabFrame.size.height;
    self.tabBar.frame = tabFrame;
}

- (void)setupChildVc: (UIViewController *)vc title: (NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];

    [self addChildViewController:vc];
 
    [vc loadView];
    [vc viewDidLoad];
}
@end


