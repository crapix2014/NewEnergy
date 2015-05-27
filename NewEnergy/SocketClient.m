//
//  SocketClient.m
//  Socket
//
//  Created by newenergy on 1/24/15.
//  Copyright (c) 2015 newenergy. All rights reserved.
//

#import "SocketClient.h"
#include<stdio.h>
#include<string.h>    //strlen
#include<sys/socket.h>
#include<arpa/inet.h> //inet_addr
@implementation SocketClient
int socket_desc;
-(instancetype)initWithAddress:(NSString *)addr andPort:(int)port  {
    struct sockaddr_in server;
    
    //Create socket
    socket_desc = socket(AF_INET , SOCK_STREAM , 0);
    if (socket_desc == -1)
    {
        NSLog(@"Could not create socket");
        return nil;
    }
    
    server.sin_addr.s_addr = inet_addr([addr cStringUsingEncoding:NSUTF8StringEncoding]);
    server.sin_family = AF_INET;
    server.sin_port = htons(port);
    
    //Connect to remote server
    if (connect(socket_desc , (struct sockaddr *)&server , sizeof(server)) < 0)
    {
        puts("connect error");
        return nil;
    }
    
    //puts("Login Connected\n");
    
    return self;
}

-(NSString *)writtenToSocketWithString:(NSString *)request{
    const char *message = "";
    char server_reply[4000] = "";
    message = [request UTF8String];
    if( send(socket_desc , message , strlen(message) , 0) < 0)
    {
        puts("Send failed");
        return nil;
    }
    //puts("Data Send\n");
    //NSLog(@"-------message:%s",message);
    //Receive a reply from the server
    if( recv(socket_desc, server_reply , 2000 , 0) < 0)
    {
        puts("recv failed");
    }
    //puts("Reply received\n");
    //puts(server_reply);
    char *end = strrchr(server_reply, '}');
    if (end){
        int e=end-server_reply+1;
        char dest[e+1];
        memcpy( dest, &server_reply[0],e);
        dest[e] = '\0';
        return [NSString stringWithUTF8String:dest];
    }else {
        return nil;
    }

}
@end
