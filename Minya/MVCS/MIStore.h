//
//  MIStore.h
//  MinyaDemo
//
//  Created by Konka on 2016/9/27.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MIPipeline;

#pragma mark - MIStore Protocol

/**
 *  MIStore Protocol
 *
 *  This protocol defines methods for a store that it could provide
 *  to the view controller layer.
 */
@protocol MIStore <NSObject>

/**
 *  Pipeline for the scene
 */
- (__kindof MIPipeline * _Nullable)pipeline;

/**
 *  Fetch data
 *
 *  We create store instance at the init method of view controller,
 *  but we should fetch data in the viewDidLoad or viewWillAppeared method,
 *  so we provide this method.
 */
- (void)fetchData;

@optional

/**
 *  cancel all the data requests.
 */
- (void)cancel;

@end

#pragma mark - MIStore Class


/**
 *  Base class for store
 *
 *  A store is used to handle all the business logic. The base store class
 *  has default implementation for `-pipeline` and `-fetchData` method.
 *  However, the default `-pipeline` throw and exception, so you must implement
 *  this method in the subclass. An the `-fetchData` method is just empty.
 *
 *  The other work of store layer is to create the pipeline object for the scene.
 *  The view controller will fetch the pipeline object and pass it to the view layer.
 *
 */
@interface MIStore : NSObject <MIStore>

/**
 *  Context for this store
 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *context;

/**
 *  Designated initialize method
 *
 *  @param context context for current scene
 *
 *  @return MIStore instance
 */
- (instancetype _Nullable)initWithContext:(NSDictionary<NSString *, id> * _Nullable)context;

/**
 *  Add observer for the pipeline data.
 */
- (void)addObservers;

#pragma mark - Check Method

/**
 *  Return an array of the keys that the current store object needs in the context
 *
 *  This class method is used to check input context in debug model, and will not run in 
 *  release model unless you allow assert function in release model.
 *
 *  @return requiredParameters  An array of the required parameters
 */
+ (NSArray<NSString *> * _Nullable)requiredParameters;

@end

NS_ASSUME_NONNULL_END
