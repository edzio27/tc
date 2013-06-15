//
//  ProductViewController.h
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 14.06.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ProductViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *productImage;
@property (nonatomic, strong) IBOutlet UILabel *productName;
@property (nonatomic, strong) IBOutlet UILabel *productDescription;
@property (nonatomic, strong) NSManagedObject *detail;
@property (nonatomic, strong) IBOutlet UILabel *mediumPrice;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;

@end
