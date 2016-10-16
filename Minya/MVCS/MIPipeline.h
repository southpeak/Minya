//
//  MIPipeline.h
//  MinyaDemo
//
//  Created by Konka on 2016/9/27.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Basic class for pipeline
 *
 *  The pipeline is the core of the Minya MVCS hierarchy. In fact, pipeline object 
 *  is a data container and a data pipeline for the view, view controller, store layer.
 *  These three layers is decoupled, they are just dependent on the pipeline, if some 
 *  data should be pass in these layers, you can put it in the pipeline. Then the 
 *  other layer can observe the pipeline's property to do some work.
 *
 *  We suggest that you can put five type data in the pipeline:
 *
 *  1. `Normal data`: these data is from the server and then showed in the view.
 *  2. `Flag data`: now the KVO is not good for collection data, so we can set a flag for
 *     these data which from server. The view layer can observe the flag peoperty to
 *     know the collection data is updated.
 *  3. `Status data`: sometimes, the view want to show different subviews in different status,
 *     For example, if the user does not sign in, we show a `sign in` button in a view,
 *     and if the user has signed in, we show some other information in the same view.
 *     We can define some status data for these situations.
 *  4. `Input data`: when the user has some input, such as tapping a button, you should do
 *     some business logic work. The store layer want to know that, so you can define a 
 *     input property in the pipeline, and the store layer can observe this property and 
 *     when the property changed, you can do what you want to do.
 *  5. `Context data`: context data is used for data transmission between view controller.
 *     In Minya MVCS, dictionary is used for data transmission. The view controller layer does
 *     not store any data but the pipeline does, and the view controller do the transmission
 *     job, so it can fetch data from pipeline.
 *
 *  Of course, if the data from the server should not be pass to the other layer, you can
 *  just put it in the store layer as a private proterty and so on.
 */
@interface MIPipeline : NSObject

@end
