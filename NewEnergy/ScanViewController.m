//
//  ScanViewController.m
//  Emanager
//
//  Created by newenergy on 1/6/15.
//  Copyright (c) 2015 New Energy. All rights reserved.
//

#import "ScanViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "DeviceViewController.h"
#import "DEMONavigationController.h"
#import "UIViewController+REFrostedViewController.h"
#import "NetConfigViewController.h"
#import "Item.h"
#import "ItemStore.h"
#import "SocketClient.h"
@interface ScanViewController ()
@property UIView *viewPreview;
@property AVCaptureSession *captureSession;
@property AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property AVAudioPlayer *audioPlayer;
@property BOOL isReading;
@property NSString *messages;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    _viewPreview=[[UIView alloc] initWithFrame:CGRectMake(width*0.1, height*0.3+originY, width*0.8, width*0.8)];
    [_viewPreview setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_viewPreview];
    
    _captureSession = nil;
    _isReading = NO;
    [self loadBeepSound];
    [self startReading];
}

- (void) messageReceived:(NSString *)message {
    
    self.messages=message;
}

-(void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSLog(@"mainBundle:%@",[NSBundle mainBundle]);
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        // If the audio player cannot be initialized then log a message.
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        // If the audio player was successfully initialized then load it in memory.
        [_audioPlayer prepareToPlay];
    }
}

- (BOOL)startReading {
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    //[_lblStatus setText:@"正在扫描二维码..."];
    [_captureSession startRunning];
    
    return YES;
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];

    Item *itemInStore = [[ItemStore sharedStore] item];
    NSString *str=[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"{\"data\":[{\"M\":\"",[_messages substringWithRange:NSMakeRange(0, 12)],@"\"}],\"cmd\":207,\"num\":6,\"tid\":",itemInStore.tid,@"}\n"];
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
                                                   message:[[NSString alloc] initWithFormat:@"%@%@",@"请在手机设置->Wi-Fi中将Wi-Fi连接切换为:",[_messages substringWithRange:NSMakeRange(12, 16)]]
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
        [item setScannedStr:_messages];
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

    NetConfigViewController *nVC = [[NetConfigViewController alloc] init];
    DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:nVC];
    self.frostedViewController.contentViewController = navigationController;
    
    /*BNRItem *item =[[BNRItem alloc] initWithName:_messages];
    [[BNRItemStore sharedStore] createItem:item];
    NSString *str;
    if ([_messages substringWithRange:NSMakeRange(14, 4)]){
        str=[[NSString alloc] initWithFormat:@"%@%@",@"请在手机设置->Wi-Fi中将Wi-Fi连接切换为:",[_messages substringWithRange:NSMakeRange(14, 4)]];
        NSString *flag=@"true";
        if([flag isEqualToString:@"true"]){
            UIAlertView *a= [[UIAlertView alloc] initWithTitle:@"设备获取成功"
                                                       message:str
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
            [a show];
            
        }
        
        NetConfigViewController *nVC = [[NetConfigViewController alloc] init];
        DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:nVC];
        self.frostedViewController.contentViewController = navigationController;

   }*/

}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    @try {
        if (metadataObjects != nil && [metadataObjects count] > 0) {
            AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
            if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
                //[_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
                [self messageReceived:[metadataObj stringValue]];
                [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
                _isReading = NO;
                if (_audioPlayer) {
                    [_audioPlayer play];
                }
                
                
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
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
