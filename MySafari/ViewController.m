//
//  ViewController.m
//  MySafari
//
//  Created by Paul Kitchener on 9/30/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *networkActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@property NSString *theTitle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.networkActivityIndicator.hidesWhenStopped = YES;
    [self.webView.scrollView setDelegate:self];

    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;

    [self openURL:@"http://apple.com"];

}

- (void)openURL:(NSString *)string {
    if ([string hasPrefix:@"http://"]) {
        NSURL *url = [NSURL URLWithString:string];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    else {
        NSString *formattedString = [NSString stringWithFormat:@"http://%@", string];
        NSURL *url = [NSURL URLWithString:formattedString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self openURL:textField.text];
    return [textField resignFirstResponder];
}


-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.networkActivityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.networkActivityIndicator stopAnimating];

    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;

    self.urlTextField.text = self.webView.request.URL.absoluteString;

    self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (IBAction)onBackButtonPressed:(id)sender {
    [self.webView goBack];

}

- (IBAction)onForwardButtonPressed:(id)sender {
    [self.webView goForward];
}

- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [self.webView stopLoading];
}

- (IBAction)onReloadButtonPressed:(id)sender {
    [self.webView reload];
}

- (IBAction)onPlusButtonPressed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Coming soon!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *goHomeButton = [UIAlertAction actionWithTitle:@"Go home" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openURL:@"http://apple.com"];
    }];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:goHomeButton];
    [alertController addAction:cancelButton];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect newFrame = self.urlTextField.frame;
    if (scrollView.contentOffset.y > 0) {
        self.urlTextField.alpha = (100/scrollView.contentOffset.y);
        newFrame.origin.y -= (scrollView.contentOffset.y/100);
        self.urlTextField.frame = newFrame;
    }
    else {
        self.urlTextField.alpha = 1;
        newFrame.origin.y = 75;
        self.urlTextField.frame = newFrame;
    }
}

@end
