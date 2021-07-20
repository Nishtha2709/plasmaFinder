# Plasma Finder
The project aims at connecting plasma donators and receivers.

<!-- TABLE OF CONTENTS -->
## Table of Contents

* [Description](#description)
* [Technology Stack](#technology-stack)
* [Future Scope](#future-scope)
* [Result](#result)

## Description
This solution will help the customer buy their appropriate fit from anytime anywhere. 
All they will need is a perfectly fitting garment (which the customer already owns) to find their perfect fit.   

We take input image of garment from user, from a certain mentioned height, which user already owns and fits user perfectly. 
We now use this image and images of all different sizes of that garment given by seller which are stored in Firebase, to find the least closest fit to this given input using 
ChangeDetection method which uses Unspuervised Machine Learning Algorithms like PCA and K-Means Clustering.
We use few conditions and finally our solution gives user the output of his/her perfect fit size.

(More Detailed Explaination can be found in [#1](https://github.com/Bhumika-Kothwal/Mind-Debuggers/pull/1) and [#2](https://github.com/Bhumika-Kothwal/Mind-Debuggers/pull/2))

## Technology stack

Tools and technologies that you learnt and used in the project.

1. Flutter
2. Firebase

## Future scope
Features aimed to be implemented in next phase :
- [ ] Providing feature to capture images with camera having distance measuring feature
- [ ] Providing separate login for Buyers and Sellers in the android app.

## Result   

### PerfectFit

![Result](https://github.com/Bhumika-Kothwal/Mind-Debuggers/blob/master/Images/App%20Images/App_img2.jpg)
