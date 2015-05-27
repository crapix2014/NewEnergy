//
//  AboutViewController.m
//  Emanager
//
//  Created by newenergy on 12/26/14.
//  Copyright (c) 2014 New Energy. All rights reserved.
//

#import "AboutViewController.h"
#import "DEMONavigationController.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"关于";
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
    
    CGRect imageRect=CGRectMake(width*0.375, height*0.1+originY, width*0.25, width*0.25);
    UIImage *image= [UIImage imageNamed:@"Image02"];
    UIImage *roundimage=[self roundCorneredImage:image radius:width*0.03];
    UIImageView *imageMarker =[[UIImageView alloc] initWithImage:roundimage];
    [imageMarker setFrame:imageRect];
    [self.view addSubview:imageMarker];
    
    CGRect usernameLabelRect=CGRectMake(width*0.1, height*0.33+originY, width*0.8, width*0.09);
    UILabel *usernameLabel=[[UILabel alloc] initWithFrame:usernameLabelRect];
    [usernameLabel setText:@"www.168home.net"];
    [usernameLabel setTextAlignment:NSTextAlignmentCenter];
    usernameLabel.backgroundColor=[UIColor whiteColor];
    [usernameLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
    [usernameLabel addGestureRecognizer:gr];
    gr.numberOfTapsRequired = 1;
    gr.cancelsTouchesInView = NO;
    [self.view addSubview:usernameLabel];
    
    CGRect nameLabelRect=CGRectMake(width*0.1, height*0.43+originY, width*0.8, width*0.09);
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:nameLabelRect];
    [nameLabel setText:@"service@168home.net"];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    nameLabel.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:nameLabel];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)tapLabel: (UITapGestureRecognizer *) gr {
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://120.24.70.175:8080/tb.jsp" ];
    [[UIApplication sharedApplication] openURL:url];
}
@end
