#
Quotes App

## 1. Clone and run the Quotes App
---

- Clone the quotes app repository:
```bash
git clone https://github.com/kedarkk28/quotes-app.git
cd quotes-app
```

- Apply the Kubernetes yaml manifests for the quotes app:
```bash
kubectl apply -f k8s-specifications/
```

- Forward the ports to access the frontend for quotes app:
```bash
kubectl port-forward svc/frontend-service 9081:81 -n quotes-app > /dev/null 2>&1 &
```

---

## 2. Installing Argo CD:
- Create a namespace for Argo CD:
  ```bash
  kubectl create namespace argocd
  ```

- Apply the yaml manifest file for Argo CD:
  ```bash
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
  ```

- View the services in argocd namespace:
  ```bash
  kubectl get svc -n argocd
  ```

- Change the service from ClusterIP to NodePort:
  ```bash
  kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
  ```

- Forward the port to access Argo CD server and run in background:
  ```bash
  kubectl port-forward -n argocd service/argocd-server 8443:443 > /dev/null 2>&1 &
  ```
---

