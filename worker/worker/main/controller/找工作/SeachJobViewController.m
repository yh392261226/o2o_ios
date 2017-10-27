//
//  SeachJobViewController.m
//  worker
//
//  Created by 郭健 on 2017/8/3.
//  Copyright © 2017年 郭健. All rights reserved.
//

#import "SeachJobViewController.h"
#import "WorkerMessTableViewCell.h"
#import "DressingWorkerViewController.h"
#import "BmapWorkerViewController.h"



@implementation jobListData


@end


@interface SeachJobViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *dataArray;
    
    NSMutableArray *newArray;   // 缓存的数组
    
    
    
    NSString *name1;
    NSString *range1;
    NSString *time1;
    NSString *money1;
    NSString *startTime1;
    NSString *proType1;
    NSString *worker1;
    
}

@property (nonatomic, strong)UITableView *tableview;

@end

@implementation SeachJobViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataArray = [NSMutableArray array];
    
    newArray = [NSMutableArray array];
    
    
    [self getdata];
    
    [self addhead:@"工作信息"];
    
    [self initScreenBtn];
    
   // [self slitherBack:self.navigationController];
    
    [self tableview];
    
}




#pragma Tableview

- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        
        [_tableview registerClass:[WorkerMessTableViewCell class] forCellReuseIdentifier:@"cell"];
        
        _tableview.backgroundColor = [myselfway stringTOColor:@"0xC4CED3"];
        
       
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        
        [self.view addSubview:_tableview];
    }
    
    return _tableview;
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    jobListData *model = [dataArray objectAtIndex:indexPath.section];
    
    
    WorkerMessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.details.hidden = YES;
    
    cell.title.text = model.t_title;
    cell.introduce.text = model.t_info;
    
    if ([model.t_status isEqualToString:@"0"])
    {
        cell.state.image = [UIImage imageNamed:@"main_state1"];
    }
    else if ([model.t_status isEqualToString:@"1"])
    {
        cell.state.image = [UIImage imageNamed:@"main_state3"];
    }
    else if ([model.t_status isEqualToString:@"2"])
    {
        cell.state.image = [UIImage imageNamed:@"main_state5"];
    }
    else
    {
        cell.state.image = [UIImage imageNamed:@"main_state6"];
    }
    
    int myInt = [model.favorate intValue];
    
    if (myInt == 0)
    {
        [cell.favoriteBtn setImage:[UIImage imageNamed:@"main_favoriteNO"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.favoriteBtn setImage:[UIImage imageNamed:@"main_favoriteYes"] forState:UIControlStateNormal];
    }
    
    
    
    NSURL *url = [NSURL URLWithString:model.u_img];
    
    [cell.IconBtn sd_setImageWithURL:url];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.favoriteBtn.tag = 500 + indexPath.section;
    
    [cell.favoriteBtn addTarget:self action:@selector(favoriteBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    return view;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    jobListData *data = [dataArray objectAtIndex:indexPath.section];
    
    self.hidesBottomBarWhenPushed = YES;
    
    BmapWorkerViewController *temp = [[BmapWorkerViewController alloc] init];
    
    temp.t_id = data.t_id;
    
    temp.info = data;
    
    [self.navigationController pushViewController:temp animated:YES];
    
}


#pragma 自己的方法

//添加筛选按钮
- (void)initScreenBtn
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(SCREEN_WIDTH - 35, 33, 20, 20);
    
    [button addTarget:self action:@selector(screenBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [button setBackgroundImage:[UIImage imageNamed:@"main_screen"] forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    
}


//筛选按钮的点击事件
- (void)screenBtn
{
    self.hidesBottomBarWhenPushed = YES;
    
    DressingWorkerViewController *temp = [[DressingWorkerViewController alloc] init];

    temp.delegate = self;
    [self presentViewController:temp animated:YES completion:nil];
}



//cell上收藏按钮的点击
- (void)favoriteBtn: (UIButton *)btn
{
    NSLog(@"%ld", btn.tag);
}



//网络请求
- (void)getdata
{
    NSString *url = [NSString stringWithFormat:@"%@Tasks/index?action=list&u_id=%@", baseUrl, user_ID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         
         if ([[dictionary objectForKey:@"code"] integerValue] == 200)
         {
             [dataArray removeAllObjects];
             
             NSArray *arr = [dictionary objectForKey:@"data"];
             
             for (int i = 0; i < arr.count; i++)
             {
                 NSDictionary *dic = [arr objectAtIndex:i];
                 
                 jobListData *data = [[jobListData alloc] init];
                 
                 data.t_id = [dic objectForKey:@"t_id"];
                 data.t_title = [dic objectForKey:@"t_title"];
                 data.t_info = [dic objectForKey:@"t_info"];
                 data.t_amount = [dic objectForKey:@"t_amount"];
                 data.t_duration = [dic objectForKey:@"t_duration"];
                 data.t_edit_amount = [dic objectForKey:@"t_edit_amount"];
                 data.t_amount_edit_times = [dic objectForKey:@"t_amount_edit_times"];
                 data.t_posit_x = [dic objectForKey:@"t_posit_x"];
                 data.t_posit_y = [dic objectForKey:@"t_posit_y"];
                 data.t_author = [dic objectForKey:@"t_author"];
                 data.t_in_time = [dic objectForKey:@"t_in_time"];
                 data.t_last_edit_time = [dic objectForKey:@"t_last_edit_time"];
                 data.t_last_editor = [dic objectForKey:@"t_last_editor"];
                 data.t_status = [dic objectForKey:@"t_status"];
                 data.t_phone = [dic objectForKey:@"t_phone"];
                 data.t_phone_status = [dic objectForKey:@"t_pho ne_status"];
                 data.t_desc = [dic objectForKey:@"t_desc"];
                 data.favorate = [dic objectForKey:@"favorate"];
                 data.tew_id = [dic objectForKey:@"tew_id"];
                 data.tew_lock = [dic objectForKey:@"tew_lock"];
                 data.tew_skills = [dic objectForKey:@"tew_skills"];
                 data.tew_worker_num = [dic objectForKey:@"tew_worker_num"];
                 data.tew_price = [dic objectForKey:@"tew_price"];
                 data.tew_start_time = [dic objectForKey:@"tew_start_time"];
                 data.tew_end_time = [dic objectForKey:@"tew_end_time"];
                 data.r_province = [dic objectForKey:@"r_province"];
                 data.r_city = [dic objectForKey:@"r_city"];
                 data.r_area = [dic objectForKey:@"r_area"];
                 data.tew_address = [dic objectForKey:@"tew_address"];
                 data.u_img = [dic objectForKey:@"u_img"];
                 
                 [dataArray addObject:data];
                 
             }
             
             for (int i = 0; i < dataArray.count; i++)
             {
                 jobListData *data = [dataArray objectAtIndex:i];
                 
                 NSString *IDwor = data.t_id;
                 
                 data.t_imageUrl = [NSString stringWithFormat:@"http://static.gangjianwang.com/images/skills/%@.png", IDwor];
             }
             
             [self.tableview reloadData];
             
             
             [self cacheData];
             
         }
         else
         {
             
             
             
         }
         
         
         
     }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
     }];
    
    
}


//把网络请求来的数据，缓存成本地文件夹
- (void)cacheData
{
    [newArray removeAllObjects];
    
    for (int i = 0; i < dataArray.count; i++)
    {
        jobListData *data = [dataArray objectAtIndex:i];
        
        NSDictionary *dic = [myselfway entityToDictionary:data];
        
        [newArray addObject:dic];
    }
    
    [self creatPlistFileWithArr:newArray];
}


- (void)creatPlistFileWithArr:(NSArray *)array
{
    //将字典保存到document文件->获取appdocument路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    //创建工种列表的路径
    NSString *workerPath = [NSString stringWithFormat:@"%@/employerList", docPath];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:workerPath])
    {
        [fileManager createDirectoryAtPath:workerPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    else
    {
        
    }
    
    NSString *userInfo = [workerPath stringByAppendingPathComponent:@"listEmployer.plist"];
    
    [array writeToFile:userInfo atomically:YES];
    
}








//筛选条件的代理
- (void)DressWorkerData:(NSString *)name adree:(NSString *)adree proData:(NSString *)proData proMoney:(NSString *)proMoney proTime:(NSString *)proTime proType:(NSString *)proType proWorker:(NSString *)proWorker
{
    name1 = name;
    range1 = adree;
    time1 = proData;
    money1 = proMoney;
    startTime1 = proTime;
    proType1 = proType;
    worker1 = proWorker;
    
    [self getdata];
}














- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
