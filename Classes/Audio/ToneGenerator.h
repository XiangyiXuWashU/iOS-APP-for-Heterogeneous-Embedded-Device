
#import <Foundation/Foundation.h>
@import AudioToolbox;
@import AVFoundation;


#define TONE_GENERATOR_SAMPLE_RATE_DEFAULT 96000.0f


@interface ToneGenerator : NSObject
{
@public
    AudioComponentInstance _toneUnit;
    double _sampleRate;
    UInt32 _numChannels;
    float  _amplitude;
}

- (id)initChannels:(UInt32)size amplitude:(float)volume;
- (void)playForDuration:(NSTimeInterval)time;
- (void)play;
- (void)stop;

@end

