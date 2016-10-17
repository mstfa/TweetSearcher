//
//  TweetMediaCell.h
//  TweetSearcher
//
//  Created by MUSTAFA TOPÇU on 15.10.2016.
//  Copyright © 2016 mstfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetMediaCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *tweetText;
@property (strong, nonatomic) IBOutlet UIImageView *contentImage;

-(void) sendTweetContent:(Tweet *)tweetObject;
@end
