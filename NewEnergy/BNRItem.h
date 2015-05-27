//
//  BNRItem.h
//  RandomPossessions
//
//  Created by Joe Conway on 10/12/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject

- (instancetype)initWithName:(NSString *)name;

@property (nonatomic, copy) NSString *M;    //id
@property (nonatomic, copy) NSString *N;    //name
@property (nonatomic, copy) NSString *T1;   //temperature
@property (nonatomic, copy) NSString *T2;
@property (nonatomic, copy) NSString *T3;
@property (nonatomic, copy) NSString *T4;
@property (nonatomic, copy) NSString *T5;
@property (nonatomic, copy) NSString *HT;   //up tempe
@property (nonatomic, copy) NSString *LT;   //low tempe
@property (nonatomic, copy) NSString *T;    //time
@property (nonatomic, copy) NSString *ET1;
@property (nonatomic, copy) NSString *ET2;
@property (nonatomic, copy) NSString *ET3;
@property (nonatomic, copy) NSString *S;    //state
@property (nonatomic, copy) NSString *ER;   //warn
@property (nonatomic, copy) NSString *port;
@property (nonatomic, copy) NSString *IP;
@property (nonatomic, copy) NSString *loginStr;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *scannedStr;
@end
