//
//  BNRItemStore.m
//  HomePwner
//
//  Created by John Gallagher on 1/7/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "ItemStore.h"
#import "Item.h"

@interface ItemStore ()

//@property (nonatomic) NSMutableArray *privateItems;
@property (nonatomic) Item *privateItem;
@end

@implementation ItemStore

+ (instancetype)sharedStore
{
    static ItemStore *sharedStore;

    // Do I need to create a sharedStore?
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }

    return sharedStore;
}

// If a programmer calls [[BNRItemStore alloc] init], let him
// know the error of his ways
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BNRItemStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

// Here is the real (secret) initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        //_privateItems = [[NSMutableArray alloc] init];
        _privateItem = [[ Item alloc] init];
    }
    return self;
}

/*- (NSArray *)allItems
{
    //return [self.privateItems copy];
    return [self.privateItem copy];
}*/

- (Item *)item
{
    //return [self.privateItem copy];
    return self.privateItem;
}

- (Item *)createItem: (Item *) item
{
    //[self.privateItems addObject:item];
    self.privateItem = item;
    return item;
}

- (void)removeItem:(Item *)item
{
    //[self.privateItems removeObjectIdenticalTo:item];
}

@end
