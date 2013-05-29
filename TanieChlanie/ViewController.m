//
//  ViewController.m
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 27.05.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "ViewController.h"
#import "ParseViewController.h"
#import "ProductsListViewController.h"
#import "MBProgressHUD.h"
#import "ShopListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

int(^myBlock)(int) = ^(int number){return number*2;};

- (IBAction)showAll:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Ładowanie...";
    
    ParseViewController *parse = [[ParseViewController alloc] init];
    [parse downloadJSONAsString:^(NSString *result) {
        [hud hide:YES];
        ProductsListViewController *products = [[ProductsListViewController alloc] init];
        [self.navigationController pushViewController:products animated:YES];
    }];
}

- (IBAction)shopByShop:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Ładowanie...";
    
    ParseViewController *parse = [[ParseViewController alloc] init];
    [parse downloadJSONAsString:^(NSString *result) {
        [hud hide:YES];
        ShopListViewController *products = [[ShopListViewController alloc] init];
        [self.navigationController pushViewController:products animated:YES];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self ]
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
