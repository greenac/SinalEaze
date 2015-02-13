//
//  ViewController.m
//  SignalEaze
//
//  Created by Andre Green on 2/12/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "ViewController.h"
#import "SEGaugeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SEGaugeView *gaugeView = [[SEGaugeView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    gaugeView.center = self.view.center;
    [self.view addSubview:gaugeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
