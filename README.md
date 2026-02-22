**Edge-First Infrastructure (EFI)** is a reference architecture for geographically distributed workloads. It addresses the trade-offs between centralized cloud management and low-latency edge execution. Compute should reside where the data is born. Control should reside where the humans are.

```mermaid
graph TB
    subgraph Management_Hub [Management Hub]
        direction TB
        ArgoCD[ArgoCD Control Plane]
        GitOps[(Git Source of Truth)]
        S3_State[S3 State & Lockfile]
        Central_Repo[(Central Data Repository)]

        ArgoCD --> GitOps
    end

    subgraph Edge_Node [Edge]
        direction TB
        EKS_Edge[EKS Cluster]

        subgraph Data_Plane [Kernel-Level Data Plane]
            Cilium[Cilium CNI / eBPF]
            Longhorn[Longhorn Distributed Storage]
            Workloads[Edge Workloads]
        end

        EKS_Edge --> Cilium
        EKS_Edge --> Longhorn
        Longhorn --> Workloads
    end

    %% Encrypted Fabric Connection
    ArgoCD -.->|GitOps Sync| EKS_Edge
    Cilium ~~~ Management_Hub
    Workloads -.->|Summarized Telemetry| Central_Repo

    %% Styling
    classDef blue_space fill:#4169e1,stroke:#333,stroke-width:2px;
    classDef grey_space fill:#708090,stroke:#333,stroke-width:2px;

    class Management_Hub blue_space;
    class Edge_Node grey_space;
```

---

## 🏗 The Architecture

EFI implements a **Hub-and-Spoke** topology across multiple AWS regions, designed to satisfy three core pillars:

1.  **Autonomous Survivability:** Edge nodes must continue to process local data and maintain state even during a total hub outage.
2.  **Kernel-Level Security:** Leveraging **eBPF (Cilium)** to replace `iptables` and sidecar-heavy service meshes with near-zero overhead networking and identity-aware security.
3.  **Declarative Consistency:** Every piece is governed by **GitOps (ArgoCD)**, ensuring no configuration drift across the global fleet.

---

## 🛠 The Tech Stack & "The Why"

| Component          | Choice            | Justification                                                                               |
| :----------------- | :---------------- | :------------------------------------------------------------------------------------------ |
| **Cloud Provider** | **AWS**           | Utilizing Multi-Region VPCs and EKS for managed control plane stability.                    |
| **Networking**     | **Cilium (eBPF)** | High-throughput, low-latency routing; kernel-level observability (Hubble) without sidecars. |
| **Storage**        | **Longhorn**      | Cloud-native distributed block storage that ensures data persistence at the edge.           |
| **Automation**     | **Terraform**     | Modular, multi-region IaC using S3-native state locking.                                    |
| **GitOps**         | **ArgoCD**        | Managing multi-cluster applications via the "App-of-Apps" pattern.                          |

---

## 🧩 System Components

### 1. The Management Hub

The "Central Nervous System." It hosts **ArgoCD** and the primary data repository. Responsible for global state monitoring and aggregated telemetry.

### 2. The Edge Node

The "Workhorse." It hosts the high-impact workloads where sub-10ms latency is mandatory. Performs real-time data processing, local state persistence via **Longhorn**, and eBPF-driven workload isolation.
