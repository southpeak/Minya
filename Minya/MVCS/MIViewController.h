//
//  MIViewController.h
//  MinyaDemo
//
//  Created by Konka on 2016/9/27.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MIUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MIStore;
@class MIPipeline;

/**
 *  Basic View Controller for all the view controller in our app.
 *
 *  There are three basic elements in a view controller:
 *  1. Store: used to handle all the business logic
 *  2. Container view: the container view of all the subviews, now it is just the ControllerView's view,
 *     but we set it with the instance of the viewClass in the `-loadView` method
 *  3. Pipeline: used to handle the data flow
 *
 *  This basic class just do the job related to the MVCS:
 *  1. Set the ViewController's view with a instance of viewClass;
 *  2. Set its own pipeline and the container view's pipeline. This step is the key step
 *     that binds the pipeline hierarchy to the view hierarchy;
 *  3. Call the addObservers method to add observers of the pipeline data.
 *
 *  The store object is created outside of the view controller. We adopt dependency injection
 *  strategy but not create it directly in the view controller.
 *
 *  The store protocol has a `-fetchData` method, and you can call this method for fetching data
 *  from the store layer as need by yourself.
 */
@interface MIViewController : UIViewController

@property (nonatomic, strong, readonly, nonnull) id<MIStore> store;          //!< Store for the business logic

/**
 *  Initiallize method
 *
 *  @param store     store
 *  @param viewClass class of the container view
 *  @param callback  callback for the preview scene. Use this block to return data to 
 *                   previous scene.
 *
 *  @return MIViewController instance
 */
- (instancetype _Nullable)initWithStore:(id<MIStore> _Nonnull)store viewClass:(Class _Nonnull)viewClass callback:(MICallback _Nullable)callback;
- (instancetype _Nullable)initWithStore:(id<MIStore> _Nonnull)store viewClass:(Class _Nonnull)viewClass;

/**
 *  Add observers
 *
 *  This method is used to add observer of the pipeline data.
 *  The default implementation is empty, if the subclass has to observer the pipeline's
 *  properties changed, you should override this method.
 */
- (void)addObservers;

/**
 *  Set the pipeline for this view controller
 *
 *  This basic view controller doesn't supply a pipeline object, you should define a sutable pipeline
 *  for the view controller if needed.
 *
 *  @param pipeline pineline object
 */
- (void)setupPipeline:(__kindof MIPipeline * _Nonnull)pipeline;

@end

NS_ASSUME_NONNULL_END
