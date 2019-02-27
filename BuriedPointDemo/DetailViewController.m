//
//  DetailViewController.m
//  BuriedPointDemo
//
//  Created by 惠上科技 on 2019/2/27.
//  Copyright © 2019 惠上科技. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DetailViewController";
}

/**
 分享按钮点击
 */
- (IBAction)onShareBtnPressed:(UIButton *)sender {
    NSLog(@"==========我要分享啦==========");
}

@end
