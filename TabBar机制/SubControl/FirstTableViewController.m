//
//  FirstTableViewController.m
//  TabBar机制
//
//  Created by 王春龙 on 2018/1/24.
//  Copyright © 2018年 Balopy. All rights reserved.
//

#import "FirstTableViewController.h"
#import "BLListModel.h"
#import "BLListTableViewCell.h"
@interface FirstTableViewController ()
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger totalPage;
@property (nonatomic, assign) BOOL refresh;
@end

static NSString *cellID = @"FirstTableViewControllerID";
@implementation FirstTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"第一个View";
    [self.tableView registerNib:[UINib nibWithNibName:@"BLListTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
   

    MJWeakSelf
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        weakSelf.refresh = YES;
        weakSelf.currentPage = 1;
        [weakSelf loadFirstData];
    }];

    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        if (weakSelf.currentPage < weakSelf.totalPage) {
            [self.tableView.mj_footer beginRefreshing];
            weakSelf.refresh = NO;
            weakSelf.currentPage ++;
            [weakSelf loadFirstData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadFirstData {
    
    [HttpRequestModel request:baseUrlString withParamters:@{@"currentPage" : @(self.currentPage)} success:^(id responseData) {
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            if ([responseData[@"success"] boolValue]) {
               
                
                NSDictionary *entity = [responseData objectForKey:@"entity"];
                NSDictionary *page = [entity objectForKey:@"page"];
                self.currentPage = [[page objectForKey:@"currentPage"] integerValue];
                self.totalPage = [[page objectForKey:@"totalPageSize"] integerValue];
                NSArray *list = [entity objectForKey:@"teacherList"];
               
                if (self.refresh) {
                    self.listArray = [NSArray modelArrayWithClass:[BLListModel class] json:list];
                } else {
                  
                    NSMutableArray *tempArr = self.listArray.mutableCopy;
                    NSArray *temp = [NSArray modelArrayWithClass:[BLListModel class] json:list];
                    [tempArr addObjectsFromArray:temp];
                    self.listArray = tempArr;
                }
                [self.tableView reloadData];
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    BLListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
   
    BLListModel *model = self.listArray[indexPath.row];
    
    cell.titleLab.text = model.name;
    cell.detailLab.text = model.career;
    NSURL *url = [NSURL URLWithString:[imageUrlString stringByAppendingString:model.picPath]];
    [cell.imageVw setImageURL:url];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

@end
