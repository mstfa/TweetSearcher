//
//  DetailViewController.h
//  TweetSearcher
//
//  Created by MUSTAFA TOPÇU on 12.10.2016.
//  Copyright © 2016 mstfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetDetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (nonatomic,strong) Tweet *tweet;

-(void)reloadData;

@end

