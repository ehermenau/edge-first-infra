resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"

  }
}

# 2. ArgoCD Helm Release
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
  version    = "9.4.4"

  # We use 'set' for high-level toggles
  set = [
    {
      name  = "server.extraArgs"
      value = "{--insecure}" # TLS termination will happen at the AWS LB later
    }
  ]

  # Injects the 'EFI' tag into all resources created by the Helm chart
  values = [
    <<-EOF
    global:
      additionalLabels:
        Project: EFI
    server:
      service:
        type: NodePort
    EOF
  ]

  depends_on = [kubernetes_namespace_v1.argocd]
}

# 3. The Root Application (The GitOps Anchor)
resource "kubernetes_manifest" "root_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "root-app"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://gitlab.com/evanhermenau/edge-first-infrastructure.git"
        targetRevision = "main"
        path           = "gitops/hub/root"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "argocd"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }

  depends_on = [helm_release.argocd]
}
