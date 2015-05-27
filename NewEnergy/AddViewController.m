//
//  AddViewController.m
//  Emanager
//
//  Created by newenergy on 1/13/15.
//  Copyright (c) 2015 New Energy. All rights reserved.
//

#import "AddViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "Item.h"
#import "ItemStore.h"
#import "DeviceViewController.h"
#import "DEMONavigationController.h"
#import "UIViewController+REFrostedViewController.h"
#import "LoginViewController.h"
#import "SocketClient.h"
@interface AddViewController ()
@property UITextField *usernameText;
@end

@implementation AddViewController

-(void)loadView{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.592157 green:0.760784 blue:1 alpha:1]];
    float width = self.view.frame.size.width; //320
    float height = self.view.frame.size.height-self.navigationController.navigationBar.frame.origin.y-self.navigationController.navigationBar.frame.size.height; //504=568-20-44
    float originY=self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height; //64
    //NSLog(@"w:%f,h:%f,y:%f",width,height,originY);
    
    CGRect imageRect=CGRectMake(width*0.375, height*0.05+originY, width*0.25, width*0.25);
    UIImage *image= [UIImage imageNamed:@"Image02"];
    UIImage *roundimage=[self roundCorneredImage:image radius:width*0.03];
    UIImageView *imageMarker =[[UIImageView alloc] initWithImage:roundimage];
    [imageMarker setFrame:imageRect];
    [self.view addSubview:imageMarker];
    
    CGRect usernameLabelRect=CGRectMake(width*0.1, height*(1/(float)3)+originY, width*0.3, height*(30/(float)568));
    UILabel *usernameLabel=[[UILabel alloc] initWithFrame:usernameLabelRect];
    [usernameLabel setText:@"设备标识"];
    [usernameLabel setTextAlignment:NSTextAlignmentCenter];
    usernameLabel.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:usernameLabel];
    
    CGRect usernameTextRect=CGRectMake(width*0.4, height*(1/(float)3)+originY, width*0.5, height*(30/(float)568));
    _usernameText=[[UITextField alloc] initWithFrame:usernameTextRect];
    _usernameText.backgroundColor=[UIColor whiteColor];
    _usernameText.placeholder=@"请输入设备标识";
    [_usernameText setReturnKeyType:UIReturnKeyDone];
    [_usernameText addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:_usernameText];
    
    CGRect passwordLabelRect=CGRectMake(width*0.1, height*((1/(float)3+30/(float)568))+originY, width*0.3, height*(30/(float)568));
    UILabel *passwordLabel=[[UILabel alloc] initWithFrame:passwordLabelRect];
    [passwordLabel setText:@"设备别名"];
    [passwordLabel setTextAlignment:NSTextAlignmentCenter];
    passwordLabel.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:passwordLabel];
    
    CGRect passwordTextRect=CGRectMake(width*0.4, height*((1/(float)3+30/(float)568))+originY, width*0.5, height*(30/(float)568));
    UITextField *passwordText=[[UITextField alloc] initWithFrame:passwordTextRect];
    passwordText.backgroundColor=[UIColor whiteColor];
    passwordText.placeholder=@"请输入设备别名";
    [passwordText setReturnKeyType:UIReturnKeyDone];
    [passwordText addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:passwordText];
    
    CGRect signupButtonRect=CGRectMake(width*0.1, height*((1/(float)3+3*30/(float)568))+originY, width*0.8, height*(30/(float)568));
    UIButton *signupButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [signupButton setFrame:signupButtonRect];
    [signupButton addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
    [signupButton setTitle:@"添加设备" forState:UIControlStateNormal];
    [signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signupButton setBackgroundColor:[UIColor colorWithRed:0.219608 green:0.45098 blue:0.996078 alpha:1]];
    [self.view addSubview:signupButton];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(DEMONavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

- (void)signup:(id)sender{
    Item *itemInStore = [[ItemStore sharedStore] item];
    NSString *str=[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"{\"data\":[{\"M\":\"",_usernameText.text,@"\"}],\"cmd\":207,\"num\":6,\"tid\":",itemInStore.tid,@"}\n"];
    NSArray *array=[[BNRItemStore sharedStore] allItems];
    SocketClient *sc = [[SocketClient alloc] initWithAddress:itemInStore.ip andPort:[itemInStore.port intValue]];
    if (!sc) {
        UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"网络不可用"
                                                   message:@"请检查您的网络设置"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
        [a show];
        
        return;
    }
    [sc writtenToSocketWithString:itemInStore.loginStr];
    NSString *addrecv = [sc writtenToSocketWithString:str];
    id addjson = [NSJSONSerialization JSONObjectWithData:[addrecv dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSString *code = [[addjson valueForKey:@"code"] stringValue];
    if([code isEqualToString:@"0"]){
        UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"设备添加成功"
                                                   message:@"返回设备列表"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
        [a show];
    } else {
        UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"设备添加失败"
                                                   message:@"设备不存在或已被绑定"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
        [a show];
        return;

    }

    //remove all devices in table view
    for (int i=0; i<[array count]; i++){
        [[BNRItemStore sharedStore] removeItem:array[i]];
    }
    
    NSString *recv = [sc writtenToSocketWithString:itemInStore.loginStr]; //update device list
    NSLog(@"add device login recv:%@",recv);
    NSData *data = [recv dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    array=[json valueForKey:@"data"];
    for (int i=0; i<[array count]; i++) {
        //NSLog(@"add device i:%@",array[i]);
        BNRItem *item =[[BNRItem alloc] initWithName:[array[i] valueForKey:@"N"]];
        [item setM:[array[i] valueForKey:@"M"]];
        [item setS:[array[i] valueForKey:@"S"]];
        [item setIP:itemInStore.ip];
        [item setPort:itemInStore.port];
        [item setLoginStr:itemInStore.loginStr];
        [item setTid:[json valueForKey:@"tid"]];
        if ([[[array[i] valueForKey:@"S"] substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"1"]){
            [item setT1:[[array[i] valueForKey:@"T1"] stringValue]];
            [item setT2:[[array[i] valueForKey:@"T2"] stringValue]];
            [item setT3:[[array[i] valueForKey:@"T3"] stringValue]];
            [item setT4:[[array[i] valueForKey:@"T4"] stringValue]];
            [item setT5:[[array[i] valueForKey:@"T5"] stringValue]];
            [item setT:[array[i] valueForKey:@"T"]];
            [item setET1:[array[i] valueForKey:@"ET1"]];
            [item setET2:[array[i] valueForKey:@"ET2"]];
            [item setET3:[array[i] valueForKey:@"ET3"]];
            [item setLT:[[array[i] valueForKey:@"LT"] stringValue]];
            [item setHT:[[array[i] valueForKey:@"HT"] stringValue]];
        }
        [[BNRItemStore sharedStore] createItem:item];
    }


    DeviceViewController *dVC=[[DeviceViewController alloc] init];
    DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:dVC];
    self.frostedViewController.contentViewController = navigationController;

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
