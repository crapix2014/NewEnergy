//
//  SignupViewController.m
//  Emanager
//
//  Created by newenergy on 12/26/14.
//  Copyright (c) 2014 New Energy. All rights reserved.
//

#import "SignupViewController.h"
#import "SocketClient.h"
@interface SignupViewController ()
@property UITextField *usernameText;
@property UITextField *passwordText;
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"注册用户";
    
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
    [usernameLabel setText:@"邮箱"];
    [usernameLabel setTextAlignment:NSTextAlignmentCenter];
    usernameLabel.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:usernameLabel];
    
    CGRect usernameTextRect=CGRectMake(width*0.3, height*0.33+originY, width*0.6, width*0.09);
    _usernameText=[[UITextField alloc] initWithFrame:usernameTextRect];
    _usernameText.backgroundColor=[UIColor whiteColor];
    _usernameText.placeholder=@"请输入邮箱";
    [_usernameText setReturnKeyType:UIReturnKeyDone];
    [_usernameText addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:_usernameText];
    
    CGRect passwordLabelRect=CGRectMake(width*0.1, height*0.33+originY+width*0.09, width*0.2, width*0.09);
    UILabel *passwordLabel=[[UILabel alloc] initWithFrame:passwordLabelRect];
    [passwordLabel setText:@"密码"];
    [passwordLabel setTextAlignment:NSTextAlignmentCenter];
    passwordLabel.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:passwordLabel];
    
    CGRect passwordTextRect=CGRectMake(width*0.3, height*0.33+originY+width*0.09, width*0.6, width*0.09);
    _passwordText=[[UITextField alloc] initWithFrame:passwordTextRect];
    _passwordText.backgroundColor=[UIColor whiteColor];
    _passwordText.placeholder=@"请输入密码";
    [_passwordText setSecureTextEntry:YES];
    [_passwordText setReturnKeyType:UIReturnKeyDone];
    [_passwordText addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:_passwordText];
    
    CGRect rpasswordLabelRect=CGRectMake(width*0.1, height*0.33+originY+width*0.18, width*0.2, width*0.09);
    UILabel *rpasswordLabel=[[UILabel alloc] initWithFrame:rpasswordLabelRect];
    [rpasswordLabel setText:@"密码"];
    [rpasswordLabel setTextAlignment:NSTextAlignmentCenter];
    rpasswordLabel.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:rpasswordLabel];
    
    CGRect rpasswordTextRect=CGRectMake(width*0.3, height*0.33+originY+width*0.18, width*0.6, width*0.09);
    UITextField *rpasswordText=[[UITextField alloc] initWithFrame:rpasswordTextRect];
    rpasswordText.backgroundColor=[UIColor whiteColor];
    rpasswordText.placeholder=@"请再次输入密码";
    [rpasswordText setSecureTextEntry:YES];
    [rpasswordText setReturnKeyType:UIReturnKeyDone];
    [rpasswordText addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:rpasswordText];
    
    CGRect signupButtonRect=CGRectMake(width*0.1, height*0.33+originY+width*0.36, width*0.8, width*0.09);
    UIButton *signupButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [signupButton setFrame:signupButtonRect];
    [signupButton addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
    [signupButton setTitle:@"注册" forState:UIControlStateNormal];
    [signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signupButton setBackgroundColor:[UIColor colorWithRed:0.219608 green:0.45098 blue:0.996078 alpha:1]];
    [self.view addSubview:signupButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

- (void)signup:(id)sender{
    NSString *signupStr=[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"{\"cmd\":202,\"num\":6,\"UID\":\"",_usernameText.text,@"\",\"PW\":\"",_passwordText.text,@"\"}\n"];
    SocketClient *sc = [[SocketClient alloc] initWithAddress:@"120.24.70.175" andPort:56666];
    if (!sc) {
        UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"网络不可用"
                                                   message:@"请检查您的网络设置"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
        [a show];
        
        return;
    }
    NSString *recv = [sc writtenToSocketWithString:signupStr];
    NSLog(@"signup recv: %@",recv);
    id signupjson = [NSJSONSerialization JSONObjectWithData:[recv dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSString *code = [[signupjson valueForKey:@"code"] stringValue];
    if([code isEqualToString:@"0"]){
        UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"注册成功"
                                                   message:@"返回登陆界面"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
        [a show];
    } else {
        UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"注册失败"
                                                   message:@"请确认用户是否已经存在"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
        [a show];
        return;
        
    }

    [self.navigationController popToRootViewControllerAnimated:YES];

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
