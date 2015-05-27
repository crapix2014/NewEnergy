//
//  SettingsViewController.m
//  Emanager
//
//  Created by New Energy on 11/18/14.
//  Copyright (c) 2014 New Energy. All rights reserved.
//

#import "SettingsViewController.h"
#import "AccountViewController.h"
#import "NetConfigViewController.h"
#import "AddViewController.h"
#import "RemoveViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"

@interface SettingsViewController ()
@property (copy, nonatomic) NSArray *settingItem;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"设置";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.settingItem=@[@"账户管理", @"网络设置", @"添加设备", @"退出"];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.settingItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:@"star"];
    cell.imageView.image = image;
    cell.textLabel.text=self.settingItem[indexPath.row];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    cell.textLabel.font=[UIFont boldSystemFontOfSize:20];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //cell.textLabel.text=@"添加设备";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        //AccountManagementViewController *accountManagementVC=[[AccountManagementViewController alloc] init];
        //[accountManagementVC setTitle:@"账号管理"];
        AccountViewController *aVC=[[AccountViewController alloc] init];
        [aVC setTitle:@"账号管理"];
        [self.navigationController pushViewController:aVC animated:YES];
    }
    else if (indexPath.row==1){
        NetConfigViewController *netVC=[[NetConfigViewController alloc] init];
        [netVC setTitle:@"网络设置"];
        [self.navigationController pushViewController:netVC animated:YES];
    }
    else if (indexPath.row==2){
        AddViewController *aVC=[[AddViewController alloc] init];
        [aVC setTitle:@"添加设备"];
        [self.navigationController pushViewController:aVC animated:YES];
    }
    else if (indexPath.row==3){
        /*RemoveViewController *rVC=[[RemoveViewController alloc] init];
        [self.navigationController pushViewController:rVC animated:YES];*/
        NSArray *itemsArray=[[BNRItemStore sharedStore] allItems];
        for (int i=0; i<[itemsArray count]; i++){
            [[BNRItemStore sharedStore] removeItem:itemsArray[i]];
            NSLog(@"delete i:%d",i);
        }
        [self.tableView reloadData];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        return;
    }
}

/*
- (NSInteger)tableView:(UITableView *)tableView
indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 7;
}*/

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width*0.15;
}

-(NSString *)getStr:(NSString *) sourceStr{
    @try {
        NSRange divRange = [sourceStr rangeOfString:@"\"RPORT\":" options:NSCaseInsensitiveSearch];
        if (divRange.location != NSNotFound)
        {
            NSRange endDivRange;
            
            endDivRange.location = divRange.length + divRange.location;
            endDivRange.length   = [sourceStr length] - endDivRange.location;
            endDivRange = [sourceStr rangeOfString:@"," options:NSCaseInsensitiveSearch range:endDivRange];
            
            if (endDivRange.location != NSNotFound)
            {
                divRange.location += divRange.length;
                divRange.length  = endDivRange.location - divRange.location;
                
                
                //NSLog(@"resultStr : %@",[sourceStr substringWithRange:divRange]);
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
