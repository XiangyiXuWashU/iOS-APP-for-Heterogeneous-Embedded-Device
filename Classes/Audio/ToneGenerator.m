#import "ToneGenerator.h"
#import "AudioParameters.h"
#import "LineChartViewController.h"
#import "UdpSocket.h"
#import <AudioToolbox/AudioToolbox.h>

/** WIFI Data */
extern WIFIDATA receivedWifiData;




@implementation ToneGenerator

/** Audio Total Duration Time(S) */
extern float audioTotalDurationTime;

/** Audio Frequency Multiply Number */
extern int audioFreqMultiply;


/** Define Audio Parmeters */
extern AUDIOPARAMETER audioParameter;


float audioAmplitude = 0.02;



- (id)initChannels:(UInt32)size amplitude:(float)volume
{
    if (self = [super init])
    {
        _numChannels = size;
        _amplitude = volume;
        _sampleRate = TONE_GENERATOR_SAMPLE_RATE_DEFAULT;
        [self _setupAudioSession];
    }
    
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)playForDuration:(NSTimeInterval)time
{
    [self play];
    [self performSelector:@selector(stop) withObject:nil afterDelay:time];
}

- (void)play
{
    if (!_toneUnit)
    {
        [self _createToneUnit];
        
        // Stop changing parameters on the unit
        OSErr err = AudioUnitInitialize(_toneUnit);
        NSAssert1(err == noErr, @"Error initializing unit: %hd", err);
        
        // Start playback
        err = AudioOutputUnitStart(_toneUnit);
        NSAssert1(err == noErr, @"Error starting unit: %hd", err);
    }
}

- (void)stop
{
    if (_toneUnit)
    {
        AudioOutputUnitStop(_toneUnit);
        AudioUnitUninitialize(_toneUnit);
        AudioComponentInstanceDispose(_toneUnit);
        _toneUnit = nil;        
        
        [[AudioParameters sharedAudioParameters] updateInNumberFrames:audioParameter.inNumberFrames];
        [[AudioParameters sharedAudioParameters] updateAudioSampleRate:audioParameter.sampleRate];
        [[AudioParameters sharedAudioParameters] updatePreferAudioSampleRate:audioParameter.preferAudioSampleRate];
        [[AudioParameters sharedAudioParameters] updateframeDuration:audioParameter.audioTotalDurationTime];
        [[AudioParameters sharedAudioParameters] updateTotalDuration:audioParameter.audioTotalDurationTime];
        [[AudioParameters sharedAudioParameters] updateFrequencyMultiTimes:audioParameter.audioFreqMultiply];
        [[AudioParameters sharedAudioParameters] updateChartSelectStartTime: audioParameter.inViewStart];
        [[AudioParameters sharedAudioParameters] updateChartSelectStopTime:audioParameter.inViewStop];
        [[AudioParameters sharedAudioParameters] updateChartPlayTime: audioParameter.chartPlayTime];
    }
}

- (int)calculatePreferSampleRate
{
    int preferRate = 96000;
    float coefficient = 96000/1024;
    preferRate =(int) (coefficient*[[LineChartViewController sharedLineChartViewController] extractDataInView]);
    _sampleRate = preferRate;
    return preferRate;
}

- (int)calculateMultiSampleRate: (int) number
{
    int preferRate = 96000;
    float coefficient = 96000/1024;
    preferRate =(int) (coefficient*[[LineChartViewController sharedLineChartViewController] extractDataInView])*audioFreqMultiply;
    _sampleRate = preferRate;
    return preferRate;
}

- (void)_setupAudioSession
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL ok;
    NSError *setCategoryError = nil;
    ok = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    NSAssert1(ok, @"Audio error %@", setCategoryError);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_handleInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:audioSession];
}

- (void)_handleInterruption:(id)sender
{
    [self stop];
}

- (void)_createToneUnit
{
    // Configure the search parameters to find the default playback output unit
    // (called the kAudioUnitSubType_RemoteIO on iOS but
    // kAudioUnitSubType_DefaultOutput on Mac OS X)
    AudioComponentDescription defaultOutputDescription;
    defaultOutputDescription.componentType = kAudioUnitType_Output;
    defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
    defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    defaultOutputDescription.componentFlags = 0;
    defaultOutputDescription.componentFlagsMask = 0;
    
    // Get the default playback output unit
    AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
    NSAssert(defaultOutput, @"Can't find default output");
    
    // Create a new unit based on this that we'll use for output
    OSErr err = AudioComponentInstanceNew(defaultOutput, &_toneUnit);
    NSAssert1(_toneUnit, @"Error creating unit: %hd", err);
    
    // Set our tone rendering function on the unit
    AURenderCallbackStruct input;
    input.inputProc = RenderTone;
    input.inputProcRefCon = (__bridge void *)(self);
    err = AudioUnitSetProperty(_toneUnit,
                               kAudioUnitProperty_SetRenderCallback,
                               kAudioUnitScope_Input,
                               0,
                               &input,
                               sizeof(input));
    NSAssert1(err == noErr, @"Error setting callback: %hd", err);
    
    // Set the format to 32 bit, single channel, floating point, linear PCM
    
    [self calculateMultiSampleRate: audioFreqMultiply];
    
    const int four_bytes_per_float = 4;
    const int eight_bits_per_byte = 8;
    AudioStreamBasicDescription streamFormat;
    streamFormat.mSampleRate = _sampleRate;
    
    streamFormat.mFormatID = kAudioFormatLinearPCM;
    streamFormat.mFormatFlags =
    kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
    streamFormat.mBytesPerPacket = four_bytes_per_float;
    streamFormat.mFramesPerPacket = 1;
    streamFormat.mBytesPerFrame = four_bytes_per_float;
    streamFormat.mChannelsPerFrame = _numChannels;
    streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
    err = AudioUnitSetProperty (_toneUnit,
                                kAudioUnitProperty_StreamFormat,
                                kAudioUnitScope_Input,
                                0,
                                &streamFormat,
                                sizeof(AudioStreamBasicDescription));
    NSAssert1(err == noErr, @"Error setting stream format: %hd", err);
}


/** Normalize Chart Data */
- (float *)normalizeData:(float *)data sizeofArray: (int) size
{
    float min = [self arrayMin:data arraySize:size];
    float max = [self arrayMax:data arraySize:size];
    
    for(int i=0;i<size;i++)
    {
        data[i] = (data[i]-min)/(max-min)-0.5;
    }
    
    return data;
}

- (float)arrayMax:(float *) array arraySize: (int) size
{
    float max=array[0];
    
    for(int i=0;i<size;i++)
    {
        if(array[i]>max)
        {
            max = array[i];
        }
    }
    
    return max;
}

- (float)arrayMin:(float *) array arraySize: (int) size
{
    float min=array[0];
    
    for(int i=0;i<size;i++)
    {
        if(array[i]<min)
        {
            min = array[i];
        }
    }
    
    return min;
}

OSStatus RenderTone(
                    void *inRefCon,
                    AudioUnitRenderActionFlags   *ioActionFlags,
                    const AudioTimeStamp         *inTimeStamp,
                    UInt32                         inBusNumber,
                    UInt32                         inNumberFrames,
                    AudioBufferList              *ioData)

{
    // Get the tone parameters out of the object
    ToneGenerator *toneGenerator = (__bridge ToneGenerator *)inRefCon;
    assert(ioData->mNumberBuffers == toneGenerator->_numChannels);
    
    int size = [[LineChartViewController sharedLineChartViewController] extractDataInView];

    
    for (size_t chan = 0; chan < toneGenerator->_numChannels; chan++)
    {
        float *audiodata = [toneGenerator normalizeData:receivedWifiData.inViewData sizeofArray:size];
        
        float multiAudioData[size*audioFreqMultiply];

        for(int i=0; i<size*audioFreqMultiply;i++)
        {
            multiAudioData[i] = audiodata[i%size];
        }
        
        Float32 *buffer = (Float32 *)ioData->mBuffers[chan].mData;
        // Generate the samples
        for (UInt32 frame = 0; frame < size*audioFreqMultiply; frame++)
        {
           buffer[frame] = multiAudioData[frame]* audioAmplitude;
        }

    }
    
    audioParameter.inNumberFrames = inNumberFrames;
    audioParameter.sampleRate = toneGenerator->_sampleRate*audioFreqMultiply;
    audioParameter.preferAudioSampleRate = toneGenerator->_sampleRate;
    audioParameter.audioTotalDurationTime = audioTotalDurationTime;
    audioParameter.audioFreqMultiply = audioFreqMultiply;
    audioParameter.frameDuration = inNumberFrames/toneGenerator->_sampleRate;
    
    float inViewStart = [[LineChartViewController sharedLineChartViewController] readInViewStart];
    float inViewStop  = [[LineChartViewController sharedLineChartViewController] readInViewStop];
    audioParameter.inViewStart = inViewStart;
    audioParameter.inViewStop = inViewStop;
    audioParameter.chartPlayTime = inViewStop-inViewStart;

    return noErr;    
}




@end
