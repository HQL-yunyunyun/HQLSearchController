//
//  ViewController.m
//  HQLSearchController
//
//  Created by weplus on 2017/3/28.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "ViewController.h"

#import "HQLSearchTagView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HQLSearchTagView *tagView = [[HQLSearchTagView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tagView];
    
    HQLSearchTagComponentModel *model = [[HQLSearchTagComponentModel alloc] init];
    NSMutableArray *stringArray = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [stringArray addObject:[NSString stringWithFormat:@"tagButton%d", i]];
    }
    model.dataSource = stringArray;
    model.title = @"这是第一个title";
    tagView.componentsDataSource = @[model];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
