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

@interface ProductViewController ()

@end

@implementation ProductViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
