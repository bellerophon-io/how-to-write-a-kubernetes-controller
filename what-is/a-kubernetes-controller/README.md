# What is a `Kubernetes Controller` ?

In this page, I explore :
* What a `Kubernetes Controller` is,
* What you can doo with it
* What this concept was designed to do : The designers of this concept, had in mind use cases, what are those use cases ?


## Constructive approach



The top README.md of https://github.com/kubernetes/sample-controller (an official example `Kubernetes Controller` implementation), gives tons of informations on what a `Kubernetes Controller` is, what it is made of :
* it is made of :
  * a typed client,
  * informers,
  * listers
  * and deep-copy functions




### What is deep copy / shallow copy ?

https://www.youtube.com/watch?v=QaCYMgyprtc :  Explained in Java

This is about copying just the reference to an object, or the entire object it self. Seee arguments passd by referene, or by value.

See also clone methods in Java, immutability etc...

real deep copy will duplicate all trasitively referenced objects

So in my opinion, deep copy might be useful to achieve immutability.

Ok, so in my developing a `Kubernetes Controller` in `TypeScript` , it seems like i am fgoing to need deep copy methods in `TypeScript`

### Deep copy in `TypeScript`


Ok, so in my developing a `Kubernetes Controller` in `TypeScript` , it seems like i am fgoing to need deep copy methods in `TypeScript`


* https://github.com/ykdr2017/ts-deepcopy
* https://github.com/ghatchue/deep-copy-ts : last commits  on Feb 3, 2015
* https://github.com/lihroff/deeplyAssign : last commits  on Feb 21, 2019
* https://github.com/SpaceTrev/Deep-Copy-Alg :  this one is from 2020, and seems seriously to implement an given clear algorithm for deep copy
* https://github.com/ardentia/deep-copy : this one is from march 2021, has a package published on `npm`, seems serious candidate to try


### The Go library schematics

![How A Kubernetes Controller Should Work](./client-go-controller-interaction.jpeg)


#### client-go components

* Reflector: A reflector, which is defined in [type *Reflector* inside package *cache*](https://github.com/kubernetes/client-go/blob/master/tools/cache/reflector.go),
watches the Kubernetes API for the specified resource type (kind).
The function in which this is done is *ListAndWatch*.
The watch could be for an in-built resource or it could be for a custom resource.
When the reflector receives notification about existence of new
resource instance through the watch API, it gets the newly created object
using the corresponding listing API and puts it in the Delta Fifo queue
inside the *watchHandler* function.


* Informer: An informer defined in the [base controller inside package *cache*](https://github.com/kubernetes/client-go/blob/master/tools/cache/controller.go) pops objects from the Delta Fifo queue.
The function in which this is done is *processLoop*. The job of this base controller
is to save the object for later retrieval, and to invoke our controller passing it the object.

* Indexer: An indexer provides indexing functionality over objects.
It is defined in [type *Indexer* inside package *cache*](https://github.com/kubernetes/client-go/blob/master/tools/cache/index.go). A typical indexing use-case is to create an index based on object labels. Indexer can
maintain indexes based on several indexing functions.
Indexer uses a thread-safe data store to store objects and their keys.
There is a default function named *MetaNamespaceKeyFunc* defined in [type Store inside package cache](https://github.com/kubernetes/client-go/blob/master/tools/cache/store.go)
that generates an object’s key as `<namespace>/<name>` combination for that object.


#### Custom Controller components

* Informer reference: This is the reference to the Informer instance that knows
how to work with your custom resource objects. Your custom controller code needs
to create the appropriate Informer.

* Indexer reference: This is the reference to the Indexer instance that knows
how to work with your custom resource objects. Your custom controller code needs
to create this. You will be using this reference for retrieving objects for
later processing.

The base controller in client-go provides the *NewIndexerInformer* function to create Informer and Indexer.
In your code you can either [directly invoke this function](https://github.com/kubernetes/client-go/blob/master/examples/workqueue/main.go#L174) or [use factory methods for creating an informer.](https://github.com/kubernetes/sample-controller/blob/master/main.go#L61)

* Resource Event Handlers: These are the callback functions which will be called by
the Informer when it wants to deliver an object to your controller. The typical
pattern to write these functions is to obtain the dispatched object’s key
and enqueue that key in a work queue for further processing.

* Work queue: This is the queue that you create in your controller code to decouple
delivery of an object from its processing. Resource event handler functions are written
to extract the delivered object’s key and add that to the work queue.

* Process Item: This is the function that you create in your code which processes items
from the work queue. There can be one or more other functions that do the actual processing.
These functions will typically use the [Indexer reference](https://github.com/kubernetes/client-go/blob/master/examples/workqueue/main.go#L73), or a Listing wrapper to retrieve the object corresponding to the key.

## Conceptual Approach

Using the explnations from the Go library above, here is the conceptual story :

* I create a Kubernetes CRD, which has its own custom `kind: BellerophonSimple`. The CRD itself is a Kubernetes Object of `kind: CustomResourceDefinition`.
* According [official documentation](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/):
  * my `CRD` would be of the following form : see  `k8s-crds/simple/bellerophon-simple.yaml`
  * then I will create a Kubernetes object of `kind: BellerophonSimple` bu running `kubectl apply -f k8s-crds/simple/bellerophon-simple-example-instance1.yaml`


```bash
# git clone https://github.com/bellerophon-io/how-to-write-a-kubernetes-controller
git clone git@github.com:bellerophon-io/how-to-write-a-kubernetes-controller.git
cd how-to-write-a-kubernetes-controller/

# ---
# After this, new Kubernetes API endpoints will exists : those
# are the Kubernetes API Endpoints with which will work my 'Bellrophon Kubernetes Controller'
kubectl apply -f ./k8s-crds/simple/bellerophon-simple.yaml


# ------------------------------------------------------------------------------------------------
#   KUBERNETES API ENDPOINTS CREATED BY THIS CRD
# ------------------------------------------------------------------------------------------------
# /apis/stable.simple-bellerophon.io/v444beta989/namespaces/*/sheroes/<and here the standard CRUD operations provided by any Kybernetes API Endpoints of any Resource, like e.g. Config Maps ...>
# ------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------


# --- #
# The apply below will give errors, because there are things missing : It is
# not enough to just [kubectl apply  the CRD] , to be able to create a
# Kubernetes Object of the Kubernetes kind defined by this CRD.
# --- #
# --- below the [ --v=6] will give verbose stdout showing
#     what Endpoints are used when creating the Resource
kubectl apply -f ./k8s-crds/simple/bellerophon-simple-example-instance1.yaml --v=6
```
