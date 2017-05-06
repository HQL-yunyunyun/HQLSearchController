//
//  ViewController.m
//  HQLSearchController
//
//  Created by weplus on 2017/3/28.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "ViewController.h"

#import "HQLSearchTagView.h"

#import "HQLSearchController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTopConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    HQLSearchTagView *tagView = [[HQLSearchTagView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:tagView];
//    
//    HQLSearchTagComponentModel *model = [[HQLSearchTagComponentModel alloc] init];
//    NSMutableArray *stringArray = [NSMutableArray array];
//    for (int i = 0; i < 20; i++) {
//        [stringArray addObject:[NSString stringWithFormat:@"tagButton%d", i]];
//    }
//    model.dataSource = stringArray;
//    model.title = @"这是第一个title";
//    tagView.componentsDataSource = @[model];
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (IBAction)buttonDidClick:(UIButton *)sender {
    HQLSearchController *controller = [HQLSearchController new];
    controller.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    __weak typeof(self) weakSelf = self;
    [controller showInViewController:self duringAnimation:^{
        weakSelf.buttonTopConstraint.constant = 0;
        [weakSelf.view layoutIfNeeded];
    }];
//    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
