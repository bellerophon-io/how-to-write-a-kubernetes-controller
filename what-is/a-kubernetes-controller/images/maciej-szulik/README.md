All those screenshots are screenshots of the outube video of the CNCF Conference of the Guy who wrote the first Kubernetes Conrollers `Maciej Szulik`

His conference was titled `Writing Kube Controllers for Everyone - Maciej Szulik, Red Hat (Beginner Skill Level)`


## Analysis of `Writing Kube Controllers for Everyone - Maciej Szulik, Red Hat (Beginner Skill Level)`

https://www.youtube.com/watch?v=AUNPLQVxvmw

note :
* It is very important to use shared Informers :
  * Their purpose is to dispatch information to all listeners interested into a given information
  * The most important part of shared Listener are its Event Handlers, and there must always be 3 event handlers :
    * `AddEventHandler` : Listen to the Add event of a given Resource of a given `kind: BellerophonSimple` (When you create the resource with `kubectl`)
    * `UpdateEventHandler` : Listen to the Update event of a given Resource of a given `kind: BellerophonSimple` (When you modify the already existing resource with `kubectl`)
    * `DeleteteEventHandler` : Listen to the Delete event of a given Resource of a given `kind: BellerophonSimple` (When you delete the already existing resource with `kubectl`)

* Shared Informers are in the official example https://github.com/kubernetes/sample-controller , in the go package named `cache`

* Shared Informers include :
  * The EventHandlers :
    * `AddEventHandler` : Listen to the Add event of a given Resource of a given `kind: BellerophonSimple` (When you create the resource with `kubectl`)
    * `UpdateEventHandler` : Listen to the Update event of a given Resource of a given `kind: BellerophonSimple` (When you modify the already existing resource with `kubectl`)
    * `DeleteteEventHandler` : Listen to the Delete event of a given Resource of a given `kind: BellerophonSimple` (When you delete the already existing resource with `kubectl`)
  * the listers :
    * methods which lists Kubernetes objects from the cache instead of hitting the Kubernetes API

#### A Cache in a Kubernetes Controller, Why ?


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


#### My controller, and the other controllers

We implement a Kubernetes Controller ok. Our Controller changes the state of Kubernetes Resource Objects, but in a real world Cluster, many other Kubernetes Controllers may changes the state of the same Kubernetes Resource Objects :

So ther must be a way to manage this compelxity, and this has probably to do with the sync state of the Cache
