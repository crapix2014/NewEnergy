//
//  DetailViewController.m
//  Emanager
//
//  Created by newenergy on 12/31/14.
//  Copyright (c) 2014 New Energy. All rights reserved.
//

#import "DetailViewController.h"
#import "SocketClient.h"
#import "CFSocketClient.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
@interface DetailViewController ()
@property UITextField *nameText;
@property UISwitch *stateSwitch;
@property UISegmentedControl *modeSC;
@property UISlider *upSlider;
@property UILabel *upLabel;
@property UISlider *downSlider;
@property UILabel *downLabel;
@property UILabel *temperatureLabel;
@property UILabel *tempe1Label;
@property UILabel *tempe2Label;
@property UILabel *tempe3Label;
@property UILabel *tempe4Label;
@property UILabel *state1Label;
@property UILabel *state2Label;
@property UILabel *state3Label;
@property UILabel *state4Label;
@property UILabel *state5Label;
@property UILabel *state6Label;
@property UILabel *state7Label;
@property UILabel *state8Label;
@property NSArray *array1;
@property NSArray *array2;
@property (nonatomic) JMPickerView *pickerView;
@property UILabel *messageLabel;
@property UIButton *spanButton1;
@property UIButton *spanButton2;
@property UIButton *spanButton3;
@property UIButton *spanButton4;
@property UIButton *spanButton5;
@property UIButton *spanButton6;
@property UILabel *warnLabel;
@property UILabel *timeLabel;
@property int tag;
@property NSTimer *detailTimer;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @try {
        _array1= @[@"00", @"01", @"02", @"03",@"04", @"05", @"06", @"07", @"08", @"08",@"09", @"10", @"11", @"12", @"13", @"14",@"15", @"16", @"17", @"18", @"19", @"20",@"21", @"22", @"23"];
        _array2= @[@"00", @"01", @"02", @"03",@"04", @"05", @"06", @"07", @"08", @"08",@"09", @"10", @"11", @"12", @"13", @"14",@"15", @"16", @"17", @"18", @"19", @"20",@"21", @"22", @"23",@"24", @"25", @"26", @"27",@"28", @"29", @"30", @"31", @"32", @"33",@"34", @"35", @"36", @"37", @"38", @"39",@"40", @"41", @"42", @"43", @"44", @"45",@"46", @"47", @"48", @"49", @"50", @"51", @"52",@"53", @"54", @"55", @"56", @"57", @"58",@"59"];
        self.pickerView = [[JMPickerView alloc] initWithDelegate:self addingToViewController:self];
        [self.pickerView setBackgroundColor:[UIColor whiteColor]];
        self.view.backgroundColor=[UIColor whiteColor];
        float width=self.view.bounds.size.width;
        float height=self.view.bounds.size.height;
        
        CGRect imageRect=CGRectMake(width*0.05, height*0.14, width*0.25, width*0.25);
        UIImage *image= [UIImage imageNamed:@"Image02"];
        UIImageView *imageMarker =[[UIImageView alloc] initWithImage:image];
        [imageMarker setFrame:imageRect];
        [self.view addSubview:imageMarker];
        
        CGRect nameTextRect=CGRectMake(width*0.5, height*0.14, width*0.45, height*0.05);
        _nameText=[[UITextField alloc] initWithFrame:nameTextRect];
        [_nameText setTextAlignment:NSTextAlignmentLeft];
        [_nameText setText:self.item.N];
        [_nameText setFont:[UIFont boldSystemFontOfSize:20]];
        [_nameText setReturnKeyType:UIReturnKeyDone];
        [_nameText addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [self.view addSubview:_nameText];
        
        CGRect timeLabelRect=CGRectMake(width*0.5, height*0.21, width*0.45, width*0.125);
        _timeLabel=[[UILabel alloc] initWithFrame:timeLabelRect];
        _timeLabel.textAlignment=NSTextAlignmentLeft;
        if (self.item.T.length>0){
            _timeLabel.text=[[NSString alloc] initWithFormat:@"%@%@%@%@",@"系统时间: ",[self.item.T substringWithRange:NSMakeRange(0, 2)],@":",[self.item.T substringWithRange:NSMakeRange(2, 2)]];
            }else {
            _timeLabel.text=[[NSString alloc] initWithFormat:@"%@%@",@"系统时间: ",@""];
        }
        _timeLabel.font=[UIFont boldSystemFontOfSize:20];
        _timeLabel.backgroundColor=[UIColor grayColor];
        [self.view addSubview:_timeLabel];
        
        CGRect temperatureLabelRect=CGRectMake(width*0.05, height*0.3, width*0.45, width*0.125);
        _temperatureLabel=[[UILabel alloc] initWithFrame:temperatureLabelRect];
        _temperatureLabel.textAlignment=NSTextAlignmentLeft;
        _temperatureLabel.font=[UIFont boldSystemFontOfSize:25];
        _temperatureLabel.backgroundColor=[UIColor whiteColor];
        if (self.item.T1.length>0){
           [_temperatureLabel setText:[[NSString alloc] initWithFormat:@"%@%@%@%@",[self.item.T1 substringToIndex:[self.item.T1 length]-1],@".",[self.item.T1 substringFromIndex:[self.item.T1 length]-1],@" ℃"]];
        }else{
            
        }
        [self.view addSubview:_temperatureLabel];
        /*
        CGRect stateLabelRect=CGRectMake(width*0.5, height*0.3, width*0.2, width*0.125);
        UILabel *stateLabel=[[UILabel alloc] initWithFrame:stateLabelRect];
        stateLabel.textAlignment=NSTextAlignmentLeft;
        stateLabel.text=@"加热";
        stateLabel.font=[UIFont boldSystemFontOfSize:20];
        stateLabel.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:stateLabel];*/
        
        //stateSwitch
        CGRect stateSwitchRect=CGRectMake(width*0.75, height*0.3, width*0.2, width*0.125);
        _stateSwitch=[[UISwitch alloc] initWithFrame:stateSwitchRect];
        [_stateSwitch addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_stateSwitch];
        
        CGRect state1LabelRect=CGRectMake(width*0.5, height*0.3, width*0.1125, height*0.05);
        _state1Label=[[UILabel alloc] initWithFrame:state1LabelRect];
        _state1Label.textAlignment=NSTextAlignmentLeft;
        if ([[self.item.S substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"1"]){
            [_state1Label setText:@"开机"];
            [_state1Label setTextColor:[UIColor redColor]];
            [_stateSwitch setOn:YES];
        }else{
            [_state1Label setText:@"关机"];
            [_state1Label setTextColor:[UIColor blackColor]];
            [_stateSwitch setOn:NO];
        }
        _state1Label.font=[UIFont systemFontOfSize:18];
        _state1Label.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_state1Label];
        
        CGRect state2LabelRect=CGRectMake(width*0.05, height*0.4, width*0.1125, height*0.05);
        _state2Label=[[UILabel alloc] initWithFrame:state2LabelRect];
        _state2Label.textAlignment=NSTextAlignmentLeft;
        [_state2Label setText:@"保温"];
        if ([[self.item.S substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"]){
            [_state2Label setTextColor:[UIColor redColor]];
        }else{
            [_state2Label setTextColor:[UIColor blackColor]];
        }
        _state2Label.font=[UIFont systemFontOfSize:18];
        _state2Label.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_state2Label];
        
        CGRect state3LabelRect=CGRectMake(width*0.275, height*0.4, width*0.1125, height*0.05);
        _state3Label=[[UILabel alloc] initWithFrame:state3LabelRect];
        _state3Label.textAlignment=NSTextAlignmentLeft;
        [_state3Label setText:@"加热"];
        if ([[self.item.S substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"]){
            [_state3Label setTextColor:[UIColor redColor]];
        }else{
            [_state3Label setTextColor:[UIColor blackColor]];
        }
        _state3Label.font=[UIFont systemFontOfSize:18];
        _state3Label.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_state3Label];
        
        /*CGRect state4LabelRect=CGRectMake(width*0.3875, height*0.4, width*0.1125, height*0.05);
        _state4Label=[[UILabel alloc] initWithFrame:state4LabelRect];
        _state4Label.textAlignment=NSTextAlignmentLeft;
        [_state4Label setText:@"新风"];
        if ([[self.item.S substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"]){
            [_state4Label setTextColor:[UIColor redColor]];
        }
        _state4Label.font=[UIFont systemFontOfSize:18];
        _state4Label.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_state4Label];
        
        CGRect state5LabelRect=CGRectMake(width*0.5, height*0.4, width*0.1125, height*0.05);
        _state5Label=[[UILabel alloc] initWithFrame:state5LabelRect];
        _state5Label.textAlignment=NSTextAlignmentLeft;
        [_state5Label setText:@"告警"];
        if ([[self.item.S substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"]){
            [_state5Label setTextColor:[UIColor redColor]];
        }
        _state5Label.font=[UIFont systemFontOfSize:18];
        _state5Label.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_state5Label];
        
        CGRect state6LabelRect=CGRectMake(width*0.6125, height*0.4, width*0.1125, height*0.05);
        _state6Label=[[UILabel alloc] initWithFrame:state6LabelRect];
        _state6Label.textAlignment=NSTextAlignmentLeft;
        [_state6Label setText:@"化霜"];
        if ([[self.item.S substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"]){
            [_state6Label setTextColor:[UIColor redColor]];
        }
        _state6Label.font=[UIFont systemFontOfSize:18];
        _state6Label.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_state6Label];
        
        CGRect state7LabelRect=CGRectMake(width*0.725, height*0.4, width*0.1125, height*0.05);
        _state7Label=[[UILabel alloc] initWithFrame:state7LabelRect];
        _state7Label.textAlignment=NSTextAlignmentLeft;
        [_state7Label setText:@"加氟"];
        if ([[self.item.S substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"1"]){
            [_state7Label setTextColor:[UIColor redColor]];
        }
        _state7Label.font=[UIFont systemFontOfSize:18];
        _state7Label.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_state7Label];
        
        CGRect state8LabelRect=CGRectMake(width*0.8375, height*0.4, width*0.1125, height*0.05);
        _state8Label=[[UILabel alloc] initWithFrame:state8LabelRect];
        _state8Label.textAlignment=NSTextAlignmentLeft;
        [_state8Label setText:@"测试"];
        if ([[self.item.S substringWithRange:NSMakeRange(9, 1)] isEqualToString:@"1"]){
            [_state8Label setTextColor:[UIColor redColor]];
        }*/
        
        _state8Label.font=[UIFont systemFontOfSize:18];
        _state8Label.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_state8Label];
        
        CGRect tempe1LabelRect=CGRectMake(width*0.05, height*0.45, width*0.45, height*0.07);
        _tempe1Label=[[UILabel alloc] initWithFrame:tempe1LabelRect];
        _tempe1Label.textAlignment=NSTextAlignmentLeft;
        if (self.item.T2.length>0){
           [_tempe1Label setText:[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"进水温度: ",[self.item.T2 substringToIndex:[self.item.T2 length]-1],@".",[self.item.T2 substringFromIndex:[self.item.T2 length]-1],@" ℃"]];
        }else{
           [_tempe1Label setText:[[NSString alloc] initWithFormat:@"%@",@"进水温度:"]];
        }
        _tempe1Label.font=[UIFont systemFontOfSize:12];
        _tempe1Label.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_tempe1Label];
        
        CGRect tempe3LabelRect=CGRectMake(width*0.05, height*0.52, width*0.45, height*0.07);
        _tempe3Label=[[UILabel alloc] initWithFrame:tempe3LabelRect];
        _tempe3Label.textAlignment=NSTextAlignmentLeft;
        if (self.item.T3.length>0){
            [_tempe3Label setText:[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"外机温度: ",[self.item.T3 substringToIndex:[self.item.T3 length]-1],@".",[self.item.T3 substringFromIndex:[self.item.T3 length]-1],@" ℃"]];
        }else{
            [_tempe3Label setText:[[NSString alloc] initWithFormat:@"%@",@"外机温度:"]];
        }
        _tempe3Label.font=[UIFont systemFontOfSize:12];
        _tempe3Label.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_tempe3Label];
        
        CGRect tempe2LabelRect=CGRectMake(width*0.05, height*0.59, width*0.45, height*0.07);
        _tempe2Label=[[UILabel alloc] initWithFrame:tempe2LabelRect];
        _tempe2Label.textAlignment=NSTextAlignmentLeft;
        if (self.item.T4.length>0){
           [_tempe2Label setText:[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"排气温度: ",[self.item.T4 substringToIndex:[self.item.T4 length]-1],@".",[self.item.T4 substringFromIndex:[self.item.T4 length]-1],@" ℃"]];
        }else{
            [_tempe2Label setText:[[NSString alloc] initWithFormat:@"%@",@"排气温度:"]];
        }
        _tempe2Label.font=[UIFont systemFontOfSize:12];
        _tempe2Label.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_tempe2Label];
        
        CGRect tempe4LabelRect=CGRectMake(width*0.05, height*0.66, width*0.45, height*0.07);
        _tempe4Label=[[UILabel alloc] initWithFrame:tempe4LabelRect];
        _tempe4Label.textAlignment=NSTextAlignmentLeft;
        if (self.item.T5.length>0){
            [_tempe4Label setText:[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"环境温度: ",[self.item.T5 substringToIndex:[self.item.T5 length]-1],@".",[self.item.T5 substringFromIndex:[self.item.T5 length]-1],@" ℃"]];
        }else{
            [_tempe4Label setText:[[NSString alloc] initWithFormat:@"%@",@"环境温度:"]];
        }
        _tempe4Label.font=[UIFont systemFontOfSize:12];
        _tempe4Label.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_tempe4Label];
        
        CGRect modeSCRect=CGRectMake(width*0.5, height*0.45, width*0.45, height*0.05);
        _modeSC=[[UISegmentedControl alloc] initWithItems:@[@"自动",@"经济"]];
        [_modeSC addTarget:self action:@selector(changeMode:) forControlEvents:UIControlEventValueChanged];
        [_modeSC setFrame:modeSCRect];
        if ([[self.item.S substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]){
            [_modeSC setSelectedSegmentIndex:0];
            [self enablePickers];
        }else{
            [_modeSC setSelectedSegmentIndex:1];
            [self disablePickers];
        }
        [self.view addSubview:_modeSC];
        
        CGRect spanButton1Rect=CGRectMake(width*0.5, height*0.52, width*0.2, height*0.05);
        _spanButton1=[[UIButton alloc] initWithFrame:spanButton1Rect];
        [_spanButton1 setTag:1];
        [_spanButton1 addTarget:self action:@selector(presentPicker:) forControlEvents:UIControlEventTouchUpInside];
        if (self.item.ET1){
            NSString *str=[self.item.ET1 substringWithRange:NSMakeRange(0, 4)];
            NSString *str1=[[NSString alloc] initWithFormat:@"%@%@%@",[str substringWithRange:NSMakeRange(0, 2)],@":",[str substringWithRange:NSMakeRange(2, 2)]];
        [_spanButton1 setTitle:str1 forState:UIControlStateNormal];
        }else {
            [_spanButton1 setTitle:@"00:00" forState:UIControlStateNormal];
        }
        [_spanButton1.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [_spanButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _spanButton1.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_spanButton1];
        
        CGRect spanButton2Rect=CGRectMake(width*0.7, height*0.52, width*0.2, height*0.05);
        _spanButton2=[[UIButton alloc] initWithFrame:spanButton2Rect];
        [_spanButton2 setTag:2];
        [_spanButton2 addTarget:self action:@selector(presentPicker:) forControlEvents:UIControlEventTouchUpInside];
        if (self.item.ET1){
            NSString *str=[self.item.ET1 substringWithRange:NSMakeRange(4, 4)];
            NSString *str1=[[NSString alloc] initWithFormat:@"%@%@%@",[str substringWithRange:NSMakeRange(0, 2)],@":",[str substringWithRange:NSMakeRange(2, 2)]];
        [_spanButton2 setTitle:str1 forState:UIControlStateNormal];
        }else {
            [_spanButton2 setTitle:@"00:00" forState:UIControlStateNormal];
        }
        [_spanButton2.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [_spanButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _spanButton2.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_spanButton2];
        
        CGRect spanButton3Rect=CGRectMake(width*0.5, height*0.57, width*0.2, height*0.05);
        _spanButton3=[[UIButton alloc] initWithFrame:spanButton3Rect];
        [_spanButton3 setTag:3];
        [_spanButton3 addTarget:self action:@selector(presentPicker:) forControlEvents:UIControlEventTouchUpInside];
        [_spanButton3 setTitle:@"07:00" forState:UIControlStateNormal];
        if (self.item.ET2){
            NSString *str=[self.item.ET2 substringWithRange:NSMakeRange(0, 4)];
            NSString *str1=[[NSString alloc] initWithFormat:@"%@%@%@",[str substringWithRange:NSMakeRange(0, 2)],@":",[str substringWithRange:NSMakeRange(2, 2)]];
        [_spanButton3 setTitle:str1 forState:UIControlStateNormal];
        }
        [_spanButton3.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [_spanButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _spanButton3.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_spanButton3];
        
        CGRect spanButton4Rect=CGRectMake(width*0.7, height*0.57, width*0.2, height*0.05);
        _spanButton4=[[UIButton alloc] initWithFrame:spanButton4Rect];
        [_spanButton4 setTag:4];
        [_spanButton4 addTarget:self action:@selector(presentPicker:) forControlEvents:UIControlEventTouchUpInside];
        if (self.item.ET2){
            NSString *str=[self.item.ET2 substringWithRange:NSMakeRange(4, 4)];
            NSString *str1=[[NSString alloc] initWithFormat:@"%@%@%@",[str substringWithRange:NSMakeRange(0, 2)],@":",[str substringWithRange:NSMakeRange(2, 2)]];
        [_spanButton4 setTitle:str1 forState:UIControlStateNormal];
        }else {
            [_spanButton4 setTitle:@"00:00" forState:UIControlStateNormal];
        }
        [_spanButton4.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [_spanButton4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _spanButton4.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_spanButton4];
        
        CGRect spanButton5Rect=CGRectMake(width*0.5, height*0.62, width*0.2, height*0.05);
        _spanButton5=[[UIButton alloc] initWithFrame:spanButton5Rect];
        [_spanButton5 setTag:5];
        [_spanButton5 addTarget:self action:@selector(presentPicker:) forControlEvents:UIControlEventTouchUpInside];
        if (self.item.ET3) {
            NSString *str=[self.item.ET3 substringWithRange:NSMakeRange(0, 4)];
            NSString *str1=[[NSString alloc] initWithFormat:@"%@%@%@",[str substringWithRange:NSMakeRange(0, 2)],@":",[str substringWithRange:NSMakeRange(2, 2)]];
        [_spanButton5 setTitle:str1 forState:UIControlStateNormal];
        }else {
            [_spanButton5 setTitle:@"00:00" forState:UIControlStateNormal];
        }
        [_spanButton5.titleLabel setFont:[UIFont systemFontOfSize:20]];
        //[spanButton1.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_spanButton5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _spanButton5.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_spanButton5];
        
        CGRect spanButton6Rect=CGRectMake(width*0.7, height*0.62, width*0.2, height*0.05);
        _spanButton6=[[UIButton alloc] initWithFrame:spanButton6Rect];
        [_spanButton6 setTag:6];
        [_spanButton6 addTarget:self action:@selector(presentPicker:) forControlEvents:UIControlEventTouchUpInside];
        if (self.item.ET3){
            NSString *str=[self.item.ET3 substringWithRange:NSMakeRange(4, 4)];
            NSString *str1=[[NSString alloc] initWithFormat:@"%@%@%@",[str substringWithRange:NSMakeRange(0, 2)],@":",[str substringWithRange:NSMakeRange(2, 2)]];
        [_spanButton6 setTitle:str1 forState:UIControlStateNormal];
        }else {
            [_spanButton6 setTitle:@"00:00" forState:UIControlStateNormal];
        }
        [_spanButton6.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [_spanButton6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _spanButton6.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_spanButton6];
        
        CGRect upLabelRect=CGRectMake(width*0.05, height*0.73, width*0.25, width*0.125);
        _upLabel=[[UILabel alloc] initWithFrame:upLabelRect];
        _upLabel.textAlignment=NSTextAlignmentLeft;
        if (self.item.HT){
            [_upLabel setText:[[NSString alloc] initWithFormat:@"%@%@",@"上限温度 :",self.item.HT]];
        }else{
            [_upLabel setText:[[NSString alloc] initWithFormat:@"%@",@"上限温度 :"]];
        }
        _upLabel.font=[UIFont boldSystemFontOfSize:14];
        _upLabel.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_upLabel];
        
        CGRect downLabelRect=CGRectMake(width*0.05, height*0.8, width*0.25, width*0.125);
        _downLabel=[[UILabel alloc] initWithFrame:downLabelRect];
        _downLabel.textAlignment=NSTextAlignmentLeft;
        if (self.item.LT){
            [_downLabel setText:[[NSString alloc] initWithFormat:@"%@%@",@"下限温度 :",self.item.LT]];
        }else{
            [_downLabel setText:[[NSString alloc] initWithFormat:@"%@",@"下限温度 :"]];
        }
        _downLabel.font=[UIFont boldSystemFontOfSize:14];
        _downLabel.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_downLabel];
        
        CGRect upSliderRect=CGRectMake(width*0.35, height*0.73, width*0.6, width*0.125);
        _upSlider=[[UISlider alloc] initWithFrame:upSliderRect];
        [_upSlider setMaximumValue:60];
        [_upSlider setMinimumValue:10];
        if (self.item.HT){
            [_upSlider setValue:[self.item.HT floatValue]];
        }else{
            [_upSlider setValue:0];
        }
        [_upSlider addTarget:self action:@selector(uptempe:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_upSlider];
        
        CGRect downSliderRect=CGRectMake(width*0.35, height*0.8, width*0.6, width*0.125);
        _downSlider=[[UISlider alloc] initWithFrame:downSliderRect];
        [_downSlider setMaximumValue:60];
        [_downSlider setMinimumValue:10];
        if (self.item.LT){
            [_downSlider setValue:[self.item.LT floatValue]];
        }else{
            [_downSlider setValue:0];
        }
        [_downSlider addTarget:self action:@selector(downtempe:) forControlEvents:UIControlEventValueChanged];
        [_downSlider setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_downSlider];
        
        CGRect warnLabelRect=CGRectMake(width*0.05, height*0.9, width*0.9, height*0.05);
        _warnLabel=[[UILabel alloc] initWithFrame:warnLabelRect];
        [_warnLabel setText:[[NSString alloc] initWithFormat:@"%@%@",@"故障代码:",@""]];
        [_warnLabel setTextColor:[UIColor redColor]];
        [self.view addSubview:_warnLabel];
        
        if ([[self.item.S substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]){
            [self enableAllControls];
        }else {
            [self disableAllControls];
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    @try {
        if ([[self.item.S substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]){
            [self startTimer];
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopTimer];
}

- (void)startTimer
{
    if (_detailTimer == nil) {
        _detailTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer
{
    [_detailTimer invalidate];
    _detailTimer = nil;
}

- (void)timerTick:(NSTimer *)timer
{
    CFSocketClient *cf = [[CFSocketClient alloc] initWithAddress:self.item.IP andPort:[self.item.port intValue]];
    if (cf.errorCode == NOERROR) {
        NSString *recv = [cf writtenToSocket:cf.sockfd withChar:self.item.loginStr];
        NSLog(@"%@",recv);
        NSData *data = [recv dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //NSLog(@"++++++++++++++recv :%@",recv);
        NSArray *array=[json valueForKey:@"data"];
        for (int i=0; i<[array count]; i++) {
            
            if ([[array[i] valueForKey:@"M"] isEqualToString:self.item.M]){
                [self.item setS:[array[i] valueForKey:@"S"]];
                if ([[self.item.S substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]){
                    [self enableAllControls];
                    [self.item setT1:[[array[i] valueForKey:@"T1"] stringValue]];
                    [self.item setT2:[[array[i] valueForKey:@"T2"] stringValue]];
                    [self.item setT3:[[array[i] valueForKey:@"T3"] stringValue]];
                    [self.item setT4:[[array[i] valueForKey:@"T4"] stringValue]];
                    [self.item setT5:[[array[i] valueForKey:@"T5"] stringValue]];
                    [self.item setT:[array[i] valueForKey:@"T"]];
                    [self.item setET1:[array[i] valueForKey:@"ET1"]];
                    [self.item setET2:[array[i] valueForKey:@"ET2"]];
                    [self.item setET3:[array[i] valueForKey:@"ET3"]];
                    [self.item setLT:[[array[i] valueForKey:@"LT"] stringValue]];
                    [self.item setHT:[[array[i] valueForKey:@"HT"] stringValue]];
                    if ([[self.item.S substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"]) {
                        [self.item setER:[array[i] valueForKey:@"ER"]];
                    }
                    
                }else {
                    [self disableAllControls];
                }
                
                if ([[self.item.S substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"1"]){
                    [_state1Label setText:@"开机"];
                    [_state1Label setTextColor:[UIColor redColor]];
                    [_stateSwitch setOn:YES];
                }else{
                    [_state1Label setText:@"关机"];
                    [_state1Label setTextColor:[UIColor blackColor]];
                    [_stateSwitch setOn:NO];
                }
                
                if ([[self.item.S substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"]){
                    [_state2Label setTextColor:[UIColor redColor]];
                }else{
                    [_state2Label setTextColor:[UIColor blackColor]];
                }
                
                if ([[self.item.S substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"]){
                    [_state3Label setTextColor:[UIColor redColor]];
                }else{
                    [_state3Label setTextColor:[UIColor blackColor]];
                }
                
                if ([[self.item.S substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]){
                    [_modeSC setSelectedSegmentIndex:0];
                    [self disablePickers];
                }else{
                    [_modeSC setSelectedSegmentIndex:1];
                    [self enablePickers];
                }
                
                if (self.item.HT){
                    [_upLabel setText:[[NSString alloc] initWithFormat:@"%@%@",@"上限温度 :",self.item.HT]];
                    [_upSlider setValue:[self.item.HT floatValue]];
                }else{
                    [_upLabel setText:[[NSString alloc] initWithFormat:@"%@",@"上限温度 :"]];
                    [_upSlider setValue:0];
                }
                
                if (self.item.LT){
                    [_downLabel setText:[[NSString alloc] initWithFormat:@"%@%@",@"下限温度 :",self.item.LT]];
                    [_downSlider setValue:[self.item.LT floatValue]];
                }else{
                    [_downLabel setText:[[NSString alloc] initWithFormat:@"%@",@"下限温度 :"]];
                    [_downSlider setValue:0];
                }
                
                if (self.item.ET1){
                    NSString *str=[self.item.ET1 substringWithRange:NSMakeRange(0, 4)];
                    NSString *str1=[[NSString alloc] initWithFormat:@"%@%@%@",[str substringWithRange:NSMakeRange(0, 2)],@":",[str substringWithRange:NSMakeRange(2, 2)]];
                    [_spanButton1 setTitle:str1 forState:UIControlStateNormal];
                }else {
                    [_spanButton1 setTitle:@"00:00" forState:UIControlStateNormal];
                }
                
                if (self.item.ET1){
                    NSString *str=[self.item.ET1 substringWithRange:NSMakeRange(4, 4)];
                    NSString *str1=[[NSString alloc] initWithFormat:@"%@%@%@",[str substringWithRange:NSMakeRange(0, 2)],@":",[str substringWithRange:NSMakeRange(2, 2)]];
                    [_spanButton2 setTitle:str1 forState:UIControlStateNormal];
                }else {
                    [_spanButton2 setTitle:@"00:00" forState:UIControlStateNormal];
                }
                
                if (self.item.ET2){
                    NSString *str=[self.item.ET2 substringWithRange:NSMakeRange(0, 4)];
                    NSString *str1=[[NSString alloc] initWithFormat:@"%@%@%@",[str substringWithRange:NSMakeRange(0, 2)],@":",[str substringWithRange:NSMakeRange(2, 2)]];
                    [_spanButton3 setTitle:str1 forState:UIControlStateNormal];
                }
                
                if (self.item.ET2){
                    NSString *str=[self.item.ET2 substringWithRange:NSMakeRange(4, 4)];
                    NSString *str1=[[NSString alloc] initWithFormat:@"%@%@%@",[str substringWithRange:NSMakeRange(0, 2)],@":",[str substringWithRange:NSMakeRange(2, 2)]];
                    [_spanButton4 setTitle:str1 forState:UIControlStateNormal];
                }else {
                    [_spanButton4 setTitle:@"00:00" forState:UIControlStateNormal];
                }
                
                if (self.item.ET3) {
                    NSString *str=[self.item.ET3 substringWithRange:NSMakeRange(0, 4)];
                    NSString *str1=[[NSString alloc] initWithFormat:@"%@%@%@",[str substringWithRange:NSMakeRange(0, 2)],@":",[str substringWithRange:NSMakeRange(2, 2)]];
                    [_spanButton5 setTitle:str1 forState:UIControlStateNormal];
                }else {
                    [_spanButton5 setTitle:@"00:00" forState:UIControlStateNormal];
                }
                
                if (self.item.ET3){
                    NSString *str=[self.item.ET3 substringWithRange:NSMakeRange(4, 4)];
                    NSString *str1=[[NSString alloc] initWithFormat:@"%@%@%@",[str substringWithRange:NSMakeRange(0, 2)],@":",[str substringWithRange:NSMakeRange(2, 2)]];
                    [_spanButton6 setTitle:str1 forState:UIControlStateNormal];
                }else {
                    [_spanButton6 setTitle:@"00:00" forState:UIControlStateNormal];
                }
                
                if ([[self.item.S substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"]&&self.item.ER.length>0){
                    NSMutableString *ms = [[NSMutableString alloc] init];
                    [ms appendString:@"故障代码:"];
                    if ([[self.item.ER substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]) {
                        [ms appendString:@"A12 "];
                    }
                    if([[self.item.ER substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"1"]){
                        [ms appendString:@"A13 "];
                    }
                    if ([[self.item.ER substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"1"]){
                        [ms appendString:@"A21 "];
                    }
                    if ([[self.item.ER substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"]){
                        [ms appendString:@"A22 "];
                    }
                    if ([[self.item.ER substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"]){
                        [ms appendString:@"A23 "];
                    }
                    if ([[self.item.ER substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"]){
                        [ms appendString:@"A24 "];
                    }
                    if ([[self.item.ER substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"]){
                        [ms appendString:@"A25"];
                    }
                    if ([[self.item.ER substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"]){
                        [ms appendString:@"oPE "];
                    }
                    if ([[self.item.ER substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"1"]){
                        [ms appendString:@"SHr "];
                    }
                    [_warnLabel setText:ms];
                    NSLog(@"-------------ms:%@",ms);
                    
                }else {
                    [_spanButton6 setTitle:@"00:00" forState:UIControlStateNormal];
                }
                
                
            }
            
        }
        
        NSString *t,*t1,*t2,*t3,*t4,*t5;
        if (self.item.T.length>0){
            t= [[NSString alloc] initWithFormat:@"%@%@%@%@",@"系统时间: ",[self.item.T substringWithRange:NSMakeRange(0, 2)],@":",[self.item.T substringWithRange:NSMakeRange(2, 2)]];
        }
        if (self.item.T1.length>0){
            t1=[[NSString alloc] initWithFormat:@"%@%@%@%@",[self.item.T1 substringToIndex:[self.item.T1 length]-1],@".",[self.item.T1 substringFromIndex:[self.item.T1 length]-1],@" ℃"];
        }else {
            t1=@"";
        }
        if (self.item.T2.length>0){
            t2=[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"进水温度: ",[self.item.T2 substringToIndex:[self.item.T2 length]-1],@".",[self.item.T2 substringFromIndex:[self.item.T2 length]-1],@" ℃"];
        }else {
            t2=@"进水温度:";
        }
        if (self.item.T3.length>0){
            t3=[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"外机温度: ",[self.item.T3 substringToIndex:[self.item.T3 length]-1],@".",[self.item.T3 substringFromIndex:[self.item.T3 length]-1],@" ℃"];
        }else {
            t3=@"外机温度:";
        }
        if (self.item.T4.length>0){
            t4=[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"排气温度: ",[self.item.T4 substringToIndex:[self.item.T4 length]-1],@".",[self.item.T4 substringFromIndex:[self.item.T4 length]-1],@" ℃"];
        }else {
            t4=@"排气温度:";
        }
        if (self.item.T5.length>0){
            t5=[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"环境温度: ",[self.item.T5 substringToIndex:[self.item.T5 length]-1],@".",[self.item.T5 substringFromIndex:[self.item.T5 length]-1],@" ℃"];
        }else {
            t5=@"环境温度:";
        }
        [_timeLabel setText:t];
        [_temperatureLabel setText:t1];
        [_tempe1Label setText:t2];
        [_tempe2Label setText:t4];
        [_tempe3Label setText:t3];
        [_tempe4Label setText:t5];

        
    } else {
        NSLog(@"%@",[NSString stringWithFormat:@"Error code %d recieved.  Could not connect.", cf.errorCode]);
    }

    
    

}

- (void)changeState:(id)sender{
    if (_stateSwitch.on){
        [_state1Label setTextColor:[UIColor redColor]];
        NSString *connStr=[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"{\"data\":[{\"M\":\"",self.item.M,@"\"}],\"cmd\":211,\"num\":6,\"tid\":",self.item.tid,@"}\n"];
        SocketClient *sc = [[SocketClient alloc] initWithAddress:self.item.IP andPort:[self.item.port intValue]];
        [sc writtenToSocketWithString:self.item.loginStr];
        [sc writtenToSocketWithString:connStr];
            //NSLog(@"change state on recv: %@",recv);
    }else {
        [_state1Label setTextColor:[UIColor blackColor]];
        NSString *connStr=[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"{\"data\":[{\"M\":\"",self.item.M,@"\"}],\"cmd\":210,\"num\":6,\"tid\":",self.item.tid,@"}\n"];
        SocketClient *sc = [[SocketClient alloc] initWithAddress:self.item.IP andPort:[self.item.port intValue]];
        [sc writtenToSocketWithString:self.item.loginStr];
        [sc writtenToSocketWithString:connStr];
        //NSLog(@"change state on recv: %@",recv);
            }
}

- (void)changeMode:(id)sender{
    @try {
        if (_modeSC.selectedSegmentIndex==0){
            NSString *connStr=[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"{\"data\":[{\"M\":\"",self.item.M,@"\"}],\"cmd\":212,\"num\":6,\"tid\":",self.item.tid,@"}\n"];
            SocketClient *sc = [[SocketClient alloc] initWithAddress:self.item.IP andPort:[self.item.port intValue]];
            [sc writtenToSocketWithString:self.item.loginStr];
            [sc writtenToSocketWithString:connStr];
            //NSLog(@"change state on recv: %@",recv);
            
            //update mode value in the table view
            NSString *str=self.item.S;
            self.item.S=[[NSString alloc] initWithFormat:@"%@%@%@",[str substringWithRange:NSMakeRange(0, 1)],@"0",[str substringWithRange:NSMakeRange(2, 8)]];
            
            //disable time picker
            [self disablePickers];
            
        }else if(_modeSC.selectedSegmentIndex==1){
            NSString *connStr=[[NSString alloc] initWithFormat:@"%@%@%@%@%@",@"{\"data\":[{\"M\":\"",self.item.M,@"\"}],\"cmd\":213,\"num\":6,\"tid\":",self.item.tid,@"}\n"];
            SocketClient *sc = [[SocketClient alloc] initWithAddress:self.item.IP andPort:[self.item.port intValue]];
            [sc writtenToSocketWithString:self.item.loginStr];
            [sc writtenToSocketWithString:connStr];
            //NSLog(@"change state on recv: %@",recv);
            
            //update mode value in the table view
            NSString *str=self.item.S;
            self.item.S=[[NSString alloc] initWithFormat:@"%@%@%@",[str substringWithRange:NSMakeRange(0, 1)],@"1",[str substringWithRange:NSMakeRange(2, 8)]];
            
            //enable time picker
            [self enablePickers];

        }else{
            return;
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)uptempe:(id)sender{
    NSString *str= [NSString stringWithFormat:@"%ld", lroundf(_upSlider.value)];
    //[_downSlider setMaximumValue:_upSlider.value];
    [_upLabel setText:[[NSString alloc] initWithFormat:@"%@%@",@"上限温度 :",str]];
    NSString *message=[[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@%@",@"{\"data\":[{\"M\":\"",self.item.M,@"\",\"HT\":",[NSString stringWithFormat:@"%ld", lroundf(_upSlider.value)],@",\"LT\":",[NSString stringWithFormat:@"%ld", lroundf(_downSlider.value)],@"}],\"cmd\":215,\"num\":6,\"tid\":",self.item.tid,@"}\n"];
    SocketClient *sc = [[SocketClient alloc] initWithAddress:self.item.IP andPort:[self.item.port intValue]];
    [sc writtenToSocketWithString:self.item.loginStr];
    [sc writtenToSocketWithString:message];
    //NSLog(@"uptempe recv: %@",recv);
    
}

- (void)downtempe:(id)sender{
    NSString *str= [NSString stringWithFormat:@"%ld", lroundf(_downSlider.value)];
    [_downLabel setText:[[NSString alloc] initWithFormat:@"%@%@",@"下限温度 :",str]];
    NSString *message=[[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@%@",@"{\"data\":[{\"M\":\"",self.item.M,@"\",\"HT\":",[NSString stringWithFormat:@"%ld", lroundf(_upSlider.value)],@",\"LT\":",[NSString stringWithFormat:@"%ld", lroundf(_downSlider.value)],@"}],\"cmd\":215,\"num\":6,\"tid\":",self.item.tid,@"}\n"];
    SocketClient *sc = [[SocketClient alloc] initWithAddress:self.item.IP andPort:[self.item.port intValue]];
    [sc writtenToSocketWithString:self.item.loginStr];
    [sc writtenToSocketWithString:message];
    //NSLog(@"downtempe recv: %@",recv);
    }
- (void)presentPicker:(UIButton *)sender{
    _tag=sender.tag;
     [_pickerView show];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    //return 4;
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //return 4;
    if (component == 0) {
        return [_array1 count];
    } else {
        return [_array2 count];
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //return [NSString stringWithFormat:@"%d %d", row, component];
    if (component == 0) {
        return _array1[row];
    } else {
        return _array2[row];
    }
    
}
/*
 - (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
 self.messageLabel.text = [NSString stringWithFormat:@"pickerView didSelect %@ %@", _array1[row], _array2[row]];
 }*/

- (void)pickerViewWasHidden:(JMPickerView *)pickerView {
    [_tempe4Label setHidden:NO];
    [_tempe2Label setHidden:NO];
    [_upLabel setHidden:NO];
    [_upSlider setHidden:NO];
    [_downLabel setHidden:NO];
    [_downSlider setHidden:NO];
    [_spanButton5 setHidden:NO];
    [_spanButton6 setHidden:NO];
    [_warnLabel setHidden:NO];
    self.messageLabel.text = @"pickerViewWasHidden";
    NSInteger firstRow = [_pickerView selectedRowInComponent:0];
    NSInteger secondRow = [_pickerView selectedRowInComponent:1];
    @try {
        if (_tag==1){
            [_spanButton1 setTitle:[[NSString alloc] initWithFormat:@"%@%@%@",_array1[firstRow],@":",_array2[secondRow]] forState:UIControlStateNormal];
            NSString *str=[[NSString alloc] initWithFormat:@"%@%@%@%@",_array1[firstRow],_array2[secondRow],[_spanButton2.titleLabel.text substringWithRange:NSMakeRange(0, 2)],[_spanButton1.titleLabel.text substringWithRange:NSMakeRange(3, 2)]];
            NSString *message=[[ NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@",@"{\"data\":[{\"M\":\"",self.item.M,@"\",\"ET1\":\"",str,@"\"}],\"cmd\":214,\"num\":6,\"tid\":",self.item.tid,@"}\n"];
            SocketClient *sc = [[SocketClient alloc] initWithAddress:self.item.IP andPort:[self.item.port intValue]];
            [sc writtenToSocketWithString:self.item.loginStr];
            [sc writtenToSocketWithString:message];
        }else if (_tag==2){
            [_spanButton2 setTitle:[[NSString alloc] initWithFormat:@"%@%@%@",_array1[firstRow],@":",_array2[secondRow]] forState:UIControlStateNormal];
            NSString *str=[[NSString alloc] initWithFormat:@"%@%@%@%@",[_spanButton1.titleLabel.text substringWithRange:NSMakeRange(0, 2)],[_spanButton1.titleLabel.text substringWithRange:NSMakeRange(3, 2)],_array1[firstRow],_array2[secondRow]];
            NSString *message=[[ NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@",@"{\"data\":[{\"M\":\"",self.item.M,@"\",\"ET1\":\"",str,@"\"}],\"cmd\":214,\"num\":6,\"tid\":",self.item.tid,@"}\n"];
            SocketClient *sc = [[SocketClient alloc] initWithAddress:self.item.IP andPort:[self.item.port intValue]];
            [sc writtenToSocketWithString:self.item.loginStr];
            [sc writtenToSocketWithString:message];
        }else if (_tag==3){
            [_spanButton3 setTitle:[[NSString alloc] initWithFormat:@"%@%@%@",_array1[firstRow],@":",_array2[secondRow]] forState:UIControlStateNormal];
            NSString *str=[[NSString alloc] initWithFormat:@"%@%@%@%@",_array1[firstRow],_array2[secondRow],[_spanButton4.titleLabel.text substringWithRange:NSMakeRange(0, 2)],[_spanButton3.titleLabel.text substringWithRange:NSMakeRange(3, 2)]];
            NSString *message=[[ NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@",@"{\"data\":[{\"M\":\"",self.item.M,@"\",\"ET2\":\"",str,@"\"}],\"cmd\":214,\"num\":6,\"tid\":",self.item.tid,@"}\n"];
            SocketClient *sc = [[SocketClient alloc] initWithAddress:self.item.IP andPort:[self.item.port intValue]];
            [sc writtenToSocketWithString:self.item.loginStr];
            [sc writtenToSocketWithString:message];
        }else if (_tag==4){
            [_spanButton4 setTitle:[[NSString alloc] initWithFormat:@"%@%@%@",_array1[firstRow],@":",_array2[secondRow]] forState:UIControlStateNormal];
            NSString *str=[[NSString alloc] initWithFormat:@"%@%@%@%@",[_spanButton3.titleLabel.text substringWithRange:NSMakeRange(0, 2)],[_spanButton3.titleLabel.text substringWithRange:NSMakeRange(3, 2)],_array1[firstRow],_array2[secondRow]];
            NSString *message=[[ NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@",@"{\"data\":[{\"M\":\"",self.item.M,@"\",\"ET2\":\"",str,@"\"}],\"cmd\":214,\"num\":6,\"tid\":",self.item.tid,@"}\n"];
            SocketClient *sc = [[SocketClient alloc] initWithAddress:self.item.IP andPort:[self.item.port intValue]];
            [sc writtenToSocketWithString:self.item.loginStr];
            [sc writtenToSocketWithString:message];
        }else if (_tag==5){
            [_spanButton5 setTitle:[[NSString alloc] initWithFormat:@"%@%@%@",_array1[firstRow],@":",_array2[secondRow]] forState:UIControlStateNormal];
            NSString *str=[[NSString alloc] initWithFormat:@"%@%@%@%@",_array1[firstRow],_array2[secondRow],[_spanButton6.titleLabel.text substringWithRange:NSMakeRange(0, 2)],[_spanButton5.titleLabel.text substringWithRange:NSMakeRange(3, 2)]];
            NSString *message=[[ NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@",@"{\"data\":[{\"M\":\"",self.item.M,@"\",\"ET3\":\"",str,@"\"}],\"cmd\":214,\"num\":6,\"tid\":",self.item.tid,@"}\n"];
            SocketClient *sc = [[SocketClient alloc] initWithAddress:self.item.IP andPort:[self.item.port intValue]];
            [sc writtenToSocketWithString:self.item.loginStr];
            [sc writtenToSocketWithString:message];
        }else if (_tag==6){
            [_spanButton6 setTitle:[[NSString alloc] initWithFormat:@"%@%@%@",_array1[firstRow],@":",_array2[secondRow]] forState:UIControlStateNormal];
            NSString *str=[[NSString alloc] initWithFormat:@"%@%@%@%@",[_spanButton5.titleLabel.text substringWithRange:NSMakeRange(0, 2)],[_spanButton5.titleLabel.text substringWithRange:NSMakeRange(3, 2)],_array1[firstRow],_array2[secondRow]];
            NSString *message=[[ NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@",@"{\"data\":[{\"M\":\"",self.item.M,@"\",\"ET3\":\"",str,@"\"}],\"cmd\":214,\"num\":6,\"tid\":",self.item.tid,@"}\n"];
            SocketClient *sc = [[SocketClient alloc] initWithAddress:self.item.IP andPort:[self.item.port intValue]];
            [sc writtenToSocketWithString:self.item.loginStr];
            [sc writtenToSocketWithString:message];
        }else {
            return;
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    //NSString *message = [[NSString alloc] initWithFormat:
       //                  @"Your %@ on %@ bread will be right up.", _array1[firstRow], _array2[secondRow]];
    //NSLog(@"message:%@",message);
}

- (void)pickerViewWasShown:(JMPickerView *)pickerView {
    [_tempe4Label setHidden:YES];
    [_upLabel setHidden:YES];
    [_upSlider setHidden:YES];
    [_downLabel setHidden:YES];
    [_downSlider setHidden:YES];
    [_tempe2Label setHidden:YES];
    [_spanButton5 setHidden:YES];
    [_spanButton6 setHidden:YES];
    [_warnLabel setHidden:YES];

    self.messageLabel.text = @"pickerViewWasShown";
}

- (void)pickerViewSelectionIndicatorWasTapped:(JMPickerView *)pickerView {
    [self.pickerView hide];
}

- (void)textFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
    BNRItem *item = self.item;
    item.N= _nameText.text;
    NSString *message=[[ NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@",@"{\"data\":[{\"M\":\"",self.item.M,@"\",\"N\":\"",_nameText.text,@"\"}],\"cmd\":217,\"num\":6,\"tid\":",self.item.tid,@"}\n"];
    SocketClient *sc = [[SocketClient alloc] initWithAddress:self.item.IP andPort:[self.item.port intValue]];
    [sc writtenToSocketWithString:self.item.loginStr];
    [sc writtenToSocketWithString:message];

}

- (void)enablePickers{
    [_spanButton1 setEnabled:YES];
    [_spanButton1 setHighlighted:YES];
    [_spanButton2 setEnabled:YES];
    [_spanButton3 setEnabled:YES];
    [_spanButton4 setEnabled:YES];
    [_spanButton5 setEnabled:YES];
    [_spanButton6 setEnabled:YES];

}

- (void)disablePickers{
    [_spanButton1 setEnabled:NO];
    [_spanButton2 setEnabled:NO];
    [_spanButton3 setEnabled:NO];
    [_spanButton4 setEnabled:NO];
    [_spanButton5 setEnabled:NO];
    [_spanButton6 setEnabled:NO];
}

- (void)enableAllControls{
    //[_nameText setEnabled:YES];
    [_stateSwitch setEnabled:YES];
    [_modeSC setEnabled:YES];
    [_upSlider setEnabled:YES];
    [_upLabel setEnabled:YES];
    [_downSlider setEnabled:YES];
    [_downLabel setEnabled:YES];
    [_temperatureLabel setEnabled:YES];
    [_tempe1Label setEnabled:YES];
    [_tempe2Label setEnabled:YES];
    [_tempe3Label setEnabled:YES];
    [_tempe4Label setEnabled:YES];
    [_state1Label setEnabled:YES];
    [_state2Label setEnabled:YES];
    [_state3Label setEnabled:YES];
    [_state4Label setEnabled:YES];
    [_state5Label setEnabled:YES];
    [_state6Label setEnabled:YES];
    [_state7Label setEnabled:YES];
    [_state8Label setEnabled:YES];
    [_messageLabel setEnabled:YES];
    [_spanButton1 setEnabled:YES];
    [_spanButton2 setEnabled:YES];
    [_spanButton3 setEnabled:YES];
    [_spanButton4 setEnabled:YES];
    [_spanButton5 setEnabled:YES];
    [_spanButton6 setEnabled:YES];
    [_warnLabel setEnabled:YES];

}

- (void)disableAllControls{
    //[_nameText setEnabled:NO];
    [_stateSwitch setEnabled:NO];
    [_modeSC setEnabled:NO];
    [_upSlider setEnabled:NO];
    [_upLabel setEnabled:NO];
    [_downSlider setEnabled:NO];
    [_downLabel setEnabled:NO];
    [_temperatureLabel setEnabled:NO];
    [_tempe1Label setEnabled:NO];
    [_tempe2Label setEnabled:NO];
    [_tempe3Label setEnabled:NO];
    [_tempe4Label setEnabled:NO];
    [_state1Label setEnabled:NO];
    [_state2Label setEnabled:NO];
    [_state3Label setEnabled:NO];
    [_state4Label setEnabled:NO];
    [_state5Label setEnabled:NO];
    [_state6Label setEnabled:NO];
    [_state7Label setEnabled:NO];
    [_state8Label setEnabled:NO];
    [_messageLabel setEnabled:NO];
    [_spanButton1 setEnabled:NO];
    [_spanButton2 setEnabled:NO];
    [_spanButton3 setEnabled:NO];
    [_spanButton4 setEnabled:NO];
    [_spanButton5 setEnabled:NO];
    [_spanButton6 setEnabled:NO];
    [_warnLabel setEnabled:NO];
}

- (void)removeDevice:(id)sender{
    
}

@end
