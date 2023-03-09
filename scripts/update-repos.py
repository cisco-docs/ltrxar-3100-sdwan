# -*- coding: utf-8 -*-

# Copyright: (c) 2023, Daniel Schmidt <danischm@cisco.com>

import os
import shutil
import subprocess
import tempfile

REPOS = [
    {
        "url": "https://wwwin-github.cisco.com/AS-Customer/sdwanac.git",
        "commit_message": "Nac sdwan updates",
        "directories": [
            {
                "src": "../validation/rules",
                "dst": "./validation/rules",
            },
        ],
        "files": [
            {
                "src": "../schemas/sdwan.yaml",
                "dst": "./schema/sdwan.yml",
            },
            {
                "src": "../defaults/sdwan.yaml",
                "dst": "./defaults/cedge_feature_templates.yml",
            },
        ],
    },
    {
        "url": "https://wwwin-github.cisco.com/netascode/nac-sdwan-example.git",
        "commit_message": "Nac sdwan updates",
        "directories": [
            {
                "src": "../validation/rules",
                "dst": "./.rules",
            },
        ],
        "files": [
            {
                "src": "../schemas/sdwan.yaml",
                "dst": "./.schema.yaml",
            },
        ],
    },
    {
        "url": "https://wwwin-github.cisco.com/netascode/terraform-sdwan-nac-sdwan.git",
        "commit_message": "Nac sdwan updates",
        "files": [
            {
                "src": "../defaults/sdwan.yaml",
                "dst": "./defaults/defaults.yaml",
            },
        ],
    },
]


def update_repo(repo):
    with tempfile.TemporaryDirectory() as dirname:
        subprocess.run(["git", "clone", repo["url"], dirname])
        # copy files and dirs
        for dir in repo.get("directories", []):
            shutil.copytree(
                dir["src"], os.path.join(dirname, dir["dst"]), dirs_exist_ok=True
            )
        for file in repo.get("files", []):
            shutil.copyfile(file["src"], os.path.join(dirname, file["dst"]))
        cwd = dirname
        subprocess.run(["git", "add", "--all"], cwd=cwd)
        p = subprocess.run(["git", "diff", "--cached", "--exit-code"], cwd=cwd)
        if p.returncode > 0:
            subprocess.run(["git", "commit", "-m", repo["commit_message"]], cwd=cwd)
            subprocess.run(["git", "push"], cwd=cwd)


def update_repos():
    for repo in REPOS:
        print("\n-> Updating repo {}\n".format(repo["url"]))
        update_repo(repo)


if __name__ == "__main__":
    update_repos()
