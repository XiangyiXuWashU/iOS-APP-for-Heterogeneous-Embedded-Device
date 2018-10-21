
#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

@interface fft: NSObject

typedef struct FFTHelperRef
{
    FFTSetup fftSetup;
    COMPLEX_SPLIT complexA;
    Float32 *outFFTData;
} FFTHelperRef;


- (FFTHelperRef *) FFTHelperCreate: (int) numberOfSamples;
- (Float32 *)computeFFT: (FFTHelperRef *)fftHelperRef timeDomainData: (float *)timeDomainData numSamples: (int)numSamples;
- (void)FFTHelperRelease: (FFTHelperRef *)fftHelper;



@end
