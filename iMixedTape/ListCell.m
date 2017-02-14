//
//  ListCell.m
//  iMixedTape
//
//  Created by Mustafa on 21/12/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    dispatch_async(dispatch_get_main_queue(), ^{
        
    
    gradient.frame = self.cardView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor colorWithRed:0.820 green:0.816 blue:0.820 alpha:1.00] CGColor], nil];
    [self.cardView.layer insertSublayer:gradient atIndex:0];
    });
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
