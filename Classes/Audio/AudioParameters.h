
#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface AudioParameters : UIViewController


/* WIFIDataStructure. */

typedef struct
{
    UInt32   inNumberFrames;
    float    sampleRate;
    float    preferAudioSampleRate;
    float    audioTotalDurationTime;
    float    frameDuration;
    float    audioFreqMultiply;
    float    inViewStart;
    float    inViewStop;
    float    chartPlayTime;    
}AUDIOPARAMETER;


/** Singleton Mode */
SingletonH(AudioParameters)


- (void)updateAudioParameters;
- (void)updateAudioSampleRate: (float) sampleRate;
- (void)updatePreferAudioSampleRate: (float) sampleRate;
- (void)updateFrequencyMultiTimes: (float) times;
- (void)updateInNumberFrames: (float) frames;
- (void)updateframeDuration: (float) duration;
- (void)updateTotalDuration: (float) duration;
- (void)updateChartSelectStartTime: (float) time;
- (void)updateChartSelectStopTime: (float) time;
- (void)updateChartPlayTime: (float) time;


@end

