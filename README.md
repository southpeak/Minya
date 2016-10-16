# Minya

A simple basic hierarchy for iOS development with Objective-C. It is based on MVCS and KVO.

The following image is the all elements of this hierarchy, we will describe it in detail.

![](https://github.com/southpeak/Blog-images/blob/master/MVCS.png?raw=true)

## MVCS and scene

In Minya, MVCS means Model-View-ViewController-Store. You must know the MVC, so it is very simple to understand MVCS. We just put the business logic code to the Store layer. However, our aims is not only the lighter view controller.

In Minya, each layer has the special job to do, and all the job is related to the data:

* Model Layer: it is just a data structure most of the time; sometimes it do some light data operation, such as formatting a date string;
* View Layer: show the data to the user and receive the user's input data;
* View Controller Layer: only pass data between different view controllers;
* Store Layer: it is the business logic processing layer; its duty is to request data from the server or local storage, and process the data from the view; 

> Note: The whole store layer in the previous image contain three elements: Store, Service, Storage.

Obviously, it is simple, and there is nothing special.


