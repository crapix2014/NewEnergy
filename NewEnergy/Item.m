//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Joe Conway on 10/12/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "Item.h"
@interface Item ()

@end

@implementation Item

- (id)initWithStr1:(NSString *)str1
{
    // Call the superclass's designated initializer
    self = [super init];
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        self.str1 = str1;
        
    }
    
    // Return the address of the newly initialized object
    return self;
}

/*
- (id)init {
    return [self initWithItemName:@"Item"
                     serialNumber:@""];
}*/

/*
- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@",self.str1];
    return descriptionString;
}*/

- (void)dealloc
{
    //NSLog(@"Destroyed: %@", self);
}

@end
