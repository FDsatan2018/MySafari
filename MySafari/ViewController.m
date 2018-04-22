//
//  ViewController.m
//  MySafari
//
//  Created by FDsatan on 2018/4/22.
//  Copyright © 2018年 FDsatan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 200, 100)];
    label.text = @"Hello World!";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    
    [self.view addSubview:label];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
