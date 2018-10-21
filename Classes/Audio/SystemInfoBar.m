#import "SystemInfoBar.h"
#import "UdpSocket.h"

@interface SystemInfoBar()
@property (weak, nonatomic) IBOutlet UILabel *wifiStatus;
@property (weak, nonatomic) IBOutlet UILabel *adcSampleRate;
@property (weak, nonatomic) IBOutlet UILabel *dspOnOff;
@property (weak, nonatomic) IBOutlet UILabel *algorismName;


@end

@implementation SystemInfoBar

extern WIFIDATA receivedWifiData;

/** Is UDP Connected */
extern bool isUDPConnected;

/** Algorism Number */
extern  int algorismNumber;

/** rawData */
extern  int isRawdata;

/** Sample Rate Number */
extern int rateNumber;


/** Singleton Mode */
SingletonM(SystemInfoBar)

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateDSPStatus];
    [self updateDSPStatus];
    [self updateSampleRate:rateNumber];
    [self updateAlgorismInfo:algorismNumber];
}


- (void)setLable: (UILabel *)lable LableName: (NSString *)name LableColor: (UIColor *)UIColor
{
    lable.text = name;
    lable.textColor = UIColor;    
}

- (void)updateWifiStatus
{
    if(isUDPConnected)
    {
        [self setLable:_wifiStatus LableName:@"YES" LableColor:[UIColor greenColor]];
    }
    else
    {
        [self setLable:_wifiStatus LableName:@"NO" LableColor:[UIColor redColor]];
    }
}

- (void)updateDSPStatus
{
    if(isRawdata)
    {
        [self setLable:_dspOnOff LableName:@"OFF" LableColor:[UIColor redColor]];
    }
    else
    {
        [self setLable:_dspOnOff LableName:@"ON" LableColor:[UIColor greenColor]];
    }
}

- (void)updateAlgorismInfo: (int)number
{
    switch (number)
    {
        case 1:
            _algorismName.text = @"FIR";
            break;
        case 2:
            _algorismName.text = @"FFT";
            break;
        default:
            break;
    }
}

- (void)updateSampleRate: (int)rate
{
    switch (rate)
    {
        case 1:
            _adcSampleRate.text = @"10K";
            break;
        case 2:
            _adcSampleRate.text = @"20K";
            break;
        case 3:
            _adcSampleRate.text = @"50K";
            break;
        case 4:
            _adcSampleRate.text = @"100K";
            break;
        case 5:
            _adcSampleRate.text = @"200K";
            break;
        case 6:
            _adcSampleRate.text = @"500K";
            break;
        case 7:
            _adcSampleRate.text = @"1M";
            break;
        case 8:
            _adcSampleRate.text = @"2M";
            break;
        case 9:
            _adcSampleRate.text = @"5M";
            break;
        case 10:
            _adcSampleRate.text = @"10M";
            break;
        case 11:
            _adcSampleRate.text = @"20M";
            break;
        case 12:
            _adcSampleRate.text = @"25M";
            break;
        case 13:
            _adcSampleRate.text = @"50M";
            break;
            
        default:
            break;
    }
}


@end

