# Minya

A simple basic hierarchy for iOS development with Objective-C. It is based on MVCS and KVO.

The following image is the all elements of this hierarchy, we will describe it in detail.

![](https://github.com/southpeak/Blog-images/blob/master/MVCS.png?raw=true)

## MVCS and Scene

In Minya, MVCS means Model-View-ViewController-Store. You must know the MVC, so it is very simple to understand MVCS. We just put the business logic code to the Store layer. However, our aims is not only the lighter view controller.

In Minya, each layer has the special job to do, and all the job is related to the data:

* Model Layer: it is just a data structure most of the time; sometimes it do some light data operation, such as formatting a date string;
* View Layer: show the data to the user and receive the user's input data;
* View Controller Layer: only pass data between different view controllers;
* Store Layer: it is the business logic processing layer; its duty is to request data from the server or local storage, and process the data from the view; 

> Note: The whole store layer in the previous image contain three elements: Store, Service, Storage.

Obviously, it is simple, and there is nothing special.

Some differences is the organization between layers. Our aims is to decouple the View, ViewController and Store. You can see the MIViewController, which is the base view controller class for all the view controller:

```objc
@interface MIViewController : UIViewController

@property (nonatomic, strong, readonly, nonnull) id<MIStore> store;          //!< Store for the business logic
@property (nonatomic, strong, readonly, nonnull) UIView *containerView;      //!< The container view of the view hierarchy

@end
```

View controller just knows nothing except a container view and a store protocol object. We organize the View, ViewController and Store with a Scene: 

```objc
@interface MIScene : NSObject

@property (nonatomic, copy, nonnull) NSString *viewName;             //!< view name
@property (nonatomic, copy, nonnull) NSString *controllerName;       //!< controller name
@property (nonatomic, copy, nonnull) NSString *storeName;            //!< store name

@end
```

You can create a scene with any of the three elements which share the same pipeline, which we will talk later. And then you can create a view controller with a scene object like this:

```objc
MIScene *scene = [MIScene sceneWithView:@"SearchView" controller:@"SearchViewController" store:@"SearchStore"];
    UIViewController *viewController = [[MIMediator sharedMediator] viewControllerWithScene:scene context:nil];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
``` 

Of course, there are some questions: how do they communicate with each other? And which they depend on? We will talk later.

Let's come back to Store. Store's job is to precess business logic. A store has three data source: Server, Local Storage and User input. We just talk about the Server and Local Storage.

We declare two protocols: `MIService` and `MIStorage`, which declare some method that classes conforming to them should implement. Take the `MIService` for example, if you have a RESTful API to request a list data from the server, you can define a subclass of `MIService` class which has conformed to `MIService` protocol and implement the `-requestWithParameters:success:fail:`. In the subclass, you can create request object and start a request, and handle the response, then pass the data to the store object by the two blocks. And a store just know about the protocol object, and not know the concrete service class. We create a service instance with the service class's name, just like the following code:

```objc
@interface PhotoDetailStore ()

@property (nonatomic, strong) id<MIService> searchDetailService;        // Service for get photo's detail
@property (nonatomic, strong) id<MIService> getPhotoContextService;     // Service for get photo's context

@end

#pragma mark - PhotoDetailStore implementation

@implementation PhotoDetailStore

// ...

- (void)fetchData {
    
    @weakify(self)
    
    [self.searchDetailService requestWithParameters:@{@"photo_id": self.photoID ?: @""} success:^(id  _Nullable data) {
        
        @strongify(self)
        self.detailPipeline.photo = data;
        self.detailPipeline.flagRequestFinished = YES;
        
    } fail:^(id  _Nullable data, NSError * _Nullable error) {
        // You can do something if the data request fail.
    }];
    
    // ...
}

// ...

- (id<MIService>)searchDetailService {
    if (!_searchDetailService) {
        _searchDetailService = [MIService serviceWithName:@"SearchPhotoDetailService"];
    }
    return _searchDetailService;
}

- (id<MIService>)getPhotoContextService {
    if (!_getPhotoContextService) {
        _getPhotoContextService = [MIService serviceWithName:@"GetPhotoContextService"];
    }
    return _getPhotoContextService;
}

@end
```

Storage is the same.

Store Layer has three element, and each element has it own job:

* Store: process the business logic, fetch data from service or storage; it does need to know the details about the data, such as RESTful API, the network layer's implementation, the local data's storage type. It just cares the data.
* Service: request data from server and do some job to process the response data as you need. May be some day, you want to change you network layer implementation, then you just need change the code here.
* Storage: operate the local storage data, such as read, write, remove data. If you want to change your way to storage data, such as from sqlite to realm, just do here.

OK, we describe the jobs of all the layer elements. We still don't know how the View, ViewController and Store communicate with each other. Let's talk about it.


