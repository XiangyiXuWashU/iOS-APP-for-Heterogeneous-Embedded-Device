#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface SystemInfoBar : UIViewController

/** Singleton Mode */
SingletonH(SystemInfoBar)


- (void)updateWifiStatus;
- (void)updateDSPStatus;
- (void)updateSampleRate: (int)rate;
- (void)updateAlgorismInfo: (int)number;

@end


