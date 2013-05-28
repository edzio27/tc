//
//  ShopListViewController.m
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 28.05.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "ShopListViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface ShopListViewController ()

@property (nonatomic, strong) UITableView *tableView;

/* core data */
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *productsList;
@property (nonatomic, strong) NSMutableArray *shopList;

@end

@implementation ShopListViewController

#pragma mark -
#pragma mark initialization

- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (UITableView *)tableView {
    if(_tableView == nil) {
        CGRect rectTableView = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height
                                          - self.navigationController.navigationBar.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:rectTableView style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark -
#pragma mark Arrays

- (NSMutableArray *)shopList {
    if(_shopList == nil) {
        _shopList = [[NSMutableArray alloc] init];
        
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Shop" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        _shopList = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    }
    return _shopList;
}

- (NSMutableArray *)productsList {
    if(_productsList == nil) {
        _productsList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.shopList.count; i++) {
            
            NSError *error;
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            
            NSManagedObject *details = [self.shopList objectAtIndex:i];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shop = %@", details];
            NSEntityDescription *entity = [NSEntityDescription
                                           entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            [_productsList addObject:array];
        }
    }
    return _productsList;
}

#pragma mark -
#pragma mark tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.shopList.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSManagedObject *details = [self.shopList objectAtIndex:section];
    return [details valueForKey:@"name"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.productsList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Identifier";
    ProductCell *cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if(cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSManagedObject *details = [[self.productsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@", [details valueForKey:@"price"]];
    cell.titleLabel.text = [details valueForKey:@"name"];
    cell.productImageView.image = [UIImage imageNamed:@"no-image-blog-one"];
    dispatch_queue_t queue = dispatch_queue_create("com.yourdomain.yourappname", NULL);
    dispatch_async(queue, ^{
        NSLog(@"image %@", [details valueForKey:@"imageURL"]);
        NSURL *url = [NSURL URLWithString:[details valueForKey:@"imageURL"]];
        NSData * data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage * image = [[UIImage alloc] initWithData:data];
        dispatch_async( dispatch_get_main_queue(), ^(void){
            if(image != nil) {
                cell.productImageView.image = image;
            } else {
                //errorBlock();
            }
        });
    });
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tab]
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
