//
//  HowItWorksView.h
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 2/14/17.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HowItWorksView : UIView<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
