//
//  DetailViewController.m
//  TweetSearcher
//
//  Created by MUSTAFA TOPÇU on 12.10.2016.
//  Copyright © 2016 mstfa. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "User.h"
#import "Entities.h"
#import "Media.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TweetDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *contentImage;
@property (strong, nonatomic) IBOutlet UIImageView *twitterImage;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Detail Screen";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureUI];
}

#pragma mark - Utility

-(void)reloadData{
    
    [self configureUI];
    
}

#pragma mark - UI

-(void)configureUI{
    
    if (self.tweet) {
        
        self.twitterImage.hidden = NO;
        
        NSURL *imageUrl = [NSURL URLWithString:self.tweet.user.profile_image_url_https];
        
        [self.profileImage sd_setImageWithURL:imageUrl];
        
        self.userNameLabel.text = self.tweet.user.name;
        
        self.tweetTextLabel.text = self.tweet.text;
        
        Media *media = self.tweet.entities.media.firstObject;
        
        if ([media.type.lowercaseString isEqualToString:@"photo"]) {
            
            self.contentImage.hidden = NO;
            
            NSURL *contentImageUrl = [NSURL URLWithString:media.media_url_https];
            
            [self.contentImage sd_setImageWithURL:contentImageUrl];
        } else{
            self.contentImage.hidden = YES;
        }
        
    } else {
        
        self.userNameLabel.text = @"";
        self.tweetTextLabel.text = @"";
        self.twitterImage.hidden = YES;
    }
    
    
}


@end
