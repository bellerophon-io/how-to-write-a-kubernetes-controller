# The Bellerophon Kubernetes Controller

What do we get in tocuh with , first, when Talking about Kubernetes Controllers ? `CRDs`. Oh, and those are pretty trendy those days.

So let's begin this journey by trying to do things, with `CRDs`.


## A first CRD Experiment

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

So what Happened here ?

* Well all the yaml were accpeted by Kubernetes no prob , everything fine as far as the Kubernetes Cluster is concerned.
* Oh yeah: But actually **NOTHING** Happened into the cluster, meaning absolutely no resources were either ceated, deleted or modified. _**The Desired state**_ (of whatever) has not changed at all, not one inch.

So what a Kubernetes Controller will do, is that it will do the things that are not done here. Oh, Ok i see.

Now one more word, here, is that I now know, this :
* The Kubernetes Controller role is to ensure the _**desired state**_ of "something" is maintained.
* The desired state of what ? Well the desired state of a stateful app deployed into the cluster :
  * The Kuebrenetes Clsuter will perfectly know, without the need of any Kubernetes Controller coming from you, how to maitnain the desired state of a stateless appllication : in a word, because it is easy, and Kuebrnetes knows ho w to do that perfrectly
  * But when it comes to a given stateful application, deployed into Kubernetes, only those who developed that applications, know "how to maintain the deisred state" of the aplication. Examples : think of a MySQL Staeful set, or a MongoDB Atlas etc.. Those who develope dthe softwarte, or people who know very well the software.
  * In other words, and it's more important to understand it that way :
    * the operations you perform, to maintain the diresired state of a stateful software, are very different from one software, to another
    * maintaining the desired state of a MongoDB Atlas cluster, requries performing operations taht ar very different form the operations you perform, to maintain the desired state of a PostgreSQL Cluster
    * So in a aword , a Kubernetes Controller (or: a Kubernetes Operator), factorizes these operations, that are specific for each different sofware, into one thing. And there fore provides automation for those operations.
    * This is why the Kubernetes Operator is such a friend with gitops : it just rtequries you, to operate the software, to give the desired state you want, and since this desired state can entirely be descirbed as YAML files, well you can git version control the hsitory of the different states YOU desired for your software, into the Kubernetes Cluster...



#### A Cache in a Kubernetes Controller, Why ?

According the very offical https://github.com/kubernetes/sample-controller/blob/master/docs/controller-client-go.md , there must be a cache into a Kuebrnetes Controller impementation : Why ?

What gave me the answer to that is https://www.youtube.com/watch?v=AUNPLQVxvmw , aka Maciej Szulik's excellent talk `Writing Kube Controllers for Everyone - Maciej Szulik, Red Hat (Beginner Skill Level)` from 2018 an CNCF

Hitting the Kubernetes API, especially to get / list objects, is very expensive.

This is why A Cache component was introduced into the `Kubernetes Controller` Architecture, and :
* instead of using a simple Kubernetes API client to list objects by hitting the Kubernetes API
* you should use the shared Informer `listers` methods, which read from cache, and do not hit the Kubernetes API

Extremely important !


One impôrtant problem to manage with the cache :
  * The cache must be in sync with the Objects Actually returned by the Kubernetes API
  * so at any time, it must be posible to find out if the cache is synced or not


In NodeJS `TypeScript`, I look for cache management libraries, and:
* here are the requriements :
  * must be concurrency safe
  * must provide index (they use index called "metanamespace" where the key of each object stored in the cache, is `<k8s namespace>/<name of the K8S resource Object>` somtyhg like that )
  * must allow checking the sync state,
* here is what I found :
  * https://github.com/lukechilds/keyv
  * ...

Hum.. actually all these kinds of cache, I can find in the nodejs / React / Angular / etc... wold, are chachces whic PULL the data from the data source (in my case, the Kubernetes REST API)

But in my Kubernetes Controller case, my cache is fed from a watcher :
* So ok, most of the cache libraries from the JAvaScript wworld won't fit my needs, since they pull
* Oh, Ok, now that I understood that this Resource Cache I need, will be fed by the "watchers" :  How to I define what "synced" means ? Ideas :
  * If watchers keep receiving a lot of events, then we wait until "it calms down" => so there's her a concept of what "calm" means. This concept must depende of the main loop
  * Here is what I call "the main loop" :
    * **Responsible Component : `Reflector`** : The `Reflector` with its watchers, capture a Resource event from Kubernetes API, and uses the Kubernetes API to retrieve/list the state of the Reource Objects which were modified / created / deleted, in this event.
    * **Responsible Component : `Reflector`** : The `Reflector` put the event into the "Delta" FIFO Queue, together with the retrieved new state of the Resource Kubernetes Objects
    * **Responsible Component : `Informer`** : The `Informer` pops the event From the FIFO Queue, to update the resource cache :
      * **Responsible Component : `Informer`** the event says what resources were created, or modified, or deleted. And the Informer tries to find the Reource Object by it skey in the cache (the index) :
        * **Responsible Component : `Informer`** If the Resource is not found in cache, and the event is a deletion event, then it is a deletion, and then the `Informer` just deletes the Resource Object Reference form the cache, and its index
        * **Responsible Component : `Informer`** If the Resource is not found in cache, and the event is a creation event, then it is a creation, and well the `Informer` puts a deep copy of the Resource Object into the cache : the cache generates automatically the index entry from the Resource Object infos ( namespace and name of the resource, maybe I'll add a hash). The cache keeps a reference of the object, and the reference of the object is not its index, it's dfiifrent, the index is the key on the (reference point on ) the Resource Object.
        * **Responsible Component : `Informer`** (Because of this case the `Informer` feeding queue must be a FIFO) If the Resource is not found in cache, and the event is a deletion event : then it is an error case ? At least shoudl be logged and there is no need to delete from cache what is not inside of it anyway.. Hum to me this means there is a problem there (see case below it could be it brother)
        * **Responsible Component : `Informer`** (Because of this case the `Informer` feeding queue must be a FIFO)If the Resource is found in cache, and the event is a creation event : Is it an error case ? No, it shluld be logged, but this just means that the resource was deleted, and then re-created, but the creation event, got to the cache before the creation event ... Ok but then if the deletio event if it happens after the creation, instead of before.. Hum to me this means there is a problem there
        * **Responsible Component : `Informer`** If it is a modification (update) of an object which already is in the cache:
          * The Resource Object is retrieved from the cache, and :
            * a lock is added on the resource object (mutex) :  as long as the lock is there, the resource object can be read, but not modified (a modification request will have to wait til the lock flag is removed)
            * the resource object which is modified is deep copied : it is the deep copy which is going to be modified, and which will be replaced into the cache, the previous copy of the object. OWhen the raplcement is done, the lock/flag is removed. This way the cache is conccurency - safe.
            * after the lock is removed, then event is also forwarded by the Informer, to the event handlers of the custom controller (so basically, you must have `myInformer.AddEventHandler(andThisIsAnEventHandlerBeloginToTheCustomController)` not ethere reactive is perfect like with `RxSubject`) :
              * the resource event, together with the index of the resource object(s) concerned by the event, is put into the Custom Conroller's **WorkLoad Queue** (This queue is a FIFO) of the custom controller
              * on the other part of the Controller Worker Eats from the **WorkLoad Queue**, and :
                * it analyzes what is that event, and knows wha to do (fuck this is what a Kubernetes operator does, no ??)
                * To do what it's got to do, the Controller will probable need to inspect the state of multiple Resources Objects : and it wil retrieve those FROM the cache (no hit K8S API directly), by using Shared Informer's Listers
                * Finally, the controller WILL hit the Kubernetes API, to change the state of the Cluster, to reach the desired state. Ok. He will do that, this time NOT Through the cache but hitting the Kubernetes API directly : The watchers of the reflector wil then detect the change from Kubernets API, n the loop will end up udtating the cache.

Ok, so with this entire loop, what doe it mean that the cache is in sync ? It means this :
* the controller hits the Kubernetes APi too change the clustyer state, to its desired state. Ok: an then the controller cwaits untils the cache actually has recived those changes, and reflects the desired state.
* ok cool. So it really is about comparing the diesired state, and the actual state of the CLuster... :
  * hum, so maybe the desired state will be ....

Ok, I have there 3 thigns :
* I have a naive automata that I can implement, just to see wht problems I will get
* I have two questions :
  * What about conccurrency ? What problems will i get with this naive automata
  * What will it mean that the cache is in sync with the Kubernetes Cluster API ? To me, that there is no more event in a duratio equal to `10` times the duration of the above loop. That is a good stating point I believe. 10 is good, its a order in phydics
  * How will the COntroller compare the desired state and the acutal state ? It will wait


Ok Ok, So here is my program :
* I will define a stateful software, called `Bellerophon`, rather simple, and its helm deployement into Kubernetes
* I will implement a Kubernetes Operator, responsible to maintain the dresired state of a deployed `Bellerophon`. I will do that Following the Quarkus Tutorial in :
  * `documentation/references/tutorials/hazelcast-guys/quarkus-based-operator/part1`
  * `documentation/references/tutorials/hazelcast-guys/quarkus-based-operator/part2`
  * `documentation/references/tutorials/hazelcast-guys/quarkus-based-operator/part3`

* I will then implement in TypeScript RxJS , the Kubernetes Controller for `Bellerophon`, which will do the exct same as the Quarkus Kuebrnetes Oeprator
* And there I wil analyze all this by comparing the two resulting implementations, see what i can improve, etc...
* In those two cases, I will need very serious logging at least, if not complete monitoring, and will also need prometheus expporter certainly to analyze events with time series
