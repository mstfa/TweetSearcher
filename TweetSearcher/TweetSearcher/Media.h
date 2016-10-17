//
//  Media.h
//  TweetSearcher
//
//  Created by MUSTAFA TOPÇU on 15.10.2016.
//  Copyright © 2016 mstfa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Media : NSObject

@property (nonatomic, copy) NSString *id_str;
@property (nonatomic, copy) NSString *media_url_https;
@property (nonatomic, copy) NSString *type;

@end
