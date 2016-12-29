//
//  TestDemoTests.m
//  TestDemoTests
//
//  Created by 李勇 on 2016/12/29.
//  Copyright © 2016年 aoke. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface TestDemoTests : XCTestCase
@property (nonatomic, strong) ViewController *VC;

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
    
    
}

/**
 *  每个test方法执行之后调用,释放测试用例的资源代码，这个方法会每个测试用例执行后调用
 */
- (void)tearDown {
    
    //结束后释放
    self.VC = nil;

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


// 异步测试
- (void)testAsynchronousURLConnection {
    
    [self measureBlock:^{
        
        NSLog(@"testAsynchronousURLConnection");
        XCTestExpectation *expectation = [self expectationWithDescription:@"GET Baidu"];
        
        //下面三个地址可以查看测试通过与不通过的区别
        //    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com/"];
        //    NSURL *url = [NSURL URLWithString:@"https://ly92.github.io/2016/11/09/Easemob_ly/"];
        NSURL *url = [NSURL URLWithString:@"https://github.com/ly92/PrivateSpace"];
        
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
        [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
            [task cancel];
        }];
    }];
}


@end
