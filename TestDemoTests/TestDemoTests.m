//
//  TestDemoTests.m
//  TestDemoTests
//
//  Created by 李勇 on 2016/12/29.
//  Copyright © 2016年 aoke. All rights reserved.
//

#import "TestDemoCase.h"
#import "ViewController.h"

@interface TestDemoTests : TestDemoCase
@property (nonatomic, strong) ViewController *VC;
@property (strong, nonatomic) UIButton *button;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation TestDemoTests
/**
 *  每个test方法执行之前调用
 *
 */
- (void)setUp {
    [super setUp];
    
    //定义
    self.VC = [[ViewController alloc] init];
    
    self.button = [UIButton new];
    self.imageView = [UIImageView new];
    
    
}

/**
 *  每个test方法执行之后调用,释放测试用例的资源代码，这个方法会每个测试用例执行后调用
 */
- (void)tearDown {
    
    //结束后释放
    self.VC = nil;
    self.button = nil;
    self.imageView = nil;

    [super tearDown];
}
/**
 *  测试用例的例子，注意测试用例一定要test开头
 */
- (void)testExample {
    //测试view是否加载出来
    XCTAssertNotNil(self.VC.view,@"view未成功加载出来");
}

- (void)testPerformanceExample {
    //主要测试代码性能
    [self measureBlock:^{
        
        
    }];
}


#pragma mark - 自定义测试
//必须以test开头的函数
- (void)testMyFuc{
    int result = self.VC.getNum;
    XCTAssertEqual(result, 100,@"测试普通函数不通过");
}



//测试图片处理
- (void)testImageResize{
    UIImage *image = [UIImage imageNamed:@"icon1.jpeg"];
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        for (NSInteger i=0; i<10000; i++) {
            UIImage *resizedImage = [self imageWithImage:image scaledToSize:CGSizeMake(100, 100)];
            XCTAssertNotNil(resizedImage, @"缩放后图片不应为nil");
            CGFloat resizedWidth = resizedImage.size.width;
            CGFloat resizedHeight = resizedImage.size.height;
            XCTAssertTrue(resizedWidth == 100 && resizedHeight == 100, @"缩放后尺寸");
        }
    }];
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//异步测试，有三种方式（expectationWithDescription，expectationForPredicate和expectationForNotification）
// 测试接口(异步测试)使用expectationWithDescription
- (void)testAsynchronousURLConnection {
    [self measureBlock:^{
        NSLog(@"testAsynchronousURLConnection");
        XCTestExpectation *expectation = [self expectationWithDescription:@"GET Baidu"];
        //下面三个地址可以查看测试通过与不通过的区别
            NSURL *url = [NSURL URLWithString:@"http://www.baidu.com/"];
        //    NSURL *url = [NSURL URLWithString:@"https://ly92.github.io/2016/11/09/Easemob_ly/"];
//        NSURL *url = [NSURL URLWithString:@"https://github.com/ly92/PrivateSpace"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //        NSLog(@"data : %@", data);
            // XCTestExpectation条件已满足，接下来的测试代码可以开始执行了。
            [expectation fulfill];
            XCTAssertNotNil(data, @"返回数据不应非nil");
            XCTAssertNil(error, @"error应该为nil");
            if (nil != response) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                XCTAssertEqual(httpResponse.statusCode, 200, @"HTTPResponse的状态码应该是200");
                XCTAssertEqual(httpResponse.URL.absoluteString, url.absoluteString, @"HTTPResponse的URL应该与请求的URL一致");
                //            XCTAssertEqual(httpResponse.MIMEType, @"text/html", @"HTTPResponse的内容应该是text/html");
            } else {
                XCTFail(@"返回内容不是NSHTTPURLResponse类型");
            }
        }];
        [task resume];
        
        
        // 超时后执行
        [self waitForExpectationsWithCommonTimeoutUsingHandler:^(NSError * _Nullable error) {
            [task cancel];
        }];
    }];
}

//异步测试，使用expectationForPredicate
- (void)testThatBackgroundImageChanges {
    
    XCTAssertNil(self.imageView.image);
    
    [self.imageView setImage:[UIImage imageNamed:@"icon1.jpeg"]];
    
    //设置一个期望
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"image != nil"];
    
    //若在规定时间内满足期望，则测试成功
    [self expectationForPredicate:predicate
              evaluatedWithObject:self.imageView
                          handler:nil];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

//异步测试，使用expectationForNotification,该方法监听一个通知,如果在规定时间内正确收到通知则测试通过
- (void)testAsynExampleWithExpectationForNotification {
    
    //监听通知，在规定时间内受到通知，则测试通过
    [self expectationForNotification:@"监听通知的名称测试" object:nil handler:^BOOL(NSNotification * _Nonnull notification) {
        NSLog(@"请求成功");
        //做后续处理
        return YES;
    }];
    
    //下面2个地址可以查看测试通过与不通过的区别
    //测试通过
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com/"];
    //测试失败
//    NSURL *url = [NSURL URLWithString:@"www.baidu.com/"];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data && !error && response) {
            //发送通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"监听通知的名称测试" object:nil];
        }
        
    }];
    [task resume];
    
    //设置延迟多少秒后，如果没有满足测试条件就报错
    [self waitForExpectationsWithCommonTimeoutUsingHandler:^(NSError * _Nullable error) {
        [task cancel];
    }];
    
}

@end
