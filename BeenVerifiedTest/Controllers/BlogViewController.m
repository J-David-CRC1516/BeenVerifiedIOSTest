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
    data = [self getData];
    articles = data[@"articles"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return articles.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
    ArticlesController *cv = [[ArticlesController alloc]initWithFrame:CGRectMake(5, 5, 405, 400)];
    
    article = articles[count];
    [cv addTitle:article[@"title"]];
    [cv addDescription:article[@"description"]];
    [cv addAuthor:article[@"author"]];
    [cv addDate:article[@"article_date"]];
    url = article[@"link"];
    
    UITapGestureRecognizer *singleFingerTap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(openWeb)];
    
    [cell addGestureRecognizer:singleFingerTap];
    
    [cell addSubview: cv];
    
    count++;
    return cell;
}

-(NSDictionary *) getData {
    
    NSError *error;
    NSString *url = [NSString stringWithFormat:@"https://www.beenverified.com/articles/index.ios.json"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return json;
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

@end
