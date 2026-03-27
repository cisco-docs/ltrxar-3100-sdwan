# Services-as-Code (SaC) User Guide
### SD-WAN Network Automation — Getting Started

---

## Welcome

This guide walks you through your first hands-on experience with the **Services-as-Code (SaC)** platform for Cisco SD-WAN — a system that lets you describe your SD-WAN configuration in plain YAML files and have it automatically validated and deployed to a real vManage environment through a CI/CD pipeline.

You do not need to be a network automation expert to follow this guide. Each concept is explained before you use it, and every step includes the exact commands to run.

By the end of this guide you will have:
- Logged into the developer environment
- Used the `sac` CLI to set up your personal workspace
- Pushed feature templates and a device template to a real vManage using the CI/CD pipeline
- Applied a site attachment locally using Docker to onboard a physical SD-WAN device
- Cleaned everything up for the next user

---

## Part 1 — The Building Blocks

The platform is made up of three servers that work together, plus vManage itself as the target. Understanding what each one does will help you make sense of everything that follows.

```
┌─────────────────────────────┐     ┌─────────────────────────────┐
│  cx-us-ps-gitlab.cisco.com  │     │  cx-us-ps-devbox.cisco.com  │
│       10.122.104.32         │     │       10.122.104.39         │
│                             │     │                             │
│  • Git repository server    │     │  • Your Linux terminal      │
│  • CI/CD platform           │◄────│  • Where you write YAML     │
│  • Stores pipeline history  │     │  • Where sac CLI runs       │
│  • Stores Terraform state   │     │  • Where Docker runs        │
└─────────────────────────────┘     └─────────────────────────────┘
              │
              ▼
┌─────────────────────────────┐     ┌─────────────────────────────┐
│ cx-us-ps-gitlab-runner.cisco│     │  vManage — 10.122.20.77     │
│         .com                │     │  https://10.122.20.77:2501  │
│       10.122.104.38         │     │                             │
│                             │────►│  • Cisco SD-WAN Manager     │
│  • Executes CI/CD pipelines │     │  • Where configuration      │
│  • Runs Terraform inside    │     │    is applied               │
│    a Docker container       │     │  • UI for verification      │
│  • Connects to vManage on   │     │                             │
│    your behalf              │     │                             │
└─────────────────────────────┘     └─────────────────────────────┘
```

| Server | Address | What it does |
|--------|---------|--------------|
| **GitLab** | `cx-us-ps-gitlab.cisco.com` | Hosts all Git repositories; runs your CI/CD pipelines; stores the browser UI you use to watch pipelines |
| **DevBox** | `cx-us-ps-devbox.cisco.com` | A shared Linux server where you work — your terminal, your YAML files, your personal workspace |
| **Runner** | `cx-us-ps-gitlab-runner.cisco.com` | A dedicated machine that executes pipeline jobs — it runs the Docker container that pushes configs to vManage |
| **vManage** | `10.122.20.77:2501` | The SD-WAN Manager controller — the target device. Every template and site attachment ends up here |

---

## Part 2 — Getting Access

You will be given two sets of credentials by your administrator:

| Access type | What you need | How |
|-------------|--------------|-----|
| **Terminal (DevBox)** | Username + password | SSH from your laptop |
| **GitLab UI** | Username + password | Browser |
| **vManage UI** | `sac-user` / `cisco` | Browser (shared read-only account for validation) |

### 2.1 — SSH into the DevBox

The first thing you need to do is open a terminal on the DevBox. You will use this to run the `sac` setup commands in Part 3.

Open a terminal on your laptop and run:

```bash
ssh <your-username>@cx-us-ps-devbox.cisco.com
```

Enter your password when prompted. You are now inside the DevBox.

> **Windows users:** Use PowerShell, Windows Terminal, or PuTTY (host: `cx-us-ps-devbox.cisco.com`, port `22`).

### 2.2 — Log into GitLab (Browser Access)

Open your browser and go to:

```
http://cx-us-ps-gitlab.cisco.com
```

Log in with your GitLab username and password. This is where you will watch your pipelines run, review plan artifacts, and manage your branches.

> **Note:** The GitLab server uses a self-signed certificate. Your browser may show a security warning — click "Advanced" → "Proceed" to continue.

### 2.3 — Log into vManage (Browser Access)

Open your browser and go to:

```
https://10.122.20.77:2501
```

Log in as `sac-user` / `cisco`. This is the read-only account used to verify that configurations were applied correctly. You will use this in the exercises to confirm that templates and device attachments appear in vManage after deployment.

> **Note:** vManage uses a self-signed certificate. Accept the browser warning to proceed.

---

## Part 3 — The SAC CLI

The `sac` (Services-as-Code) command-line tool is a helper you run on the DevBox. Its job is to make sure your personal environment is correctly set up before you start working — checking for SSH keys, cloning the right repository, configuring git, and generating the files needed to run Terraform.

Think of it as a **setup wizard** that runs once to prepare your workspace.

### 3.1 — `sac doctor` — Health Check

Before doing anything else, run a health check:

```bash
sac doctor
```

This command checks ~15 conditions:

- Can the DevBox reach GitLab? (DNS + HTTPS)
- Is Docker installed and running?
- Is the NAC Docker image available locally?
- Do you have an SSH key, and is it trusted by GitLab?
- Is your GitLab access token configured?

Every check prints either `PASS` or `FAIL` with a clear message. Fix anything that shows `FAIL` before continuing. In most cases the `FAIL` message will tell you exactly what to do.

```
  PASS  DNS resolution: cx-us-ps-gitlab.cisco.com
  PASS  HTTPS reachability: cx-us-ps-gitlab.cisco.com
  PASS  Docker daemon is running
  PASS  Docker image danischm/nac:latest is available
  PASS  SSH key exists: ~/.ssh/id_rsa
  PASS  SSH connection to GitLab: OK
  PASS  GitLab token configured
  ...
```

### 3.2 — `sac init sdwan` — Workspace Setup

Once doctor is clean, run:

```bash
sac init sdwan
```

This performs a one-time setup of your personal SD-WAN workspace:

| Step | What happens |
|------|-------------|
| 1 | Verifies your GitLab token |
| 2 | Ensures your SSH key is registered in GitLab |
| 3 | Clones the `sac-sdwan` repository into `~/devhub/workspaces/sac-sdwan/` and creates a personal branch (`devhub/<your-username>/sac-sdwan`) |
| 4 | Configures your git identity (`user.name` and `user.email`) |
| 5 | Writes `SDWAN_USERNAME`, `SDWAN_URL`, and Terraform backend variables into your env file |
| 6 | Writes `~/.config/sac/sdwan_password` (your SD-WAN password, stored securely, never written to the env file) |
| 7 | Prints the `docker run` command you will use for local execution |

After `sac init sdwan` completes, your workspace is ready at:

```
~/devhub/workspaces/sac-sdwan/
```

### 3.3 — Open the Workspace in VS Code

Now that `sac init` has created your workspace folder, switch from the plain SSH terminal to **VS Code with the Remote - SSH extension**. This gives you a full editor with file browsing and an integrated terminal — making it much easier to edit YAML files and run commands side by side.

**One-time setup:**

1. Install [Visual Studio Code](https://code.visualstudio.com/) on your laptop if you haven't already
2. Install the **Remote - SSH** extension:
   - Open VS Code → click the Extensions icon (or press `Ctrl+Shift+X`)
   - Search for `Remote - SSH` (published by Microsoft) → click **Install**
3. Connect to the DevBox:
   - Press `F1` (or `Ctrl+Shift+P`) → type `Remote-SSH: Connect to Host` → Enter
   - Type `<your-username>@cx-us-ps-devbox.cisco.com` and press Enter
   - Enter your password when prompted
4. Open your workspace folder:
   - VS Code will prompt you to open a folder — navigate to `/home/<your-username>/devhub/workspaces/sac-sdwan` and click **OK**
   - Or use **File** → **Open Folder** after connecting

You now have the `sac-sdwan` repository open in VS Code, with the file explorer on the left and an integrated terminal at the bottom. Open the terminal with `` Ctrl+` ``.

> From this point forward, all file editing is done in the VS Code editor and all commands are run in the VS Code integrated terminal.

---

## Part 4 — The sac-sdwan Repository

Once `sac init` clones the repo, navigate into it:

```bash
cd ~/devhub/workspaces/sac-sdwan
```

Here is what the repository contains and what each part does:

```
sac-sdwan/
├── main.tf                                ← Terraform entry point
├── .gitlab-ci.yml                         ← CI/CD pipeline definition
├── data/                                  ← Configuration intent (your YAML files)
│   ├── edge_feature_templates.nac.yaml    ←   Feature templates (VPN, interface, system, etc.)
│   ├── edge_device_templates.nac.yaml     ←   Device template (assembles feature templates)
│   └── sites.nac.yaml                     ←   Site attachment (maps a physical device to its template)
├── schemas/
│   └── schema.yaml                        ← Data model — defines what YAML keys are valid
├── validation/
│   └── rules/                             ← Semantic validation rules (Python)
└── defaults/
    └── defaults.yaml                      ← NAC module default values
```

### 4.1 — `main.tf` — The Terraform Entry Point

`main.tf` is the file that ties everything together. It has three parts:

**1. Provider requirement**
```hcl
required_providers {
  sdwan = {
    source  = "CiscoDevNet/sdwan"
    version = "~> 0.11.0"
  }
}
```
This tells Terraform to download the Cisco SD-WAN provider — the plugin that translates your YAML intent into vManage REST API calls.

**2. The HTTP backend**
```hcl
backend "http" {
  skip_cert_verification = true
}
```
This tells Terraform to store its state file (a record of what it has deployed) in GitLab rather than locally. The connection details (`TF_HTTP_ADDRESS`, username, token) are injected automatically as environment variables — either by the CI/CD pipeline or by your `env.sdwan` file when running locally. This ensures you and the pipeline always share the same view of what has been applied.

**3. The NAC module**
```hcl
module "sdwan" {
  source = "github.com/netascode/terraform-sdwan-nac-sdwan"

  yaml_directories = ["data/"]

  write_default_values_file = "defaults.yaml"
}
```

The `netascode/terraform-sdwan-nac-sdwan` module reads all your YAML data files and drives the SD-WAN provider to create, update, or delete the corresponding objects in vManage. It writes a `defaults.yaml` file after each run that captures the resolved default values for your configuration.

In short: **you write YAML → module reads YAML → Terraform pushes config to vManage**.

You never edit `main.tf`. You only edit files in `data/`.

### 4.2 — `.gitlab-ci.yml` — The Pipeline

When you push a commit to your branch, GitLab automatically starts a pipeline. The pipeline runs a sequence of jobs inside a Docker container (`danischm/nac:latest`) on the runner server.

```
 validate → plan → deploy (manual) → test → notify
                                  ↘
                              destroy (manual)
```

| Stage | What it does | Runs when |
|-------|-------------|-----------|
| **validate** | Checks YAML formatting (`terraform fmt`) and runs `nac-validate` which enforces the schema AND all semantic rules | Every push |
| **plan** | Runs `terraform plan` — computes what would change in vManage without touching it. Saves the plan as an artifact and posts a summary | Every push (after validate passes) |
| **deploy** | Runs `terraform apply` using the saved plan — actually pushes configuration to vManage | **Manual trigger** — you click the play button |
| **test** | Runs integration tests to verify the deployed config matches intent | After deploy (master branch only) |
| **notify** | Sends a Webex notification on success or failure | Always |
| **destroy** | Runs `terraform destroy` — removes all configurations from vManage | **Manual trigger** |

> **Key insight:** You are protected by two checkpoints before anything reaches vManage: (1) the validate stage catches errors in your YAML, and (2) the plan stage shows you a preview. The actual deployment only happens when **you** click the play button on deploy.

### 4.3 — `data/` — Configuration Intent

The `data/` folder is where you express **what you want** the SD-WAN fabric to look like. You do not use the vManage GUI — you write structured YAML that describes the desired state. The SD-WAN configuration in this lab follows a three-tier model that mirrors the vManage template hierarchy:

```
Feature Templates  (edge_feature_templates.nac.yaml)
       │
       ▼
Device Template   (edge_device_templates.nac.yaml)   ← assembles feature templates
       │
       ▼
Site Attachment   (sites.nac.yaml)                   ← binds a physical device to the device template
```

**Feature templates** (`edge_feature_templates.nac.yaml`):
Feature templates are the building blocks — each one configures a single area of the device (a VPN, an interface, the system settings, NTP, AAA, etc.). This file defines the following template types used in the lab:

| Template type | Names defined |
|------|------|
| VPN templates | `FT-REMOTE-VPN30-CORP`, `FT-REMOTE-VPN40-GUEST`, `FT-REMOTE-VPN0-OVERLAY`, `FT-REMOTE-VPN512-MGMT` |
| Ethernet interface templates | `FT-ETH3-VPN30`, `FT-ETH4-VPN40`, `FT-TLOC1-PUBLIC-REMOTE-VPN0`, `FT-TLOC2-PRIVATE-REMOTE-VPN0` |
| OMP template | `FT-REMOTE-EDGE-OMP-01` |
| AAA template | `FT-REMOTE-EDGE-AAA-01` |
| Banner template | `FT-REMOTE-EDGE-BANNER-01` |
| BFD template | `FT-REMOTE-EDGE-BFD-01` |
| CLI template | `FT-REMOTE-EDGE-CLI-BGP-BFD-01` |
| Global settings template | `FT-REMOTE-EDGE-GLOBAL-01` |
| Logging template | `FT-REMOTE-EDGE-LOGGING-01` |
| NTP template | `FT-REMOTE-EDGE-NTP-01` |
| Security template | `FT-REMOTE-EDGE-SECURITY-01` |
| SNMP template | `FT-REMOTE-EDGE-SNMPV3-01` |
| System template | `FT-REMOTE-EDGE-SYSTEM-01` |

Most fields use `_variable` suffixes (e.g., `interface_name_variable: vpn30_eth3_if_name`) — these are template variables that get their actual values from the per-device variable assignments in `sites.nac.yaml`.

**Device template** (`edge_device_templates.nac.yaml`):
This file defines a single device template `DT-USPS-SAC-REMOTE-C8000V-01` for a `C8000V` model. It assembles all the feature templates into a complete router configuration by referencing them by name:

```yaml
sdwan:
  edge_device_templates:
    - name: DT-USPS-SAC-REMOTE-C8000V-01
      description: "Remote Branch Site - cEdge01"
      device_model: C8000V
      system_template: FT-REMOTE-EDGE-SYSTEM-01
      aaa_template: FT-REMOTE-EDGE-AAA-01
      omp_template: FT-REMOTE-EDGE-OMP-01
      ...
      vpn_0_template:
        name: FT-REMOTE-VPN0-OVERLAY
        ethernet_interface_templates:
          - name: FT-TLOC1-PUBLIC-REMOTE-VPN0
          - name: FT-TLOC2-PRIVATE-REMOTE-VPN0
```

Think of the device template as a bill of materials — it says which feature templates are used together to form a complete cEdge router configuration.

**Site attachment** (`sites.nac.yaml`):
This file attaches a real physical device to the device template. It specifies the chassis ID of the device, the device template it should use, and the per-device variable values that fill in all the `_variable` placeholders from the feature templates.

The lab has one site (Site 2) with one router:
- **Chassis ID:** `C8K-D4CE7174-5261-7E6F-91EA-4926BCF4C2DD`
- **Device template:** `DT-USPS-SAC-REMOTE-C8000V-01`
- **Hostname:** `SD-SITE2-C8KV-01`
- **System IP:** `10.0.0.2`

> **Important:** This file starts with its `sdwan.sites` block commented out in your lab workspace. In Exercise 1 you push only the feature and device templates. In Exercise 2 you uncomment this file and apply the site attachment locally using Docker.

### 4.4 — `schemas/schema.yaml` — Data Model and Syntax Validation

The schema file defines the **data model**: what YAML keys are allowed under `sdwan:`, what type their values must be, and which fields are required vs optional.

Think of it as a grammar rule book for your configuration files. When `nac-validate` runs in the pipeline, it compares every YAML file in `data/` against this schema. If you use a key that doesn't exist in vManage's model, misspell a field name, or put a string where an integer is expected, the validate stage will fail with a clear error — before any Terraform planning happens.

Examples of what the schema enforces:
- `sdwan.edge_feature_templates.vpn_templates[].vpn_id` must be an integer
- `sdwan.edge_device_templates[].device_model` must be a string and is required
- `sdwan.sites[].routers[].chassis_id` must be a string and is required

This catches **typos and structural mistakes** — syntax-level errors.

### 4.5 — `validation/rules/` — Semantic Validation

The schema validates structure, but it cannot validate *intent*. Semantic rules are custom Python scripts that validate the *meaning* of the configuration — things the schema cannot express.

The rules in this repo cover cross-reference integrity across the three-tier model:

**Rule 101 — Unique keys** (`101_Unique_keys.py`):
Checks that no two objects of the same type share the same identifier — no two sites with the same site ID, no two device templates with the same name. Catches accidental duplicates before they cause conflicts in vManage.

**Rule 201 — Feature template references in device templates** (`201_Feature_Template_references.py`):
Verifies that every feature template referenced by name inside a device template actually exists in `edge_feature_templates`. If your device template references `FT-REMOTE-EDGE-SYSTEM-99` but that template isn't defined, this rule catches the broken reference.

**Rule 202 — Device template references in sites** (`202_Device_Template_references.py`):
Verifies that every device template referenced by name inside a site attachment actually exists in `edge_device_templates`. Prevents attaching a device to a template that was deleted or renamed.

**Together, schema + rules give you two layers of protection:**

```
YAML file saved
      │
      ▼
  schema.yaml     ──► Is the structure/syntax correct?   (valid key names, correct types)
      │
      ▼
  rules/*.py      ──► Is the intent correct?              (valid references, no duplicates)
      │
      ▼
  terraform plan  ──► What will actually change in vManage?
      │
      ▼
  terraform apply ──► Push config (manual approval required)
```

---

## Part 5 — Hands-On Exercises

**Before starting:** Make sure you have completed Parts 2 and 3 — specifically that `sac init sdwan` has run successfully and you have the workspace open in VS Code as described in Section 3.3. Your personal branch (`devhub/<your-username>/sac-sdwan`) is already checked out.

---

### Exercise 1 — Deploy Feature Templates and Device Template via the CI/CD Pipeline

In this exercise you will push the SD-WAN feature templates and device template to vManage by committing to your branch and watching the full pipeline run. The site attachment (`sites.nac.yaml`) starts commented out — you are building the template library first, without attaching any physical devices yet.

**Pre-requisite:** VS Code is connected to the DevBox with the `sac-sdwan` workspace folder open (Section 3.3). All commands below are run in the VS Code integrated terminal (`` Ctrl+` `` to open it).

**Step 1 — Review the data files**

In the VS Code file explorer (left sidebar), open and read through the following files to familiarise yourself with the configuration intent:

- `data/edge_feature_templates.nac.yaml` — All feature templates: VPN, interface, system, AAA, NTP, logging, etc.
- `data/edge_device_templates.nac.yaml` — The device template `DT-USPS-SAC-REMOTE-C8000V-01` which assembles the feature templates
- `data/sites.nac.yaml` — The site attachment for router `SD-SITE2-C8KV-01` (currently commented out)

Open `data/sites.nac.yaml` and confirm the `sdwan:` block is commented out:

```yaml
---
# SD-WAN Sites
# sdwan:
#   sites:
#     - id: 2
#       routers:
#         - chassis_id: C8K-D4CE7174-5261-7E6F-91EA-4926BCF4C2DD
#           ...
```

If the file is **not** already commented out, comment it out now:

1. Press `Ctrl+A` to select all content
2. Press `Ctrl+/` to comment out every line
3. Save the file (`Ctrl+S` on Windows/Linux, `Cmd+S` on Mac)

This ensures Terraform will create only the feature templates and device template in this exercise. The physical device attachment happens in Exercise 2.

**Step 2 — Stage, commit, and push your branch**

In the VS Code integrated terminal, run:

```bash
git add .
git commit -m "feat: initial SD-WAN config - feature templates and device template"
git push origin devhub/<your-username>/sac-sdwan
```

Replace `<your-username>` with your actual username (e.g., `devhub/nsuvarna/sac-sdwan`).

**Step 3 — Watch the pipeline in GitLab**

1. Open your browser and go to `http://cx-us-ps-gitlab.cisco.com`
2. Navigate to **sac-devhub / sac-sdwan**
3. Click **CI/CD** → **Pipelines** in the left sidebar
4. Find your pipeline (it will show your branch name). Click on it.
5. You will see the pipeline stages: **validate → plan → deploy → ...**

Wait for **validate** and **plan** to go green (this takes about 2–3 minutes).

**Step 4 — Review the plan artifacts**

Click on the **plan** job. In the job log you will see the Terraform plan output. You can also click **Browse** under "Job artifacts" to download:
- `plan.txt` — human-readable plan showing all feature templates and the device template that will be created in vManage
- `plan_gitlab.json` — counts of creates/updates/deletes (shown as a summary badge on the pipeline page)

Review the plan. You should see resources being created for all feature templates (`FT-REMOTE-VPN30-CORP`, `FT-REMOTE-VPN40-GUEST`, `FT-REMOTE-VPN0-OVERLAY`, `FT-REMOTE-VPN512-MGMT`, and all interface/system/NTP/AAA/etc. templates) and the device template `DT-USPS-SAC-REMOTE-C8000V-01`.

**Step 5 — Trigger the deploy**

Back on the pipeline view, you will see the **deploy** job with a ▶ play button (it does not run automatically). Click it to trigger the deployment.

Wait for the deploy job to complete (green checkmark). This step applies all the plan changes to vManage.

**Step 6 — Validate in the vManage UI**

Open your browser and go to:

```
https://10.122.20.77:2501
```

Log in as `sac-user` / `cisco`.

Navigate to **Configuration** → **Classic** → **Templates**.

Verify the following:

| What to check | Where to look in vManage |
|---|---|
| Feature templates created | **Configuration → Classic → Templates → Feature Templates** |
| VPN templates | Filter or search for `FT-REMOTE-VPN` — you should see all 4 VPN templates |
| Interface templates | Search for `FT-ETH` and `FT-TLOC` — you should see all 4 interface templates |
| System and service templates | Search for `FT-REMOTE-EDGE` — you should see the OMP, AAA, Banner, BFD, CLI, Global, Logging, NTP, Security, SNMP, System templates |
| Device template created | **Configuration → Classic → Templates → Device Templates** — find `DT-USPS-SAC-REMOTE-C8000V-01` |
| No devices attached | Click on `DT-USPS-SAC-REMOTE-C8000V-01` — the "Attached Devices" count should be **0** |

The templates are in vManage but no physical device is attached yet. You will fix that in Exercise 2.

---

### Exercise 2 — Attach the SD-WAN Device Using Docker

In this exercise you will uncomment the site attachment in `sites.nac.yaml` and apply the change directly from the DevBox using Docker, without going through the CI/CD pipeline. This is useful for immediate, interactive changes — and it demonstrates that the same Terraform code used in the pipeline can also be run locally.

When the site attachment is applied, vManage will push the assembled device template (with all its feature templates and per-device variable values) to the physical cEdge device `SD-SITE2-C8KV-01`.

**Pre-requisite:** Exercise 1 completed successfully — feature templates and device template are deployed in vManage. VS Code is connected to the DevBox with the `sac-sdwan` workspace folder open.

**Step 1 — Uncomment `data/sites.nac.yaml`**

In the VS Code file explorer, open `data/sites.nac.yaml`.

The file currently looks like this (all content commented out):

```yaml
---
# SD-WAN Sites
# sdwan:
#   sites:
#     - id: 2
#       routers:
#         - chassis_id: C8K-D4CE7174-5261-7E6F-91EA-4926BCF4C2DD
#           model: C8000V
#           device_template: DT-USPS-SAC-REMOTE-C8000V-01
#           device_variables:
#             site_id: 2
#             system_ip: 10.0.0.2
#             system_hostname: SD-SITE2-C8KV-01
#             ...
```

Uncomment every line in the file:

1. Press `Ctrl+A` to select all content
2. Press `Ctrl+/` to uncomment every line
3. Save the file (`Ctrl+S` on Windows/Linux, `Cmd+S` on Mac)

The file should now look like this:

```yaml
---
# SD-WAN Sites
sdwan:
  sites:
    - id: 2
      routers:
        - chassis_id: C8K-D4CE7174-5261-7E6F-91EA-4926BCF4C2DD
          model: C8000V
          device_template: DT-USPS-SAC-REMOTE-C8000V-01
          device_variables:
            site_id: 2
            system_ip: 10.0.0.2
            system_hostname: SD-SITE2-C8KV-01
            ...
```

**Step 2 — Get your `docker run` command**

After `sac init sdwan`, the CLI printed a `docker run` command. You can retrieve it again by running in the VS Code integrated terminal:

```bash
sac init sdwan --force
```

Look for the **"Ready-to-run Docker command"** block in the output. Copy the exact command printed — it will be pre-filled with your username and paths. It will look similar to:

```bash
WORKDIR="/home/<your-username>/devhub/workspaces/sac-sdwan"
docker run --rm -it \
  -u "$(id -u):$(id -g)" \
  --env-file "/home/<your-username>/.config/sac/env.sdwan" \
  -e TF_HTTP_PASSWORD="$(cat $HOME/.config/sac/gitlab_token)" \
  -e SDWAN_PASSWORD="$(cat /home/<your-username>/.config/sac/sdwan_password)" \
  -v "$WORKDIR:/work" -w /work \
  danischm/nac:latest bash
```

> **Do not type this manually.** Copy the exact command from the `sac init sdwan --force` output — it has your real username and correct paths already filled in.

**Step 3 — Launch the container**

Paste the full `docker run` command into the VS Code integrated terminal and press Enter. You will enter an interactive shell inside the NAC container with all your SD-WAN credentials and Terraform backend variables already set.

**Step 4 — Initialize and apply**

Inside the container, run:

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

`terraform init` reconnects to the GitLab state backend and picks up the existing state from Exercise 1 (all the templates you already deployed). Because this state is stored in GitLab rather than locally, the container knows what is already deployed and computes only the delta.

`terraform plan` will show you what will change. You should see only new resources for the site attachment of `SD-SITE2-C8KV-01` — all the templates from Exercise 1 should show zero changes.

`terraform apply` pushes the site attachment to vManage, which in turn pushes the device template configuration to the physical cEdge device.

**Step 5 — Exit the container**

```bash
exit
```

**Step 6 — Validate in the vManage UI**

Log into `https://10.122.20.77:2501` as `sac-user` / `cisco` and verify:

| What to check | Where to look in vManage |
|---|---|
| Device `SD-SITE2-C8KV-01` is onboarded | **Monitor** → **Devices** — find `SD-SITE2-C8KV-01` in the device list |
| Device template has 1 attached device | **Configuration → Classic → Templates → Device Templates** → click `DT-USPS-SAC-REMOTE-C8000V-01` → Attached Devices: **1** |

---

### Exercise 3 — Destroy Everything (Cleanup)

When you are done, please remove all configurations you deployed so vManage is clean for the next user.

> **Important:** Always destroy after your session. Other users share the same vManage target. Leaving templates and stale site attachments will interfere with their exercises.

**Option A — Destroy via the CI/CD pipeline (recommended)**

1. Go to GitLab → **sac-devhub / sac-sdwan** → **CI/CD** → **Pipelines**
2. Find your most recent **successful** pipeline (the one from Exercise 2)
3. You will see the **destroy** job with a ▶ play button — click it
4. Wait for the destroy job to complete (green checkmark)

This runs `terraform destroy -auto-approve` inside the pipeline container, removing all templates and site attachments from vManage.

**Option B — Destroy locally using Docker**

If you prefer to destroy from the DevBox, run `sac init sdwan --force` in the VS Code integrated terminal to get the docker run command again, paste it to launch the container, then inside the container:

```bash
terraform init
terraform destroy -auto-approve
exit
```

**Verify cleanup**

Log into `https://10.122.20.77:2501` as `sac-user` / `cisco` and confirm:

| What to check | Expected result |
|---|---|
| **Monitor → Devices** | Device `SD-SITE2-C8KV-01` is no longer listed (or shows as detached) |
| **Configuration → Classic → Templates → Device Templates** | `DT-USPS-SAC-REMOTE-C8000V-01` is removed |
| **Configuration → Classic → Templates → Feature Templates** | All `FT-REMOTE-*` templates are removed |

---

## Part 6 — Quick Reference

### Key commands

| Task | Command |
|------|---------|
| Health check | `sac doctor` |
| Set up workspace | `sac init sdwan` |
| Regenerate env + docker command | `sac init sdwan --force` |
| Navigate to workspace | `cd ~/devhub/workspaces/sac-sdwan` |
| Check your branch | `git branch` |
| Stage all changes | `git add .` |
| Commit | `git commit -m "your message"` |
| Push to your branch | `git push origin devhub/<username>/sac-sdwan` |

### Key URLs

| Resource | URL |
|----------|-----|
| GitLab UI | `http://cx-us-ps-gitlab.cisco.com` |
| sac-sdwan project | `http://cx-us-ps-gitlab.cisco.com/sac-devhub/sac-sdwan` |
| Pipelines | `http://cx-us-ps-gitlab.cisco.com/sac-devhub/sac-sdwan/-/pipelines` |
| vManage UI | `https://10.122.20.77:2501` |

### vManage login

| Account | Password | Use |
|---------|---------|-----|
| `sac-user` | `cisco` | Read-only UI login for validating applied configuration |

### SD-WAN template hierarchy

```
Feature Templates           ← configure individual device functions (VPN, interfaces, NTP, AAA, etc.)
       │
       ▼
Device Template             ← assembles feature templates into a complete router config
       │
       ▼
Site Attachment             ← binds a specific physical device to a device template
                              and provides per-device variable values
```

### Key template and object names in this lab

| Object type | Name |
|-------------|------|
| Device template | `DT-USPS-SAC-REMOTE-C8000V-01` |
| Site ID | `2` |
| Device hostname | `SD-SITE2-C8KV-01` |
| System IP | `10.0.0.2` |

### Data file reference

| File | What it configures | Touches vManage object type |
|------|-------------------|---------------------------|
| `edge_feature_templates.nac.yaml` | VPN, interface, system, AAA, NTP, logging, SNMP, etc. feature templates | Feature Templates |
| `edge_device_templates.nac.yaml` | Device template assembling feature templates | Device Templates |
| `sites.nac.yaml` | Site ID, chassis ID, template assignment, device variables | Device Attachment / Site |

### Validation rules summary

| Rule | Severity | What it catches |
|------|----------|----------------|
| 101 | HIGH | Duplicate site IDs or duplicate device template names |
| 201 | HIGH | Feature template referenced in a device template does not exist |
| 202 | HIGH | Device template referenced in a site attachment does not exist |

### Understanding pipeline job colors

| Color | Meaning |
|-------|---------|
| 🔵 Blue (running) | Job is executing right now |
| ✅ Green | Job passed |
| ❌ Red | Job failed — click it to see the error log |
| ⏸ Grey with ▶ | Job is waiting for manual trigger (deploy, destroy) |

---

## Troubleshooting

**`sac: command not found`**
Your PATH may not include `~/.local/bin`. Run:
```bash
export PATH="$HOME/.local/bin:$PATH"
```
Then add that line to your `~/.bashrc` so it persists.

**`sac doctor` shows SSH FAIL**
Your SSH public key may not be registered in GitLab. Run `sac init sdwan` — it will detect this and print your public key with instructions to add it at:
`http://cx-us-ps-gitlab.cisco.com/-/user_settings/ssh_keys`

**Pipeline fails at `terraform init` with TLS error**
Check that `TF_CLI_ARGS_init` in your `env.sdwan` contains `-backend-config=skip_cert_verification=true`. Run `sac init sdwan --force` to regenerate it.

**`docker: permission denied`**
You are not in the docker group. Contact your administrator to run:
```bash
sudo usermod -aG docker <your-username>
```
Then log out and back in.

**Pipeline only runs `validate` and `notify` — `plan` and `deploy` are skipped**
Your branch name must follow the exact pattern `devhub/<username>/sac-sdwan`. Verify with `git branch` in the VS Code terminal. If the branch name is wrong, run `sac init sdwan` again to recreate it correctly.

**`terraform apply` fails with "certificate" or "TLS" error when connecting to vManage**
vManage uses a self-signed certificate. Confirm that `TF_CLI_ARGS_init` in your env file includes `skip_cert_verification=true`. Run `sac init sdwan --force` to regenerate.

**`terraform plan` shows all resources as destroyed and recreated (unexpected)**
This can happen if the Terraform state was created by a different branch. Check that `TF_STATE_NAME` matches your branch. The `sac init sdwan` command sets up the correct env file — run `sac init sdwan --force` to regenerate it.

**vManage UI shows no changes after deploy**
Click the `deploy` job in the pipeline and scroll through the logs for any errors. Also check `terraform output` at the end of the deploy log for diagnostic information. If vManage rejected a resource, the error will appear in the Terraform debug log artifact.

**Destroy job fails or leaves partial state**
Use Option B (local docker destroy). Your local `data/` folder contains all configuration, so `terraform destroy` run locally will produce a complete and correct plan for removal.

**`SD-SITE2-C8KV-01` does not appear in Monitor → Devices after Exercise 2**
The site attachment was applied to vManage, but the physical device may not have connected to vManage yet. Check that `terraform apply` completed without errors. If it did, wait 1–2 minutes and refresh the Devices page. If it still doesn't appear, check the vManage device status under **Configuration → Classic → Templates → Device Templates → DT-USPS-SAC-REMOTE-C8000V-01** to see if the template was pushed successfully.
