//
//  NetConfigViewController.m
//  Emanager
//
//  Created by newenergy on 12/30/14.
//  Copyright (c) 2014 New Energy. All rights reserved.
//

#import "NetConfigViewController.h"
#import "SettingsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "Item.h"
#import "ItemStore.h"
#import "CFSocketClient.h"
#import "ScanViewController.h"
#import "DEMONavigationController.h"
@interface NetConfigViewController ()
@property UITextField *text1;
@property UITextField *text2;
@property UITextField *text3;
@property UITextField *text4;
@property UITextField *text5;
@end

@implementation NetConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.flag isEqualToString:@"fromMenu"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:(DEMONavigationController *)self.navigationController
                                                                                action:@selector(showMenu)];
    }else if ([self.flag isEqualToString:@"fromLogin"]){
        
    }
    
    self.view.backgroundColor=[UIColor colorWithRed:0.592157 green:0.760784 blue:1 alpha:1];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height-self.navigationController.navigationBar.frame.origin.y-self.navigationController.navigationBar.frame.size.height;
    float originY=self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
    
    CGRect imageRect=CGRectMake(width*0.375, height*0.05+originY, width*0.25, width*0.25);
    UIImage *image= [UIImage imageNamed:@"Image02"];
    UIImage *roundimage=[self roundCorneredImage:image radius:width*0.03];
    UIImageView *imageMarker =[[UIImageView alloc] initWithImage:roundimage];
    [imageMarker setFrame:imageRect];
    [self.view addSubview:imageMarker];
    
    CGRect buttonRect=CGRectMake(width*0.1, height*0.25+originY, width*0.8, width*0.09);
    UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:buttonRect];
    [button addTarget:self action:@selector(scanDevice:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"设备ID读取" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:0.219608 green:0.45098 blue:0.996078 alpha:1]];
    [self.view addSubview:button];
    
    CGRect label1Rect=CGRectMake(width*0.1, height*0.35+originY, width*0.3, width*0.09);
    UILabel *label1=[[UILabel alloc] initWithFrame:label1Rect];
    [label1 setText:@"设备标识"];
    [label1 setTextAlignment:NSTextAlignmentLeft];
    label1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:label1];
    
    CGRect text1Rect=CGRectMake(width*0.4, height*0.35+originY, width*0.5, width*0.09);
    _text1=[[UITextField alloc] initWithFrame:text1Rect];
    _text1.backgroundColor=[UIColor whiteColor];
    //_text1.placeholder=@"";
    //[_text1 setReturnKeyType:UIReturnKeyDone];
    //[_text1 addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_text1 setEnabled:NO];
    [self.view addSubview:_text1];
    
    CGRect label2Rect=CGRectMake(width*0.1, height*0.35+originY+width*0.09, width*0.3, width*0.09);
    UILabel *label2=[[UILabel alloc] initWithFrame:label2Rect];
    [label2 setText:@"AP"];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    label2.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:label2];
    
    CGRect text2Rect=CGRectMake(width*0.4, height*0.35+originY+width*0.09, width*0.5, width*0.09);
    _text2=[[UITextField alloc] initWithFrame:text2Rect];
    _text2.backgroundColor=[UIColor whiteColor];
    _text2.placeholder=@"请输入AP";
    [_text2 setEnabled:NO];
    [_text1 setReturnKeyType:UIReturnKeyDone];
    [_text1 addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:_text2];
    
    CGRect label3Rect=CGRectMake(width*0.1, height*0.5+originY, width*0.3, width*0.09);
    UILabel *label3=[[UILabel alloc] initWithFrame:label3Rect];
    [label3 setText:@"SSID"];
    [label3 setTextAlignment:NSTextAlignmentCenter];
    label3.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:label3];
    
    CGRect text3Rect=CGRectMake(width*0.4, height*0.5+originY, width*0.5, width*0.09);
    _text3=[[UITextField alloc] initWithFrame:text3Rect];
    _text3.backgroundColor=[UIColor whiteColor];
    _text3.placeholder=@"请输入SSID";
    [_text3 setReturnKeyType:UIReturnKeyDone];
    [_text3 addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:_text3];
    
    CGRect label4Rect=CGRectMake(width*0.1, height*0.5+originY+width*0.09, width*0.3, width*0.09);
    UILabel *label4=[[UILabel alloc] initWithFrame:label4Rect];
    [label4 setText:@"WIFI密码"];
    [label4 setTextAlignment:NSTextAlignmentCenter];
    label4.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:label4];
    
    CGRect text4Rect=CGRectMake(width*0.4, height*0.5+originY+width*0.09, width*0.5, width*0.09);
    _text4=[[UITextField alloc] initWithFrame:text4Rect];
    _text4.backgroundColor=[UIColor whiteColor];
    _text4.placeholder=@"请输入WIFI密码";
    [_text4 setReturnKeyType:UIReturnKeyDone];
    [_text4 addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:_text4];
    
    CGRect label5Rect=CGRectMake(width*0.1, height*0.5+originY+width*0.18, width*0.3, width*0.09);
    UILabel *label5=[[UILabel alloc] initWithFrame:label5Rect];
    [label5 setText:@"加密模式"];
    [label5 setTextAlignment:NSTextAlignmentCenter];
    label5.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:label5];
    
    CGRect text5Rect=CGRectMake(width*0.4, height*0.5+originY+width*0.18, width*0.5, width*0.09);
    _text5=[[UITextField alloc] initWithFrame:text5Rect];
    _text5.backgroundColor=[UIColor whiteColor];
    _text5.placeholder=@"请输入WIFI加密模式";
    [_text5 setReturnKeyType:UIReturnKeyDone];
    [_text5 addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:_text5];

    CGRect button1Rect=CGRectMake(width*0.1, height*0.75+originY, width*0.8, width*0.09);
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setFrame:button1Rect];
    [button1 addTarget:self action:@selector(saveSetting:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"保存设置" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor colorWithRed:0.219608 green:0.45098 blue:0.996078 alpha:1]];
    [self.view addSubview:button1];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    for (int i=0; i<[items count]; i++) {
        if ([items[i] scannedStr].length>27) {
            [_text1 setText:[[items[i] scannedStr] substringWithRange:NSMakeRange(0, 12)]];
            [_text2 setText:[[items[i] scannedStr] substringWithRange:NSMakeRange(12, 16)]];
        }
    }
}
- (void)scanDevice:(id)sender{
    ScanViewController *sVC=[[ScanViewController alloc] init];
    [sVC setTitle:@"读取设备"];
    [self.navigationController pushViewController:sVC animated:YES];
}

- (void)saveSetting:(id)sender{
    CFSocketClient *cf = [[CFSocketClient alloc] initWithAddress:@"192.168.66.1" andPort:5050];
    //CFSocketClient *cf = [[CFSocketClient alloc] initWithAddress:@"125.216.243.175" andPort:1008];
    //NSString *str = @"{\"M\":\"000C296163D3\",\"U\":0,\"S\":\"SSID\",\"K\":\"KEY\",\"E\":\"none\"}\n";
    _text2.text = @"0023CD033689";
    _text3.text = @"434_ST";
    _text4.text = @"123456789";
    _text5.text = @"psk2"; //WPA2
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@%@",@"{\"M\":\"",_text2.text,@"\",\"U\":0,\"S\":\"",_text3.text,@"\",\"K\":\"",_text4.text,@"\",\"E\":\"",_text5.text,@"\"}"];
    if (cf.errorCode == NOERROR) {
        NSString *recv = [cf writtenToSocket:cf.sockfd withChar:str];
        NSLog(@"--------------%@",recv);
        UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"保存成功"
                                                   message:@"返回设备列表"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
        [a show];
        return;
    } else {
        NSLog(@"%@",[NSString stringWithFormat:@"Error code %d recieved.  Could not connect.", cf.errorCode]);
        UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"保存失败"
                                                   message:@"请重试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
        [a show];
        return;
    }

    
    
}

- (void)textFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

- (UIImage*) roundCorneredImage: (UIImage*) orig radius:(CGFloat) r {
    UIGraphicsBeginImageContextWithOptions(orig.size, NO, 0);
    [[UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, orig.size}
                                cornerRadius:r] addClip];
    [orig drawInRect:(CGRect){CGPointZero, orig.size}];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}


@end
