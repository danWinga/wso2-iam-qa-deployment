# 🛡️ Kenya Revenue Authority IAM Deployment – WSO2 | SSO | MFA | CI/CD | Docker Swarm

This repository contains the complete **Identity & Access Management (IAM)** architecture and deployment codebase for **KRA (Kenya Revenue Authority)**, integrating various enterprise systems into a centralized WSO2-based identity hub with **SSO**, **MFA**, and **observability** support.

> ⚙️ **Core Technologies**: WSO2 Identity Server, Docker Swarm, PostgreSQL, ELK, Jenkins, Traefik, F5 LB, CI/CD pipelines

---

## 🎯 Goals
- Deploy WSO2 Identity Server for centralized authentication
- Enable SSO & MFA for multiple internal applications
- Provide analytics & auditing via WSO2 IS Analytics + ELK
- Support QA, staging, and production environments
- Manage CI/CD with Jenkins + Git-driven automation
- Customize login UI for corporate branding

---

## 🔐 Integrated Applications

| System              | Purpose                          |
|---------------------|----------------------------------|
| **iShare**          | Document Management              |
| **Active Directory**| Internal LDAP/AD integration     |
| **iConnect (Koha)** | Library Management               |
| **Teammate**        | Audit & Collaboration Platform   |
| **Lotus Notes**     | Enterprise Email/Messaging       |
| **Koha (Laptops)**  | Distributed library system       |
| **IBM Analytics**   | Business Intelligence (Insight BI)|

All integrated via **WSO2 Service Providers (SP)** configuration under `kra-service-providers-configuration/`

---

## 📁 Repository Structure Overview

```text
kra-iam/
├── common/                                # Shared scripts & templates
├── db-postgres/                           # PostgreSQL setup for IS/Analytics
├── kra-cicd/                              # Jenkins pipeline definitions
├── kra-cicd-master/                       # Extended CI templates
├── kra-corporate-image-visual-atributes/ # WSO2 Login UI customization
├── kra-docker-wso2is/                    # WSO2 Identity Server Docker setup
├── kra-docker-wso2is-analytics/          # Analytics engine stack
├── kra-elk/                               # Centralized ELK observability setup
├── kra-iam-documents/                    # Architecture, SOPs, workflows
├── kra-qa-functional-requirements-testing/ # QA scripts and plans
├── kra-service-providers-configuration/   # SSO integrations for enterprise apps
├── kra-swarm-wso2/                        # Docker Swarm-based QA deployment
├── kra-swarm-wso2-master/                # Production Swarm configs (F5/Traefik)
```

---

## 🌐 Deployment Architecture

**Hybrid Multi-Zone Swarm Cluster**

- 🧠 **Identity Core**: WSO2 IS + PostgreSQL
- 📊 **Analytics**: WSO2 IS Analytics, ELK Stack
- 🔒 **Load Balancers**:
  - Internal: **Traefik** (Intranet LB)
  - External: **F5** (Enterprise DMZ/Edge LB)
- 📡 **CI/CD**: GitHub → Jenkins Pipelines (via `kra-cicd/`)

### Environment Flow:
```bash
Git Push → Jenkins CI Build → Image Publish → Swarm Deploy
```

---

## 🖼️ Login Page Customization

The login page was customized to reflect KRA branding and enhance user experience:

![Custom Login Page](ae2f473d-222a-431a-8fd8-879587dc613a.png)

**Location**: `kra-corporate-image-visual-atributes-for-login/`

### Customizations Applied:
- ✅ Custom **iDentity** logo branding
- ✅ Kenya Revenue Authority footer/logo
- ✅ UI theming (red/white/gray color scheme)
- ✅ Enhanced "Forgot Password" flow visibility
- ✅ "Remember Me" checkbox enabled
- ✅ Font adjustments for mobile compatibility

### How to Apply Custom Theme in WSO2 IS:
1. Copy customized theme files to: 
   ```
   <WSO2_HOME>/repository/deployment/server/webapps/authenticationendpoint/
   ```
2. Clear browser cache and restart WSO2 server:
   ```bash
   sh wso2server.sh restart
   ```
3. Access login UI at:
   ```
   https://identity.kra.co.ke/authenticationendpoint/login.do
   ```

---

## 🧪 QA & Testing
Directory: `kra-qa-functional-requirements-testing/`
- End-to-end test plans
- Auth flow simulations (SSO, MFA, recovery)
- SP/IdP validation scripts

---

## 📈 Observability
- 🔍 **ELK Stack** captures logs from IS & analytics
- 📊 **WSO2 IS Analytics Dashboard** for login patterns, failed auth, MFA drop-off
- 📦 Logging flows configured in `kra-elk/`

---

## 🔒 Access & Security
Due to enterprise confidentiality, deployment access is restricted.
For demo access or deployment documentation, request credentials via secure KRA channels.

---

## 🧰 Usage & CI/CD Setup
To spin up a QA stack:
```bash
cd kra-swarm-wso2/
docker stack deploy -c docker-compose.yml kra-iam
```

CI/CD flow uses Jenkinsfiles under `kra-cicd/`. Ensure:
- GitHub access tokens or webhooks are set
- Docker registry creds are configured on Jenkins

---

## 🧠 Contributors
**Daniel Ooro Winga**  
DevOps & WSO2 Specialist for Enterprise Identity  
[LinkedIn](https://www.linkedin.com/in/daniel-winga-8b910032/)  
[GitHub](https://github.com/danWinga)

---

## 📜 License
© 2025 Kenya Revenue Authority & Daniel Ooro Winga – Confidential Use Only
