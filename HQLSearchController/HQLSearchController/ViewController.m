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

@interface ViewController () <HQLSearchControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) UINavigationController *searchController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc {
    NSLog(@"dealloc ---> %@", NSStringFromClass([self class]));
}

- (IBAction)buttonDidClick:(UIButton *)sender {
    HQLSearchController *controller = [HQLSearchController new];
    controller.delegate = self;
    self.searchController = [[UINavigationController alloc] initWithRootViewController:controller];
    __weak typeof(self) weakSelf = self;
    [controller showInViewController:self searchBarOriginPoint:self.button.frame.origin duringAnimation:^{
        weakSelf.buttonTopConstraint.constant = 0;
        [weakSelf.view layoutIfNeeded];
    }];
//    [self.view layoutIfNeeded];
}

- (void)searchController:(HQLSearchController *)searchController searchBarCancelButtonDidClick:(HQLSearchBar *)searchBar {
    __weak typeof(self) weakSelf = self;
    [searchController hideControllerWithDuringAnimationBlock:^{
        weakSelf.buttonTopConstraint.constant = 64;
        [weakSelf.view layoutIfNeeded];
    } completeBlock:^{
        weakSelf.searchController = nil;
    }];
}

@end
