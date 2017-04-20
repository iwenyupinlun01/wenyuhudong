//
//  newViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/5.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "newViewController.h"
#import "newCell.h"
#import "detailsViewController.h"
#import "SQTopicTableViewController.h"
#import "XWScanImage.h"
#import "newModel.h"
#import "YYPhotoGroupView.h"

@interface newViewController ()<UITableViewDataSource,UITableViewDelegate,mycellVdelegate>
/** 用于加载下一页的参数(页码) */
{
    int pn;
}

@property (nonatomic,strong) UITableView *newtable;
@property (nonatomic,strong) UIImageView *demoimg;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *dataarr;
@property (nonatomic,strong) newModel *nmodel;


@property (strong, nonatomic) NSMutableArray<newModel *> * menus;

@end
static NSString *newidentfid = @"newidentfid";
@implementation newViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    

    
    pn=1;
    self.dataSource = [NSMutableArray array];
    self.dataarr = [NSMutableArray array];
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    [self.view addSubview:self.newtable];
    
}



- (void)addHeader
{
    
    // 头部刷新控件
    self.newtable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    
    [self.newtable.mj_header beginRefreshing];
    
}
- (void)addFooter
{
    self.newtable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshLoadMore)];
}
- (void)refreshAction {
    
    [self headerRefreshEndAction];
    
}
- (void)refreshLoadMore {
    
    [self footerRefreshEndAction];
    
}
- (void)headerRefreshEndAction {
    
    [self.dataSource removeAllObjects];
    [self.dataarr removeAllObjects];
    NSString *strurl = [NSString stringWithFormat:newVCload,@"1",@"1",@""];
    [AFManager getReqURL:strurl block:^(id infor) {
        NSLog(@"infor=====%@",infor);
        NSLog(@"str====%@",strurl);
        NSArray *dit = [infor objectForKey:@"info"];
        
        for (int i = 0; i<dit.count; i++) {
            NSDictionary *dicarr = [dit objectAtIndex:i];
            self.nmodel = [[newModel alloc] init];
            self.nmodel.contentstr = dicarr[@"content"];
            self.nmodel.timestr = dicarr[@"create_time"];
            self.nmodel.imgurlstr = dicarr[@"images"];
            //self.nmodel.imgurlstr = @"http://pic17.nipic.com/20111018/4132236_105939280314_2.jpg";
            self.nmodel.namestr = dicarr[@"name"];
            self.nmodel.dianzanstr = dicarr[@"support_num"];
            self.nmodel.pinglunstr = dicarr[@"reply_num"];
            self.nmodel.newidstr = dicarr[@"id"];
            self.nmodel.titlestr = dicarr[@"title"];
            self.nmodel.fromstr = [NSString stringWithFormat:@"%@%@",@"被点赞",dicarr[@"support_count"]];
            [self.dataSource addObject:self.nmodel.contentstr];
            [self.dataarr addObject:self.nmodel];
        }
        [self.newtable.mj_header endRefreshing];
        
        [self.newtable reloadData];
       
    } errorblock:^(NSError *error) {
        
    }];

//    for (int i = 0; i<10; i++) {
//        self.nmodel = [[newModel alloc] init];
//        self.nmodel.contentstr = @"对空射击诶积极的司法解释";
//        
//        self.nmodel.timestr = @"12999291992";
//        self.nmodel.imgurlstr = @"http://pic17.nipic.com/20111018/4132236_105939280314_2.jpg";
//        self.nmodel.namestr = @"name";
//        self.nmodel.titlestr = @"title";
//        [self.dataSource addObject:self.nmodel.contentstr];
//        [self.dataarr addObject:self.nmodel];
//    }
//    [self.newtable.mj_header endRefreshing];
//    
//    [self.newtable reloadData];
    
}
- (void)footerRefreshEndAction {
    pn ++;
    
    
    NSString *pnstr = [NSString stringWithFormat:@"%d",pn];
    NSString *strurl = [NSString stringWithFormat:newVCload,pnstr,@"1",@""];
    [AFManager getReqURL:strurl block:^(id infor) {
        NSLog(@"infor=====%@",infor);
        NSLog(@"str====%@",strurl);
        
        NSArray *dit = [infor objectForKey:@"info"];
        for (int i = 0; i<dit.count; i++) {
            NSDictionary *dicarr = [dit objectAtIndex:i];
            self.nmodel = [[newModel alloc] init];
            self.nmodel.contentstr = dicarr[@"content"];
            self.nmodel.timestr = dicarr[@"create_time"];
            self.nmodel.imgurlstr = dicarr[@"images"];
            //self.nmodel.imgurlstr = @"http://baiduapp.changweibo.net/user_img/2017/0415/14362936404.png";
            self.nmodel.namestr = dicarr[@"name"];
            self.nmodel.dianzanstr = dicarr[@"support_num"];
            self.nmodel.pinglunstr = dicarr[@"reply_num"];
            self.nmodel.newidstr = dicarr[@"id"];
            self.nmodel.titlestr = dicarr[@"title"];
            self.nmodel.fromstr = [NSString stringWithFormat:@"%@%@",@"被点赞",dicarr[@"support_count"]];
            [self.dataSource addObject:self.nmodel.contentstr];
            [self.dataarr addObject:self.nmodel];
        }
        [self.newtable.mj_footer endRefreshing];
        
        [self.newtable reloadData];
       
    } errorblock:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.newtable.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64);
    
}

#pragma mark - getters

-(UIImageView *)demoimg
{
    if(!_demoimg)
    {
        _demoimg = [[UIImageView alloc] init];
    }
    return _demoimg;
}

-(UITableView *)newtable
{
    if(!_newtable)
    {
        _newtable = [[UITableView alloc] init];
        _newtable.dataSource = self;
        _newtable.delegate = self;
    }
    return _newtable;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.nmodel.imgurlstr.length==0) {
        return [newCell cellHeightWithText:self.dataSource[indexPath.row]]+(16+14+16+4+20+16+16)*HEIGHT_SCALE;
    }
    else if(self.nmodel.contentstr.length==0&&self.nmodel.imgurlstr.length!=0)
    {
        return (16+14+16+4+20+16+16+196)*HEIGHT_SCALE;
    }
    else
    {
         return [newCell cellHeightWithText:self.dataSource[indexPath.row]]+(16+14+16+4+20+16+16+14+196)*HEIGHT_SCALE;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    newCell *cell = [tableView dequeueReusableCellWithIdentifier:newidentfid];
    if (!cell) {
        cell = [[newCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newidentfid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell setcelldata:self.dataarr[indexPath.row]];
    return cell;
}

- (NSString *)p_textAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.dataSource objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.nmodel = [[newModel alloc] init];
    self.nmodel = self.dataarr[indexPath.row];
    NSString *str = self.nmodel.newidstr;
    NSLog(@"str======%@",str);

    detailsViewController *detailsvc = [[detailsViewController alloc] init];
    detailsvc.detalisidstr = str;
    [self.navigationController pushViewController:detailsvc animated:YES];
    
}

//点赞
-(void)myTabVClick1:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.newtable indexPathForCell:cell];
    NSLog(@"333===%ld   点赞",index.row);
}

//回复
-(void)myTabVClick2:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.newtable indexPathForCell:cell];
    NSLog(@"333===%ld   回复",index.row);
}



@end
