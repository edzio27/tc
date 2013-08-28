//
//  ProductViewController.m
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 14.06.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "ProductViewController.h"
#import "TMCache.h"
#import <QuartzCore/QuartzCore.h>
#import "Shop.h"
#import "Product.h"
#import "Favourite.h"
#import "AppDelegate.h"

@interface ProductViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ProductViewController

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 44)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:23];
        _titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIButton *)button {
    if(_button == nil) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(10, 220, 90, 35)];
        _button.layer.cornerRadius = 10.0f;
        _button.layer.masksToBounds = YES;
        _button.titleLabel.textColor = [UIColor whiteColor];
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button setTitle:@"Ulubione" forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:17];
        [_button setBackgroundColor:[UIColor colorWithRed:0.322 green:0.314 blue:0.345 alpha:1.0]];
        [_button addTarget:self action:@selector(addToFavourite) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)addToFavourite {
    Product *product = (Product *)self.detail;
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Favourite" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *array = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(! [((NSMutableArray *)[array valueForKey:@"productURL"]) containsObject:product.productURL] ) {
        Favourite *favourite = [NSEntityDescription insertNewObjectForEntityForName:@"Favourite" inManagedObjectContext:self.managedObjectContext];
        
        NSString *shopName = [product.shop.name mutableCopy];
        [favourite setValue:product.name forKey:@"name"];
        [favourite setValue:product.price forKey:@"price"];
        [favourite setValue:product.priceForLiter forKey:@"priceForLiter"];
        [favourite setValue:product.endDate forKey:@"endDate"];
        [favourite setValue:product.startDate forKey:@"startDate"];
        [favourite setValue:product.imageURL forKey:@"imageURL"];
        [favourite setValue:product.productURL forKey:@"productURL"];
        [favourite setValue:product.size forKey:@"size"];
        [favourite setValue:product.quantity forKey:@"quantity"];
        [favourite setValue:shopName forKey:@"shopName"];
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dodano" message:@"Produkt dodano do ulubionych!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (void)loadProductImageView {
     dispatch_queue_t queue = dispatch_queue_create("com.yourdomain.yourappname", NULL);
    [[TMCache sharedCache] objectForKey:[self.detail valueForKey:@"productURL"]
                                  block:^(TMCache *cache, NSString *key, id object) {
                                      UIImage *image = (UIImage *)object;
                                      if(image) {
                                          dispatch_async( dispatch_get_main_queue(), ^(void){
                                              [self.productImage setImage:image];
                                              self.productImage.clipsToBounds = YES;
                                          });
                                      } else {
                                          dispatch_async(queue, ^{
                                              NSURL *url = [NSURL URLWithString:[self.detail valueForKey:@"imageURL"]];
                                              NSData * data = [[NSData alloc] initWithContentsOfURL:url];
                                              UIImage * image = [[UIImage alloc] initWithData:data];
                                              dispatch_async( dispatch_get_main_queue(), ^(void){
                                                  if(image != nil) {
                                                      [self.productImage setImage:image];
                                                      self.productImage.clipsToBounds = YES;
                                                      [[TMCache sharedCache] setObject:image forKey:[self.detail valueForKey:@"productURL"] block:nil];
                                                  } else {
                                                      //errorBlock();
                                                  }
                                              });
                                          });
                                      }
                                  }];
}

- (void)addTextToProduct {
    
    /* add title to product title */
    self.productName.backgroundColor = [UIColor clearColor];
    self.productName.textColor = [UIColor colorWithRed:0.69411764710000001 green:0.20000000000000001 blue:0.1450980392 alpha:1.0];
    self.productName.font = [UIFont fontWithName:@"Courier-Bold" size:18];
    self.productName.numberOfLines = 2;
    if([[self.detail valueForKey:@"quantity"] integerValue] > 1) {
        self.productName.text = [NSString stringWithFormat:@"%@ %@x%@ml",
                                 [self.detail valueForKey:@"name"],
                                 [self.detail valueForKey:@"quantity"],
                                 [self.detail valueForKey:@"size"]];
    } else {
        self.productName.text = [NSString stringWithFormat:@"%@ %@ml",
                                 [self.detail valueForKey:@"name"],
                                 [self.detail valueForKey:@"size"]];
    }
    
    /* add title to description */
    self.productDescription.backgroundColor = [UIColor clearColor];
    self.productDescription.textColor = [UIColor colorWithRed:0.322 green:0.314 blue:0.345 alpha:1.0];
    self.productDescription.font = [UIFont fontWithName:@"Courier-Bold" size:14];
    self.productDescription.numberOfLines = 2;
    self.productDescription.text = [NSString stringWithFormat:@"Czas trwania promocji:\n%@ - %@",
                                    [self.detail valueForKey:@"startDate"],
                                    [self.detail valueForKey:@"endDate"]];
    
    /* add medium price label to product */
    self.mediumPrice.backgroundColor = [UIColor clearColor];
    self.mediumPrice.textColor = [UIColor colorWithRed:0.322 green:0.314 blue:0.345 alpha:1.0];
    self.mediumPrice.font = [UIFont fontWithName:@"Courier-Bold" size:14];
    self.mediumPrice.numberOfLines = 2;
    self.mediumPrice.text = [NSString stringWithFormat:@"Średnia cena za litr: %@PLN", [self.detail valueForKey:@"priceForLiter"]];
    
    /* add price label to product */
    self.priceLabel.backgroundColor = [UIColor clearColor];
    self.priceLabel.textColor = [UIColor blackColor];
    self.priceLabel.font = [UIFont fontWithName:@"Courier-Bold" size:20];
    self.priceLabel.numberOfLines = 2;
    self.priceLabel.text = [NSString stringWithFormat:@"%@PLN", [self.detail valueForKey:@"price"]];
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
    [self addTextToProduct];
    [self loadProductImageView];
    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(dupa)];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    Product *product = (Product *)self.detail;
    self.titleLabel.text = product.name;
    self.navigationItem.titleView = self.titleLabel;
    [self.view addSubview:self.button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
