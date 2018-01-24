///
///  HttpRequestModel.h
///  268EDU_Demo
///
///  Created by EDU268 on 15/10/29.
///  Copyright © 2015年 edu268. All rights reserved.
///

#import <Foundation/Foundation.h>

@interface HttpRequestModel : NSObject

/** 1 * post 请求 无进度 */
+ (void)request:(NSString *)urlString withParamters:(NSDictionary *)dic success:(void (^)(id responseData))success failure:(void (^)(NSError *error))failure;


+ (NSString *)printRequestUrlString:(NSString *)urlString withParamter:(NSDictionary *)dic;
@end
