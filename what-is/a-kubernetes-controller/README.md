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
# --- below the [ --v=6] will give verbose stdout showing
#     what Kubernetes API Endpoints are used when creating the Resource
kubectl apply -f ./k8s-crds/simple/bellerophon-simple-example-instance1.yaml --v=6


kubectl get sheroes -o wide

kubectl describe sheroes example-simple-bellerophon-hero1

```

* The full stdout of `kubectl apply -f ./k8s-crds/simple/bellerophon-simple-example-instance1.yaml --v=6` :

```bash
bash-3.2$ kubectl apply -f ./k8s-crds/simple/bellerophon-simple-example-instance1.yaml --v=6
I0425 01:32:47.409913   51336 loader.go:375] Config loaded from file:  /Users/jbl/.kube/config
I0425 01:32:47.550600   51336 round_trippers.go:444] GET https://0.0.0.0:7888/openapi/v2?timeout=32s 200 OK in 127 milliseconds
I0425 01:32:47.858291   51336 discovery.go:214] Invalidating discovery information
I0425 01:32:47.861796   51336 round_trippers.go:444] GET https://0.0.0.0:7888/api?timeout=32s 200 OK in 3 milliseconds
I0425 01:32:47.883426   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis?timeout=32s 200 OK in 3 milliseconds
I0425 01:32:47.914131   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/events.k8s.io/v1?timeout=32s 200 OK in 12 milliseconds
I0425 01:32:47.942024   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/scheduling.k8s.io/v1?timeout=32s 200 OK in 39 milliseconds
I0425 01:32:47.942066   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/node.k8s.io/v1?timeout=32s 200 OK in 40 milliseconds
I0425 01:32:47.944096   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/authentication.k8s.io/v1?timeout=32s 200 OK in 42 milliseconds
I0425 01:32:47.946215   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/apiextensions.k8s.io/v1?timeout=32s 200 OK in 43 milliseconds
I0425 01:32:47.946509   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/stable.simple-bellerophon.io/v444beta989?timeout=32s 200 OK in 43 milliseconds
I0425 01:32:47.947092   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/storage.k8s.io/v1?timeout=32s 200 OK in 44 milliseconds
I0425 01:32:47.947288   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/events.k8s.io/v1beta1?timeout=32s 200 OK in 45 milliseconds
I0425 01:32:47.948472   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/authentication.k8s.io/v1beta1?timeout=32s 200 OK in 46 milliseconds
I0425 01:32:47.948634   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/autoscaling/v2beta1?timeout=32s 200 OK in 47 milliseconds
I0425 01:32:47.949554   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/k3s.cattle.io/v1?timeout=32s 200 OK in 46 milliseconds
I0425 01:32:47.949605   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/storage.k8s.io/v1beta1?timeout=32s 200 OK in 46 milliseconds
I0425 01:32:47.949615   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/networking.k8s.io/v1?timeout=32s 200 OK in 46 milliseconds
I0425 01:32:47.951602   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/discovery.k8s.io/v1beta1?timeout=32s 200 OK in 48 milliseconds
I0425 01:32:47.951616   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/certificates.k8s.io/v1beta1?timeout=32s 200 OK in 48 milliseconds
I0425 01:32:47.951621   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/authorization.k8s.io/v1?timeout=32s 200 OK in 50 milliseconds
I0425 01:32:47.951679   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/authorization.k8s.io/v1beta1?timeout=32s 200 OK in 50 milliseconds
I0425 01:32:47.953652   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/coordination.k8s.io/v1?timeout=32s 200 OK in 51 milliseconds
I0425 01:32:47.953785   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/rbac.authorization.k8s.io/v1beta1?timeout=32s 200 OK in 51 milliseconds
I0425 01:32:47.955081   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/apps/v1?timeout=32s 200 OK in 53 milliseconds
I0425 01:32:47.958341   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/apiregistration.k8s.io/v1beta1?timeout=32s 200 OK in 56 milliseconds
I0425 01:32:47.960064   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/batch/v1beta1?timeout=32s 200 OK in 56 milliseconds
I0425 01:32:47.960173   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/autoscaling/v1?timeout=32s 200 OK in 58 milliseconds
I0425 01:32:47.960192   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/flowcontrol.apiserver.k8s.io/v1beta1?timeout=32s 200 OK in 56 milliseconds
I0425 01:32:47.960206   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/batch/v1?timeout=32s 200 OK in 57 milliseconds
I0425 01:32:47.960229   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/extensions/v1beta1?timeout=32s 200 OK in 57 milliseconds
I0425 01:32:47.960635   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/scheduling.k8s.io/v1beta1?timeout=32s 200 OK in 58 milliseconds
I0425 01:32:47.961359   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/autoscaling/v2beta2?timeout=32s 200 OK in 58 milliseconds
I0425 01:32:47.961969   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/metrics.k8s.io/v1beta1?timeout=32s 200 OK in 60 milliseconds
I0425 01:32:47.961975   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/helm.cattle.io/v1?timeout=32s 200 OK in 59 milliseconds
I0425 01:32:47.962008   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/certificates.k8s.io/v1?timeout=32s 200 OK in 59 milliseconds
I0425 01:32:47.962704   51336 round_trippers.go:444] GET https://0.0.0.0:7888/api/v1?timeout=32s 200 OK in 61 milliseconds
I0425 01:32:47.965085   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/coordination.k8s.io/v1beta1?timeout=32s 200 OK in 63 milliseconds
I0425 01:32:47.965095   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/rbac.authorization.k8s.io/v1?timeout=32s 200 OK in 61 milliseconds
I0425 01:32:47.965123   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/apiextensions.k8s.io/v1beta1?timeout=32s 200 OK in 63 milliseconds
I0425 01:32:47.965089   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/apiregistration.k8s.io/v1?timeout=32s 200 OK in 63 milliseconds
I0425 01:32:47.966222   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/node.k8s.io/v1beta1?timeout=32s 200 OK in 63 milliseconds
I0425 01:32:47.966262   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/networking.k8s.io/v1beta1?timeout=32s 200 OK in 64 milliseconds
I0425 01:32:47.966847   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/admissionregistration.k8s.io/v1?timeout=32s 200 OK in 65 milliseconds
I0425 01:32:47.969232   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/admissionregistration.k8s.io/v1beta1?timeout=32s 200 OK in 66 milliseconds
I0425 01:32:47.972158   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/policy/v1beta1?timeout=32s 200 OK in 68 milliseconds
I0425 01:32:49.001474   51336 round_trippers.go:444] GET https://0.0.0.0:7888/apis/stable.simple-bellerophon.io/v444beta989/namespaces/default/sheroes/example-simple-bellerophon-hero1 404 Not Found in 153 milliseconds
I0425 01:32:49.028337   51336 round_trippers.go:444] POST https://0.0.0.0:7888/apis/stable.simple-bellerophon.io/v444beta989/namespaces/default/sheroes?fieldManager=kubectl-client-side-apply 201 Created in 26 milliseconds
bellerophonsimple.stable.simple-bellerophon.io/example-simple-bellerophon-hero1 created
I0425 01:32:49.028684   51336 apply.go:390] Running apply post-processor function
```

* So Here are the  Kubernetes API Endpoints, created by the `BellerophonSimple` `CRD`, that are used when creating the Resource of `kind: BellerophonSimple` `kubectl apply -f ./k8s-crds/simple/bellerophon-simple-example-instance1.yaml` :

```bash
GET https://0.0.0.0:7888/apis/stable.simple-bellerophon.io/v444beta989?timeout=32s 200 OK in 43 milliseconds
GET https://0.0.0.0:7888/apis/stable.simple-bellerophon.io/v444beta989/namespaces/default/sheroes/example-simple-bellerophon-hero1 404 Not Found in 153 milliseconds
POST https://0.0.0.0:7888/apis/stable.simple-bellerophon.io/v444beta989/namespaces/default/sheroes?fieldManager=kubectl-client-side-apply 201 Created in 26 milliseconds
```

* Now the full stdout of `kubectl get sheroes -o wide` and `kubectl describe sheroes example-simple-bellerophon-hero1` :

```bash
bash-3.2$ kubectl get sheroes -o wide
NAME                               AGE
example-simple-bellerophon-hero1   34m
bash-3.2$ kubectl describe sheroes example-simple-bellerophon-hero1
Name:         example-simple-bellerophon-hero1
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  stable.simple-bellerophon.io/v444beta989
Kind:         BellerophonSimple
Metadata:
  Creation Timestamp:  2021-04-24T23:32:49Z
  Generation:          1
  Managed Fields:
    API Version:  stable.simple-bellerophon.io/v444beta989
    Fields Type:  FieldsV1
    fieldsV1:
      f:metadata:
        f:annotations:
          .:
          f:kubectl.kubernetes.io/last-applied-configuration:
      f:spec:
        .:
        f:image:
        f:replicas:
        f:winged_horse_name:
    Manager:         kubectl-client-side-apply
    Operation:       Update
    Time:            2021-04-24T23:32:49Z
  Resource Version:  3987
  UID:               bcdcfd9d-6c9d-4246-a1e0-d8eb4298b908
Spec:
  Image:              quay.io/pok-us-io/pokus_api_build
  Replicas:           7
  winged_horse_name:  pegasusio
Events:               <none>
```
