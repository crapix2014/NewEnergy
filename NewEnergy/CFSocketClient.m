//
//  CFSocketClient.m
//  EchoTcpClientCFSocket
//
//  Created by Jon Hoffman on 4/19/13.
//  Copyright (c) 2013 Jon Hoffman. All rights reserved.
//

#import "CFSocketClient.h"
#import <CoreFoundation/CFSocket.h>
#include <sys/socket.h>
#include <netinet/in.h>
#import <arpa/inet.h>

@implementation CFSocketClient

-(instancetype)initWithAddress:(NSString *)addr andPort:(int)port  {
    
    self.sockfd = CFSocketCreate(NULL, AF_INET, SOCK_STREAM, IPPROTO_TCP,
                                 0, NULL,NULL);
    if (self.sockfd == NULL)
        self.errorCode = SOCKETERROR;
    else {
        
        struct sockaddr_in servaddr;
        memset(&servaddr, 0, sizeof(servaddr));
        servaddr.sin_len = sizeof(servaddr);
        servaddr.sin_family = AF_INET;
        servaddr.sin_port = htons(port);
        inet_pton(AF_INET, [addr cStringUsingEncoding:NSUTF8StringEncoding], &servaddr.sin_addr);
        CFDataRef connectAddr = CFDataCreate(NULL, (unsigned char *)&servaddr, sizeof(servaddr));
        if (connectAddr == NULL)
            self.errorCode = CONNECTERROR;
        else {
            if (CFSocketConnectToAddress(self.sockfd, connectAddr, 30) != kCFSocketSuccess)
                self.errorCode = CONNECTERROR;
        }
    }
    return self;
}

-(NSString *) writtenToSocket:(CFSocketRef)sockfdNum withChar:(NSString *)vptr
{
    
    char buffer[MAXLINE]="";
    
    CFSocketNativeHandle sock = CFSocketGetNative(sockfdNum);
    const char *mess = [vptr cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"----mess:%s", mess);
    send(sock, mess, strlen(mess)+1, 0);
    recv(sock, buffer, sizeof(buffer), 0);
    NSLog(@"----buffer:%s", buffer);
    return [NSString stringWithUTF8String:buffer];
}

-(void)dealloc {
    if (self.sockfd != NULL) {
        CFSocketInvalidate(self.sockfd);
        CFRelease(self.sockfd);
        self.sockfd = NULL;
    }

}

@end
