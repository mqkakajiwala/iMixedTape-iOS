//
//  FaqView.m
//  iMixedTape
//
//  Created by Mustafa on 04/02/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "FaqView.h"

@implementation FaqView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *fullURL = @"http://staging.imixedtape.com/page/faqs";
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:requestObj];
        });
    
    
}

@end
