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

@interface HttpTool ()
@property (nonatomic, assign) BOOL isConnect;
+ (instancetype)sharedAFHTTPManager;

@end


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
        // 接收参数类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript", @"text/plain", @"text/xml", @"image/*", @"application/octet-stream", @"application/zip", nil];
        // 2.设置请求超时时间(请求不能无休止的发,请求超时后就会关掉)
        manager.requestSerializer.timeoutInterval = 30;
        
        // 安全策略(HTTPS，多加了一个SSL证书，默认情况下没有证书)
        /**
         *  SSLPinningMode 三种类：
         *  AFSSLPinningModeNone,        没有证书
         *  AFSSLPinningModePublicKey,   只验证公钥
         *  AFSSLPinningModeCertificate  既验证公钥，又验证证书
         */
        manager.securityPolicy = [AFSecurityPolicy defaultPolicy]; //默认情况
        //使用AFNetworking 进行 https请求核心是生成 AFSecurityPolicy 对象，并赋值给当前的SessionManager。
        manager.securityPolicy = [self customSecurityPolicy];
        
        //开启监听
        //[self openNetMonitoring];
        
    });
    return manager;
}

+ (AFSecurityPolicy*)customSecurityPolicy {
    // 证书的路径（将服务端的.crt格式证书(SSL 证书)转成mac端使用的.cer格式证书）
    // 格式转换命令：openssl x509 -in 你的证书.crt -out 你的证书.cer -outform der
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server_staging" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    if (!certData) {
        return securityPolicy;
    }
    securityPolicy.pinnedCertificates = [NSSet setWithArray:@[certData]];
    return securityPolicy;
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
