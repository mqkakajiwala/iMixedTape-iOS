//
//  AboutUs.h
//  iMixedTape
//
//  Created by Mustafa on 07/12/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUs : UIView<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
