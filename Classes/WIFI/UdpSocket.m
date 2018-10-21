//
//  UdpSocket.m
//  MINILOC
//
//  Created by Xiangyi Xu on 11/21/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import "UdpSocket.h"
#import "SystemInfoBar.h"
#import "MainView.h"
#import "SettingView.h"
#import "GCDAsyncUdpSocket.h"
#import "Singleton.h"
#import "ViewController.h"
#import "LineChartViewController.h"
#import "fft.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation UdpSocket

/** Singleton Mode */
SingletonM(UdpSocket)

WIFIDATA receivedWifiData;

/** Is UDP Connected */
bool isUDPConnected = false;

/** Is use simulate data */
extern bool isSimulateData;

/** Algorism Number */
extern  int algorismNumber;

/** rawData */
extern  int isRawdata;

/** Perform One time All Setting */
bool allSettingOneTimeFlag;

/** FFT Helper */
FFTHelperRef *fftConverter = NULL;

/** Init a UDP Socket*/
- (void)initSocket
{
    udpReceiveSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    udpSendSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)initFFT
{
   fft *fftAlgorism = [[fft alloc] init];
   fftConverter = [fftAlgorism FFTHelperCreate:1000];
}

/** UDP Connect*/
- (void)udpConnect
{  
    [udpReceiveSocket close];
    [udpSendSocket close];
    NSError *error = nil;
    
    //Receive Socket
    if (![udpReceiveSocket bindToPort:8088 error:&error])
    {
        NSLog(@"Receive Socket Error starting server (bind): %@", error);
        return;
    }
    
    if (![udpReceiveSocket beginReceiving:&error])
        
    {
        [udpReceiveSocket close];
        NSLog(@"Receive Socket Error starting server (recv): %@", error);
        return;
    }
    
    //Send Socket
    if (![udpSendSocket bindToPort:8086 error:&error])
    {
        NSLog(@"Send Socket Error starting server (bind): %@", error);
        return;
    }

    
    else
    {
        [self startTimer:0.5];
        isUDPConnected = true;
        allSettingOneTimeFlag = false;
    }
    
    AudioServicesPlaySystemSound(1113);  //begin_record.caf

}

/** UDP Disconnect*/
- (void)udpDisconnect
{
    [udpReceiveSocket close];
    [udpSendSocket close];
    isUDPConnected = false;
    [self stopTimer];
    [self loseUDPConnectionOperation];
    AudioServicesPlaySystemSound(1114);  //end_record.caf
}

/** Start a timer to update the chart data continuously */
- (void)startTimer:(NSTimeInterval)ti
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(udpReceiveTimeout) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/** Send UDP Data */
- (void)sendMessage:(NSString *)message
{
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [udpSendSocket sendData:data toHost:self.clientIP port:8086 withTimeout:-1 tag:0];
}


/** Stop a timer to stop updating the chart data continuously */
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

/** UDP Receiving time is out*/
- (void)udpReceiveTimeout
{
   isUDPConnected = false;
   [[MainView sharedMainView] updateButtonStatusUDPDisconnect];
    
   [self udpDisconnect];
    
   AudioServicesPlaySystemSound(1114);  //end_record.caf
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    [self stopTimer];
    isUDPConnected = true;
    NSString * ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    
    self.clientIP = ip;
    self.clientPort = port;
    
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg)
    {
        [self convertWifiStringToWIFIDATA:msg];
        [[MainView sharedMainView] updateButtonStatusUDPConnect];
    }
    else
    {
        NSLog(@"Error converting received data into UTF-8 String");
    }
    if(allSettingOneTimeFlag == false)
    {
       [[SettingView sharedSettingView] setAllValues];
       allSettingOneTimeFlag = YES;
    }
   
    
    [self startTimer:4];
    
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    [self loseUDPConnectionOperation];
   
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{

}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{


}

/** If losing UDP connection, update the UIButton and clear chart*/
-(void)loseUDPConnectionOperation
{
    isUDPConnected = false;
    [[MainView sharedMainView] updateButtonStatusUDPDisconnect];
    [[SystemInfoBar sharedSystemInfoBar] updateWifiStatus];    
}

/** allocate received string to WIFIDATA structure*/
- (void)convertWifiStringToWIFIDATA:(NSString *)dataString
{
    //Convert raw data
    for(int i=0; i<1000; i++)
    {
        float temp=0;
       
        //OMAPL138 DSP is enable and perform DSP FFT
        if((algorismNumber == 2)&(isRawdata == 0))
        {
           //algorismNumber = 1 FIR
           //algorismNumber = 2 FFT
           [[NSScanner scannerWithString:[dataString substringWithRange:NSMakeRange(10*i+10, 10)]] scanFloat:&temp];
           receivedWifiData.spectrumData[i]= temp;
        }
        
        else
        {
            //isRawdata = 0 Enable OMAPL138 DSP
            //isRawdata = 1 Disable OMAPL138 DSP
            [[NSScanner scannerWithString:[dataString substringWithRange:NSMakeRange(10*i, 10)]] scanFloat:&temp];
            receivedWifiData.spectrumData[i]= temp;
        }

    }

}


- (void)releaseFFT
{
    fft *fftAlgorism = [[fft alloc] init];
    [fftAlgorism FFTHelperRelease:fftConverter];
}

@end
