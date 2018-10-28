//
//  ViewController.m
//  JSExport
//
//  Created by liang wang on 2018/10/24.
//  Copyright © 2018年 liang wang. All rights reserved.
//

#import "ViewController.h"
#import "GFBNewWebViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    GFBNewWebViewController *webVc = [[GFBNewWebViewController alloc]init];
    [self.navigationController pushViewController:webVc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
