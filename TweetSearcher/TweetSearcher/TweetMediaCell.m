//
//  TweetMediaCell.m
//  TweetSearcher
//
//  Created by MUSTAFA TOPÇU on 15.10.2016.
//  Copyright © 2016 mstfa. All rights reserved.
//

#import "TweetMediaCell.h"
#import "Media.h"
#import "Entities.h"
#import "User.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation TweetMediaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    
    Media *media = tweetObject.entities.media.firstObject;
    
    NSURL *contentImageUrl = [NSURL URLWithString:media.media_url_https];
    
    [self.contentImage sd_setImageWithURL:contentImageUrl];
}

@end
