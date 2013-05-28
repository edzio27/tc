//
//  ProductCell.m
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 28.05.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 100, 30)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 0, 40, 30)];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.priceLabel];
        
        self.productImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        [self addSubview:self.productImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
