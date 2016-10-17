//
//  MasterViewController.m
//  TweetSearcher
//
//  Created by MUSTAFA TOPÇU on 12.10.2016.
//  Copyright © 2016 mstfa. All rights reserved.
//

#import "TweetSearchViewController.h"
#import "TweetTextCell.h"
#import "TweetMediaCell.h"
#import "Media.h"
#import "Entities.h"

@interface TweetSearchViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *tableData;
@property (strong, nonatomic) IBOutlet UITextField *txfSearch;
@property (strong, nonatomic) IBOutlet UITableView *twetTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation TweetSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Search Screen";
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.twetTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(getDataWithSearchString:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self resetTableData];
    
    if (_txfSearch.text.length > 1) {
        [self getDataWithSearchString:_txfSearch.text];
    }
    
    self.tweetDetailViewController = (TweetDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    static NSString *CellIdentifier = @"Tweet";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    Tweet *tweet = self.tableData[indexPath.row];
    
    Media *media = tweet.entities.media.firstObject;
    
    if ([media.type.lowercaseString isEqualToString:@"photo"]) {
        
        TweetMediaCell *mediaCell = [tableView dequeueReusableCellWithIdentifier:@"TweetMediaCell"];
        
        [mediaCell sendTweetContent:tweet];
        
        cell = mediaCell;
        
    } else {
        TweetTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"TweetTextCell"];
        
        [textCell sendTweetContent:tweet];
        
        cell = textCell;
    }
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        
        Tweet *tweet = self.tableData[indexPath.row];
        
        [self.tweetDetailViewController setTweet:tweet];
        
        [self.tweetDetailViewController reloadData];
        
    } else{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.selected = NO;
        
        [self performSegueWithIdentifier:@"ShowDetail" sender:@{@"selectedIndex" : @(indexPath.row)}];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_txfSearch resignFirstResponder];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string; {
    
    if (range.location == 0 && range.length == textField.text.length && !string.length) {
        // empty
        
        [self resetTableData];
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (newString.length > 2) {
        
        [self getDataWithSearchString:newString];
        
    } else {
        
        [self resetTableData];
        
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Utility

-(void)resetTableData{
    self.tableData = [NSMutableArray new];
    
}

-(void)setTableData:(NSMutableArray *)tableData{
    _tableData = tableData;
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.twetTableView reloadData];
        });
}

-(void)getDataWithSearchString:(NSString *)searchString{
    
    if ([searchString isKindOfClass:[UIRefreshControl class]]) {
        searchString = self.txfSearch.text;
    }
    
    [[RestRequestManager restManager] stopRequest];
    
    NSString *queryParameter=[@"count=100&q=" stringByAppendingString:searchString];
    
    [[RestRequestManager restManager] sendRequest:@"https://api.twitter.com/" resource:@"1.1/search/tweets.json?"
                            queryStringParameters:queryParameter
                                   bodyParameters:nil
                                       httpMethod:@"GET"
                                      contentType:@"application/x-www-form-urlencoded;charset=UTF-8"
                                     successBlock:^(NSArray *response) {
                                         self.tableData = response.mutableCopy;
                                         
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [self.refreshControl endRefreshing];
                                         });
                                         
                                     }
                                       errorBlock:^(NSError *error) {
                                           [self.refreshControl endRefreshing];
                                       }];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ShowDetail"]) {
        
        NSInteger selectedIndex = [(NSNumber *)sender[@"selectedIndex"] integerValue];
        
        Tweet *tweet = self.tableData[selectedIndex];
        
        TweetDetailViewController *controller = (TweetDetailViewController *)[segue destinationViewController];
        
        [controller setTweet:tweet];
        [controller setDetailItem:[NSDate date]];
        
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


@end
