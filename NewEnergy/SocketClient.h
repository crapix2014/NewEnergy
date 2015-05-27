//
//  SocketClient.h
//  Socket
//
//  Created by newenergy on 1/24/15.
//  Copyright (c) 2015 newenergy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketClient : NSObject
-(instancetype)initWithAddress:(NSString *)addr andPort:(int)port;
-(NSString *) writtenToSocketWithString:(NSString *)vptr;
@end
