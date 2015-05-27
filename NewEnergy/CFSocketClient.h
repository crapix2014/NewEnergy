//
//  CFSocketClient.h
//  EchoTcpClientCFSocket
//
//  Created by Jon Hoffman on 4/19/13.
//  Copyright (c) 2013 Jon Hoffman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BSDServerErrorCode) {
    NOERROR,
    SOCKETERROR,
    CONNECTERROR,
    READERROR,
    WRITEERROR
};

#define MAXLINE 4096

@interface CFSocketClient : NSObject

@property (nonatomic) CFSocketRef sockfd;
@property (nonatomic) int errorCode;

-(instancetype)initWithAddress:(NSString *)addr andPort:(int)port;

-(NSString *) writtenToSocket:(CFSocketRef)sockfdNum withChar:(NSString *)vptr;

@end
