//
//  TweetTextCell.m
//  TweetSearcher
//
//  Created by MUSTAFA TOPÇU on 14.10.2016.
//  Copyright © 2016 mstfa. All rights reserved.
//

#import "TweetTextCell.h"
#import "Entities.h"
#import "User.h"
#import "Media.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation TweetTextCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) sendTweetContent:(Tweet *)tweetObject{
    
    NSURL *imageUrl = [NSURL URLWithString:tweetObject.user.profile_image_url_https];
    
    [self.profileImage sd_setImageWithURL:imageUrl];
    
    self.userName.text = tweetObject.user.name;
    
    self.tweetText.text = tweetObject.text;
 
}

@end
