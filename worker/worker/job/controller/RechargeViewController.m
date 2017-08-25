//
//  RechargeViewController.m
//  worker
//
//  Created by 郭健 on 2017/8/7.
//  Copyright © 2017年 郭健. All rights reserved.
//

#import "RechargeViewController.h"
#import "RechargeTableViewCell.h"
#import "PayTableViewCell.h"

@interface RechargeViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSMutableArray *dataArray;
    
    
    NSMutableArray *nameArray;   
    NSMutableArray *imageArray;
    
    NSInteger paySelecd;   //判断选择支付方式
    
    
    
}


@property (nonatomic, strong)UITableView *tableview;

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    paySelecd = 0;   //默认选择第一个
    
    dataArray = [NSMutableArray array];
    
    nameArray = [NSMutableArray arrayWithObjects:@"微信支付",@"支付宝支付", @"银行卡支付",  nil];
    
    imageArray = [NSMutableArray arrayWithObjects:@"job_wechat", @"job_alipay", @"job_yinhang", nil];
    
    [self addhead:@"充值"];
    
    [self slitherBack:self.navigationController];
    
    [self tableview];
    
    [self initOneLine];
}

//加载一条黑线
- (void)initOneLine
{
    UIView *line = [[UIView alloc] init];
    
    line.frame = CGRectMake(0, 64, SCREEN_WIDTH, 1);
    
    line.backgroundColor = [myselfway stringTOColor:@"0x808080"];
    
    [self.view addSubview:line];
}

#pragma tableview 代理方法

- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT - 65) style:UITableViewStyleGrouped];
        
        [_tableview registerClass:[RechargeTableViewCell class] forCellReuseIdentifier:@"firstCell"];
        [_tableview registerClass:[PayTableViewCell class] forCellReuseIdentifier:@"paycell"];
        
        _tableview.separatorStyle = NO;
        
        _tableview.backgroundColor = [UIColor whiteColor];
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        
        [self.view addSubview:_tableview];
    }
    
    
    
    
    return _tableview;
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return nameArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        RechargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
        
        [cell.textfield addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
   else
   {
       PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paycell"];
       
       cell.logoImage.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
       
       cell.name.text = [nameArray objectAtIndex:indexPath.row];
       
       cell.selecd.backgroundColor = [UIColor orangeColor];
       
       if (indexPath.row == paySelecd)
       {
           cell.selecd.backgroundColor = [UIColor greenColor];
       }
       
       
       return cell;
   }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 40;
    }
    else
    {
        return 60;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    
    UILabel *name = [[UILabel alloc] init];
    
    if (section == 0)
    {
        name.text = @"充值金额";
        
        
    }
    else
    {
        name.text = @"支付方式";
        
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(0, 29, SCREEN_WIDTH, 1);
        line.backgroundColor = [myselfway stringTOColor:@"0x808080"];
        [view addSubview:line];
    }
    
    name.textAlignment = NSTextAlignmentLeft;
    name.textColor = [UIColor grayColor];
    name.font = [UIFont systemFontOfSize:15];
    
    [view addSubview:name];
    
    
    [name mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.mas_equalTo(view).offset(5);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(view).offset(15);
        make.width.mas_equalTo(200);
    }];
    
    
    
    
    
    
    return view;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    if (section == 1)
    {
        
       
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.tag = 400;
        
        button.backgroundColor = [myselfway stringTOColor:@"0x2E84F8"];
        
        [button setTitle:@"去支付" forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        button.layer.cornerRadius = 5;
        
        [button addTarget:self action:@selector(payBtn) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:button];
        
        
        [button mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.mas_equalTo(view).offset(5);
            make.centerX.mas_equalTo(view);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(150);
        }];
        
        
        UITextField *field = [self.view viewWithTag:400];
        
        if (field.text.length == 0)
        {
            button.backgroundColor = [UIColor grayColor];
        }
        
    }
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        paySelecd = indexPath.row;
        
        [self.tableview reloadData];
    }
   
}




#pragma textfield的代理

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UIButton *btn = [self.view viewWithTag:400];
    
    NSString *allStr = [NSString stringWithFormat:@"%@%@", textField.text, string];
    
    if (allStr == textField.text)   //说明在删除
    {
        if (allStr.length == 1)
        {
            btn.backgroundColor = [UIColor grayColor];
            
            btn.userInteractionEnabled = NO;
        }
        
        else
        {
            btn.backgroundColor = [myselfway stringTOColor:@"0x2E84F8"];
            btn.userInteractionEnabled = YES;
        }
    }
    else                            //说明在添加
    {
        if (allStr.length == 0)
        {
            btn.backgroundColor = [UIColor grayColor];
            btn.userInteractionEnabled = NO;
        }
        
        else
        {
            btn.backgroundColor = [myselfway stringTOColor:@"0x2E84F8"];
            btn.userInteractionEnabled = YES;
        }
    }
    
    
    
    
    
    
    
    return YES;
}




//消键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    
    NSLog(@"textfield text %@",textField.text);
    
}


#pragma 自己定义的方法

//去支付按钮
- (void)payBtn
{
    NSLog(@"1");
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end