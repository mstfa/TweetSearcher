//
//  RestRequestManager.h
//  TweetSearcher
//
//  Created by MUSTAFA TOPÇU on 14.10.2016.
//  Copyright © 2016 mstfa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestRequestManager.h"

@interface RestRequestManager : NSObject

+ (RestRequestManager*)restManager;
-(void) sendRequest:(NSString *)baseUrl
                 resource:(NSString *)resource
    queryStringParameters:(NSString *)queryStringParameters
           bodyParameters:(NSArray *)bodyParams
               httpMethod:(NSString *)httpMethod
              contentType:(NSString *)contentType
             successBlock:(void(^)(NSArray *response))successBlock
               errorBlock:(void(^)(NSError *error))errorBlock;
-(void) getAccessToken;

-(void)stopRequest;
@end
