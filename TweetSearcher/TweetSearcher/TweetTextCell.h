//
//  TweetTextCell.h
//  TweetSearcher
//
//  Created by MUSTAFA TOPÇU on 14.10.2016.
//  Copyright © 2016 mstfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetTextCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *tweetText;

-(void) sendTweetContent:(Tweet *) tweetObject;

@end
