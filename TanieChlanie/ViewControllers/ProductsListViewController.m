//
//  ProductsListViewController.m
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 28.05.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "ProductsListViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "ProductCell.h"
#import "TMCache.h"
#import "ProductViewController.h"

@interface ProductsListViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic) dispatch_queue_t queue;

/* core data */
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *productsList;
@property (nonatomic, strong) NSMutableArray *shopList;

@end

@implementation ProductsListViewController

#pragma mark -
#pragma mark initialization

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 44)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:23];
        _titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        if(!self.shopName) {
            _titleLabel.text = @"Produkty";
        } else {
            _titleLabel.text = self.shopName;
        }
    }
    return _titleLabel;
}


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
                                          - self.navigationController.navigationBar.frame.size.height - 30);
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
        NSArray *array = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
        if(!self.shopName) {
            _shopList = [array mutableCopy];
        } else {
            for(int i = 0; i < array.count; i++) {
                NSManagedObject *object = [array objectAtIndex:i];
                if([self.shopName isEqualToString:[object valueForKey:@"name"]]) {
                    [_shopList addObject:object];
                }
            }
        }
            
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    //imageView.image = [UIImage imageNamed:@"section"];
    imageView.backgroundColor = [UIColor colorWithRed:0.69411764710000001 green:0.20000000000000001 blue:0.1450980392 alpha:1.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:16];
    titleLabel.text = [self tableView:self.tableView titleForHeaderInSection:section];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [imageView addSubview:titleLabel];
    
    return imageView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Identifier";
    ProductCell *cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if(cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSManagedObject *details = [[self.productsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@PLN", [details valueForKey:@"price"]];
    if([[details valueForKey:@"quantity"] integerValue] > 1) {
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@x%@ml", [details valueForKey:@"name"], [details valueForKey:@"quantity"], [details valueForKey:@"size"]];
    } else {
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@ml", [details valueForKey:@"name"], [details valueForKey:@"size"]];
    }
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ - %@", [details valueForKey:@"startDate"], [details valueForKey:@"endDate"]];
    cell.productImageView.image = [UIImage imageNamed:@"no-image-blog-one"];
 
    [[TMCache sharedCache] objectForKey:[details valueForKey:@"productURL"]
                  block:^(TMCache *cache, NSString *key, id object) {
                      UIImage *image = (UIImage *)object;
                      if(image) {
                          dispatch_async( dispatch_get_main_queue(), ^(void){
                              [cell.productImageView setImage:image];
                              cell.productImageView.clipsToBounds = YES;
                          });
                      } else {
                          dispatch_async(self.queue, ^{
                              NSURL *url = [NSURL URLWithString:[details valueForKey:@"imageURL"]];
                              NSData * data = [[NSData alloc] initWithContentsOfURL:url];
                              UIImage * image = [[UIImage alloc] initWithData:data];
                              dispatch_async( dispatch_get_main_queue(), ^(void){
                                  if(image != nil) {
                                      [[TMCache sharedCache] setObject:image forKey:[details valueForKey:@"productURL"] block:nil];
                                      cell.productImageView.clipsToBounds = YES;
                                      [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                  } else {
                                      //errorBlock();
                                  }
                              });
                          });
                      }
                  }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductViewController *product = [[ProductViewController alloc] init];
    product.detail = [[self.productsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:product animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.queue = dispatch_queue_create("com.yourdomain.yourappname", NULL);
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.navigationItem.titleView = self.titleLabel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
