//
//  HowItWorksView.m
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 2/14/17.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "HowItWorksView.h"


@implementation HowItWorksView{
    
        NSTimer *timer;
    
}

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
    
    self.webView.delegate = self;
     
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *fullURL = @"http://staging.imixedtape.com/page/how-it-works";
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:requestObj];
    });
    
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
     timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(cancelWeb) userInfo:nil repeats:NO];
    [SVProgressHUD show];
}

- (void)cancelWeb
{
    NSLog(@"didn't finish loading within 20 sec");
    [SVProgressHUD dismiss];
    // do anything error
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [timer invalidate];
    [SVProgressHUD dismiss];
    
}


@end
