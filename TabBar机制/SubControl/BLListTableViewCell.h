//
//  BLListTableViewCell.h
//  TabBar机制
//
//  Created by 王春龙 on 2018/1/24.
//  Copyright © 2018年 Balopy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageVw;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@end
