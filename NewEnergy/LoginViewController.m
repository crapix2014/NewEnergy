//
//  LoginViewController.m
//  Emanager
//
//  Created by newenergy on 12/31/14.
//  Copyright (c) 2014 New Energy. All rights reserved.
//

#import "LoginViewController.h"
#import "DeviceViewController.h"
#import "SignupViewController.h"
#import "SocketClient.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "Item.h"
#import "ItemStore.h"
#import "AboutViewController.h"
#import "FindpwViewController.h"
#import "Reachability.h"
#import "NetConfigViewController.h"
@interface LoginViewController ()
@property UITextField *usernameText;
@property UITextField *passwordText;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"电器管家";
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]
                                           initWithTitle:@"返回"
                                           style:UIBarButtonItemStylePlain
                                           target:nil
                                           action:nil];
    
    self.view.backgroundColor=[UIColor colorWithRed:0.592157 green:0.760784 blue:1 alpha:1];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height-self.navigationController.navigationBar.frame.origin.y-self.navigationController.navigationBar.frame.size.height;
    float originY=self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
    
    CGRect imageRect=CGRectMake(width*0.375, height*0.1+originY, width*0.25, width*0.25);
    UIImage *image= [UIImage imageNamed:@"Image02"];
    UIImage *roundimage=[self roundCorneredImage:image radius:width*0.03];
    UIImageView *imageMarker =[[UIImageView alloc] initWithImage:roundimage];
    [imageMarker setFrame:imageRect];
    [self.view addSubview:imageMarker];
    
    CGRect usernameLabelRect=CGRectMake(width*0.1, height*0.33+originY, width*0.2, width*0.09);
    UILabel *usernameLabel=[[UILabel alloc] initWithFrame:usernameLabelRect];
    [usernameLabel setText:@"用户名"];
    [usernameLabel setTextAlignment:NSTextAlignmentCenter];
    usernameLabel.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:usernameLabel];
    
    CGRect usernameTextRect=CGRectMake(width*0.3, height*0.33+originY, width*0.6, width*0.09);
    _usernameText=[[UITextField alloc] initWithFrame:usernameTextRect];
    _usernameText.backgroundColor=[UIColor whiteColor];
    _usernameText.placeholder=@"请输入用户名";
    [_usernameText setReturnKeyType:UIReturnKeyDone];
    [_usernameText addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:_usernameText];
    
    CGRect passwordLabelRect=CGRectMake(width*0.1, height*0.33+width*0.09+originY, width*0.2, width*0.09);
    UILabel *passwordLabel=[[UILabel alloc] initWithFrame:passwordLabelRect];
    [passwordLabel setText:@"密码"];
    [passwordLabel setTextAlignment:NSTextAlignmentCenter];
    passwordLabel.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:passwordLabel];
    
    CGRect passwordTextRect=CGRectMake(width*0.3, height*0.33+width*0.09+originY, width*0.6, width*0.09);
    _passwordText=[[UITextField alloc] initWithFrame:passwordTextRect];
    _passwordText.backgroundColor=[UIColor whiteColor];
    _passwordText.placeholder=@"请输入密码";
    [_passwordText setSecureTextEntry:YES];
    [_passwordText setReturnKeyType:UIReturnKeyDone];
    [_passwordText addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:_passwordText];
    
    CGRect loginButtonRect=CGRectMake(width*0.1, height*0.5+originY, width*0.8, width*0.09);
    UIButton *loginButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [loginButton setFrame:loginButtonRect];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithRed:0.219608 green:0.45098 blue:0.996078 alpha:1]];
    [self.view addSubview:loginButton];
    
    CGRect signupButtonRect=CGRectMake(width*0.1, height*0.63+originY, width*0.1, width*0.09);
    UIButton *signupButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [signupButton setFrame:signupButtonRect];
    [signupButton addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
    [signupButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:signupButton];
    
    CGRect findpwButtonRect=CGRectMake(width*0.25, height*0.63+originY, width*0.2, width*0.09);
    UIButton *findpwButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [findpwButton setFrame:findpwButtonRect];
    [findpwButton addTarget:self action:@selector(findpw:) forControlEvents:UIControlEventTouchUpInside];
    [findpwButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.view addSubview:findpwButton];
    
    CGRect setButtonRect=CGRectMake(width*0.5, height*0.63+originY, width*0.2, width*0.09);
    UIButton *setButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [setButton setFrame:setButtonRect];
    [setButton addTarget:self action:@selector(setButton:) forControlEvents:UIControlEventTouchUpInside];
    [setButton setTitle:@"网络设置" forState:UIControlStateNormal];
    [self.view addSubview:setButton];
    
    CGRect aboutButtonRect=CGRectMake(width*0.75, height*0.63+originY, width*0.1, width*0.09);
    UIButton *aboutButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [aboutButton setFrame:aboutButtonRect];
    [aboutButton addTarget:self action:@selector(about:) forControlEvents:UIControlEventTouchUpInside];
    [aboutButton setTitle:@"关于" forState:UIControlStateNormal];
    [self.view addSubview:aboutButton];
}

-(void)viewWillAppear:(BOOL)animated{
    _usernameText.text=@"new@google.com";
    _passwordText.text=@"new@google.com";
}

- (void)login:(id)sender{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"网络不可用"
                                                   message:@"请检查您的网络设置"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
        [a show];
        return;
    }
    
    NSString *hostIP=@"120.24.72.241";
    NSString *port;
    NSString *connStr=[[NSString alloc] initWithFormat:@"%@%@%@",@"{\"cmd\":204,\"num\":6,\"UID\":\"",_usernameText.text,@"\",\"VER\":2010,\"APPTYPE\":\"IOS\"}"];
    SocketClient *sc = [[SocketClient alloc] initWithAddress:hostIP andPort:56666];
    if (!sc) {
        UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"网络不可用"
                                                   message:@"请检查您的网络设置"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
        [a show];

        return;
    }
        NSString *connrecv = [sc writtenToSocketWithString:connStr];
        NSData *conndata = [connrecv dataUsingEncoding:NSUTF8StringEncoding];
        id connjson = [NSJSONSerialization JSONObjectWithData:conndata options:0 error:nil];
        port=[connjson valueForKey:@"RPORT"];
        NSLog(@"conn recv: %@", connrecv);
    if (![[[connjson valueForKey:@"code"] stringValue] isEqualToString:@"0"]) {
        UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                   message:@"请检查用户名或密码是否正确"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
        [a show];
        return;
    }
    
    NSString *loginStr=[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"{\"cmd\":201,\"num\":6,\"UID\":\"",_usernameText.text,@"\",\"PW\":\"",_passwordText.text,@"\"}\n"];
    sc = [[SocketClient alloc] initWithAddress:hostIP andPort:[port intValue]];
       NSString *loginrecv = [sc writtenToSocketWithString:loginStr];
       NSData *logindata = [loginrecv dataUsingEncoding:NSUTF8StringEncoding];
        id loginjson = [NSJSONSerialization JSONObjectWithData:logindata options:0 error:nil];
        //NSLog(@"login recv: %@",[json valueForKey:@"RPORT"]);
        NSLog(@"login recv: %@",loginrecv);
    if (![[[loginjson valueForKey:@"code"] stringValue] isEqualToString:@"0"]){
        UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                   message:@"请检查用户名或密码是否正确"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
        [a show];
        return;
    }
    
    //NSLog(@"-------tid:%@",[json valueForKey:@"tid"]);
    Item *constantItem = [[Item alloc] initWithStr1:@""];
    [constantItem setTid:[loginjson valueForKey:@"tid"]];
    [constantItem setIp:hostIP];
    [constantItem setPort:port];
    [constantItem setLoginStr:loginStr];
    [constantItem setUsername:_usernameText.text];
    [[ItemStore sharedStore] createItem:constantItem];
    //NSLog(@"-----------ItemStore sharedStore allItems:%@",[[ItemStore sharedStore] item].tid);
    
    NSArray *array=[loginjson valueForKey:@"data"];
    for (int i=0; i<[array count]; i++) {
        NSLog(@"i:%@",array[i]);
        BNRItem *item =[[BNRItem alloc] initWithName:[array[i] valueForKey:@"N"]];
        [item setM:[array[i] valueForKey:@"M"]];
        [item setS:[array[i] valueForKey:@"S"]];
        [item setIP:hostIP];
        [item setPort:port];
        [item setLoginStr:loginStr];
        [item setTid:[loginjson valueForKey:@"tid"]];
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
    [self.navigationController pushViewController:dVC animated:YES];

}

- (void)textFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

- (void)signup:(id)sender{
    SignupViewController *suVC=[[SignupViewController alloc] init];
    [self.navigationController pushViewController:suVC animated:YES];
}

- (void)findpw:(id)sender{
    FindpwViewController *fVC=[[FindpwViewController alloc] init];
    [self.navigationController pushViewController:fVC animated:YES];
}

- (void)about:(id)sender{
    AboutViewController *aVC=[[AboutViewController alloc] init];
    aVC.flag = @"fromLogin";
    [self.navigationController pushViewController:aVC animated:YES];
}

- (void)setButton:(id)sender{
    NetConfigViewController *nVC = [[NetConfigViewController alloc] init];
    nVC.flag = @"fromLogin";
    [self.navigationController pushViewController:nVC animated:YES];
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

-(NSString *)subStringWithSource:(NSString *)sourceStr startWith:(NSString *)start endWith:(NSString *)end{
    @try {
        NSRange divRange = [sourceStr rangeOfString:start options:NSCaseInsensitiveSearch];
        if (divRange.location != NSNotFound)
        {
            NSRange endDivRange;
            
            endDivRange.location = divRange.length + divRange.location;
            endDivRange.length   = [sourceStr length] - endDivRange.location;
            endDivRange = [sourceStr rangeOfString:end options:NSCaseInsensitiveSearch range:endDivRange];
            
            if (endDivRange.location != NSNotFound)
            {
                divRange.location += divRange.length;
                divRange.length  = endDivRange.location - divRange.location;
                
                
                //NSLog(@"subString: %@",[sourceStr substringWithRange:divRange]);
                return [sourceStr substringWithRange:divRange];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return nil;
}

@end
