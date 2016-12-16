//
//  MIService.h
//  MinyaDemo
//
//  Created by Konka on 2016/9/27.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Block Type

typedef void (^MIRequestSuccessBlock)(id _Nullable data);
typedef void (^MIRequestFailBlock)(id _Nullable data,  NSError * _Nullable error);
typedef void (^MIRequestCancel)();

#pragma mark - MIService Protocol

/**
 *  MIService Protocol
 *
 *  This protocol declares some methods that you can use to request data from the net.
 *
 *  In Minya MVCS, we suggest that you define a service for a network API. That say, 
 *  every network API has a corresponding MIService class.
 *
 *  Of course, there are some problems, the most obvious problem is class explosion.
 *  For example, if you App has 100 network API, you must define 100 MIService class.
 *  But I think that it will make you code clear, and we can reuse this service class
 *  in many place.
 *
 */
@protocol MIService <NSObject>

/**
 *  Start a network request
 *
 *  We suggest that you just pass variable parameters, and some common and fixed parameters
 *  for every request call can be created in this method implementation directly.
 *
 *  And if you want to download file or upload file, you also define a service class that 
 *  implements this protocol. In our opinion, store layer just concerns about data, and 
 *  does not care it is a common data request or download/upload. The concrete service class
 *  will determine the implementation details.
 *
 *  @param parameters   request parameters
 *  @param success      callback block for success request
 *  @param fail         callback block for fail request
 */
- (void)requestWithParameters:(NSDictionary * _Nullable)parameters
                      success:(MIRequestSuccessBlock _Nullable)success
                         fail:(MIRequestFailBlock _Nullable)fail;

@optional
/**
 *  Cancel the request
 *
 *  @param cancel       callback block for canceling the request
 */
- (void)cancelWithOperation:(MIRequestCancel _Nullable)cancel;

@end

#pragma mark - MIService Class

/**
 *  MIService Class
 *
 *  The base class for network service. The base class implements the 
 *  `-requestWithParameters:success:fail:`, but it just throws and exception by default,
 *  so you must implement this method in the subclass. And we don't implement the optional
 *  method `-cancelWithOperation:`, so if you need cancel the request, just implement it.
 *
 *  There is another thing. We identify an request with and string(`_identifier`) but not a object,
 *  because we manager all the requests in a net request center. If your implementation is diffirent,
 *  you can ignore or delete the `_identifier` variable in you implementation.
 *
 */
@interface MIService : NSObject <MIService> {
    NSMutableArray *_identifiers;               //!< request identifiers, which can be used for cancel request
}

/**
 *  Create a MIService with service class name
 *
 *  @param serviceName  service name, the class with serviceName must conform to `MIService` protocol and 
 *                      be the subclass of `MIService` class.
 *
 *  @return If there exist a MIService's subclass with then serviceName, return an instance
 *          of the class; if not, return nil.
 */
+ (id<MIService> _Nullable)serviceWithName:(NSString * _Nonnull)serviceName;

@end

NS_ASSUME_NONNULL_END
