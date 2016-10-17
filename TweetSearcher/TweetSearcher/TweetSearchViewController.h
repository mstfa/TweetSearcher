//
//  MasterViewController.h
//  TweetSearcher
//
//  Created by MUSTAFA TOPÇU on 12.10.2016.
//  Copyright © 2016 mstfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestRequestManager.h"
#import "TweetDetailViewController.h"
#import "Tweet.h"


@class DetailViewController;

@interface TweetSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) TweetDetailViewController *tweetDetailViewController;

@end

