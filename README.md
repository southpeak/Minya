# Minya

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/southpeak/Minya/blob/master/LICENSE)

A simple basic hierarchy for iOS development with Objective-C. It is based on MVCS and KVO.

The following image is the all elements of this hierarchy.

![](https://github.com/southpeak/Blog-images/blob/master/MVCS.png?raw=true)

There are some aims for this hierarchy:

* Divide the codes to different layers to make sure one class will not be too large;
* Decouple the View, ViewController, Store layers, and you can reuse or replace one of the layers which is relied on the same shared pipeline;
* Each layer just does their own job;

We will describe it in detail.

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

We declare two protocols: `MIService` and `MIStorage`, which declare some methods that classes conforming to them should implement. Take the `MIService` for example, if you have a RESTful API to request a list data from the server, you can define a subclass of `MIService` class which has conformed to `MIService` protocol and implement the `-requestWithParameters:success:fail:`. In the subclass, you can create request object and start a request, and handle the response, then pass the data to the store object by the two blocks. And a store just know about the protocol object, and not know the concrete service class. We create a service instance with the service class's name, just like the following code:

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

## Data and Pipeline

Yes, data. In Minya, data is all, data is everything. View, ViewController and Store are relied on data. View shows data from server and capture data from user; ViewController passes data to the other ViewController; Store processes data from the server or user input; Service request data from server; Storage read data from local storage or write data to it. 

Of course, data has to have a container. You may say store it in the store object. Yes, but not all. We define a pipeline to contain the data that want to pass through the View, ViewController and Store. We can say that pipeline object is a contain for data and a data pipeline for View, ViewController and Store. And in fact, View, ViewController and Store are relied on `Pipeline`. In the previous section, we say View, ViewController and Store don't know each other, buy they know the same thing: a shared pipeline object. For example, in the demo code, we have a `PhotoList` scene. The scene's elements(`PhotoListView`, `PhotoListViewController`, `PhotoListStore`) share the same `PhotoListPipeline`.

The store object will create a pipeline object, because in Minya it is the data distribution center. When we create a scene, we will pass the pipeline object from the store object to the view controller object and view object. In the `MIViewController`, we have do the job:

```objc
@implementation MIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Build the view hierarchy
    self.containerView = [[self.viewClass alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.containerView];
    
    // Set up pipeline
    [self setupPipeline:self.store.pipeline];
    [self.containerView setupPipeline:self.store.pipeline];
    
    // Add observers of the pipeline data.
    [self addObservers];
}

// ...

@end
```

Then the three elements have shared the pipeline object. Now you can get the data you need from the pipeline at any layer.  

We suggest that you can put five type data in the pipeline:

1. `Normal data`: these data is from the server and then showed in the view.
2. `Flag data`: now the KVO is not good for collection data, so we can set a flag for these data which from server. The view layer can observe the flag peoperty to know the collection data is updated.
3. `Status data`: sometimes, the view want to show different subviews in different status. For example, if the user does not sign in, we show a `sign in` button in a view, and if the user has signed in, we show some other information in the same view. We can define some status data for these situations.
4. `Input data`: when the user has some input, such as tapping a button, you should do some business logic work. The store layer want to know that, so you can define a input property in the pipeline, and the store layer can observe this property and when the property changed, you can do what you want to do.
5. `Context data`: context data is used for data transmission between view controller. In Minya MVCS, dictionary is used for data transmission. The view controller layer does not store any data but the pipeline does, and the view controller do the transmission job, so it can fetch data from pipeline.

Well, we have had five type data. But there still have a question: When a user tap a button, how does the store know to do something? Yes, our answer is KVO.

We describe three scenarios and the data process flow:

1. User tap a button to fetch data from the server. User tap the button, we change a `inputTapButon` property of the pipeline in the button action. The store which observes `inputTapButon` property will prepare the parameter that RESTful API needed, then call the service's request method. The service start a request...

2. List data back from the server, and the view should update the list view. Store changes the `flagForRequestFinished` property of the pipeline, and the view which observes this property will receive kvo message, then call the tableview's `reloadData` method. The view fetch the list data from the pipeline's property.

3. User selects a cell in the table view and then push a detail view controller. User tap the cell, and app call the `-tableView:didSelectRowAtIndexPath:` method. In this method, we change the `inputSelectedIndex` property of the pipeline. The view controller which observes `inputSelectedIndex` will fetch the context from the pipeline, create a scene, and then push the next view controller.

You see, it is not hard. You just want to know who will change the pipeline's property, and who care about the property.

Well, you must know that apple's KVO API is hard to use. However, if you have used the Reactive Cocoa, you may find its KVO API is more friendly. We extract Reactive Cocoa's KVO API code, and do some change for Minya. You can see it in the source code.

## Three trees: View tree, Pipeline tree and Store tree

I think you are very familiar with View tree hierarchy. A parent view have some subviews. In Minya, if the business logic is complicated, you may build three type tree hierarchy:

* View Tree: separate you view code in some subviews; so you want to define some subclass of `UIView`;
* Pipeline Tree: in our opinion, every custom subclass of `UIView` should have a pipeline object to provide data for it. So, corresponding to the View Tree, you may want to build up a Pipeline Tree for the View Tree. Of course, there are some situation that Minya may be not satisfied, we will talk later.
* Store Tree: If the business logic in a store is too complicated, you can divide different business logic to different store object. The Store Tree does not need to correspond to the View Tree and Pipeline Tree. For example, one sub store can have two pipelines, you just make sure that the two pipelines will be attached to the Pipeline Tree correctly.

You can see the `InterestingnessStore` class in the demo code.

## Problems

One coin has two side. The Minya also has some problems:

* Class explosion: One scene has 4 class and 8 file at least. And if the business if very complicated, you may be want to create a lot of classes for a single scene. This has some consequences, such as influencing the launch time.
* Pipeline class may contain a lot of properties if you don't build up the Pipeline Tree correctly.
* If you are not familiar with KVO, you may be confuse, especially when you debug the code. In this situation, you just know who changes the data and who cares the changed data.
* The scene'e three element is decoupled, however they are relied on the pipeline object. When you want to reuse or change one element object, you must make sure the pipeline is correct.

So, if you want to use Minya, you should know these problems. And there will be more problems in practice.

## Usage

Minya is just a hierarchy and a thought. There are still a lot of things should be done. In our project, we have done some optimization to meet the actual needs. So we did not set it for the CocoaPods. If you want to use it, you can import the source code in the MVCS directory.

Another thing is that we use the Flickr API for the url request, if you want to run the demo, you should change the Flickr API key and shared secret of your own in the `AppDelegate.m`.

## Tool

It is a boring work to create 4 classes and 8 files for a single scene, so I write a python script `minya.py` to help you to create these file. Of course, you must do something, such as changing the project_name, author_name, company_name in the script file. Run the following command in the directory of the file:

```bash
python minya.py SCENE_NAME
```

Then it will create all the 8 files for you.

And some Xcode 8 extensions may be in plan.

## Licenses

All source code is licensed under the [MIT License](https://github.com/southpeak/Minya/blob/master/LICENSE).

