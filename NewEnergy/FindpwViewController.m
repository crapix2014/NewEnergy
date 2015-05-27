//
//  FindpwViewController.m
//  Emanager
//
//  Created by newenergy on 12/26/14.
//  Copyright (c) 2014 New Energy. All rights reserved.
//

#import "FindpwViewController.h"
#import "SocketClient.h"
#import <AVFoundation/AVFoundation.h>
@interface FindpwViewController ()
@property UITextField *usernameText;
@end

@implementation FindpwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"找回密码";
    
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
    _usernameText.placeholder=@"请输入邮箱找回密码";
    [_usernameText setReturnKeyType:UIReturnKeyDone];
    [_usernameText addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:_usernameText];
    
    CGRect loginButtonRect=CGRectMake(width*0.1, height*0.43+originY, width*0.8, width*0.09);
    UIButton *loginButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [loginButton setFrame:loginButtonRect];
    [loginButton addTarget:self action:@selector(findpw:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"找回密码" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithRed:0.219608 green:0.45098 blue:0.996078 alpha:1]];
    [self.view addSubview:loginButton];
    
    [self loadBeepSound];

}

-(void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSLog(@"bundle:%@",[NSBundle mainBundle]);
    NSError *error;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        // If the audio player cannot be initialized then log a message.
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        // If the audio player was successfully initialized then load it in memory.
        [audioPlayer prepareToPlay];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

- (void)findpw:(id)sender{
    NSString *findStr=[[NSString alloc] initWithFormat:@"%@%@%@",@"{\"cmd\":203,\"num\":6,\"UID\":\"",_usernameText.text,@"\"}\n"];
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
    NSString *recv = [sc writtenToSocketWithString:findStr];
    NSLog(@"find recv: %@",recv);
    id findjson = [NSJSONSerialization JSONObjectWithData:[recv dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSString *code = [[findjson valueForKey:@"code"] stringValue];
    if([code isEqualToString:@"0"]){
        UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"重置密码链接已发送至您的邮箱"
                                                   message:@"请在邮箱查看并打开链接"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
        [a show];
    } else {
        UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"找回密码失败"
                                                   message:@"请确认用户是否存在"
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
