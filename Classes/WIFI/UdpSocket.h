//
//  UdpSocket.h
//  MINILOC
//
//  Created by Xiangyi Xu on 11/21/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
#import "Singleton.h"

@interface UdpSocket : NSObject <GCDAsyncUdpSocketDelegate>

{
  GCDAsyncUdpSocket *udpReceiveSocket;
  GCDAsyncUdpSocket *udpSendSocket;
}

@property (nonatomic, copy)NSString * clientIP;
@property (nonatomic, assign)uint16_t clientPort;

/** Timer */
@property (nonatomic, strong) NSTimer *timer;

/* WIFIDataStructure. */

typedef struct
{
  float spectrumData[1000];
  float inViewData[1000];
}WIFIDATA;


SingletonH(UdpSocket)

- (void)initSocket;
- (void)initFFT;
- (void)udpConnect;
- (void)udpDisconnect;
- (void)sendMessage:(NSString *)message;
- (void)releaseFFT;

@end
