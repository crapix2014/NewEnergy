//
//  BNRItemStore.h
//  HomePwner
//
//  Created by John Gallagher on 1/7/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
@interface ItemStore : NSObject

//@property (nonatomic, readonly) NSArray *allItems;
@property (nonatomic, readonly) Item *item;
// Notice that this is a class method and prefixed with a + instead of a -
+ (instancetype)sharedStore;
- (Item *)createItem:(Item *)item;
- (void)removeItem:(Item *)item;
@end
