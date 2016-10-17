//
//  RestRequestManager.m
//  TweetSearcher
//
//  Created by MUSTAFA TOPÇU on 14.10.2016.
//  Copyright © 2016 mstfa. All rights reserved.
//

#import "RestRequestManager.h"
#import <DCKeyValueObjectMapping/DCKeyValueObjectMapping.h>
#import <DCKeyValueObjectMapping/DCArrayMapping.h>
#import <DCKeyValueObjectMapping/DCParserConfiguration.h>
#import "Tweet.h"
#import "User.h"
#import "Entities.h"
#import "Media.h"

@implementation RestRequestManager{
    NSString *authentication;
    NSString *access_token;
    NSString *token_type;
    NSURLSession *session;
    NSURLSessionDataTask *sessionTask;

}

static  NSString *consumerKey = @"y1xRz17a83IRPmFd71EV8hoSY";
static NSString *consumerSecret = @"fNPMbSUojAQ0w2E8izK7BrNn3mtHmmnIciAFUCL04lsrQfhI0D";


+ (RestRequestManager*)restManager
{
    static RestRequestManager *restManager = nil;
    @synchronized(self) {
        if (restManager == nil){
            restManager = [[self alloc] init];
              [restManager getAccessToken];
        }
        
        //RestRequestManager *sharedManager = [RestRequestManager restManager];
    }
    return restManager;
}

-(void) getAccessToken{

    if (!access_token.length) {
        NSString *consumerKeyRFC1738 = [consumerKey stringByAddingPercentEscapesUsingEncoding:
                                        NSASCIIStringEncoding];
        NSString *consumerSecretRFC1738 = [consumerSecret stringByAddingPercentEscapesUsingEncoding:
                                           NSASCIIStringEncoding];
        
        NSString *concatKeySecret = [[consumerKeyRFC1738 stringByAppendingString:@":"]    stringByAppendingString:consumerSecretRFC1738];
        
        
        
        NSData *nsdata = [concatKeySecret
                          dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
        
        NSLog(@"Encoded: %@", base64Encoded);
        NSLog(@"concatKeySecret:%@", concatKeySecret);
        
       
        
        NSMutableURLRequest *request = [NSMutableURLRequest
                                                requestWithURL:[NSURL URLWithString:@"https://api.twitter.com/oauth2/token"]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:[@"Basic " stringByAppendingString:base64Encoded] forHTTPHeaderField:@"Authorization"];
        
        [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        
        
        NSString *bodyStr = @"grant_type=client_credentials";
        NSData *httpBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPBody:httpBody];
        
        NSLog(@"Request:%@",request);
        
        
        session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        sessionTask = [session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        
                        if (data.length > 0 && error == nil)
                        {
                            NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:0
                                                                             error:NULL];
                            
                            token_type = [greeting objectForKey:@"token_type"];
                            access_token = [greeting objectForKey:@"access_token"];
                            
                        }
                    }];

        [sessionTask resume];
    }

}

-(void)sendRequest:(NSString *)baseUrl
                resource:(NSString *)resource
   queryStringParameters:(NSString *)queryStringParameters
              bodyParameters:(NSArray *)bodyParams
              httpMethod:(NSString *)httpMethod
              contentType:(NSString *)contentType
              successBlock:(void(^)(NSArray *response))successBlock
              errorBlock:(void(^)(NSError *error))errorBlock{
    
    NSDictionary __block *responseData;
    
    NSString *tokenFirstPart = [token_type stringByAppendingString:@" "];
    

    if (!authentication.length) {
          authentication=[tokenFirstPart stringByAppendingString:access_token];
    }
  
    
  
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:[[baseUrl stringByAppendingString:resource] stringByAppendingString:queryStringParameters]]];
    
    
    [request setHTTPMethod:httpMethod];
    [request setValue:authentication forHTTPHeaderField:@"Authorization"];
    
    if (!contentType.length) {
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    }
    
    if (bodyParams.count!=0&&[httpMethod isEqual:@"POST"]) {
        NSMutableString *bodyStr=[[NSMutableString alloc] init];
        for (NSString* key in bodyParams) {
            
            [bodyStr appendFormat: @"%@", key];
        }
        
        NSData *httpBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPBody:httpBody];

    }
    
    NSLog(@"Request:%@",request);
   
    
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    sessionTask = [session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    if (data.length > 0 && error == nil)
                    {
                        responseData = [NSJSONSerialization JSONObjectWithData:data
                                                                                 options:0
                                                                                   error:NULL];
                        
                        DCParserConfiguration *config = [DCParserConfiguration configuration];
                        
                        DCObjectMapping *descText = [DCObjectMapping mapKeyPath:@"description" toAttribute:@"descriptionText" onClass:[User class]];

                        [config addObjectMapping:descText];
                        
                        DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[Media class] forAttribute:@"media" onClass:[Entities class]];
                        
                        [config addArrayMapper:mapper];
                        
                        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Tweet class]  andConfiguration:config];
                        
                        NSArray *response = [parser parseArray:responseData[@"statuses"]];
                        
                            successBlock(response);
                        
                    }
                    else{
                    
                        errorBlock(error);
                    
                    }
                }];
    
    [sessionTask resume];

}

-(void)stopRequest{
    if (sessionTask.state == NSURLSessionTaskStateRunning) {
        [sessionTask cancel];
    }
}


@end
