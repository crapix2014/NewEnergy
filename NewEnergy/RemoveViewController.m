//
//  RemoveViewController.m
//  Emanager
//
//  Created by newenergy on 12/31/14.
//  Copyright (c) 2014 New Energy. All rights reserved.
//

#import "RemoveViewController.h"

@interface RemoveViewController ()
@property UITextField *text5;
@end

@implementation RemoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:0.592157 green:0.760784 blue:1 alpha:1];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height-self.navigationController.navigationBar.frame.origin.y-self.navigationController.navigationBar.frame.size.height;
    float originY=self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
    
    CGRect text5Rect=CGRectMake(width*0.1, height*0.5+originY+width*0.18, width*0.8, width*0.09);
    _text5=[[UITextField alloc] initWithFrame:text5Rect];
    _text5.backgroundColor=[UIColor whiteColor];
    _text5.placeholder=@"请输入WIFI加密模式";
    [self.view addSubview:_text5];
    
    CGRect button1Rect=CGRectMake(width*0.1, height*0.75+originY, width*0.8, width*0.09);
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setFrame:button1Rect];
    [button1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"保存设置" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor colorWithRed:0.219608 green:0.45098 blue:0.996078 alpha:1]];
    [self.view addSubview:button1];
    
    NSTimer *theTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(buttonPressed:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:theTimer forMode:NSRunLoopCommonModes];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonPressed:(id)sender{
    @try {
        NSDate* currentDate = [NSDate date];
        [_text5 setText:currentDate.description];
        NSLog(@"time:%@",[currentDate.description substringWithRange:NSMakeRange(17,2)]);

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
