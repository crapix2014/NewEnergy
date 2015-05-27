//
//  BNRItem.h
//  RandomPossessions
//
//  Created by Joe Conway on 10/12/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

- (instancetype)initWithStr1:(NSString *)str1;

@property (nonatomic, copy) NSString *str1;    //id
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *port;
@property (nonatomic, copy) NSString *loginStr;
@property (nonatomic, copy) NSString *username;
@end
