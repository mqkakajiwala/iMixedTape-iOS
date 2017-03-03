//
//  CustomCell.m
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 12/29/16.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

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
