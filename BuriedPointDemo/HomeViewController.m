//
//  HomeViewController.m
//  BuriedPointDemo
//
//  Created by 惠上科技 on 2019/2/27.
//  Copyright © 2019 惠上科技. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"HomeViewController";
}

/**
 收藏点击
 */
- (IBAction)onFavBtnPressed:(UIButton *)sender {
    NSLog(@"==========我要收藏啦==========");
}


/**
 分享点击
 */
- (IBAction)onShareBtnPressed:(UIButton *)sender {
    NSLog(@"==========我要分享啦==========");
}


/**
 跳转到下一界面
 */
- (IBAction)onNextItemPressed:(UIBarButtonItem *)sender {
    DetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
