#import "AudioParameters.h"
#import "UdpSocket.h"

@interface AudioParameters()

@property (weak, nonatomic) IBOutlet UILabel *audioSampleRate;
@property (weak, nonatomic) IBOutlet UILabel *preferAudioSampleRate;
@property (weak, nonatomic) IBOutlet UILabel *frequencyMultiTimes;
@property (weak, nonatomic) IBOutlet UILabel *inNumberFrames;
@property (weak, nonatomic) IBOutlet UILabel *frameDuration;
@property (weak, nonatomic) IBOutlet UILabel *totalDuration;
@property (weak, nonatomic) IBOutlet UILabel *chartSelectStartTime;
@property (weak, nonatomic) IBOutlet UILabel *chartSelectStopTime;
@property (weak, nonatomic) IBOutlet UILabel *chartPlayTime;



@end

@implementation AudioParameters

extern WIFIDATA receivedWifiData;

/** Is UDP Connected */
extern bool isUDPConnected;

/** Define Audio Parmeters */
AUDIOPARAMETER audioParameter;

/** Singleton Mode */
SingletonM(AudioParameters)

- (void)viewDidLoad
{
    [super viewDidLoad];
}

/** update audio parameters monitor value */
- (void)updateAudioParameters
{
    
    
}

- (void)updateAudioSampleRate: (float) sampleRate
{
   _audioSampleRate.text = [NSString stringWithFormat:@"%0.2e",sampleRate];
}


- (void)updatePreferAudioSampleRate: (float) sampleRate
{
    _preferAudioSampleRate.text = [NSString stringWithFormat:@"%0.2e",sampleRate];
}

- (void)updateFrequencyMultiTimes: (float) times
{
    _frequencyMultiTimes.text = [NSString stringWithFormat:@"%0.0f",times];
}

- (void)updateInNumberFrames: (float) frames
{
    _inNumberFrames.text = [NSString stringWithFormat:@"%0.0f",frames];
}

- (void)updateframeDuration: (float) duration
{
    _frameDuration.text = [NSString stringWithFormat:@"%0.1e",duration];
}

- (void)updateTotalDuration: (float) duration
{
    _totalDuration.text = [NSString stringWithFormat:@"%0.1f",duration];
}

- (void)updateChartSelectStartTime: (float) time
{
    _chartSelectStartTime.text = [NSString stringWithFormat:@"%0.2e",time];
}

- (void)updateChartSelectStopTime: (float) time
{
    _chartSelectStopTime.text = [NSString stringWithFormat:@"%0.2e",time];
}

- (void)updateChartPlayTime: (float) time
{
    _chartPlayTime.text = [NSString stringWithFormat:@"%0.2e",time];
}

@end
