//
//  DeviceViewController.m
//  Emanager
//
//  Created by newenergy on 12/31/14.
//  Copyright (c) 2014 New Energy. All rights reserved.
//

#import "DeviceViewController.h"
#import "SettingsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "DetailViewController.h"
#import "DEMONavigationController.h"
#import "CFSocketClient.h"
#import "SocketClient.h"
#import "Item.h"
#import "ItemStore.h"
@interface DeviceViewController ()
@property UILabel *nameLabel;
@property UILabel *temperatureMarker;
@property UILabel *modeMarker;
@property UILabel *onoffMarker;
@property UILabel *stateMarker;
@property NSTimer *deviceTimer;
@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"设备列表";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    /*self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]
                                           initWithTitle:@"退出"
                                           style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(Logout:)];*/
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]
                                           initWithTitle:@"菜单"
                                           style:UIBarButtonItemStylePlain
                                           target:(DEMONavigationController *)self.navigationController
                                           action:@selector(showMenu)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]
                                           initWithTitle:@"编辑"
                                           style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(toggleEditingMode:)];
    //UIButton *editButton=[[UIButton alloc] init];
    //[editButton setTitle:@"编辑" forState:UIControlStateNormal];
    //self.navigationItem.rightBarButtonItem=self.editButtonItem;
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]
                                           initWithTitle:@"返回"
                                           style:UIBarButtonItemStylePlain
                                           target:nil
                                           action:nil];
    /*self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]
                                            initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(Settings:)];*/
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.tableView reloadData];  //memory rocketed up!!!
    [self startTimer];

}

- (void)viewWillDisappear:(BOOL)animated{
    [self stopTimer];
}

- (void)startTimer
{
    if (_deviceTimer == nil) {
        _deviceTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer
{
    [_deviceTimer invalidate];
    _deviceTimer = nil;
}

- (void)timerTick:(NSTimer *)timer
{
    Item *itemInStore = [[ItemStore sharedStore] item];
    CFSocketClient *cf = [[CFSocketClient alloc] initWithAddress:itemInStore.ip andPort:[itemInStore.port intValue]];
    if (cf.errorCode == NOERROR) {
        NSString *recv = [cf writtenToSocket:cf.sockfd withChar:itemInStore.loginStr];
        NSLog(@"%@",recv);
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        NSData *data = [recv dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *array=[json valueForKey:@"data"];
        for (int i=0; i<[array count]; i++) {
            for (int j=0; j<[items count]; j++) {
                if ([[array[i] valueForKey:@"M"] isEqualToString:[items[j] M]]){
                    [items[j] setS:[array[i] valueForKey:@"S"]];
                    [items[j] setT1:[[array[i] valueForKey:@"T1"] stringValue]];
                    //NSLog(@"----T1:%@", [items[j] T1]);
                }
                
            }
        }
        
        NSArray *indexArray=[self.tableView indexPathsForVisibleRows];
        for (int m=0; m<[indexArray count]; m++) {
            NSIndexPath *indexPath = indexArray[m];
            _nameLabel = (UILabel *)[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:1];
            _temperatureMarker = (UILabel *)[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:3];
            _modeMarker = (UILabel *)[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:4];
            _stateMarker = (UILabel *)[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:2];
            _onoffMarker = (UILabel *)[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:5];
            for (int n=0; n<[items count]; n++) {
                if ([[items[indexPath.row] M] isEqualToString:[items[n] M]]) {
                    _nameLabel.text = [items[n] N];
                    _temperatureMarker.text = [[NSString alloc] initWithFormat:@"%.01f%@",[[items[n] T1] intValue]/10.0,@" ℃"];
                    if ([[[items[n] S] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]){
                        _stateMarker.text = @"在线";
                    }else {
                        _stateMarker.text = @"离线";
                    }
                    
                    if ([[[items[n] S] substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]){
                        _modeMarker.text = @"自动模式";
                    }else{
                        _modeMarker.text = @"经济模式";
                    }
                    
                    if ([[[items[n] S] substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"]){
                        _onoffMarker.text = @"保温";
                    }else if ([[[items[n] S] substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"]){
                        _onoffMarker.text = @"加热";
                    }
                    
                }
            }
        }

        
    } else {
        NSLog(@"%@",[NSString stringWithFormat:@"Error code %d recieved.  Could not connect.", cf.errorCode]);
    }

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        @try {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        UIImage *image = [UIImage imageNamed:@"Image02"];
        cell.imageView.image = image;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        [cell setBackgroundColor:[UIColor whiteColor]];
        float width = self.view.frame.size.width;
        
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item=items[indexPath.row];
        //NSLog(@"deviceView items:%@",item.description);
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*0.25, 0, width*0.65*0.33, width*0.125)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        if (item.N.length) {
            [_nameLabel setText:item.N];
        }else{
            [_nameLabel setText:@""];
        }
            [_nameLabel setTag:1];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.backgroundColor=[UIColor whiteColor];
        [cell.contentView addSubview:_nameLabel];
        
        _stateMarker = [[UILabel alloc] initWithFrame:CGRectMake(width*0.25, width*0.125, width*0.65*0.33, width*0.125)];
        _stateMarker.textAlignment = NSTextAlignmentLeft;
        if (item.S.length>0){
            if ([[item.S substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]){
            _stateMarker.text = @"在线";
            }else {
            _stateMarker.text = @"离线";
            }
        }else{
            _stateMarker.text = @"离线";
        }
            [_stateMarker setTag:2];
        _stateMarker.font = [UIFont boldSystemFontOfSize:15];
        _stateMarker.backgroundColor=[UIColor whiteColor];
        [cell.contentView addSubview:_stateMarker];
        
        _temperatureMarker = [[UILabel alloc] initWithFrame:CGRectMake(width*0.25+width*0.65*0.33, width*0.125*0.5, width*0.65*0.33, width*0.125)];
        _temperatureMarker.textAlignment = NSTextAlignmentLeft;
        if (item.T1.length>0){
            NSString *t1=[[NSString alloc] initWithFormat:@"%@%@%@%@",[item.T1 substringToIndex:[item.T1 length]-1],@".",[item.T1 substringFromIndex:[item.T1 length]-1],@" ℃"];
            _temperatureMarker.text = t1;
        }else {
            _temperatureMarker.text =@" ℃";
        }
        [_temperatureMarker setTag:3];
        _temperatureMarker.font = [UIFont boldSystemFontOfSize:15];
        _temperatureMarker.backgroundColor=[UIColor whiteColor];
        [cell.contentView addSubview:_temperatureMarker];
        
        _modeMarker = [[UILabel alloc] initWithFrame:CGRectMake(width*0.25+width*0.65*0.66, 0, width*0.22, width*0.125)];
        _modeMarker.textAlignment = NSTextAlignmentLeft;
        if (item.S.length>0){
            if ([[item.S substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]){
                _modeMarker.text = @"自动模式";
            }else{
                _modeMarker.text = @"经济模式";
            }
        }else{
            _modeMarker.text = @"自动模式";
        }
            [_modeMarker setTag:4];
        _modeMarker.font = [UIFont boldSystemFontOfSize:15];
        _modeMarker.backgroundColor=[UIColor whiteColor];
        [cell.contentView addSubview:_modeMarker];
        
        _onoffMarker = [[UILabel alloc] initWithFrame:CGRectMake(width*0.25+width*0.65*0.66, width*0.125, width*0.22, width*0.125)];
        _onoffMarker.textAlignment = NSTextAlignmentLeft;
        if (item.S.length>0){
            if ([[item.S substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"]){
                _onoffMarker.text = @"保温";
            }else if ([[item.S substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"]){
                _onoffMarker.text = @"加热";
            }
        }else{
            _onoffMarker.text = @"";
        }
            [_onoffMarker setTag:5];
        _onoffMarker.font = [UIFont boldSystemFontOfSize:15];
        _onoffMarker.backgroundColor=[UIColor whiteColor];
        [cell.contentView addSubview:_onoffMarker];
        
        return cell;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *dVC=[[DetailViewController alloc] init];
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = items[indexPath.row];
    dVC.item = selectedItem;
    [self.navigationController pushViewController:dVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView
  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
   forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row];

        NSString *connStr=[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"{\"data\":[{\"M\":\"",item.M,@"\"}],\"cmd\":208,\"num\":6,\"tid\":",item.tid,@"}\n"];
        SocketClient *sc = [[SocketClient alloc] initWithAddress:item.IP andPort:[item.port intValue]];
        [sc writtenToSocketWithString:item.loginStr];
        [sc writtenToSocketWithString:connStr];
        
        [[BNRItemStore sharedStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView
  moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
         toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                        toIndex:destinationIndexPath.row];
}

/*
 - (NSInteger)tableView:(UITableView *)tableView
 indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return 5;
 }*/

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width*0.25;
}

-(void)Settings:(id)sender{
    SettingsViewController *settingsViewController=[[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

-(void)Logout:(id)sender{
    NSArray *itemsArray=[[BNRItemStore sharedStore] allItems];
    for (int i=0; i<[itemsArray count]; i++){
        [[BNRItemStore sharedStore] removeItem:itemsArray[i]];
        NSLog(@"delete i:%d",i);
    }
    [self.tableView reloadData];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)toggleEditingMode:(id)sender
{
    // If you are currently in editing mode...
    if (self.isEditing) {
        // Change text of button to inform user of state
        //[sender setTitle:@"编辑" forState:UIControlStateNormal];
        [sender setTitle:@"编辑"];
        // Turn off editing mode
        [self setEditing:NO animated:YES];
    } else {
        // Change tet of button to inform user of state
        //[sender setTitle:@"完成" forState:UIControlStateNormal];
        [sender setTitle:@"完成"];
        // Enter editing mode
        [self setEditing:YES animated:YES];
    }
}
@end

