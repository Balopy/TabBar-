//
//  BLMainViewController.m
//  TabBar机制
//
//  Created by 王春龙 on 2018/1/24.
//  Copyright © 2018年 Balopy. All rights reserved.
//

#import "BLMainViewController.h"
#import "FirstTableViewController.h"
#import "SecondTableViewController.h"


#define kScreen_height [UIScreen mainScreen].bounds.size.height
#define kScreen_width [UIScreen mainScreen].bounds.size.width
/*代替之前的49*/
#define BLTabBar_Height ([UIApplication sharedApplication].statusBarFrame.size.height > 20.0 ? 83.0:49.0)
#define BLNavBar_Height 44.0
#define BLStatusBar_Height [UIApplication sharedApplication].statusBarFrame.size.height

/*代替之前的64*/
#define BLTop_Height (BLStatusBar_Height + BLNavBar_Height)


@interface BLMainViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *currentBtn;
@property (nonatomic, strong)UIView *titleView;
@property (nonatomic, strong)NSMutableArray *controllerArray;
@end



static NSString *kMeCellID = @"meCellId";
@implementation BLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"tabBar机制";

    self.titles = @[@"全部内容",@"视频",@"声音",@"图片",@"段子"];

    if (@available(iOS 11.0, *)) {
      
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    
    [self createLevelView];
    [self createScrollView];
}

#pragma mark -- 创建顶部按钮 --
- (void) createLevelView {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, BLTop_Height, kScreen_width, 44)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    self.titleView = titleView;
    [titleView addSubview:self.bottomLine];
    
    
    for (int i = 0; i<self.titles.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(sectionDidSelectedForTag:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat width = kScreen_width / self.titles.count;
        CGFloat height = titleView.frame.size.height-2;
        button.frame = CGRectMake(i * width, 0, width, height);
        [titleView addSubview:button];
        
        if (i == 0) {
            
            self.bottomLine.center = CGPointMake(CGRectGetMidX(button.frame), CGRectGetMaxY(button.frame) + 1);
            [self sectionDidSelectedForTag:button];
        }
    }
}

#pragma mark -- 创建 ScrollView, 主用于存放 控制器 --
- (void) createScrollView {
  
    CGRect frame = self.view.bounds;
    self.scrollView = [[UIScrollView alloc] init];
    frame.origin.y = CGRectGetMaxY(self.titleView.frame);
    frame.size.height = kScreen_height - CGRectGetMinY(frame);
    self.scrollView.frame = frame;
    CGSize size = CGSizeMake(kScreen_width * self.titles.count, kScreen_height);
    self.scrollView.contentSize = size;
    self.scrollView.bounces = false;
    self.scrollView.scrollEnabled = false;
    self.scrollView.pagingEnabled = true;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    //先调一次，
    [self scrollViewDidScroll:self.scrollView];
}

#pragma mark -- 顶部按钮的响应事件 --
- (void) sectionDidSelectedForTag:(UIButton *)sender {
    
    self.scrollView.contentOffset = CGPointMake(kScreen_width*(sender.tag), 0);
    
    self.currentBtn.selected = false;
    self.currentBtn = sender;
    self.currentBtn.selected = true;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.bottomLine.center = CGPointMake(CGRectGetMidX(sender.frame), CGRectGetMaxY(sender.frame) + 1);
    }];
}


#pragma mark -- scrollview delegate --
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int index = scrollView.contentOffset.x / kScreen_width;
   
    UIViewController * vc = self.controllerArray[index];
    
    vc.view.frame = CGRectMake(index * kScreen_width, 0, kScreen_width, CGRectGetHeight(self.scrollView.bounds));
    
    [self.scrollView addSubview:vc.view];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//// MARK: - 数据源
- (NSMutableArray *)controllerArray {
    
    if (!_controllerArray) {
        
        NSMutableArray *tempArr = @[].mutableCopy;
        
        for (int i = 0; i<self.titles.count; i ++) {
            
            if (i%2 == 0) {
                
                FirstTableViewController *vc =  [[FirstTableViewController alloc] init];
                [tempArr addObject:vc];
            } else {
                
                SecondTableViewController *vc =  [[SecondTableViewController alloc] init];
                [tempArr addObject:vc];
            }
        }
        _controllerArray = tempArr;
    }
    return _controllerArray;
}

- (UIView *)bottomLine {
   
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor redColor];
        _bottomLine.frame = CGRectMake(0, 0, 80, 2);
    }
    return _bottomLine;
}
@end
