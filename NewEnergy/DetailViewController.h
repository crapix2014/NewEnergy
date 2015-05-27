//
//  DetailViewController.h
//  Emanager
//
//  Created by newenergy on 12/31/14.
//  Copyright (c) 2014 New Energy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNRItem.h"
#import "JMPickerView.h"
@interface DetailViewController : UIViewController<JMPickerViewDelegate>
@property (nonatomic, strong) BNRItem *item;
@end

