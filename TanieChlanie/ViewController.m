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
#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *authorLabel;

@end

@implementation ViewController

- (void)openEmail {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:@[@"eugeniusz.keptia@gmail.com"]];
    if ([MFMailComposeViewController canSendMail]) {
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)button1 {
    if(_button1 == nil) {
        _button1 = [[UIButton alloc] initWithFrame:CGRectMake(70, 180, 180, 40)];
        _button1.layer.cornerRadius = 10.0f;
        _button1.layer.masksToBounds = YES;
        _button1.titleLabel.textColor = [UIColor whiteColor];
        _button1.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button1 setTitle:@"Pokaż wszystkie" forState:UIControlStateNormal];
        _button1.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:17];
        [_button1 setBackgroundColor:[UIColor colorWithRed:0.608 green:0.518 blue:0.953 alpha:1.0]];
        [_button1 addTarget:self action:@selector(showAll) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}

- (UIButton *)button2 {
    if(_button2 == nil) {
        _button2 = [[UIButton alloc] initWithFrame:CGRectMake(70, 240, 180, 40)];
        _button2.layer.cornerRadius = 10.0f;
        _button2.layer.masksToBounds = YES;
        _button2.titleLabel.textColor = [UIColor whiteColor];
        _button2.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button2 setTitle:@"Szukaj w sklepie" forState:UIControlStateNormal];
        _button2.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:17];
        [_button2 setBackgroundColor:[UIColor colorWithRed:0.608 green:0.518 blue:0.953 alpha:1.0]];
        [_button2 addTarget:self action:@selector(shopByShop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}

- (UIButton *)button3 {
    if(_button3 == nil) {
        _button3 = [[UIButton alloc] initWithFrame:CGRectMake(70, 300, 180, 40)];
        _button3.layer.cornerRadius = 10.0f;
        _button3.layer.masksToBounds = YES;
        _button3.titleLabel.textColor = [UIColor whiteColor];
        _button3.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button3 setTitle:@"Wyszukaj" forState:UIControlStateNormal];
        _button3.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:17];
        [_button3 setBackgroundColor:[UIColor colorWithRed:0.608 green:0.518 blue:0.953 alpha:1.0]];
        [_button3 addTarget:self action:@selector(showSearchResult) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button3;
}

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 80)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:35];
        _titleLabel.textColor = [UIColor colorWithRed:0.608 green:0.518 blue:0.953 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"Tanie chlanie";
    }
    return _titleLabel;
}

- (UILabel *)authorLabel {
    if(_authorLabel == nil) {
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                 [[UIScreen mainScreen] bounds].size.height - 70,
                                                                 self.view.frame.size.width,
                                                                 50)];
        _authorLabel.backgroundColor = [UIColor clearColor];
        _authorLabel.numberOfLines = 2;
        _authorLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:10];
        _authorLabel.textColor = [UIColor colorWithRed:0.608 green:0.518 blue:0.953 alpha:1.0];
        _authorLabel.textAlignment = NSTextAlignmentCenter;
        _authorLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openEmail)];
        tapGesture.numberOfTapsRequired = 1;
        
        [_authorLabel addGestureRecognizer:tapGesture];
        _authorLabel.text = @"Aplikacja stworzona przez: Eugeniusz Keptia eugeniusz.keptia@gmail.com";
    }
    return _authorLabel;
}

- (BOOL)isThereInternetConnection {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    return internetStatus != NotReachable ? YES : NO;
}

- (void)showAll {
    if([self isThereInternetConnection]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Ładowanie...";
        
        ParseViewController *parse = [[ParseViewController alloc] init];
        [parse downloadJSONAsString:^(NSString *result) {
            [hud hide:YES];
            ProductsListViewController *products = [[ProductsListViewController alloc] init];
            [self.navigationController pushViewController:products animated:YES];
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Błąd połączenia" message:@"Brak połączenia z siecią" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)shopByShop {
    if([self isThereInternetConnection]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Ładowanie...";
        
        ParseViewController *parse = [[ParseViewController alloc] init];
        [parse downloadJSONAsString:^(NSString *result) {
            [hud hide:YES];
            ShopListViewController *products = [[ShopListViewController alloc] init];
            [self.navigationController pushViewController:products animated:YES];
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Błąd połączenia" message:@"Brak połączenia z siecią" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

- (void)showSearchResult {
    if([self isThereInternetConnection]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Ładowanie...";
        
        ParseViewController *parse = [[ParseViewController alloc] init];
        [parse downloadJSONAsString:^(NSString *result) {
            [hud hide:YES];
            SearchViewController *products = [[SearchViewController alloc] init];
            [self.navigationController pushViewController:products animated:YES];
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Błąd połączenia" message:@"Brak połączenia z siecią" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.322 green:0.314 blue:0.345 alpha:1.0];
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];
    [self.view addSubview:self.authorLabel];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.titleLabel];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
