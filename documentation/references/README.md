# All external References I found

### Tech forums

#### Source 0

https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/

Specifies rules isomorphic with the rational language defined by Open APIv3, to use to define CRDs.

There we have validation , and it's probably there that we can implement in the Kubernetes Controller, a validation module, whatever its architecture is (Validation probably in the "Process phase") in the below schematics :

![How A Kubernetes Controller Should Work](../../what-is/a-kubernetes-controller/images/client-go-controller-interaction.jpeg)

[See also this page in this repo](../../what-is/a-kubernetes-controller)

#### Source 1

* On https://stackoverflow.com/questions/55991672/can-i-write-a-kubernetes-controller-in-nodejs-instead-of-go :
  * a person asks if it is possible to develop a Kubernetes Controller, using `TypeScript`
  * someone answers that therte are multiple Client Libraries for Kubernetes, and gives https://kubernetes.io/docs/reference/using-api/client-libraries/


Now, on https://kubernetes.io/docs/reference/using-api/client-libraries/ , what do I find ?
* SDK for multiples languages, to work with the Kubernetes API. Ok.
* As for `TypeScript`, here is what I get :
  * Among the offically supported "client libraries", there is one for JavaScript, which includes `TypeScript` examples https://github.com/kubernetes-client/javascript/tree/master/examples/typescript
  * In those examples , I do not see a "Controller", but components among which two seems to be interesting to develop a Kubernetes Controller :
    * An `Informer` : https://github.com/kubernetes-client/javascript/tree/master/examples/typescript/informer
    * A `Watcher` : https://github.com/kubernetes-client/javascript/tree/master/examples/typescript/watch

#### Source 2 : Conceptual

https://insujang.github.io/2020-02-11/kubernetes-custom-resource/

* explains the origin of the concept of `CRD`, which is the Operator Pattern :
  * `Kubernetes Operator` Pattern, came out of `CoreOS` Team. The idea is getting a "Human-like behaviour", described as _**"Observe, Analyze, and Act"**_ :  SO the concpet of CRD has a relation with the Concept of a Kubernetes Operator
  * gives concrete test be creating an example, simple `CRD`, and then trying to create a `Kubernetes` Object, of the `Kubernetes` `kind` defined tby the Kubernetes `CRD`



#### Source 3 : CRD Validation

Oh, Ok, I can write anything in a CRD ?

https://book.kubebuilder.io/reference/markers/crd-validation.html

https://github.com/kubeflow/crd-validation

https://github.com/kubernetes/kubernetes/issues/54579#issuecomment-370372942

I will consider the question of CRD validation when I have played a bit more with CRDs



#### Source 4 : Conceptual presentation `Writing Kube Controllers for Everyone - Maciej Szulik, Red Hat (Beginner Skill Level)`

https://www.youtube.com/watch?v=AUNPLQVxvmw

note :
* It is very importasnt to use shared Informers :
  * Their purpose is to dispatch information to all listeners interested into a given information


#### Source 5 : A CRDs Tutorial

https://itnext.io/building-your-own-kubernetes-crds-701de1c9a161


#### Source 6 : An example Kubernetes COntroller to implement the Kubernetes Operator pattern


https://github.com/jinghzhu/KubernetesCRDOperator

Purpose :

>  "how to create a controller to watch all events (add/update/delete) of some CRD kinds so that we can implement the Operator pattern."

#### What are Kubernetes Operators ?


https://www.youtube.com/watch?v=ha3LjlD6g7g


* Kubernetes Operator => For stateful apps deployed in Kubernetes,
* Each stateful software deployed in Kubernetes, as its own Kubernetes Operator :
  * Its own Kubernetes Operator knows how to perform software specific operations, like bakcup , etc...
  * So for example, at my company gravitee.io, My companys product being a Stateful software (an API Gateway), of course we must have a Gravitee Kubernetes Operator for each of Gravitee AM, Gravitee APIM, Gravitee Cockpit, Gravitee AE (and maybe there  is collision between what Cockpit is, and what a Kubernetes Operator Is, and actuall maybe Cockpit must become a Kubernetes Operator). Here the problem is that Cockpit modifies state of APIM and AM potentially, so to not intrfere with the Kubernetes Operator Cockpit **Must** use a kubernetes client to operate APIM and AM deploed services.
  * Interesting : How about a Kubernetes Operator has a UI ? THis UI would then be just "read only " => would give insights on what's happening in the sofware, etc... Also here it is obvious a Kubernetes Controlelr / Operator msut have prometheus exporters to monitor eveything happening there... There must be a monitoring of any Kubernetes Controller / Operator.

One very intersting question here :
* Let `Lambda` be a stateful app deployed to Kubernetes.
* Since it is a stateful application, `Lambda` needs a Kubernetes Operator
* Let `Mew`, be the Kuebrnetes Oeprator of `Lambda` :
  * `Mew` itself, is an pplication deployed into `Kubernetes`
  * if `Mew` is a stateful application, oh my, then we need a Kubernetes Operator, ofr our Kubernetes Operator
  * So : can we make a Kuebrnetes Operator Stateless, for every application ? Or can we make a finite "tower" of Kubernetes Operators, with "last" operator being a Stateless one ? (which is quite equivalent actually, because the so called "otwer of Kuebrentes Operators" , can it self, be cosidered an Operator, and the question is then, can we always build a stateless Operator, for any stateful application ? )



* There exists multiple SDK to develop Kuebernetes Operators, and maybe its better to try and build a Kubernetes Operator, instead of just a Kubernetes Controller.... :
  * Operator SDK s :
    * https://github.com/operator-framework (apparently most known one in GO)
    * another in nodejs javascript : https://github.com/dot-i/k8s-operator-node
    * very few I found in JAvascript,
    * it seems like there are some serious SDK in java for operators :
      * according https://hazelcast.com/blog/build-your-kubernetes-operator-with-the-right-tool/ : in that page they show how to implement an Operator using the java quarkus framework. They also mention that Operators are nothing more tha dockerized app, wso we can wrtie one in any language, that's our choice. their example showing how t implement the operator using Quarkus is something I want to try
      * there is also their dedicated article :
        * https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-1/ ==> general concept explanations and why quarkus provides a good alternative to CoreSO big Golang SDK stuff
        * https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-2/ ==>> here they teach us how to set up the Quarkus project, with the Quarkus Kubernetes Client Extension
        * https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-3/ ===>> here is implemented the Operator specific code, **And What is VERY INTEREsTING HERE** is that they tlak about implementing **THE RESOURCE CACHE** (the cache they talk about with the kubernetes controller)
  * Operator Hub : https://operatorhub.io/
