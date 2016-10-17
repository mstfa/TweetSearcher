//
//  User.h
//  TweetSearcher
//
//  Created by MUSTAFA TOPÇU on 14.10.2016.
//  Copyright © 2016 mstfa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *id_str;
@property (nonatomic, strong) NSString *screen_name;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *profile_image_url_https;


@end
