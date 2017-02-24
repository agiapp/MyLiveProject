//
//  HttpTool.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/21.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking/AFNetworking.h"

// 请求服务器的基本路径
static NSString *kBaseURL = SERVER_HOST;

@interface AFHTTPManager : AFHTTPSessionManager
@property (nonatomic, assign) BOOL isConnect;
+ (instancetype)sharedAFHTTPManager;

@end

@implementation AFHTTPManager
+ (instancetype)sharedAFHTTPManager {
    static AFHTTPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //一、创建管理者对象
        manager = [[AFHTTPManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseURL] sessionConfiguration:configuration];
        //二、设置manager的属性
        //1.默认解析模式
        // 设置请求参数的类型
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        // 设置服务器返回结果的类型
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        // 2.设置请求超时时间(请求不能无休止的发,请求超时后就会关掉)
        manager.requestSerializer.timeoutInterval = 30;
        // 接收参数类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript", @"text/plain", @"text/xml", @"image/*", @"application/octet-stream", @"application/zip", nil];
        // 安全策略(HTTPS，多加了一个SSL证书，默认情况下没有证书)
        /**
         *  SSLPinningMode 三种类：
         *  AFSSLPinningModeNone,        没有证书
         *  AFSSLPinningModePublicKey,   只验证公钥
         *  AFSSLPinningModeCertificate  既验证公钥，又验证证书
         */
        manager.securityPolicy = [AFSecurityPolicy defaultPolicy]; //默认情况
        
        //开启监听
        //[self openNetMonitoring];
        
    });
    return manager;
}


//判断是否有网络连接，有网络连接再进行下一操作。
- (void)openNetMonitoring {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                self.isConnect = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                self.isConnect = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.isConnect = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.isConnect = YES;
                break;
            default:
                break;
        }
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    self.isConnect = YES;
}

@end

@implementation HttpTool
#pragma mark - get网络请求
+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure {
    //获取完整的url路径
    NSString * url = [kBaseURL stringByAppendingPathComponent:path];
    [[AFHTTPManager sharedAFHTTPManager] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

#pragma mark - post网络请求
+ (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure {
    //获取完整的url路径
    NSString * url = [kBaseURL stringByAppendingPathComponent:path];
    [[AFHTTPManager sharedAFHTTPManager] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

#pragma mark - 下载文件
+ (void)downloadWithPath:(NSString *)path
                 success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure
                progress:(HttpDownloadProgressBlock)progress {
    //获取完整的url路径
    NSString * urlString = [kBaseURL stringByAppendingPathComponent:path];
    //下载
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [[AFHTTPManager sharedAFHTTPManager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress.fractionCompleted);
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //下载完后，实际下载在临时文件夹里；在这里需要保存到缓存文件夹
        //获取沙盒cache路径
        NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            failure(error);
        } else {
            success(filePath.path);
        }
    }];
    [downloadTask resume];
}

#pragma mark - 上传图片
+ (void)uploadImageWithPath:(NSString *)path
                     params:(NSDictionary *)params
                  thumbName:(NSString *)thumbName
                      image:(UIImage *)image
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
                   progress:(HttpUploadProgressBlock)progress {
    //获取完整的url路径
    NSString * urlString = [kBaseURL stringByAppendingPathComponent:path];
    //data就是要上传的数据
    NSData * data = UIImagePNGRepresentation(image);
    [[AFHTTPManager sharedAFHTTPManager] POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:thumbName fileName:@"01.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


@end
