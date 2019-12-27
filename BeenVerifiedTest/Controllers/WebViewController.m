//
//  WebViewController.m
//  BeenVerifiedTest
//
//  Created by David Saborio Alvarado on 12/27/19.
//  Copyright © 2019 David Saborio Alvarado. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.delegate = self;

    NSURL *targetURL = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [_webView loadRequest:request];

}

@end
