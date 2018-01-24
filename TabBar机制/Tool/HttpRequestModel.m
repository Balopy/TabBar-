///
///  HttpRequestModel.m
///  268EDU_Demo
///
///  Created by EDU268 on 15/10/29.
///  Copyright © 2015年 edu268. All rights reserved.
///

#import "HttpRequestModel.h"

@implementation HttpRequestModel


+ (void)request:(NSString *)urlString withParamters:(NSDictionary *)dic success:(void (^)(id responseData))success failure:(void (^)(NSError *error))failure {
    
    urlString = [NSString stringWithFormat:@"%@.json",urlString];
    
    [self printRequestUrlString:urlString withParamter:dic];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:10.f];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success != nil) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        if (failure != nil) {
            failure(error);
        }
    }];
}

+ (NSString *)printRequestUrlString:(NSString *)urlString withParamter:(NSDictionary *)dic {
    
    NSArray *dicKeysArray = [dic allKeys];
    
    if (dicKeysArray.count != 0) {
        
        urlString = [urlString stringByAppendingString:@"?"];
    }
    
    for (NSInteger i = 0; i < dicKeysArray.count; i++) {
        
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", dicKeysArray[i], [dic objectForKey:dicKeysArray[i]]]];
        
        if (i == dicKeysArray.count - 1) {
            
            urlString = [urlString substringToIndex:urlString.length - 1];
        }
    }
    NSLog(@"link--%@", urlString);
    return urlString;
}

@end
