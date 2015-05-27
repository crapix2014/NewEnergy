//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Joe Conway on 10/12/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "BNRItem.h"
@interface BNRItem ()

@property (nonatomic, strong) NSDate *dateCreated;

@end

@implementation BNRItem

- (id)initWithName:(NSString *)name
{
    // Call the superclass's designated initializer
    self = [super init];
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        self.N = name;
    }
    
    // Return the address of the newly initialized object
    return self;
}
/*
- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@,%@,%@",self.N,self.S,self.T1];
    return descriptionString;
}*/

- (void)dealloc
{
    //NSLog(@"Destroyed: %@", self);
}

@end
