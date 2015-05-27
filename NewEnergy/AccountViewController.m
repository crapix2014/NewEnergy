//
//  AccountViewController.m
//  Emanager
//
//  Created by newenergy on 1/13/15.
//  Copyright (c) 2015 New Energy. All rights reserved.
//

#import "AccountViewController.h"
#import "DEMONavigationController.h"
#import "SocketClient.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "Item.h"
#import "ItemStore.h"
#import "LoginViewController.h"
#import "REFrostedViewController.h"
@interface AccountViewController ()
@property UITextField *usernameText;
@property UITextField *rpasswordText;
@end

@implementation AccountViewController

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
    
    CGRect usernameLabelRect=CGRectMake(width*0.1, height*(1/(float)3)+originY, width*0.2, height*(30/(float)568));
    UILabel *usernameLabel=[[UILabel alloc] initWithFrame:usernameLabelRect];
    [usernameLabel setText:@"邮箱"];
    [usernameLabel setTextAlignment:NSTextAlignmentCenter];
    usernameLabel.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:usernameLabel];
    
    CGRect usernameTextRect=CGRectMake(width*0.3, height*(1/(float)3)+originY, width*0.6, height*(30/(float)568));
    _usernameText=[[UITextField alloc] initWithFrame:usernameTextRect];
    _usernameText.backgroundColor=[UIColor whiteColor];
    _usernameText.placeholder=@"请输入邮箱";
    [_usernameText setReturnKeyType:UIReturnKeyDone];
    [_usernameText addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:_usernameText];
    
    CGRect passwordLabelRect=CGRectMake(width*0.1, height*((1/(float)3+30/(float)568))+originY, width*0.2, height*(30/(float)568));
    UILabel *passwordLabel=[[UILabel alloc] initWithFrame:passwordLabelRect];
    [passwordLabel setText:@"旧密码"];
    [passwordLabel setTextAlignment:NSTextAlignmentCenter];
    passwordLabel.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:passwordLabel];
    
    CGRect passwordTextRect=CGRectMake(width*0.3, height*((1/(float)3+30/(float)568))+originY, width*0.6, height*(30/(float)568));
    UITextField *passwordText=[[UITextField alloc] initWithFrame:passwordTextRect];
    passwordText.backgroundColor=[UIColor whiteColor];
    passwordText.placeholder=@"请输入旧密码";
    [passwordText setSecureTextEntry:YES];
    [passwordText setReturnKeyType:UIReturnKeyDone];
    [passwordText addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:passwordText];
    
    CGRect rpasswordLabelRect=CGRectMake(width*0.1, height*((1/(float)3+2*30/(float)568))+originY, width*0.2, height*(30/(float)568));
    UILabel *rpasswordLabel=[[UILabel alloc] initWithFrame:rpasswordLabelRect];
    [rpasswordLabel setText:@"新密码"];
    [rpasswordLabel setTextAlignment:NSTextAlignmentCenter];
    rpasswordLabel.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:rpasswordLabel];
    
    CGRect rpasswordTextRect=CGRectMake(width*0.3, height*((1/(float)3+2*30/(float)568))+originY, width*0.6, height*(30/(float)568));
    _rpasswordText=[[UITextField alloc] initWithFrame:rpasswordTextRect];
    _rpasswordText.backgroundColor=[UIColor whiteColor];
    _rpasswordText.placeholder=@"请输入新密码";
    [_rpasswordText setSecureTextEntry:YES];
    [_rpasswordText setReturnKeyType:UIReturnKeyDone];
    [_rpasswordText addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:_rpasswordText];
    
    CGRect rnpasswordLabelRect=CGRectMake(width*0.1, height*((1/(float)3+3*30/(float)568))+originY, width*0.2, height*(30/(float)568));
    UILabel *rnpasswordLabel=[[UILabel alloc] initWithFrame:rnpasswordLabelRect];
    [rnpasswordLabel setText:@"新密码"];
    [rnpasswordLabel setTextAlignment:NSTextAlignmentCenter];
    rnpasswordLabel.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:rnpasswordLabel];
    
    CGRect rnpasswordTextRect=CGRectMake(width*0.3, height*((1/(float)3+3*30/(float)568))+originY, width*0.6, height*(30/(float)568));
    UITextField *rnpasswordText=[[UITextField alloc] initWithFrame:rnpasswordTextRect];
    rnpasswordText.backgroundColor=[UIColor whiteColor];
    rnpasswordText.placeholder=@"请确认新密码";
    [rnpasswordText setSecureTextEntry:YES];
    [rnpasswordText setReturnKeyType:UIReturnKeyDone];
    [rnpasswordText addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:rnpasswordText];
    
    CGRect signupButtonRect=CGRectMake(width*0.1, height*((1/(float)3+5*30/(float)568))+originY, width*0.8, height*(30/(float)568));
    UIButton *signupButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [signupButton setFrame:signupButtonRect];
    [signupButton addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
    [signupButton setTitle:@"更改注册信息" forState:UIControlStateNormal];
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
    NSString *str=[[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@",@"{\"data\":[{\"UID\":\"",_usernameText.text,@"\",\"PW\":\"",_rpasswordText.text,@"\"}],\"cmd\":219,\"num\":6,\"tid\":",itemInStore.tid,@"}\n"];
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
    NSString *recv = [sc writtenToSocketWithString:str];
    id json = [NSJSONSerialization JSONObjectWithData:[recv dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSLog(@"update recv: %@", [json valueForKey:@"code"]);
    NSString *code = [[json valueForKey:@"code"] stringValue];
    if([code isEqualToString:@"0"]){
        NSArray *itemsArray=[[BNRItemStore sharedStore] allItems];
        for (int i=0; i<[itemsArray count]; i++){
            [[BNRItemStore sharedStore] removeItem:itemsArray[i]];
        }
        UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"用户信息修改成功"
                                                   message:@"请重新登录"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
        [a show];
        LoginViewController *lVC=[[LoginViewController alloc] init];
        DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:lVC];
        self.frostedViewController.contentViewController = navigationController;
    }else {
        UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"用户信息修改失败"
                                                   message:@"请重新修改"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
        [a show];
        return;
    }
    
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
