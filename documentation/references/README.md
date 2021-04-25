# All external References I found

### Tech forums

#### Source 0

https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/

Specifies rules isomorphic with the rational language defined by Open APIv3, to use to define CRDs.

There we have validation , and it's probably there that we can implement in the Kubernetes Controller, a validation module, whatever its architecture is (Validation probably in the "Process phase") in the below schematics :

![How A Kubernetes Controller Should Work](../../what-is/a-kubernetes-controller/client-go-controller-interaction.jpeg)

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
