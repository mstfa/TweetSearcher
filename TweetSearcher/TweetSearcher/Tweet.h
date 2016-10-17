//
//  Tweet.h
//  TweetSearcher
//
//  Created by MUSTAFA TOPÇU on 14.10.2016.
//  Copyright © 2016 mstfa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class Entities;

@interface Tweet : NSObject
@property (nonatomic, copy) NSString *id_str;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Entities *entities;


@end
