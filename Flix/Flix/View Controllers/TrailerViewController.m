//
//  TrailerViewController.m
//  
//
//  Created by Maya Epps on 5/23/21.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>

@interface TrailerViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *webkitView;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getURL];
}

- (void) getURL {
    
    NSString *apiCallString = @"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:apiCallString, self.movie[@"id"]]];
    NSLog(@"URL: %@", url.absoluteString);
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unable to get trailer" message:[error localizedDescription] preferredStyle:(UIAlertControllerStyleAlert)];
               // create a "Try Again" action
               UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   [self getURL];
                }];
               // add the action to the alert controller
               [alert addAction:tryAgainAction];
               [self presentViewController:alert animated:YES completion:^{}];

           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSDictionary *result = dataDictionary[@"results"][0];
               
               NSString *urlString = @"https://www.youtube.com/watch?v=";
               NSString *key = result[@"key"];
               NSString *stringURL = [urlString stringByAppendingString:key];
               NSURL *trailerUrl = [NSURL URLWithString:stringURL];
               [self playTrailer: trailerUrl];
               
           }
       }];
    [task resume];
}

- (void) playTrailer: (NSURL*) trailerURL {

    // Place the URL in a URL Request.
    NSURLRequest *request = [NSURLRequest requestWithURL:trailerURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    // Load Request into WebView.
    [self.webkitView loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
