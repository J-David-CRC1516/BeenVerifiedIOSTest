//
//  FirstViewController.m
//  BeenVerifiedTest
//
//  Created by David Saborio Alvarado on 12/21/19.
//  Copyright © 2019 David Saborio Alvarado. All rights reserved.
//

#import "BlogViewController.h"
#import "ArticlesController.h"
#import "WebViewController.h"

@interface BlogViewController () <UITableViewDataSource, UITableViewDelegate>{}
@property (weak, nonatomic) IBOutlet UITableView *articlesHolder;

@end

@implementation BlogViewController

NSUInteger numberOfCells;
NSDictionary *data;
NSArray *articles;
NSUInteger count = 0;
NSDictionary *article;
NSString *url;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
}

-(void) getData {
    
    dispatch_queue_t articlesQueue = dispatch_queue_create("Image Queue",NULL);
    
    @try{
    
    dispatch_async(articlesQueue, ^{
        
        NSString *url = [NSString stringWithFormat:@"https://www.beenverified.com/articles/index.ios.json"];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            NSError *error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            articles = json[@"articles"];
            [self.articlesHolder reloadData];
            
        });
    });
    
    }
    @catch(NSException *exception){
        [self ShowAlert:@"An error has ocurred, please check your internet and try again"];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return articles.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
    ArticlesController *cv = [[ArticlesController alloc]initWithFrame:CGRectMake(5, 5, 0, 0)];
    
    article = articles[count];
    [cv addTitle:article[@"title"]];
    [cv addDescription:article[@"description"]];
    [cv addAuthor:article[@"author"]];
    [cv addDate:article[@"article_date"]];
    [cv addImage:article[@"image"]];
    url = article[@"link"];
    
    UITapGestureRecognizer *singleFingerTap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(openWeb)];
    
    [cell addGestureRecognizer:singleFingerTap];
    
    [cell addSubview: cv];
    [self stretchToSuperView: cv];
    
    count++;
    return cell;
}

- (void) stretchToSuperView:(UIView*) view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    NSString *formatTemplate = @"%@:|[view]|";
    for (NSString * axis in @[@"H",@"V"]) {
        NSString * format = [NSString stringWithFormat:formatTemplate,axis];
        NSArray * constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:bindings];
        [view.superview addConstraints:constraints];
    }

}

- (void) openWeb {
    [self performSegueWithIdentifier:@"displayWeb" sender:url ];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"displayWeb"]) {
        WebViewController *destViewController = segue.destinationViewController;
        destViewController.url = sender;
    }
}

//Got this from https://stackoverflow.com/questions/43581351/how-to-give-toast-message-in-objective-c
- (void) ShowAlert:(NSString *)Message {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:@""
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIView *firstSubview = alert.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) {
        subSubView.backgroundColor = [UIColor colorWithRed:141/255.0f green:0/255.0f blue:254/255.0f alpha:1.0f];
    }
    NSMutableAttributedString *AS = [[NSMutableAttributedString alloc] initWithString:Message];
    [AS addAttribute: NSForegroundColorAttributeName value: [UIColor whiteColor] range: NSMakeRange(0,AS.length)];
    [alert setValue:AS forKey:@"attributedTitle"];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    });
}

@end
