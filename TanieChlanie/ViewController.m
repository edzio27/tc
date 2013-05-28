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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    ParseViewController *parse = [[ParseViewController alloc] init];
    [parse downloadJSONAsString];
    [self performSelector:@selector(pok) withObject:self afterDelay:5.0];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)pok {
    ProductsListViewController *products = [[ProductsListViewController alloc] init];
    NSLog(@"sda %@", self.navigationController);
    [self.navigationController pushViewController:products animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
